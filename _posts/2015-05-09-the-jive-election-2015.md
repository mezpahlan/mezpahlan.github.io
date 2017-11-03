---
layout: post
title: The Jive Election 2015
date: '2015-05-09T16:49:00.002+01:00'
author: Mez Pahlan
disqus_identifier: 2ec4d7e1-30f6-461c-99cb-93fd4de0f4b2
tags:
- programming
- politics
---

Throughout March and April of 2015 I have been busy working on a pet project with my friend Ricky Shelton. The idea was simple. Make the politicians running in the 2015 UK General Election more electable by having them speak Jive.

{% youtube "//www.youtube.com/v/RrZlWw8Di10" %}

<!-- more -->

We came up with the crazy idea at a very slow and depressing day at work one day last year. Ricky quickly mocked up some code that would listen to the candidate's Twitter feed, grab a Tweet and send it to a Jive Translation service. We had a few hours worth of giggles over at [Luke's Jive Translator](http://www.luketillo.com/jiveluke.html) so decided to reuse his back end. The way his service works is by accepting a string of text and replacing predefined values with Jive values. The results are hilarious. So we thought why not automate it?

Here is the former leader of the Labour Party, [Ed Miliband](https://twitter.com/ed_miliband), saying, "Thanks", for a hard fought campaign.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/ed.png" }}
    alt: "Ed Miliband"
{% endresponsive_image_block %}

And here is his Jive counterpart, [Ed Jiveaband](https://twitter.com/edjiveaband), saying the same.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/ed-jive.png" }}
    alt: "Ed Jiveaband"
{% endresponsive_image_block %}

OK, so 3 retweets is not quite up there with 2.7 thousand but I'll take that anyway!

Here are some of my favourites from the other candidates.

[David Cameron](https://twitter.com/david_cameron) wishing the new royal baby well.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/dave.png" }}
    alt: "David Cameron"
{% endresponsive_image_block %}

And his Jive counterpart, [David Jiveron](https://twitter.com/DavidJiveron), wishing the same.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/dave-jive.png" }}
    alt: "David Jiveron"
{% endresponsive_image_block %}

Finally old [Cleggers](https://twitter.com/nick_clegg) after being flashed by an overexcited student.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/nick.png" }}
    alt: "Cleggers"
{% endresponsive_image_block %}

And [Nick Jivegg](https://twitter.com/nickjivegg)'s response.

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: "#excerpt" | append: "/nick-jive.png" }}
    alt: "Nick Jivegg"
{% endresponsive_image_block %}

At some point I will follow this up with a post on how we made this with some technical details. But if you want to check it out yourself it is on Github under my [Jive Campaign](https://github.com/mezpahlan/jivecampaign) repository.

There were some very interesting problems that we needed to solve. The worst of which (and an on going one) was that we were constantly breaking Twitter's 140 character rule since the Jive translator sends back a piece of text that we have no control over. Some times it fits, sometimes it does not. We also wanted, right from the start, not to translate hash tags, links, and user mentions but the solution to that turned out to be non trivial. Anyway, I'll get to that in a later blog post.

To run the service I chose Red Hat's [Open Shift](https://www.openshift.com/) platform as a Service. It is written in Java and makes extensive use of Yusuke Yamamoto's brilliant [Twitter4J](http://twitter4j.org/en/index.html) library. At some point I'll also get around to writing unit tests and will use [JUnit](http://junit.org/) and [Mockito](http://mockito.org/) as my tools.
