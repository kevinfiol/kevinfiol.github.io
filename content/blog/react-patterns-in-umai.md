+++
title = "React Patterns in Umai"
date = 2024-07-05
template = "post.html"
+++

# React Patterns in Umai

Last year, I forked [hyperapp](https://github.com/jorgebucaran/hyperapp) to create the single-page application library I've always wanted -- [umai](https://github.com/kevinfiol/umai). umai is heavily influenced by [Mithril.js](https://mithril.js.org), which has unfortunately been in stasis for a few years now. My goal in creating umai can be summed up in a few bullet points:

* Create a hyper minimal, but ergonomic UI library in a tiny package size (~1.7kb)
* Fully embrace Mithril.js's closure components, while cutting the cruft and unnecessary baggage (class components, object components, lifecycle events, `view` property).
* Full tree redraws on event handler calls with support for async handlers

Since then, I've used umai on multiple small personal projects and have been happy with the speed and minimalism I've been able to rebuild apps I had previously written in React, Mithril, and Svelte.

In this post, I'd like to translate React patterns taken from [react.dev](https://react.dev) into umai equivalents to demonstrate how easy it is for someone with previous SPA experience to get started with umai. I'll be providing links to live examples if you'd like to alter the examples.

## [Component Composition](https://react.dev/learn#components)

Let's start with a very basic example of component composition. Being able to reuse components is the bread and butter of any UI library.

### React

```jsx
function MyButton() {
  return (
    <button>
      I'm a button
    </button>
  );
}

function MyApp() {
  return (
    <div>
      <h1>Welcome to my app</h1>
      <MyButton />
    </div>
  );
}

```

### umai

```jsx
function MyButton() {
  return (
    <button>
      I'm a button
    </button>
  );
}

function MyApp() {
  return (
    <div>
      <h1>Welcome to my app</h1>
      <MyButton />
    </div>
  );
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyFZrMibbYQXZTKYsDHmSzcDQAWQAngAhZRiMSyAAUAEpblMNBoEmJlCRyUyOZyNAAeGr0xncAB8gqFGgAkhtlnkxQzZDKRWEVRLpeSNCy9twnITuMTuKTZJSqQBBPR6Vns3Xc3n89XCqAQABuOtlnOFIjQkoA6qYZAJKksqRpeLbhWF-d6fcLqXTVeSwgnfWF3V7BfqpkbuFMwOi5EyTkRVCEMDUyFAqajqTa9PqAqG9Ox4CQlDVeDVTF9TPBzdxrCBbABmRwuNzgoQYIgEKGBGEhJTORhOIA)

Notice anything interesting? They're both the same! If you're used to stateless components in React, moving to umai will be a breeze. This includes basics like props and conditional rendering. The following example is compatible with React and umai:

```jsx
function MyButton() {
  return (
    <button>
      I'm a button
    </button>
  );
}

function MyApp({ showButton = true } = {}) {
  return (
    <div>
      <h1>Welcome to my app</h1>
      {showButton ? <MyButton /> : 'Button is hidden!'}
    </div>
  );
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyFZrMibbYQXZTKYsDHmSzcDQAWQAngAhZRiMSyAAUAEpblMNBoEmJlCRyUyOZyNAAeGr0xncAB8gqFGgAkhtlnkxQzZDKRWEVRLpeSNCy9twnITuMTuKTZJSqQBBPR6JmLAgiU501Xkm4sXiwExYm7AJxs4CC7m8-nq4VQCAANx1ss5wpEaElAHVTDIBJUllSNLxbcKwgmY7HgI7neKLQB+EXUl0SjRhSUaN4bGsW1IaFIwBQAQg2Rt1cbCEejgv1Uz7UzA6LkTJORFUIQwNTIUCpqOpNr0+oCab07HgJCUNV4NVMX1M8HN3GsIDQAHY7O17EhaMC3OChBgiAQoYEYSElM4jBOEAA)


Let's get started with examples that contain actual differences.

## [Updating the screen](https://react.dev/learn#updating-the-screen)

### React

Basic state management takes center stage for this example. In React, we'll use the familiar `useState` hook to create a reusable component that retains its own state.

```jsx
import { useState } from 'react';

function MyApp() {
  return (
    <div>
      <h1>Counters that update separately</h1>
      <MyButton />
      <MyButton />
    </div>
  );
}

function MyButton() {
  const [count, setCount] = useState(0);

  function handleClick() {
    setCount(count + 1);
  }

  return (
    <button onClick={handleClick}>
      Clicked {count} times
    </button>
  );
}
```

### umai

umai in comparison does not feature hooks. Instead, umai uses the concept of "[closure components](https://github.com/kevinfiol/umai?tab=readme-ov-file#stateful-components)". State is defined using simple, mutable variables declared with `let`.

```jsx
function MyApp() {
  return (
    <div>
      <h1>Counters that update separately</h1>
      <MyButton />
      <MyButton />
    </div>
  );
}

function MyButton() {
  let count = 0;

  function handleClick() {
    count += 1;
  }

  return () => (
    <button onclick={handleClick}>
      Clicked {count} times
    </button>
  );
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyFZrMibbYQXZTKYsDHmSzcDQAWQAngBBPR6AAUAEpblMNBoEmJlCRyQy2eyNAAeKAQABuAD5+QKhSI0OKAMLo4IkbLJXh9ZR6KDqxImPQjHWwKmCsKyyXk6VC6kAIWUYjEsg0YXNlqtVNt9sdzqlQrCIol-KZe24TkJ3GJ3FJjptdod3GZrItCD6MgxfRutGD-IjUfJJWOCHlA3KCeAPtTmIA1Dc0MH2aHuPzOdzeSyruKNHyLezBTVY47ZERi2UrsB83B4EWIOUnC7LVPyvAoLcK2JVhYBJNu76+57uHOg1MG1MwEqxAyTkRVCEMDUyFAqajqXS9EGAjJZux4CQlDVeDVTC+Ux4FzawQFsABmRwXDccEhAwIgCChQIYRCJQACpE3ZO9tHaAgIAALyOaI3jvEgoG-docODY9uDvB8sOaOR2hYfh2CpN4CF4bgCDw78IBYOslhGaIjjeexaD0bQhP1GBiLeTMjzDWVGLUEhRI6B09AUoSWBhPDCPgcT7CkmjlPsVSRKOdotJ07N9PwgijI0CTTKUxtuBECDLPU6zbI0RSLT05jHOctAsDckNlIAFh8jSbLIbSAt0hzDLeNAADZItokQUDivzErsoLUqc9Louy5SMvyzTCuS+yQrSjQHAqjyZAoxjgrEAzSqajB7HgMAzI85RYEY2SRW4aJ2iOAZuHgPCxBGMRxMk6T3KmXc40YkUCAMXgOI0OoyHKIS1Piu9PTAN4UBaoCfjJMCUHsJBaGcRgnCAA)

A few important distinctions to be made with the umai version:
* umai uses browser standard names for event handlers (`onclick` vs `onClick`)
* Notice that the `handleClick` function in React will be re-created on every re-render. This is because React components *are also* the render function. Hooks are needed to get around this limitation and to store stateful data in a hidden global store invisible to the developer. When declaring stateful components with umai, instead of returning JSX, we return a **render function**. This forms a closure that retains the state of the **outer function**. `handleClick` in the umai version is only created once.  
  * This means no need for `useCallback`! Memoizing components is much simpler in umai.

## [Focusing a text input](https://react.dev/learn/manipulating-the-dom-with-refs#example-focusing-a-text-input)

### React

Sometimes, you need access to the DOM, whether it be to integrate with a third-party library or trigger DOM-specific effects. In React, a `ref` can be used to attach a DOM node to a variable accessible to React, often using the `useRef` hook.

```jsx
import { useRef } from 'react';

function Form() {
  const inputRef = useRef(null);

  function handleClick() {
    inputRef.current.focus();
  }

  return (
    <>
      <input ref={inputRef} />
      <button onClick={handleClick}>
        Focus the input
      </button>
    </>
  );
}
```

### umai

In umai, every element has a special `dom` property which accepts a handler that receives the DOM node upon creation. Using a `let` variable, we can grab a reference to this node and use it at a later time.

```jsx
function Form() {
  let inputEl = null;

  function handleClick() {
    inputEl.focus();
  }

  return () => (
    <div>
      <input dom={node => inputEl = node} />
      <button onclick={handleClick}>
        Focus the input
      </button>
    </div>
  );
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyFZrMibbYQXZTKYsDHmSzcDQAMXiYAAFABKW5TDT9eB9I56ZRiZ7XVrKSh7bhM-Ik37kkrHBAAYQG5XpjPJzKi3A5XNgGBYZCIygI9IFzKchIVCTEyhI5LlVwAfBoaULmQAeKAQABulrtivt7M5GhOYCuwDiUESVqVKu5N0D8FWYTdCsVGntNU5YlkGlkRBlZX94rg8GlEHKTlj8fjVK12WSiS9YndDrCSbEKe4xY9YSdrqFdIFBsF3DA6LkNJOWoEcgwNTIUAAnqiLdb7VSSMsY12AjJZux4CQlDVeDVTF9TPBSX8bEgAMyOFxucFCDBEAhQwIwkJKABU8uZE+07QIEAAXkc0RvBOJBBiQ7Tft2hoTtOn7NHI7QsPw7BTm8BC8NwBC-luEAsHqSwjNERxvPYtB6NoBF6LwMBAW8tDQb2IhoPBagkMRHQpno9EERqiF-v+8CkfYFGMVMIj2KxRFHO0XE8UKfFiL+AFCRoZGiVMPbieeUnsTJckaAxCkwspglvGgWAadwWncCIAAsukcbJZDcYZvEmQJqloAAbFZNkiCgjn6S58kKoppleXZfmGiI3lBZxIVucZ-EqeZImUZphoyEG8HhZ55kYPY8BgGJ3B8vB1G0dw0TtEcAzcPAv5iCMYikeRGXWYah4-GS1ggHZWBILQziME4QA)

## [Updating state based on previous state from an effect](https://react.dev/reference/react/useEffect#updating-state-based-on-previous-state-from-an-effect)

### React

React heavily relies on the `useEffect` hook for usecases involving:

* Running code on mounting of a component
* Running code on dependency updates (whether it be state or props)
* Running code on unmounting of a component
* Running code related to external systems (the DOM, third-party libraries, etc.)

This hook famously replaced every lifecycle event used when class components were idiomatic React.

```jsx
function Counter() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const intervalId = setInterval(() => {
      setCount(c => c + 1);
    }, 1000);
    return () => clearInterval(intervalId);
  }, []);

  return <h1>{count}</h1>;
}
```

### umai

In comparison, umai much more minimal. There is no special API for effects. However, we can re-use an existing concept we touched on earlier.

The handler passed to the `dom` property is only called once upon DOM node creation. Therefore, we can leverage it to run effects on "component mount". Additionally, a cleanup function can be returned in this handler to run code upon element removal.

```jsx
function Counter() {
  let count = 0;
  let intervalId = null;

  function onMount() {
    intervalId = setInterval(() => {
      count += 1;
      redraw();
    }, 1000);

    return () => clearInterval(intervalId);
  }

  return () => <h1 dom={onMount}>{count}</h1>;
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyVEJKDDfYrNZkTbbCC7KZTFgY8yWbgaADC6OCJAAFABKW5TDT9eB9GQYvo3Wh7GlcvpHeQkABuvFgAEkoNdWspKEKOflKb8abIALIMsSs9nCzli+CS6VyhUmMQyxlS2BM-VXAB8Bs5ro0vLkGgA1Dc0EK3ZzsbjWf7XS4NGhaFGWSrDRoEmJlCQaQ7ncBVW6iAgRtbxbamcbTbKoDGMx9VU4ycKE0mU2ynRoADwiNAaE5gK7AbW6pyO4AesRORthFuOoWV7jk9XUjQAQT0en16eFCD6BBEpwVLGlJljnIp3Cpsg0loAyhv9kztGzl2715ubtpQxPVTXkxpUx+y42oBAJY6y05RsamUMQxGPWQswgcpO0-M8LyZABCe99hZXtANdYAUI0AB+DQNgAVW4MBdQ2DQ3g2HU+Q2VZkkSGRZlkEIMOHECwNkAC405LCLw0AAyPim3pPkTQ0MJHQnN1h1-f9VVLbgX0nYjdSZE4iFUEIMBqMgoAAT1RT9G3nPQxMdGMAgYvR2BNJQal4GpTC+Ux4CPbhrBAWwABZaGBNxwSEDAiAIKFAhhEIlAAKhdDRtO0doCAgAAvI5ojebSSCgE12li8cq20vTopYGF2m3SBYF0t4CF4Nz4pNCAWFDNQSGiI43nsWg9CfVU9F4GAUreQUpkUltoqalqOnAvQBtDIq5HipL4Da+xOtypSRHsUaRnG9pJum1VZrEebEsWjR2pWoaqxEABmTbmqOHayCmjRBuFA6jpOtAsHOhTLs827tt256ZuKhLjreNAADZvuGlB-vuwGXv3EGFvBzzocuiG4Ymx69te5GwYjZaup+pSZEywr8Y+jB7HgMBVqmJVop6vruGidojgGbh4HisQRjENqOuJxSnJ+al3M8rAkB8pxGCcIA)

Some interesting things to note:
* Since stateful components in umai are "closure components", we don't have to keep track of dependencies with dependency arrays like in React -- the outer function is only run once on component mount.
* umai uses "[global redraws](https://github.com/kevinfiol/umai?tab=readme-ov-file#redraws--state-management)". Rerenders are only triggered by event handlers defined in your JSX, or by manual `redraw()` calls. During asynchronous operations, calling `redraw()` is necessary to tell umai to re-render.

## [Adding a reducer to a component](https://react.dev/reference/react/useReducer#adding-a-reducer-to-a-component)

### React

React's `useReducer` hook allows developers to implement an immutable store similar to Redux. A nice thing about this pattern is multi-property state alterations can be designated as "actions" which may optionally contain payloads.

```jsx
import { useReducer } from 'react';

function reducer(state, action) {
  if (action.type === 'incremented_age') {
    return {
      age: state.age + 1
    };
  }
  throw Error('Unknown action.');
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, { age: 42 });

  return (
    <>
      <button onClick={() => {
        dispatch({ type: 'incremented_age' })
      }}>
        Increment age
      </button>
      <p>Hello! You are {state.age}.</p>
    </>
  );
}
```

### umai

You may have already guessed, but umai does not feature any reducer methods or utilities to build a store. However, you may leverage any store/observable library to implement your own, such as dipole, preact-signals, MobX, Immer, or even Redux. Below, I give an example using [vyce](https://github.com/kevinfiol/vyce), a 463 byte observable store. Notice that the reducer is unchanged from the React example.

```jsx
import { store } from 'vyce';

function reducer(state, action) {
  if (action.type === 'incremented_age') {
    return {
      age: state.age + 1
    };
  }
  throw Error('Unknown action.');
}

function Counter() {
  const state = store({ age: 42 });
  const dispatch = (action) => state((prev) => reducer(prev, action));

  return () => (
    <div>
      <button onclick={() => {
        dispatch({ type: 'incremented_age' })
      }}>
        Increment age
      </button>
      <p>Hello! You are {state().age}.</p>
    </div>
  );
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyFZrMibbYQXZTBHzW4aAhieKJVYsdYaDYANwAnkR4ATuFMWBjzJZuBoElBlMySAAKMm8eSo3rcgCUtymGiiLA0QslsgwYgZekSV21tKO9wEwSgAH1eNEWTLgHL5bz4GJlCQeZaedb5ab4G9RfIMG6NABqDRoK3ypx7Z1OK3Jcj7DSPEjkYUbACq3DKcX2PJV3AwGylofDbO4HO4XNkGgAwujgsKLVagmTSWIxVqGxShYs3W8ACz2Fa52tWPpQVJ6MVEETXJWZmVXAB8DabQqFegSdOnc75AvgwuX8DpEpL3ClfYL8oSdodSrXSqDGgAPEO6TOb-LbzVlGJyTzZEQBuUrsAhSvJ0XRdIcCBHMQxzbJINXdXViwSA15GNN0Nl7Z8VicJ9nRAjQAEkEPgJCNDdDDbzCN8P1kbDcNvPQZwACVMWAyAAQg0ABNdESISW5PXgQDvTNJwMHI+ib3Ih8aI0Y98ymMBKzEIUTiIVQQgwGoyCgBlUUA6451vCsMXkEgNDCGdcwCGRZnYLclBqXgalML5THgA9rBAWxaHaewsCQTtaGBNxwSEDAiAIKFAhhEIlAAKllZ1NO0doCAgAAvI5ojeTSSCgLd2iSvMpimTTtIS+UWBhdoWH4dgGQ9XhuAIFKtwgFhQ3lNQSGiI43nsWg9G0DqNBHGBMreWgioLEQ0HKpYRh6jpyT0CbhsquQUvSuD7HsQapqmEQe2A+buqOdpltWq11rETa0u2gahqmOTuBEABmOausW86yBWjRJquqrUrut40CwPanuKl7Ow+hazouv61sBraQYANnB7hnpEFAYdOpafsu51rtuuC0E7dHMZRnGvvh-7CaR4GA12x6MchmQ8rmomgZJjB7CI-buGUWA5tGoduGidojgGbh4BSxskT6h7+Zcn5uQ8zs-MCpxGCcIA)

umai aims to be closer to vanilla JavaScript than React. In the same spirit, we can choose to embrace mutability using a pattern that avoids bugs that would normally arise from it -- and we can do so without any third-party libraries.

```jsx
const createState = () => ({ age: 42 });

const createActions = (state) => ({
  incrementAge() { state.age += 1; }  
});

const state = createState();
const actions = createActions(state);

function Counter() {
  return (
    <div>
      <button onclick={actions.incrementAge}>
        Increment age
      </button>
      <p>Hello! You are {state.age}.</p>
    </div>
  );
}
```

[Live Example](https://flems.io/#0=N4IgtglgJlA2CmIBcBWAjAOgBxYDQgGcBjAJwHtZZkBtABl1oF18AzCBAm0AOwEMxESEBgAWAFzBV8RMtzHw5yEAFcwvCAAJ4AD34AHBCHwF4CImIizOQ2kjQAmEAF9cPfoJAArAtozejIDJyCmJKAPRhGhAA5txkJPAaYiIQBADcSSkEUdm8GiwIYNkivEQA1klkWnwARgga3tr58Rpx3AC0AErwpWIasBA1JLwkEPAEADrcEGB68X3AGmAaTvnkywDkquobaVMA7hDcUGT7GN29GgC8GoukPfIAooUhSEsraQEmZhZWSrb2FDOVwgPgCJR+TjSWTyRRCGZzEgLJa4JZkZRyFZrMibbYQXZTKZBAh9e68eQAZTE5MSNwAFABKa4APg0dMWvGi8DeABZ7CsGXtuESrKSEjSAILmSzcbL0kk0plXVnsqYaKLce4COQSrmM24aBXyDCcxIAahuaAyqw0UycgsJmtFhup8muGjJlNd8EZQuJfV6MrlHvF8ilv1ldKN8Adwu4LAx0tkGgAwujgiR9cA1RoEmJlCRuGyc+qADxQCAAN2ZJfVGlLNWUYjEydkRAG5SuwEDVgwRy1IV18CcNaLdfHAElNQltQGubWy2FG83ZKPx2W9MyABKmWBkACEGgAmuiNCNEsBoyauU4MKWwpva-eK9Wc7GnI6wOmxHSTkRVCEGA1GQUAAJ6ovqyr1mmGLyCQGhhMygoBDIszsPAJBKDUvA1KYXymPASayv8SC0O09j2EgPK0MCbjgkIGBEAQUKBDCIRKAAVLcObAdo7QEBAABeRzRG8wEkFAGHtLxQofnGwFgdxY4sDC7QsPw7CgW8BC8LK-EYRALBCuqagkNERxvPYtB6NoxkaHovAwCJby0LJjoiGgSkmSM5kdC2eguXZKlyPxQnchoFE2W5cYiPy2ZjqZvntP5gU5sFYihYJ4VWVFdruQAzF5Sw+UcyVkAFGiuWlqkCVlbxoFguXcHJUwiDyRWJaVKWVUFNVhfVABsTUtdwIgoB1JV+eVqXKX1dUaGgPLDe5A0TWZXXTT11UhbV4UOMtcYyJJRXpZle0YPY8BgNFUzKLARUOU53DRO0RwDNw8D8dSSKWdZtl5XG+E-EGSg8lgpHOIwThAA)

* Instead of using strings to name actions, we simply use functions, e.g., `incrementAge`
* The `createActions` factory function produces a unique actions bag *scoped* to the state object passed to it. These actions are the only means of updating the state.

One caveat of this approach is that it is still possible to mutate the `state` object directly. If you are using TypeScript, you can use the [`Readonly`](https://www.typescriptlang.org/docs/handbook/utility-types.html#readonlytype) utility type to discourage this.

```ts
interface State {
  age: number;
}

const createState = (): State => ({ age: 42 });

const createActions = (state: State) => ({
  incrementAge() { state.age += 1; }
});

const state: Readonly<State> = createState();
const actions = createActions(state);

state.age = 10; // Cannot assign to 'age' because it is a read-only property.
```

Another interesting thing to point out is that React **batches state updates**. The reason for this is to prevent unncessary re-renders upon updating multiple state variables (for example, if you call `setState(x => x + 1)` 3 times in a row, React will only re-render once). This is a smart and sophisticated optimization.

This kind of optimization is **unneeded** in umai. Whereas the developer must remember the rules of re-rendering in React as it pertains to several hooks, umai only re-renders in these two instances:
1. An event handler is called, e.g., `onclick`, `onchange`, `oninput`
2. `redraw()` is called

## Wait, so should I migrate to umai?

No. Unsurprisingly, [umai](https://github.com/kevinfiol/umai) is very much a work-in-progress, a one-man hobby project, and not as feature-filled as React or Mithril.js for that matter. At the time of writing, umai is at version `0.2.6`. Here is a short list of things React has that umai does not:

* SSR support -- there is currently no way to render umai components with Node/Deno/Bun
* Keyed fragment support
* Error handling and useful error messaging
* Developer Tools
* Frameworks (Next.js, Remix, Gatsby, Waku)
* Mobile frameworks like React Native

Nevertheless, I think there is value in comparing it to React, if only to see what else is possible in the realm of uncompiled, single-page application libraries. I firmly believe the patterns presented by umai, and its main inspiration ([Mithril.js](https://mithril.js.org)) are viable alternatives. And, in my opinion, these patterns are *better* than the status quo set by React and Facebook/Meta. For that reason, I do encourage anyone with a small, low-stakes hobby project in mind to take `umai` for a spin.

For more examples of umai in action, check out the [examples](https://github.com/kevinfiol/umai?tab=readme-ov-file#examples) section of the README.
