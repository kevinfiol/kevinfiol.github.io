+++
title = "Getting rid of the Credential Helper Selector on Git for Windows"
date = 2020-09-18
template = "post.html"
+++

# Getting rid of the Credential Helper Selector on Git for Windows

If you're ever been tormented by the following pop-up when trying to push or pull from an HTTPS Git origin:

![Windows Credential Helper Selector](/img/blog/helper.jpg)

There may be a way out of your misery. Initially I thought that if I added my Git credentials for the respective remote origin directly into my `.gitconfig` file, Git for Windows would stop prompting me every time I wanted to push or pull. Nope. And even more painful is that **for some unknown reason** the pop-up would appear *twice* no matter what -- even if I selected `Always use this from now on`.

## How to

First off, you can simply choose to not install the Helper Selector by unchecking a box during the installation process of Git for Windows. This is assuming you are installing Git in this manner, and also that you are willing to reinstall Git for Windows entirely or re-run the installer. But what if this doesn't apply to you?

I installed Git using [scoop.sh](https://scoop.sh), so my installation process took place entirely via CLI. However, I guess this option also assumes you want the Credential Helper since I don't remember every specifying I wanted it. So what now?

### Unset the credential helper system-wide

A simple way to disable any default system-wide helper is to run the following command

```bash
git config --system --unset credential.helper
```

### Setting your credentials on an individual repository basis

Now that you've disabled the system-wide helper, you can manage your credentials on a repository-basis. [Git provides two built-in solutions](https://git-scm.com/docs/gitcredentials#_avoiding_repetition). I chose to use the `store` helper on my repos.

Navigate to your repository and run:
```bash
git config credential.helper store
```

This will then prompt you for your remote credentials. Now try running a `git pull` and marvel at now having to be bothered by a pop-up!

## Why are you using Windows?

I never claimed to make wise choices. But yes, this whole thing has been a non-issue on my Linux Mint-based laptop.
