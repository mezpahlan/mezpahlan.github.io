+++
author = "Mez Pahlan"
categories = ["android"]
date = "2013-09-27T11:06:00Z"
tags = ["programming", "android"]
title = "Catha's Seat Design Ideas"

+++

A good friend of mine, [Nick](http://nickandscottgobiking.blogspot.co.uk/), is organising the construction of a bicycle
seat on route 18 of the Cycle Network to complete the work started by his mother, Catha. You can read more about it on
the [Catha's Seat](http://www.cathas-seat.org/) website.

{{< figure figcaption="Start Activity" >}}
    {{< img src="start_activity.png" >}}
{{< /figure >}}

<!--more-->

As part of this I thought it would be cool to have an Android app to support the project. Firstly to raise awareness and
guide users to the bike seat and secondly because it's fun!

I have put together some design ideas to support the building of the app and have already [started
coding](https://github.com/mezpahlan/CathasSeat) an early version. It's all open source if you want to help out so feel
free to let me know if you're interested.

Here's the design I have so far.

The app will start on a welcome page with an image of Catha's Seat in the surrounding area and some welcome text.

1. The user will enter a starting location to receive directions to the seat. In later versions I hope to make use of
   the GPS for this as an option.
2. Pressing the Go button takes you to the next screen - the map.

 {{< figure figcaption="Map Activity" >}}
    {{< img src="map_activity.png" >}}
{{< /figure >}}

 The next screen is a Google Map with a directions plotted as a route.

3. The route will lead to a marker for Catha's Seat.

 {{< figure figcaption="Directions Activity" >}}
    {{< img src="directions_activity.png" >}}
{{< /figure >}}

 Swiping to the right brings you to a screen with text directions

4. Text directions will appear as a list from the Google Maps query.
5. Additional information (if any) about the selected direction will appear here.

 The user can interact with the different app screens by swiping left and right any time after an initial query has been
 performed.

{{< figure figcaption="Interaction" >}}
    {{< img src="interaction.png" >}}
{{< /figure >}}

So that is the basic idea. Other ideas will be to share a picture of the user at Catha's Seat and an about page with
more information about Catha's Seat. I am also toying with the idea of a donations button but don't really know how that
will work.
