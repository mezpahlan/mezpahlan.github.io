---
layout: post
title: Beta testing karma
date: '2009-10-10T22:37:00.005+01:00'
author: Mez Pahlan
disqus_identifier: 0b746b0d-53ec-47a5-a7ec-30b2c39fcd2f
tags:
- ubuntu
---

I've not checked in for a long time but let me briefly let you know what I've been up to.

I'm testing the new Ubuntu release of Karmic Koala. It is in beta now and should be released at the end of October. Unfortunately I'm away on holiday in Thailand when it comes out so I wanted to have a little play around before I went. And I've already raised three bug reports on [Launchpad](https://launchpad.net/) already. Minor difficulties but overall it is an improvement.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/countdown.png" }}
    alt: "Ubuntu 9.10 Countdown"
{% endresponsive_image_block %}

<!-- more -->

The biggest issue I had was my sound card stopped working. The beta had removed the drivers and I couldn't hear anything. But after a couple of hours of searching I found the answer [here](http://ubuntuforums.org/showthread.php?t=205449). I had to reinstall the drivers that Karmic removed but after that all I had to do was increase the volume (since it reset itself to 0) and change the output from digital to analogue (since this keeps switching itself too) and bingo I have sound now!

I've also been having a go a Xubuntu. I do like the light weight and fast nature of it, what I don't like is that its not as swish as Gnome. Upon my next computer upgrade I think I'll still get Gnome but perhaps I'll get a lightweight Xfce laptop to practise penetration testing. I think it would be worth it when battery life is relevant.
