---
layout: post.pug
tags: post
title: Git Cheatsheet
date: 2019-05-22
---

# Git Cheatsheet

This is a collection of `git` commands that I use frequently. May or may not be useful to you, but it's useful to me, goddammit.

### Git Add Interactive Mode
```bash
$ git add -i
```

### Clone repository / respective branch:

```bash
$ git clone -b <branch name> <host>
```

### Delete Local and Remote Branch

```bash
$ git push origin --delete <branch_name>
$ git branch -d <branch_name>
```

### Merge to Master

```bash
$ git checkout master
$ git pull origin master
$ git merge --no-ff test
$ git push origin master
```

### Merge into some other branch

```bash
$ git checkout production
$ git merge development
$ git push origin production
```

### Create a new branch and push it to the remote repo

```bash
$ git checkout -b myFeature dev
$ git push origin myFeature
```

### Stashing Work In Progress (WIP) changes

```bash
$ git stash
```

And to get it back:

```bash
$ git stash pop
```
