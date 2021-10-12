+++
title = "A minimal RSS Feed Reader"
date = 2021-10-12
template = "post.html"
+++

# A minimal RSS Feed Reader

Since mid-2020, I had been using [Inoreader](https://www.inoreader.com/) as my main RSS/Atom feed reader. Inoreader offers a generous free tier, giving you a maximum of 150 feeds per account, as well as a bunch of QoL features like search, bookmarking, and a dashboard with reasonable amounts of customization. The free tier is ad-supported which is understandable. For the most part, the ads are unintrusive. Using an adblocker such as uBlock Origin ocassionally results in a popup reminder by Inoreader that their free tier is ad-supported, kindly asking you to disable your adblock.

Last year, I had also come across George Mandis' [Bubo Reader](https://github.com/georgemandis/bubo-rss), an "irrationally minimalist, static RSS feed reader you can instantly deploy on Netlify, Glitch or your own server." George has a great introductory blogpost on his site [over here](https://george.mand.is/2019/11/introducing-bubo-rss-an-absurdly-minimalist-rss-feed-reader/) which I recommend reading if the description I gave seemed interesting at all. TL;DR: Bubo Reader is nothing but a static .html page that gets rebuilt and redeployed via a Node.js script. The script will be run at a set interval, fetch the latest posts from feeds (defined in a .json file), and *boom* you got a new `index.html` file with a couple `<ul>` lists of the latest articles.

When I first checked out George's [demo](https://bubo-rss-demo.netlify.app/) for Bubo Reader, I simultaneously thought "wow this is cool!" and also "wow this is crappy!". My latter thought stemmed from the fact that the demo is really *irrationally* minimal.

The genius of Bubo Reader is summarized in a few points that I realized slowly over the past year:

  * **A feed reader doesn't need to be updated too frequently.** Inoreader will refresh your feeds and even update the page dynamically if there are any new items. But why the desperation for new content to consume? I realized that Inoreader enabled my bad habit of seeking the dopamine boost that comes with getting something "new." You know what I'm talking about -- it's the same reason why immediately after closing your reddit tab, your first instinct is to Ctrl+T and go back to reddit. It's an unhealthy craving because there is always some new article to skim, comments section to meander about, or funny gif to laugh at instead of doing something productive. In George's Bubo Reader example, the feed is updated every 15 minutes. Personally, I find that 1 hour is the perfect inverval.
  * **A feed reader doesn't really need a bookmarks manager.** I tried to use Inoreader as my all-in-one bookmarking tool. I had quit Pocket and given up on Instapaper. I thought maybe my feed reader can be my bookmarks tool. The issue was that Inoreader is clumsy to bookmark articles or content that you find *outside* of your feed, and I wouldn't be surprised if other readers had the same issue. In addition, every modern browser has a bookmarking feature, and inevitably, your bookmarks will become split between your browser's built in bookmarks, and your feed reader's bookmarks. I gave up on this division. Firefox now handles all of my bookmarks and it syncs between devices using a Firefox Account.
  * **A feed reader doesn't need to be able to scrape article contents.** Probably 6 times out of 10, Inoreader would mess up the content scraping anyway, which in the age of SPAs and paywalls, is not surprising. Even when it scraped things properly, I generally still prefer to read the article on the site it originated on while using Firefox's built in reader mode.
  * **A feed reader doesn't need client-side JavaScript.** Shocking, I know. There are certainly some niceties that can only be had with JavaScript, but I found George's use of `details` and `summary` elements to be exactly what I needed.
  * **I don't need a mobile app.** I don't like staring at my phone for long periods of time. In general, I think it's not a great habit. While Bubo Reader can be viewed in a browser, I don't use it that way. If I did, I could easily put some time in to make my version mobile responsive.
  
Last month, I [forked](https://github.com/kevinfiol/reader) Bubo Reader and made several personalized changes and improvements. In addition to a dark mode, I took inspiration from the [John Doe](https://john-doe.neocities.org/) webpage that was a bit popular on Hacker News some time ago, using the CSS `:target` selector to create a "sidebar" for my reader. In addition, I adjusted the build script to sort feeds by the most latest updated.

The end result can be found at [kevinfiol.com/reader](https://kevinfiol.com/reader/).
