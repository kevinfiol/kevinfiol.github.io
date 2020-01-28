---
layout: post.pug
tags: post
title: Validating Checksum on Windows
date: 2019-06-04
---

# Validating Checksum on Windows

This is a common command that I constantly seem to forget and have to look up over and over again. Posting it here so I never have to search for it again.

```bash
certutil.exe -hashfile "data.iso" MD5
```