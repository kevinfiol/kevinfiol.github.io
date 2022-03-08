+++
title = "Binding Mouse Button + Scroll Wheel to System Volume Control"
date = 2021-01-22
template = "post.html"
+++

# Binding Mouse Button + Scroll Wheel to System Volume Control (on Windows or Ubuntu Linux)

## Some Context

About six years ago, I purchased a ROCCAT Savu gaming mouse to serve as my daily driver. The mouse itself was mediocre, but the bundled Windows-only software included a feature that I enabled on a whim that allowed the user to hold a button on the side of the mouse and use the scroll wheel to control the system volume. I didn't think much of the feature. A couple years later when my Savu finally died, I replaced it with a Logitech G203, only to find that controlling the system volume with the scroll wheel had become second nature.

## Windows

Fortunately, Logitech's software included ways to bind keys to mouse buttons, and using an [Autohotkey script](https://gist.github.com/kevinfiol/e7a915a3ed6f1f3e6d5f745633b61617) to fake an `F13` key press, I was able to bind my mouse button to a non-existent key. Afterwards, I simply launch another [Autohotkey script](https://gist.github.com/kevinfiol/9214d92033fc6a6784a607c97aa50838) on system startup to have system-wide volume control bound to my mouse.

## Linux

The state of consumer-grade peripheral software on Linux is getting better by the day, but still severely lacking compared to Windows. For the most part, you should be fine with [Piper](https://github.com/libratbag/piper/) for your gaming mouse needs on Linux. However, Piper itself is insufficient for our goals.

In the end, I was able to achieve similar functionality to the Autohotkey script above using `xbindkeys` and `xdotool`, both of which you can install using your package manager:

```bash
# Ubuntu
sudo apt update
sudo apt install xbindkeys xdotool
```

Create `~/.xbindkeysrc` in your home directory and paste:
```
"xdotool keydown ctrl"
    b:8

"xdotool keyup ctrl"
    release + control + b:8

"pactl -- set-sink-volume 0 -5%"
    control + b:5

"pactl -- set-sink-volume 0 +5%"
    control + b:4
```

Run `killall xbindkeys && xbindkeys` to restart xbindkeys.

A few things to note:
  * You may find xbindkeys keycodes using `xbindkeys --key` or mouse button codes using `xev`.

  * I am binding the side button on my mouse `b:8` to the Control key on my keyboard using `xdotool`. This may or may not work for you if you already bind your Control key to something else. What this means in practice is that holding your mouse button is essentially like holding the Control key.
    * This is a particular point of frustration on Linux, as it seems xbindkeys is very selective of what keys can be used as modifiers. The manpage lists `Release, Control, Shift, Mod1 (Alt), Mod2 (NumLock),
Mod3 (CapsLock), Mod4 (Super), Mod5 (Scroll)` as available modifiers.

  * The commands `pactl -- set-sink-volume 0 -5%` and `pactl -- set-sink-volume 0 +5%` assume you are using the PulseAudio sound driver. These commands may not work for you if you're using the ALSA sound driver, in which case, you may use commands like `amixer -q sset Master 5%-` and `amixer -q sset Master 5%+` respectively. If neither of these work, try `amixer -q -D pulse sset Master 5%+` and `amixer -q -D pulse sset Master 5%-`, or research how to control your master volume by command line on your system.

## Update, or, how to bind the Super key (03/08/2022)

A little over a year later, I discovered [ksuperkey](https://github.com/hanschen/ksuperkey), and further [xfce-superkey](https://github.com/jixunmoe/xfce-superkey) (I am an XFCE user). Last year, I avoided binding to the Super key because more often than not, this will interfere with existing keybinds in DEs where the Super key opens the Applications menu. This is the case in XFCE where the Super key is used to open the Whisker Menu. While you can simply rebind your Applications shortcut to something other than `Super`, I personally find it hard to deprogram this instinct. The above utilities allow you to keep `Super` as your sole shortcut to `Applications` but also allow you to use it in other keyboard combinations. **Note:** if you use XFCE, you still have to unbind Whisker Menu from `Super` in your Keyboard settings -- don't worry though, you'll still be able to use `Super` after running `xfce-superkey`. After installing the above utility, I changed my `.xbindkeysrc` to:

```
"xdotool keydown Super_R keydown ctrl"
    b:8

"xdotool keyup Super_R keyup ctrl"
    release + Mod4 + control + b:8

"pactl -- set-sink-volume 0 -5%"
    Mod4 + control + b:4

"pactl -- set-sink-volume 0 +5%"
    Mod4 + control + b:5
```

## Helpful related reading

* [Xbindkeys manpage](https://linux.die.net/man/1/xbindkeys)
* [ArchWiki article on xbindkeys](https://wiki.archlinux.org/index.php/Xbindkeys)
* [AskUbuntu question with helpful suggestions](https://askubuntu.com/questions/627555/how-to-map-modifiers-e-g-ctrl-to-mouse-thumb-buttons-using-xbindkeys)
* [Helpful blog article on using mouse buttons with xbindkeys](https://web.archive.org/web/20200107023614/https://blog.hanschen.org/2009/10/13/mouse-shortcuts-with-xbindkeys/)
