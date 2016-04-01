---
layout: blog
title: Deconstructing Tweets
date: '2015-07-06T19:25:00.000+01:00'
author: Mez Pahlan
tags:
- programming
modified_time: '2015-07-07T19:35:23.471+01:00'
thumbnail: http://4.bp.blogspot.com/-uAw0W3AWcY4/VU4oWO4Tj9I/AAAAAAAAhiE/6jJZXssb7cc/s72-c/jive-elections-05.png
blogger_id: tag:blogger.com,1999:blog-7057712950286438970.post-5381100861684095378
blogger_orig_url: http://mezsays.blogspot.com/2015/07/deconstructing-tweets.html
---

As part of my personal project for Spring, and to coincide with the UK 2015 General Election, I decided to create some bots that mirrored the main party candidates and translated their tweets to Jive. They are still running so you can find them on Twitter: <a href="https://twitter.com/edjiveaband" target="_blank">Ed Jiveaband</a>, <a href="https://twitter.com/nickjivegg" target="_blank">Nick Jivegg</a>, <a href="https://twitter.com/davidjiveron" target="_blank">David Jiveron</a>.

<div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/-uAw0W3AWcY4/VU4oWO4Tj9I/AAAAAAAAhiE/6jJZXssb7cc/s1600/jive-elections-05.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="398" src="http://4.bp.blogspot.com/-uAw0W3AWcY4/VU4oWO4Tj9I/AAAAAAAAhiE/6jJZXssb7cc/s640/jive-elections-05.png" width="640" /></a></div>

One of the more interesting problems that I faced was how to prevent special Tweet Entities being erroneously translated by the Jive translator. You may be asking what is a Tweet Entity? Let me explain about them first and then go on to explain how I can tackle such a problem.

<!-- more -->

<h3>Tweet Entities</h3>
Tweet Entities are special portions of your tweet that you can click. Depending on the entity your click may produce different results. One of the more common entities that you might know is the <a href="https://en.wikipedia.org/wiki/Hashtag" target="_blank">#hashtag</a>. Other entities are the URL link, the Media link, and the user @mention. It is clearly quite important that we don't translate these using the Jive translator service otherwise links may not work, #hashtags may be incorrect, and the wrong user may be @mentioned.

<h3>The Problem</h3>To start tackling this I needed to know how to break down a tweet into its constituent parts. I started with the assumption that this was possible and that the Twitter API would help with this. Sort of.....

It turned out that Twitter didn't do all the work for me. What I did have access to is the **start** and **end** positions within the tweet string of where these entities are. Naively I thought that I could simply translate the whole string and replace each entity at their original start and end positions. Sadly I quickly realised that this couldn't be done. When we use the Jive translation service it returns a string that we cannot guarantee to be the same number of characters as the input. If we can't guarantee this then our assumption that we can simply splice the original start and end positions into the new translated string falls apart.

Here's an example:

<div class="gistLoad" data-id="fe0fab8739bcac54bde5" id="gist-fe0fab8739bcac54bde5"><script src="https://gist.github.com/mezpahlan/fe0fab8739bcac54bde5.js">tweet-entities-example-1</script></div>
The input string has 11 characters. The hashtag entity **starts** at character 7 and **ends** at character 11.

Suppose the translation service comes back with the following string. 

<div class="gistLoad" data-id="a083576ba1c6fc0682d8" id="gist-a083576ba1c6fc0682d8"><script src="https://gist.github.com/mezpahlan/a083576ba1c6fc0682d8.js">tweet-entities-example-2</script></div>
The translated string is, coincidently in this example, still 11 characters long. However the #hashtag has been erroneously translated losing the original meaning. Under our original assumption we could say that we would splice the old #hashtag into the translated string at the *original* **start** and **end** positions. Let's see what happens when we do that.

<div class="gistLoad" data-id="270c20c920e78c06927f" id="gist-270c20c920e78c06927f"><script src="https://gist.github.com/mezpahlan/270c20c920e78c06927f.js">tweet-entities-example-3</script></div>
Hmmm... not good!

<h3>The Solution</h3>
I need to be able to understand where each entity starts and ends in order to translate only the parts of tweets that fall outside of these ranges. In order to do this I needed a way of creating an ordered collection of all the entities dynamically.

<div class="gistLoad" data-id="f7293a43582de1edff66" id="gist-f7293a43582de1edff66"><script src="https://gist.github.com/mezpahlan/f7293a43582de1edff66.js">tweet-entities</script></div>
There is a few things happening in the above gist. First you'll notice that I create an empty List of what I call *EntitiesModel*. This is a custom model I use to store interesting information about the entities. In particular the **start** and **end** positions. Here is what it looks like (minus all the guff of getters and setters and the constructor).

<div class="gistLoad" data-id="ed796aa6246e63a91bd1" id="gist-ed796aa6246e63a91bd1"><script src="https://gist.github.com/mezpahlan/ed796aa6246e63a91bd1.js">tweet-entities-model</script></div>
Notice that I've implemented a comparable interface which allows me to sort the resulting list based on the start position of the entity. This becomes important because after I've extracted all the entities into a List of Entities they might not be in order.

Putting it all together I have an ordered List of Entities. So now what? 

<div class="gistLoad" data-id="d91ea8f585a154543565" id="gist-d91ea8f585a154543565"><script src="https://gist.github.com/mezpahlan/d91ea8f585a154543565.js">tweet-entities-translate</script></div>
The gist above shows how we can substring the original input string until we reach an element in the Entities list, translate this string, splice the original entity back into the correct place in the translated string, and repeat until the rest of the input string is translated skipping over and splicing back in each entity as we find it.

Phew!! Finally. So that's how I tackle the Tweet Entity problem problem. Maybe next time I'll write about how I overcame the 140 Twitter character problem.

<div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/-7KY07O0Qi8Q/VZrGyETw_5I/AAAAAAAAihQ/Ve5bjtqO9D4/s1600/tweet-entities.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="464" src="http://4.bp.blogspot.com/-7KY07O0Qi8Q/VZrGyETw_5I/AAAAAAAAihQ/Ve5bjtqO9D4/s640/tweet-entities.png" width="640" /></a></div>
<script src="https://raw.github.com/moski/gist-Blogger/master/public/gistLoader.js" type="text/javascript"></script>