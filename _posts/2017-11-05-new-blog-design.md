---
layout: post
title: New Blog Design
date: '2017-11-05T19:35:23.029Z'
author: Mez Pahlan
disqus_identifier: 227a338f-3699-44f4-81f7-9486ed9af0cb
tags:
- blog
---

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: page.category | remove_first: "#excerpt" | append: "/doctor-jekyll-and-mister-hyde.png" }}
    alt: "Who's a pretty boy?"
{% endresponsive_image_block %}

Hello! I've been away a while but I'm back!

<!-- more -->

You'll notice a change of design. I've wanted to do this for a while and clean up the theme of this site. With [Jekyll](https://jekyllrb.com/) you can apply pre-made themes to your site quite easily. However your site needs to be structured in a certain way before this works. Up until recently I did not have the time to restructure my site but at last! Now I have.

I've added a separate category for [Android]({{site.base_path}}/category/android/) development. I hope to concentrate on filling that up next year. So keep your eyes peeled. I also want to add a section and **finally** start writing up my uni notes so I can save some space on my shelf. I have no idea how well that would go but it is either that or throw them in the bin, which would be a shame.

The new theme is called [Hydeout](https://fongandrew.github.io/hydeout/). Check it out and star the [repository](https://github.com/fongandrew/hydeout)!
