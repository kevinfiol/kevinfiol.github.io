---
layout: post.pug
tags: post
title: Simple State Management in Mithril.js
date: 2019-07-31
---

# Simple State Management in Mithril.js

[Mithril.js](https://mithril.js.org) is a lightweight JavaScript framework that has become a staple in my development stack after I discovered it two years ago. At the time, I was looking for a simpler, zero-dependency alternative to [React.js](https://reactjs.org/) that could help me learn modern JavaScript UI development without needing to simultaneously learn and understand various build tools and framework plugins.

I've since learned React and have come to appreciate it for its influence on modern web development. However, I find that Mithril, a framework that sits at half the size of React whilst containing more features, has remained my go-to.

When it comes to state management, Mithril is as unopinionated as they come. You can use Redux, Mobx, Cerebral, some implementation of the SAM pattern, or best of all -- just a plain ol' JavaScript object! Mithril comes with an auto-redraw system. The virtual DOM created by Mithril will diff against and synchronize the DOM whenever changes are made to your data layer. Most commonly, the redraws are triggered after a DOM event.

What this means in practice is that you are free to structure your data however you'd like, and Mithril takes care of the rest. Below is an example of a simple Counter application written with Mithril:

```js
let count = 0;

const Counter = {
  view: () =>
    m('div',
      m('h1', 'Counter'),
      m('p', count),
      m('button', { onclick: () => count += 1 }, '+'),
      m('button', { onclick: () => count -= 1 }, '-')
    )
};

m.mount(document.body, Counter);
```
[Live Example](https://flems.io/#0=N4IgZglgNgpgziAXAbVAOwIYFsZJAOgAsAXLKEAGhAGMB7NYmBvEAXwvW10QICsEqdBk2J5YxAAR0ArgwkBeCQAYA3AB00GoXEkBBAA76FE4BokSAbhBgB3RBIAUASgUA+M+YlYHAcgAmEBY+FB6eXr6EAIzBEj4AwrSyjABOPk4haGHm3j76MTIM6aGeOQBG0sTE9DHAEvTUUBDUANb2zm5SiXIA1IqREuyx3WkZWeE+5ZXVFCZ1aA1NrY4u8q6dSRIAtH0DMz6bacVOGqzqmmhY+FhdxA5+tNTSOAz4pbR+AJ4zBvpOKpQgOAwWDUYgQegIHiRABMiGhAA5NkpEEo2BwQJgcHh8NQ4AIaPRGMweGwALpURpoZqQ1AYrh4LAQYiEZLQAHSZLkHgkYj6OCIAD0Atk+maAHMcbQsALGczWVAAALQ-BKfAAZhlTJZ0CuEDQ+H4AOIH303EB1FZ+lErFJrCAA)

Our state is just a single primitive variable! For small applications, simple widgets or one-off UI components, the above solution is largely sufficient. What's important about implementing your state management solution is to understand that there is no silver bullet. You will be able to predict your needs more accurately as you work across multiple projects and grow organically. [Redux](https://redux.js.org/) is a brilliant solution for modern UI state management, but the 9/10 times I have attempted to use it out of a desire to do things "the right way", it was absolute overkill. I advise reading [this blog post](https://medium.com/@dan_abramov/you-might-not-need-redux-be46360cf367) by Dan Abramov, the creator of Redux.

While the above solution is simple and likely sufficient for small use-cases, it introduces one problem - we are modifying the state directly from within the view. It won't take long before this approach proves unwieldy, and you're scanning your templates trying to find where you wrote the logic that is altering your state in (potentially) unpredictable ways.

We can introduce indirection and a more versatile state container using plain JavaScript objects. Our `Counter` component becomes more terse, yet more expressive:

```js
const state = { count: 0 };

const actions = {
  increment: () => state.count += 1,
  decrement: () => state.count -= 1
};

const Counter = {
  view: () =>
    m('div',
      m('h1', 'Counter'),
      m('p', state.count),
      m('button', { onclick: actions.increment }, '+'),
      m('button', { onclick: actions.decrement }, '-')
    )
};

m.mount(document.body, Counter);
```
[Live Example](https://flems.io/#0=N4IgZglgNgpgziAXAbVAOwIYFsZJAOgAsAXLKEAGhAGMB7NYmBvEAXwvW10QICsEqdBk2J4hcYgAIJGRpIC8k4JLoBXBokkAGSawDcAHTRHxUjNWIR6cBUqOTJENNQBOMHBskAKAJQKAfNLEsjD4agySANSKAIwU9pIAJjCu7iKavgFBIWG06lIAtLFG+kYm1lIAwnnCLrbACQBuEDAA7hl+8v4JDlheAOSJEI398WgOE5J9-YQxo5L91fkwLv0+Y5O9AwAO8zKMufnrPRPTAEaqxMT088r01FAQ1ADWmuaW1vhOqR5S7AuRNYbTbnS7XNC3ST3R4vN4WKxoOD4ZI-ES6CgLAprE4+EqGYxoLD4LA1YheRK0aiqX74M60RIATwxS1qPj0lBAcBgsHh1jwWkQWgKMQA7IgAMwAJjYHBAmBweDCcAENHojGYPDYAF0qI80M8EChOAqeFgIMRCC5oBzVC5yDwSMRtnBEAB6V3qbbPADmuSwrrNFqtUAAApL8Fp8OKA+bLdBiU58PwOcQGdtuJzXBBtqJWFrWEA)

As your application grows in size, it might be preferable that your state and actions are easily testable and replicable from the beginning. Further, instead of relying on lexical scoping for your actions to have access to your state, we can use a combination of dependency injection and closures so that an instance of your actions will always directly reference a specific state object. We can easily achieve this with factory functions that provide your initial state and actions that directly reference a single state object.

```js
const State = () => ({ count: 0 });

const Actions = state => ({
  increment: () => state.count += 1,
  decrement: () => state.count -= 1
});
```

From there, it is dead simple to reproduce your state and actions objects respectively:

```js
const state   = State();
const actions = Actions(state);
```

Passing these to a Mithril component is trivial using the `attrs` property and object destructuring (analogous to `props` in React). Notice that our Counter component remains virtually unchanged:

```js
const Counter = {
  view: ({ attrs: { state, actions } }) =>
    m('div',
      m('h1', 'Counter'),
      m('p', state.count),
      m('button', { onclick: actions.increment }, '+'),
      m('button', { onclick: actions.decrement }, '-')
    )
};

m.mount(document.body, {
  view: () => m(Counter, { state, actions })
});
```
[Live Example](https://flems.io/#0=N4IgZglgNgpgziAXAbVAOwIYFsZJAOgAsAXLKEAGhAGMB7NYmBvEAXwvW10QICsEqdBk2J4hcYgAIAysQyNJAXkkAKAJRKAfKuCS6AVwaJJABkms1AbgA6aW+KkBBasQj04SyRPkwtO25KSEGjUAE4wOEaqGora3oz4BgySANTKAIwUAZIAJjBhESLG6n7xMIm0hlIAtBm2FjZ2Ie5SZYGesj7qjQ6SGC5uaB7Kzq7uKmVWtvYtkgDClcKhnsDZAG4QMADuxbryxKFwxrplFH0D7ubmMZrZgVgqAOQ5EGuPWWjt7Q+PhOnvkkeCyqMFCjzUHy+9yeAAcAWUKlUIXdvk8AEb6YjEegA3T0ahQCDUADWxn6YyG+GCBUiUnYgJS4MhUJ+GKxOLOeJChJJZIulLyNJE5jOj2q4JRanqjVsWHwWEWxBUOVo1H0tPwaNoOQAnpz1psdtE-A9gUtOV45IwzuTBh4LPUrJQQHAYLB+QgeOkAMyIABMAFY2BwQJgcHhEnABDR6IxmDw2ABdKiEtDEz2oUNcPBYCDEQihaDO-Shcg8EjEGFHAD01cMMOJAHMKlhq7n84WoAABP34Ez4b1tvMF6Dy4L4fjO4g6mHcF1hCAw0SsROsIA)

(P.S. Credit goes to [porsager](https://github.com/porsager) who shared this brilliant solution in the Mithril.js Gitter)

Passing your state and actions to child components would work as you'd expect. Simply pass your state and actions objects further down as `attrs`, or more wisely, be selective of what you choose to expose to child components.

You could also take an approach where your application is composed of solely stateless components. That is, every component is a pure, deterministic function. [Hyperapp](https://github.com/JorgeBucaran/hyperapp) is a JavaScript framework that does not allow for local state in components. Instead, every component returns a portion of your UI that reflects the global state. While I highly recommend checking out Hyperapp (it's only 1kb gzipped!), this post is about Mithril, and you can use a similar approach with Mithril.

```js
const State = () => ({ count: 0 });

const Actions = state => ({
  increment: () => state.count += 1,
  decrement: () => state.count -= 1
});

const Counter = (state, actions) =>
  m('div',
    m('h1', 'Counter'),
    m('p', state.count),
    m('button', { onclick: actions.increment }, '+'),
    m('button', { onclick: actions.decrement }, '-'),
    Child(state, actions)
  )
;

const Child = (state, actions) =>
  m('div',
    m('h2', 'Child'),
    m('p', state.count * 2),
    m('button', { onclick: actions.increment }, '+'),
    m('button', { onclick: actions.decrement }, '-'),
  )
;

m.mount(document.body, () => {
  const state   = State();
  const actions = Actions(state);

  return { view: () => Counter(state, actions) };
});
```
[Live Example](https://flems.io/#0=N4IgZglgNgpgziAXAbVAOwIYFsZJAOgAsAXLKEAGhAGMB7NYmBvEAXwvW10QICsEqdBk2J4hcYgAIAysQyNJAXkkAKAJRKAfKuCS6AVwaJJABkms1AbgA6aW+KkBBasQj04SyRPkwtO25KSEGjUAE4wOEaqGora3oz4BgySANTKAIwUAZIAJjBhESLG6n7xMIm0hlIAtBm2FjZ2Ie5SAMKVwqGeKmUUkhgubmhwMZrZWCoA5DkQAG6TWWiBgROThOkLkpPtVTChk2qLy5KrAA6bZRVVh9krUwBG+sTE9Ju69NRQENQA1sYDrnc+GCBUiUnYWxSByOy1Wj2erz67xCX1+-0GQLyoJE5j6k2q0NuklahGgOR6ckYfQBQxG2TUtka9haxNJUBy3V6-Qxw1G4ymM3mMLuawATJttmycoSlrCpuc+pcklIAFSSUU3WUi+EvNBvSQfVF-bmA4bAkLhMG4yEy45wp66-WG77GmmY-KWnEQ-G2yQMtBMtBYfBYDrEFQ5WjUfRg-D3Wg5ACefRKsUkwGyDi8lN8gWUsh86kagSzbuGnmcprgFJ8Vls2XCxH0oSWulmEBgAHdiqNiWG9jWqSbaRpWI0GpQQHAYLAeQgeCZECZqgBmdKIFdsDggTA4PCJOACGj0RjMHhsAC6VC+aB+89QO64eCwEGIhFC0EnzfIPBIxFOcCIAA9EBhinD8ADmFRYEBL5vh+UAAAKivgJj4CusGvu+0AhsE+D8JOxCJqc3BTmEECnKIrAXqwQA)

In the end, always do what feels right to you and makes more sense given your team and/or project. If this has been helpful or if you have any questions, [drop me an email!](mailto:fiolkevin@gmail.com)
