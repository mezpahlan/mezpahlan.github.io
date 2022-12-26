+++
author = "Mez Pahlan"
categories = ["android"]
date = "2013-07-18T12:44:00Z"
disqus_identifier = "17208ac4-ca15-4e9b-a883-a26842ab1547"
tags = ["android"]
title = "Gits Everywhere"

+++

Another long break between blog posts. Mostly out of laziness but also because I am trying to learn and teach myself
Android programming. Here's a short post about how I'm getting along.

{{< figure figcaption="Android Penguins" >}}
    {{< img src="android-penguins.jpg" >}}
{{< /figure >}}

<!--more-->

The first hurdle is to get all of your project tools set up and running correctly. This has vastly improved since the
last time I tried it out. Now there is a single package ([ADT Bundle](http://developer.android.com/sdk/index.html)) to
install that provides you with a development IDE, the SDK and the Android Tools to get you going. You can find this on
the revamped [Android Development](http://developer.android.com/) website. There are also a bunch of tutorials that are
very helpful which I suggest you look at and try to follow.

Secondly have a separate tab constantly open to [StackOverflow](http://stackoverflow.com/questions/tagged/android).
You'll thank me later.

Lastly I signed up for [GitHub](https://github.com/) access to share the code and get help from other programmers.
Perhaps at a later date I will write how to set up Git with Eclipse (it's not that difficult, but it took me about four
attempts).

You can find my code on my [user page on GitHub](https://github.com/mezpahlan).

The code for Sean's Penguins can be found [here](https://github.com/mezpahlan/SeansPenguins). It's all open source
because my primary focus is learning and I also want to say that I am an open source project lead!

The application is meant to be a simple image gallery. The source for the images is currently a penguin related
[icanhascheezburger](http://www.cheezburger.com/) search. This gets parsed by a rather brilliant library called
[JSoup](http://jsoup.org/) and displayed in a gallery which is scrollable. I use another library to help me out here
called [URLImageViewHelper](https://github.com/koush/UrlImageViewHelper).

Current problems are that it is mostly a hack job and not something I can truly call my own at the moment - I'm using
two libraries to do the clever stuff. I have a list of improvements I want to make too. Hopefully I will get around to
them over the next few weeks.

1. Fix the layout - You'll notice that the title doesn't appear in the correct place.
2. Make the images scalable with pinch to zoom affects.
3. Swap out for a Google Image search instead - Get some exposure to using a proper API (JSON based) instead of scraping
   a web page.
4. Allow more than 6 images - 6 is the number on each page of the website I'm scraping from.
5. Fix the application icons - They are low resolution and could be better.
6. Have a start up image - To be displayed whilst the images are downloading in the background.
7. Remove URLImageViewHelper dependency - Perhaps cache the images for performance so it is not always fetching.
8. Implement a sharing menu - Using intents?
9. Implement a proper application life cycle - At the moment I am at the mercy of the defaults and am probably leaking
   memory very badly.
10. Sign the application - For publishing to Google Play.

Fun!
