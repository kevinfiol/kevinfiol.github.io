+++
title = "A Tour of BeanCMS"
+++

# A Tour of BeanCMS

[BeanCMS](https://github.com/kevinfiol/beancms) is a minimalist content management system. I built it as a personal replacement for the great [rwtxt](https://github.com/schollz/rwtxt). The motivation to build BeanCMS was:

1. I wanted to self-host rwtxt, but had some changes I wanted to make to the core application.

2. I wanted an excuse to build something using [redbean.dev](https://redbean.dev/) and [fullmoon](https://github.com/pkulchenko/fullmoon) while demonstrating that Redbean and Lua are viable options for building web applications

As a result of using redbean, BeanCMS is deployed as a single >7MB file that runs natively on Windows/MacOS/Linux -- all without cross-compilation! Take a look at the [repo](https://github.com/kevinfiol/beancms) for installation instructions.

## Getting up and running

In short, download `beancms.com` from the [releases](https://github.com/kevinfiol/beancms/releases) page. On Linux/MacOS, `chmod +x beancms.com`. Then, on Windows/Linux/MacOS, simply run the file while using the current directory to store persisted data:

```bash
./beancms.com -D ./
``` 

Right away, you'll notice a `data` directory created next to your executable. This is where all persisted data for BeanCMS is stored. BeanCMS uses SQLite as supported by Redbean, which means to back up your site data, all you have to do is copy the `data` folder.

{{ img(src="https://github.com/user-attachments/assets/18ed9c08-6e1e-456b-89b4-4421aa34c2c4" alt="files screenshot") }}

Upon opening the site at `localhost:8080`, you'll see the welcome page. From here, new users can register, or existing users can log in.

{{ img(src="https://github.com/user-attachments/assets/a21b2e28-971c-40a1-9d60-8784160ab11f" alt="welcome page") }}

## User Page

Upon logging in, users are able to customize their profile pages by modifying their personal title, filling in an intro section, selecting from multiple free/open-source themes, or adding their own custom CSS that will apply to their profile page as well as their writings.

<video controls src="https://github.com/user-attachments/assets/193b7f3c-75a0-4ac4-9050-f8948b5b3ced"></video>

## Writing posts

Posts slugs are generated automatically by parsing the first line of the post content.

<video controls src="https://github.com/user-attachments/assets/d54de71d-63ac-42b9-9c55-2ed0feeb8d4f"></video>

Drafts are saved automatically on users' local machines.

<video controls src="https://github.com/user-attachments/assets/43fa99de-e048-4335-802f-c0d3557072d4"></video>

BeanCMS supports syntax highlighting for codeblocks.

<video controls src="https://github.com/user-attachments/assets/1cede03e-e15e-4c3a-b545-0d6494853c08"></video>

BeanCMS supports other features you'd want in a blog or note taking app, such as image upload, hotkeys, and table of contents support.

<video controls src="https://github.com/user-attachments/assets/e1af1679-f659-4f5e-95c5-a5bafb31d1da"></video>

You can grab the raw Markdown of a post by appending `/raw` to any post url.

Lastly, Atom feeds are enabled for all user blogs by appending `/feed` to a user's profile url!

<video controls src="https://github.com/user-attachments/assets/290d9738-9a35-4243-ba6a-d9a6d27deac9"></video>

## Admin Panel

BeanCMS comes with an included admin panel only accessible to a list of specified IP Addresses. By default, only `127.0.0.1` is allowed to access the admin panel, which provides information such as registered users, active sessions, uploaded images, and storage usage.

{{ img(src="https://github.com/user-attachments/assets/75705555-24c5-41d7-a6f8-bbb41aebc56b" alt="admin page") }}

## Try it out!

BeanCMS was intended as a hyper minimal blogging/note-taking app that I can self-host for myself and friends. Thanks to redbean, deployment is fast, tiny, and dead simple. A huge thanks to Redbean and Cosmopolitan Libc maintainers for building such a brilliant tool. And an enormous thanks to Paul Kulchenko for providing clarity and creating [Fullmoon](https://github.com/pkulchenko/fullmoon), a minimal but batteries-included web framework for Redbean.
