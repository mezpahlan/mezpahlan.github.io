---
layout: post
title: Update on the droid picture project
date: '2010-07-31T20:33:00.003+01:00'
author: Mez Pahlan
disqus_identifier: eab6dd8e-3643-4809-94bc-882db78e5429
category: android
tags:
- programming
- android
---

It's going well. I still can't program for shit though. I need to learn how to make more effective use of the android documentation though.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: page.category | remove_first: "#excerpt" | append: "/big-picture.jpg" }}
    alt: "Big Picture"
{% endresponsive_image_block %}

<!-- more -->

For example, at the moment my code displays a grid of images from the file system and lets the user select one. Upon selection the image's index position (derived from the file name) is returned in an on screen message.

I wanted to be able to use this to set the android wall paper, but I have no idea how to get the code to work and no understanding of how I would go about trying to fix it.

I love a challenge.
