+++
title = "Modern bundling with esbuild"
date = 2021-10-20
template = "post.html"
+++

# Modern bundling with esbuild

These days, you can get a pretty robust build setup for a modern browser app using just [esbuild](https://esbuild.github.io/). The benefits of using esbuild over rollup, webpack, or parcel are numerous, but the few that stand out to me are:

  * esbuild ships as a static binary; in practice this means adding it as a dependency won't bloat your project with npm packages
  * that lack of npm packages also means less dependabot alerts, since the less dependencies your project relies on, the less likely it is to be vulnerable to security concerns
  * esbuild's bundle times are *much* faster than rollup/webpack/parcel
  * esbuild includes support for TypeScript and JSX transpilation

That's a lot of bang for your buck for a single dev dependency. 

## Dead-simple setup

First off, install esbuild in your project if you haven't already.

```bash
npm install --save-dev esbuild
```

You can use esbuild via CLI or its Node API. For tiny apps where your build config is practically non-existent, using the CLI is fine. You can simply define a script in your `package.json` file and be ready to go.

```json
"scripts": {
  "build": "esbuild index.js --bundle --minify --outfile=./dist/app.js"
}
```

Define a script like the one above, run `npm run build`, and your lightning-fast build is there, minified in all its glory. This isn't terribly different than what you can already do with webpack, but when was the last time you saw webpack's [dependency graph](https://npm.anvaka.com/#/view/2d/webpack)? And that doesn't even include [webpack-cli](https://npm.anvaka.com/#/view/2d/webpack-cli). Not to rag on webpack; it is an immensely powerful tool that many great projects rely on, but unless you're already tangled in that web (heh), I'd suggest steering clear.

esbuild also includes a built-in watch mode. No extra plugins needed! Let's go ahead and define another script:

```json
"scripts": {
  "build": "esbuild index.js --outfile=dist/app.js --bundle --minify",
  "dev": "esbuild index.js --outfile=dist/app.js --bundle --sourcemap --watch"
}
```

Make changes to `index.js` and you'll see that `dist/app.js` is re-bundled automatically. It's even got source map support! Alternatively, we could take things a step further and utilize esbuild's built-in server. Let's change the `dev` script a bit:

```json
"scripts": {
  "build": "esbuild index.js --outfile=dist/app.js --bundle --minify",
  "dev": "esbuild src/index.jsx --outfile=dist/app.js --servedir=dist --bundle"
}
```

After running dev, you'll see in your terminal that a server has been started. Navigate to `localhost:8000` to see the contents of your `dist` folder hosted locally.

```bash
$ npm run dev

 > Local:   http://127.0.0.1:8000/
 > Network: http://192.168.1.12:8000/
 > Network: http://172.11.100.1:8000/
 > Network: http://192.168.1.3:8000/
```

If you're wondering where your generated output files are, no worries: esbuild's serve mode serves the bundled files directly from memory. They are never written to your disk unless you intentionally omit the `servedir` variable.

## Using the Build API

Configuring our buildstep via CLI flags can get unwieldy over time. With other bundlers, you get the benefit of config files, e.g., `rollup.config.js` or `webpack.config.js`. With esbuild, we can just use plain old Node scripts plus the existing Node APIs to configure our builds. Start by creating a new `.js` file under a directory for scripts, `scripts/build.js`. Then, change our existing `build` script in our `package.json`:

```json
"scripts": {
  "build": "node ./scripts/build.js"
}
```

This doesn't do anything yet, because `build.js` is empty. Let's fix that by translating our previous build CLI call to a Node script. That will look something like this:

```js
// scripts/build.js
import esbuild from 'esbuild';
import { resolve } from 'path';

esbuild.bundle({
  format: 'iife',
  entryPoints: [resolve('index.js')],
  bundle: true,
  outfile: resolve('dist/app.js')
}).catch((error) => {
  console.error(error);
  process.exit(1);
});
```

Running `npm run build` should function the same as before, but now we have more control over our bundles! But what about our dev script? And what if we want to reduce code duplication? After all, `build` and `dev` are very similar with just a couple different options.

Let's create a new file in our scripts folder, called `scripts/bundle.js` that will contain the config that both `build.js` and `dev.js` will use.

```js
// scripts/bundle.js
import esbuild from 'esbuild';
import { resolve } from 'path';

export async function bundle(config = {}) {
  return esbuild.build({
    format: 'iife',
    entryPoints: [resolve('index.js')],
    bundle: true,
    outfile: resolve('dist/app.js')
    ...config
  });
}
```

As you see, `bundle.js` will contain all of our default configs. Let's refactor `scripts/build.js` to specifically create one minified build:

```js
// scripts/build.js
import { bundle } from './bundle.js';

bundle({ minify: true })
  .then(() => {
    console.log('Bundled!');
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

Our build script should now function like before. Let's create `scripts/dev.js` now:

```js
// scripts/dev.js
import { bundle } from './bundle.js';

bundle({
  minify: false,
  sourcemap: true,
  watch: {
    onRebuild(error) {
      if (error) console.error(error);
      else console.log('Bundled!');
    }
  }
}).catch((error) => {
  console.error(error)
  process.exit(1);
});
```

Add the `dev` script to your `package.json`:

```json
"scripts": {
  "build": "node ./scripts/build.js",
  "dev": "node ./scripts/dev.js"
}
```

And now `npm run dev` will watch and rebundle your app as you develop your app.

## What about the server?

You very well could use esbuild's "serve" mode in your `scripts/dev.js` script if you'd like to. You would have to adjust the scripts we've created so that "dev" mode uses `esbuild.serve` instead of `esbuild.build`. While I like that esbuild has a built-in server, it does not support live-reload, which is a nice feature to have. You could implement your own live reload using `esbuild.serve`, but a simpler solution is to just use an existing server in conjunction with esbuild. In the past, I have used a global installation of [sirv-cli](https://github.com/lukeed/sirv/tree/master/packages/sirv-cli).

A cleaner solution would be to include some kind of server in our project as a dev dependency. I've found that [nativew/serve](https://github.com/nativew/serve) was a fine solution for this. At [18.7kb](https://packagephobia.com/result?p=create-serve) with 0 dependencies, it was a guilt-free inclusion. Install with npm as normal.

```bash
npm install --save-dev create-serve
```
Now let's modify our `scripts/dev.js`:

```js
// scripts/dev.js
import serve from 'create-serve';
import { bundle } from './bundle.js';

// start our server at localhost:8000
serve.start({
  port: 8000,
  root: 'dist',
  live: true
});

bundle({
  minify: false,
  sourcemap: true,
  watch: {
    onRebuild(error) {
      if (error) console.error(error);
      else console.log('Bundled!');
      serve.update(); // <-- This will live reload on every rebuild
    }
  }
}).catch((error) => {
  console.error(error)
  process.exit(1);
});
```

Re-run `npm run dev` and we'll have our live-reloading dev server up:

```bash
$ npm run dev

Serving 🍛

Local → http://localhost:8000

Network → http://192.168.2.1:8000
```

## Conclusion

If for whatever reason, you've made it this far and are not convinced and maybe want a more batteries-included solution, I highly recommend [Vite](https://vitejs.dev/) from Vue.js creator, Evan You. Vite actually uses esbuild for its own development mode to bundle vendor packages. But otherwise, I hope this has encouraged you to dig deeper into esbuild and to not be afraid to get your hands dirty in writing custom Node scripts to do your bundling. Sometimes what webpack and rollup do under the hood can seem like black magic since it's all abstracted away from you, basking in the comfort of a small config json file at the root of your project. You can cut away at a lot of that cruft by using simpler tools like esbuild, and get perf benefits and a better understanding of your tooling to boot!
