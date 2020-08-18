---
layout: post.pug
tags: post
title: Making your numeric keypad work on a Xubuntu 20.04 VM (VirtualBox)
date: 2020-08-18
---

# Making your numeric keypad work on a Xubuntu 20.04 VM (VirtualBox)

I fought with this for a good 2 hours before I finally got it working. First step is install `numlockx`, if it's not already installed:

```bash
sudo apt update
sudo apt install numlockx
```

Enable your Num Lock in your VM:
```bash
numlockx on
```

Now in Xubuntu, go to your Whisker Menu (or whatever launcher/menu you're using) and navigate to `Settings -> Accessibility -> Mouse` and disable `Use mouse emulation`. If you're on Ubuntu, or another DE other than XFCE, you may be looking for a menu called `Universal Access`.

You may need to log out and back in to confirm this works.
