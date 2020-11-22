+++
title = "Git Cheatsheet"
date = 2019-05-22
template = "post.html"
+++

# Git Cheatsheet

This is a collection of `git` commands that I use frequently. May or may not be useful to you, but it's useful to me, dammit.

## Git Add Interactive Mode
```bash
git add -i
```

## Clone repository / respective branch:

```bash
$ git clone -b <branch name> <host>
```

## Delete Local and Remote Branch

```bash
git push origin --delete <branch_name>
git branch -d <branch_name>
```

## Merge to Master

```bash
git checkout master
git pull origin master
git merge --no-ff test
git push origin master
```

## Merge into some other branch

```bash
git checkout production
git merge development
git push origin production
```

## Create a new branch and push it to the remote repo

```bash
git checkout -b myFeature dev
git push origin myFeature
```

## Stashing Work In Progress (WIP) changes

```bash
git stash
```

And to get it back:

```bash
git stash pop
```

## So you forked a Repo and want to keep your fork updated

```bash
git remote add upstream git@github.com:company/projectyourforkedfrom.git
```

To update:

```bash
git fetch upstream
git rebase upstream/master
```

If you have commit rights to the upstream repo, you can create a local `upstream` branch and do work that will go to upstream there.

```bash
git checkout -b upstream upstream/master
```

## Sometimes, you want to locally (or temporarily) ignore a file but don't want to add it to `.gitignore`

Be careful with this, because if you ignore a file, and then do a `git pull` after the file was changed upstream, you'll get a conflict. And you'll be confused because Git will tell you to stash your changes, all the while `git status` is showing no changes.

Ignore it:

```bash
git update-index --assume-unchanged <file>
```

Unignore it:

```bash
git update-index --no-assume-unchanged <file>
````
