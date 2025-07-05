+++
author = "Mez Pahlan"
categories = ["android"]
date = "2017-04-16T12:26:14Z"
tags = ["android", "programming"]
title = "Making A Scene"

+++

For the past few weeks I've been taking a brief detour into the
[Transitions](https://developer.android.com/reference/android/support/transition/package-summary.html) framework in
Android. I've building a success screen that initially shows a full screen image and text and later transitions into a
summary of your transaction.

{{< youtube KZ5WGGNSVjw >}}

This post documents some of the things I've learned whilst working on this.
<!--more-->

Some of the transitions that are available on Android are amazingly nice and the default auto transitions are pleasing
and useful for the vast majority of use cases. For finer grain control over the transitions you can make use of
[TransitionSets](https://developer.android.com/reference/android/support/transition/TransitionSet.html) to build up a
set of Transitions that you can customise all you want. The Support Library does a very good job to bring these to
earlier versions of Android however if you really want all the bells and whistles you need to specify a minimum API
level of 21. If only we could all be so lucky!! For those of us that can't easily do that there is the fantastic
[TransitionsEverywhere](https://github.com/andkulikov/transitions-everywhere) library that brings a subset of the
transitions down to APIs below 21. This gives you more than what the support library does but doesn't unlock the really
neat Activity and Fragment Shared Element Transitions.

For the transition in the video above I started off using the TransitionsEverywhere library but I think it is fair to
say that you can achieve the same using just the Android Support Library.

So let's get into the code!

The basic idea is as follows

{{< figure figcaption="Relationships in the transitions framework" >}}
    {{< img src="transitions-diagram.png" >}}
{{< /figure >}}

You declare a starting scene (either declaratively or in code), an end scene (either declaratively or in code), a
transition (either declaratively or in code), and finally tell a
[TransitionManager](https://developer.android.com/reference/android/support/transition/TransitionManager.html) to change
between the scenes using the transition.

The magic happens in a layout that contains a `scene_root` that in turn contains a placeholder for the scenes that swap
in and out. Here's what the above looks like:

{{< gist mezpahlan fd107cea98366f4704ba839966e17cd7 >}}

Notice that there is a view with an id called `scene_root` that includes, initially, the layout for `scene_a`.

Here's what Scenes A and B look like in code:

{{< gist mezpahlan 03578c91e520676e1dec7be94099e461 >}}

And for completeness here is the `hello_world` layout:

{{< gist mezpahlan 87efdac4f2f6d6182096860d2e2ad9ed >}}

Further points to notice are the differences between Scene A and Scene B, chiefly the `hello_world` layout. Also notice
that both Scene A and B have a top level layout with an id of `scene_container`. When the transition runs the
TransitionManager calculates the start and end points represented by the two scene layouts and figures out what has
changed and then uses an animation to animate the difference.

Now that everything has been defined we need to tell Android to actually do something on an event. Here's what this
looks like in Java code:

{{< gist mezpahlan 82fa058430875af3928ef3d00fc01b49 >}}

In this file we can see that references to the scene layouts in Java code in a similar way that you find references to
views with `findViewById`. Also we have a definition of what will happen when each Scene is entered. This includes some
initialisation logic. Finally we tell Android to start with Scene A.

That's it! It is very simple to define transitions in this way. As I pointed out earlier this isn't the only way that
you can define transitions. You can also define transitions via XMLs or start and end positions via code depending on
your needs. For now I will stick to defining transitions in the way I have described above as I typically want to define
them in terms of start and end layouts rather than some dynamic logic at runtime.

Anyways, happy transitioning!
