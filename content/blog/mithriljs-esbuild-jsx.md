+++
title = "Mithril.js + esbuild + JSX"
date = 2021-03-18
template = "post.html"
+++

# Mithril.js + esbuild + JSX

I recently bootstrapped a [Mithril.js](https://mithril.js.org) project using [esbuild](https://esbuild.github.io/) for my bundling purposes. If you don't already know, esbuild is next-gen bundler written in Go that is magnitudes faster than rollup, webpack, or parcel (all of which are written in JS/TS).

esbuild comes with JSX support out of the box. While I don't normally use JSX, I decided to create a demo for [mithril.netlify.app](https://mithril.netlify.app) showing off that JSX works just fine in a Mithril application. However, I ran into one major issue -- esbuild wasn't compiling JSX fragments correctly when providing `m.fragment` as the JSX fragment pragma. 

After some digging around, I found [this comment](https://gitter.im/mithriljs/mithril.js?at=5b98ce1c51a02e2a261ac656) by [Claudia Meadows](https://github.com/isiahmeadows).

In short, there's no support for Mithril fragments as Components currently. esbuild (as well as transpilers like Sucrase) compiles JSX using the provided jsx pragma + jsx fragment method in the form of:

```js
React.createElement(React.Fragment, null, "Stuff");
```

See [here](https://esbuild.github.io/api/#jsx-fragment) for more details.

Which in Mithril's case, can't work with `m.fragment`. Following Claudia's advice, defining a simple Fragment component as so worked for me. I just put this in my `index.js` file near the top:
```js
m.Fragment = { view: vnode => vnode.children };
```
Then I just set `jsxFragment` to `m.Fragment` instead of `m.fragment` in my esbuild config and voilà! Fragments work as you'd expect.

```js
var JSX = {
    view: function() {
        return (
            <>
                <h2>JSX</h2>
                <p>You could use JSX with Mithril.js as well.</p>
                <p>Be aware that this requires a build-step.</p>
                <p style={{ color: 'red' }}>
                    Attributes work as expected.
                </p>
                <p>This application uses <a href="https://esbuild.github.io/">esbuild</a> to convert JSX.</p>
            </>
        );
    }
};
```
