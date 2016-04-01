---
layout: blog
title: Gits Everywhere
date: '2013-07-18T12:44:00.001+01:00'
author: Mez Pahlan
tags:
- learning
- programming
- android
modified_time: '2013-07-18T12:44:37.806+01:00'
thumbnail: http://2.bp.blogspot.com/-zgWBeuczxZw/Uee66xgXGZI/AAAAAAAAU3M/srX4zHV2BwY/s72-c/Screenshot+from+2013-07-18+10:48:40.png
blogger_id: tag:blogger.com,1999:blog-7057712950286438970.post-3933361424352693001
blogger_orig_url: http://mezsays.blogspot.com/2013/07/gits-everywhere.html
---

<div class="separator" style="clear: both; text-align: justify;">Another long break between blog posts. Mostly out of laziness but also because I am trying to learn and teach myself Android programming. Here's a short post about how I'm getting along.</div>

<!-- more -->

<div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">The first hurdle is to get all of your project tools set up and running correctly. This has vastly improved since the last time I tried it out.&nbsp; Now there is a single package (<a href="http://developer.android.com/sdk/index.html" target="_blank">ADT Bundle</a>) to install that provides you with a development IDE, the SDK and the Android Tools to get you going. You can find this on the revamped <a href="http://developer.android.com/" target="_blank">Android Development</a> website. There are also a bunch of tutorials that are very helpful which I suggest you look at and try to follow.</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">Secondly have a separate tab constantly open to <a href="http://stackoverflow.com/questions/tagged/android" target="_blank">StackOverflow</a>. You'll thank me later.</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">Lastly I signed up for <a href="https://github.com/" target="_blank">GitHub</a> access to share the code and get help from other programmers. Perhaps at a later date I will write how to set up Git with Eclipse (it's not that difficult, but it took me about four attempts).</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">You can find my code on my <a href="https://github.com/mezpahlan" target="_blank">user page on GitHub</a>.</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">The code for Sean's Penguins can be found <a href="https://github.com/mezpahlan/SeansPenguins" target="_blank">here</a>. It's all open source because my primary focus is learning and I also want to say that I am an open source project lead!</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">The application is meant to be a simple image gallery. The source for the images is currently a penguin related <a href="http://www.cheezburger.com/" target="_blank">icanhascheezburger</a> search. This gets parsed by a rather brilliant library called <a href="http://jsoup.org/" target="_blank">JSoup</a> and displayed in a gallery which is scrollable. I use another library to help me out here called <a href="https://github.com/koush/UrlImageViewHelper" target="_blank">URLImageViewHelper</a>.</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: justify;">
</div><div class="separator" style="clear: both; text-align: center;"><a href="http://2.bp.blogspot.com/-zgWBeuczxZw/Uee66xgXGZI/AAAAAAAAU3M/srX4zHV2BwY/s1600/Screenshot+from+2013-07-18+10:48:40.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" src="http://2.bp.blogspot.com/-zgWBeuczxZw/Uee66xgXGZI/AAAAAAAAU3M/srX4zHV2BwY/s1600/Screenshot+from+2013-07-18+10:48:40.png" /></a></div><div style="text-align: justify;">
</div><div style="text-align: justify;">
</div><div style="text-align: justify;">Current problems are that it is mostly a hack job and not something I can truly call my own at the moment - I'm using two libraries to do the clever stuff. I have a list of improvements I want to make too. Hopefully I will get around to them over the next few weeks.</div><div style="text-align: justify;">
</div><ol><li>Fix the layout - You'll notice that the title doesn't appear in the correct place.</li><li>Make the images scalable with pinch to zoom affects.</li><li>Swap out for a Google Image search instead - Get some exposure to using a proper API (JSON based) instead of scraping a web page.</li><li>Allow more than 6 images - 6 is the number on each page of the website I'm scraping from.</li><li>Fix the application icons - They are low resolution and could be better.</li><li>Have a start up image - To be displayed whilst the images are downloading in the background.</li><li>Remove URLImageViewHelper dependency - Perhaps cache the images for performance so it is not always fetching. </li><li>Implement a sharing menu - Using intents?</li><li>Implement a proper application life cycle - At the moment I am at the mercy of the defaults and am probably leaking memory very badly.</li><li>Sign the application - For publishing to Google Play.</li></ol>Fun!
