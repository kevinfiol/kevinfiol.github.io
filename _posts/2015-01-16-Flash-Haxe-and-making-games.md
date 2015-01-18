---
layout: post
title: Flash, Haxe, and making games
---

Around the same time that Canabalt exploded in popularity in 2010, [a little site](http://flashgamedojo.com/) popped up built by Adam Atomic and contributors to promote game development using libraries built on Flash.

These libraries were [Flixel](http://www.flixel.org) and [Flashpunk](http://www.useflashpunk.net). Flixel was developed by Adam Atomic himself, and was the framework used to create Canabalt. Both were, however, simple and powerful libraries which, when used in conjunction with the open-source FlashDevelop and Adobe AIR, allowed users to quickly churn out prototypes without having to worry about implementing their own collision detection methods, or tilemap support, or 2D cameras; Flixel and Flashpunk took care of all that. They were fast, open-source, and easily extendable. Games were easy to publish on the web, and with AIR, on desktop and mobile platforms as well.

Why is this relevant? Well, Flashpunk and Flixel were the first times I tried a game framework --- and it looks like I've come full circle in the form of [HaxeFlixel](http://haxeflixel.com/). 

<div class="img-container">
<img src="{{ site.url }}/assets/haxeflixel.png" />
</div>

Adobe has effectively killed all support for flash, ActionScript 4 was abandoned, and AIR support for Linux was cut. Enter OpenFL, an open-source alternative to the Flash API completely rewritten in glorious Haxe, the cross-platform toolkit that'll compile straight to Flash, JavaScript, or desktop applications all quickly, and accurately. The language itself is rich and truly object-oriented, with support for classes, interfaces, and inheritance; it's strongly-typed and it has the option for dynamic typecasting. It looks good and it feels good to write, and coupled with Lime and OpenFL, my Haxe code compiles to Flash or Windows, Mac, Linux, and Mobile all running consistently.

And now with HaxeFlixel, a port of Flixel to Haxe and OpenFL, I can get that lightweight comprehensive framework that Adam Atomic built nearly five years ago and not have to worry about some software company dropping support. If there's an issue, I can go in and fix it, and [not have to wait around for the next update for my bug report to get addressed](http://issuetracker.unity3d.com/).

In short: Haxe and OpenFL are wonderful, and I love being able to code with the Sublime Text 3 Haxe Plugin. It's just too comfy.

