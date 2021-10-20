+++
title = "Modern bundling with esbuild"
date = 2021-10-20
template = "post.html"
+++

# Modern bundling with esbuild

These days, you can setup a pretty robust build setup for a modern browser app using just [esbuild](https://esbuild.github.io/). The benefits of using esbuild over rollup, webpack, or parcel are numerous, but the few that stand out to me are:

  * esbuild ships as a static binary; in practice this means adding it as a dependency won't bloat your project with npm packages
  * that lack of npm packages also means less dependabot alerts, since the less dependencies your project relies on, the less likely it is to be vulnerable to security concerns
  * esbuild's bundle times are *much* faster than rollup/webpack/parcel
  * esbuild includes support for TypeScript and JSX

That's a lot of bang for your buck for a single dev dependency. 

## Dead-simple setup

First off, install esbuild in your project if you haven't already.

```bash
npm install --save-dev esbuild
```

You can use esbuild via CLI or it's Node API. For tiny apps where your build config is practically non-existent, using the CLI is a fine way to. You can simply define a script in your `package.json` file and be ready to go.

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

If you're wondering where you generated output files are, no worries: esbuild's serve mode serves the bundled files directly from memory. They are never written to your disk unless you intentionally omit the `servedir` variable.
