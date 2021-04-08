+++
title = "demos"
template = "page.html"
+++

A collection of stuff I've worked on or made. Visit my [Github page](https://github.com/kevinfiol) for more.

[enhanced-gog](https://github.com/kevinfiol/enhanced-gog) - a userscript for [GOG.com](https://gog.com) that aims to improve the overall browsing experience by automatically finding and displaying current and historically lowest prices for games across multiple online stores. Enjoyed by many in the GOG community. Built with Hyperapp.

[it's drm free](https://github.com/kevinfiol/its-drm-free) - a userscript for [steampowered.com](https://steampowered.com) that finds and displays latest prices from DRM-free storefronts. Built with lit-html.

[etto](https://github.com/kevinfiol/etto) - tiny, framework-agnostic autocomplete and select component for modern JavaScript projects. Extremely customizable with zero dependencies, and CJS/ESM exports.

[steam friend night](https://sfn.vercel.app) - a web app based on the Steam Web and Storefront API, used to find what multiplayer games you and your friends have in common. Built with Svelte and Tailwind CSS on the front-end, Polka, Knex, and Objection.js on the back-end. The [server](https://github.com/kevinfiol/sfn-server) is running via Docker container on a Raspberry Pi located in my home office, so excuse any downtime.

[steam-service](https://github.com/kevinfiol/steam-service) - a REST API that serves data from the Steam Web and Storefront API. Used for the above-mentioned steam-friend-night. Caches game data with Postgres. Built with PHP7, Slim, and Doctrine ORM.

[mithril-pres](https://mithril.netlify.app/) - a presentation full of practical examples demonstrating [Mithril.js](https://mithril.js.org), including client-side routing, stream data-types, third-party library integration, and JSX. Source code [here](https://github.com/kevinfiol/mithril-pres).

[backlog](https://github.com/kevinfiol/backlog) - a small web application to help manage video game backlogs. Built with Polka, Preact, and SQLite. I have an [instance](https://backlog.sheev.net/) running on a Raspberry Pi 4.

[fireblog](https://fireblog.vercel.app) - *Deprecated.* a blogging SPA solution powered by Google Firebase Realtime Database that allows for multiple user registration. Built with Mithril.js. Source code [here](https://github.com/kevinfiol/fireblog).

[colm](https://addons.mozilla.org/en-US/firefox/addon/colm/) - a Firefox browser extension to create a custom newtab page using Markdown. Built with Mithril.js.

[last.fm userscript](https://gitlab.com/kevinfiol/lastfm-artists-userscript) - a userscript for Last.fm to add a 'Compare Artists' functionality to user profiles. Built with Hyperapp.

[parasite](https://keb.itch.io/parasite) - A game and interactive poem created for a Literary Studies course. Includes a brief essay on its meaning and inspiration. Built with Impact.js.

[kevinfiol.com](https://github.com/kevinfiol/kevinfiol.com) - *This site!* Built with Zola & Markdown. 11ty and Jekyll before then. Personal sites are a great vehicle for exploring static-site generators 🙂.

## Contributions

[mithril.js](https://github.com/MithrilJS/mithril.js) - *Contributor*. PR to fix annoying bug where `m.request` was not properly rejecting on XHR timeout. Wrote accompanying test cases for proper rejections using Mithril's `xhrMock` utility.
