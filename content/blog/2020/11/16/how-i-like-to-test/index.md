+++
author = "Mez Pahlan"
categories = ["android"]
title = "How I Like To Test"
date = "2020-11-16T22:14:41Z"
disqus_identifier = "4ddbbaf5-6abe-0574-1494-8c45f1846713"
tags = ["android"]
+++

I have enjoyed testing as much as I have enjoyed developing. Sometimes more. Sometimes less. Just as it is immensely
satisfying when you watch something you have built run, or be used, by a user it is also immensely satisfying to watch
those little green ticks appear in your test reports. Here's how I like to test with a focus on Android.

{{< figure figcaption="[The (Android) Test Pyramid](https://developer.android.com/training/testing/fundamentals) that is 100% centred I swear!" >}}
    {{< img src="test-pyramid.png" >}} 
{{< /figure >}}

<!--more-->

Whilst the image above is taken from the Android Testing Fundamentals it has applications to most apps that you build.
Testing, for me, is about giving you confidence that your code is doing the right thing. Some people call this verifying
behaviour but for me it really is about _confidence_. By far the best way to test and the best way to code is to break
your app up in to small enough self contained bits such that you can easily test them. Nobody likes god objects, partly
because they are hard to test! Breaking down your code so that you can write a unit test, and then stitching your code
together a bit more so that you can write an integration test, and then stitching it together even more that you can
write a long(er) running UI test is my go to way for testing. It's simple. And therefore it is powerful. The image above
suggests this and also suggests the relative split between these test types. I really like this image.

# Unit Tests

I like to write lots of unit tests. For, pretty much, the reason stated in the diagram. They are focussed, quick, and
easy (once you get used to a few). I try as much as possible to pull the _important bits_ of my code out of code that is
coupled to the framework. In Android these are Android UI classes (Activity / Fragment) but in Jenkins it is any
framework class. Spinning up fakes of Android / Jenkins is time consuming and hard to get off the ground. I'm sure this
is also true of other disciplines. Typically if you have a framework that has a lifecycle that you don't control then
don't put any significant logic in there. Not having to do so is a bonus and means I can write unit tests for important
bits of my code and really grind the gears on them. It also forces me to think again about how I structure my code. I
tend to write better structured code if I stop and think _hmmm this could be tested so much more easily if I extracted
this dependency_. Now as well as having the ability to write an easy unit test I also get better structured code. One
drives the other.

[Mockito](https://site.mockito.org/), the popular mocking framework for Java projects, really put me on to this idea
whilst I was reading the documentation for it. I very much admire their philosophy and thoughts about how good code is
testable code and testable code is good code. For example from their [wiki page on private
methods](https://github.com/mockito/mockito/wiki/Mockito-And-Private-Methods):

>Mocking private methods is a hint that there is something wrong with Object Oriented understanding. In OO you want
>objects (or roles) to collaborate, not methods. Forget about pascal & procedural code. Think in objects.

Testing made me think again about my understanding on object collaboration and how to structure code and that's why I
like it. **Extract as much of your code as possible in to non framework classes so that you can unit test them.**

# Integration Tests

I found this historically very difficult on Android. The go to way was
[Espresso](https://developer.android.com/training/testing/espresso) which is great but requires a _lot_ of frustrating
hours getting to grips with. However ever since the introduction of the
[FragmentScenario](https://developer.android.com/training/basics/fragments/testing) this has been way easier to write
because it removes the need for some complicated set up to _get to that page_ in order to start tested. What I have also
started to make more use of is [Robolectric](https://robolectric.org/). Since version 4 you can use Espresso style
construction and testing idioms but have the test run on the JVM. So I couple `FragmentScenario` with Robolectric to do
a lightweight test of the UI.

I test that the buttons produce the desired outcome be that a navigation effect or a change in another class. I also
test that views are correctly displayed / not displayed depending on some state. I don't test every little detail that I
probably could / ought to be testing but that's because I don't have the luxury of a build server that can run hundreds
of Robolectric tests. I know that is a lame excuse but that's the reality and also why I favour unit tests for most of
my testing. I can run thousands of unit tests in a few minutes. Thousands of Robolectric tests would take considerably
longer.

As I progress through my Android testing journey I would like to make more use of this technique to test way more of
what I don't test at the moment. But maybe I'll come to that later.

# UI Tests

For the reasons above I tend to shy away from these. That's bad. But for, where I am, pragmatic. I'd love to run UI
tests but simply can't afford to at this point in time.

# Test Just Enough

Of course what really matters is that you have confidence and that it grows the longer you spend with the code base. So
don't try and test everything. For a start it probably doesn't need to. Tell that PM to do one if they are badgering you
about _code coverage_. The only question you should ask yourself is _are you confident in your code base?_ and be honest
with yourself. If the answer is _no_ then write a test. But don't write a test because you want a coverage report to go
over a certain threshold.

# TDD / BDD

Whilst I like how these testing methodologies help you structure your tests (just like architecture patterns help you
structure your code) I am not dogmatic about them. Personally I find it incredibly difficult to write a failing test
first and then write the code to make it pass. _Incredibly_ difficult. As long as you have the tests when you're ready
to merge your code then I personally don't mind when you create the test. I often write a bit of code first, spin it up
on a device, play around, then pause, take stock, write a bunch of unit tests, repeat. It's only after I've finished a
feature do I go back and write some integration tests too. By the time it goes for a PR it has both (most of the time!).

I _really_ like writing tests structured with `Given When Then`. I like it so much that I create a [Live
Template](https://www.jetbrains.com/help/idea/using-live-templates.html#live_templates_configure) whenever I install
IntelliJ / Android Studio so that when I type `gwt` and press `<tab>` it auto populates this as comments within the test
structure. Since using Kotlin and discovering that you can use the [backtick character `` ` `` to create function names
with spaces](https://kotlinlang.org/docs/reference/coding-conventions.html#names-for-test-methods) I also like writing
the name of the test in a `Given When Then` structure.

{{< highlight kotlin >}} @Test fun `given user is logged out when login button pressed then should divulge password`() {
// Given

    // When

    // Then
} {{< /highlight >}}

I like this because it, again, forces a clearer structure for tests. I use this in both unit and integration type tests.
I tend to sick a bit when I see quite a few tests written like this:

{{< highlight kotlin >}} @Test fun testMethod() { val input = "one" val input2 = "one" val input3 = "one"
given(mock.someOtherMethod()).willReturn("true") val value = cut.method([input, input2, input3]) assert(value).isTrue()
} {{< /highlight >}}

And whilst that is a perfectly valid test I really struggle with this because I would write it like this:

{{< highlight kotlin >}} @Test fun `given all inputs are equal when method is call then should return true`() { // Given
val input = "one" val input2 = "one" val input3 = "one" given(mock.someOtherMethod()).willReturn("true")
    
    // When
    val value = cut.method([input, input2, input3])

    // Then
    assert(value).isTrue()
} {{< /highlight >}}

I find that way easier to read, way easier to glance at in a PR, way easier to revisit and quickly understand what the
intention of the test is.

# Mocking / Stubbing

Mockito for the reasons mentioned above. I fully trust the philosophy behind it and for that reason alone I stay loyal
to it. I haven't (yet) found anything that you can't do with it for my needs. Usually I find that if I can't do
something with Mockito I need to take a step back and reevaluate. 10 / 10 it was a code smell in my code that once I
refactored out of it I was able to use Mockito again.

# Test Framework

Since Android is (pretty much) Java, the go to framework for me has always been JUnit. [JUnit
4](https://junit.org/junit4/) specifically. Whilst incredibly old by modern standards and superceded by version 5 I
don't find any utility in moving off it or the time being. I tried JUnit 5 once and was so horribly confused by it (WTF
is Jupiter?) that after wrestling with it for about a week (in my spare time of course) I ripped it out and just got on
with testing using JUnit 4. I'm sure at some point they will end updates for JUnit 4 but until they do I'm sticking with
it!

# What's next?

As well as trying my hand at _more_ Robolectric integration tests and starting long running Espresso tests I want to get
better at two areas in particular.

1. CI setup of tests to minimise overall build time whilst increasing the number of tests I can run on the server.
2. How to effectively structure test data such that I can simulate better real world issues.

I'm sure there are good strategies and approaches to both but for the time being I have to console myself to discovering
them slowly.

That's about it for me. It's not the panacea of testing by any means and I know I need to do better. But it is what it
is and it gives me confidence whilst balancing workloads. How do you test? Leave a comment.