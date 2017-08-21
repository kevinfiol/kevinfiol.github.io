---
layout: post
title: Keeping Promises
---

I began experimenting with the free tier of [Google Firebase](https://firebase.google.com/) for apps, and other goofy purposes. I've since implemented a new feature on a current project using [Mithril.js](https://mithril.js.org), wherein users are able to edit and create new pages in real-time using Markdown. Because the creation of new pages are asynchronous and the app needs to know when Firebase has inserted the new data (or if it was rejected, or if there was an error, etc), the first thing that came to mind was 'use Promises.' 

Firebase methods return promises by default. This was great! So I created a handy little tool called `firetool.js` that will contain all methods pertaining to my Firebase connection, and make the development of my app a little easier:

```javascript
// firetool.js
import * as firebase from 'firebase/app';
import 'firebase/database';

export const firetool = {
    db: null,

    init(config) {
        firebase.initializeApp(config);
        this.db = firebase.database();
    },

    createPage(page) {
        const ref = this.db.ref('views/pages');
        return ref.child(page).set({
            content: 'blank data'
        });
    }

    ...
}
```
All well and good. Firebase creates the request, returns a promise that my new page will be made (or not), and will keep me posted on the news. Now, it's a simple matter of handling the response data, and what to do in case of a fire:

```javascript
// pages.js
firetool.createPage(page)
	.then(() => {
		vnode.state.message = 'page created!';
		m.redraw(); // have to tell Mithril to refresh the virtual DOM!
	})
	.catch(() => {
		vnode.state.message = 'an error occured!';
		m.redraw();
	})
```

This works just fine, but the more I looked at it, the more I wanted to isolate logic to `firetool.js`, and keep the workload off `pages.js`. Additionally, I need to be able to check if the page exists before I attempt to create it.

The problem becomes that the state of `pages.js` needs to know when to set the vnode data, and update the view.

Eventually, it made more sense to wrap the existing Firebase promise within my own:

```javascript
// firetool.js
createPage(page) {
    const ref = this.db.ref('views/pages');

    return new Promise((resolve, reject) => {
    	// Check if the page already exists
        ref.child(page).once('value', (res) => {

        	// If the reference result is not null
        	// the page already exists!
            if(res.val() !== null) {
                resolve({ message: 'page already exists' });
			} 

			// Attempt to create the page
			// Return an object containing the message to return
			else {
                ref.child(page).set({ content: '' })
                    .then(() => resolve({ message: 'page created!' }))
                    .catch(() => resolve({ message: 'an error occured!' }));
            }
        }, (err) => reject(err));
    });
}
```

And now it's a simple call to `firetool.createPage`, and I can easily handle the response data.

```javascript
// pages.js
firetool.createPage(page)
	.then((res) => {
		vnode.state.message = res.message;
		m.redraw();
	})
	.catch((err) => {
		vnode.state.message = err;
		m.redraw();
	})
```


