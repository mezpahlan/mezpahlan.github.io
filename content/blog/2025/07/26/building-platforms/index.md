+++
author = "Mez Pahlan"
categories = ["personal"]
title = "Building Platforms"
date = "2025-07-26T17:34:22+01:00"
tags = ["programming"]
+++

I'm currently a Staff Engineer in my organisation and sit within what we call the Platform pillar. Sort of obviously, we
build the _platforms_ that the rest of the business use to make the monies. This is how I like to think about platforms
and what it means to be a good platform.

<!--more-->

Have a think about the best platforms you know. What do they share in common? Think about some truly horrible ones. What
do _they_ all share in common? A platform is something you build upon - duuh. As such, for me, it needs to exhibit some
fundamental characteristics.

## Easy

A platform should be easy to use. If it is needlessly hard and complex users will lose interest over time and abandon
your platform for another one that is easier. Even if that platform is more expensive. When building a platform you
should ensure that you abstract as much complexity from the underlying problem away and present the user with just the
right level of complexity that they need to know about. I don't need to know about transistors work in order to use a
computer. It might help.... but it shouldn't be required.

## Stable

A platform should be stable in regards to changes. By stable I don't mean static. I mean that when it _does_ change,
that it does so in a way that preserves compatibility for users, gives them time to move to newer APIs, makes it clear
what the deprecation policies are, calls out all the places that have changed. Nobody likes surprise changes even if
those changes lead to a better product. If you're building a platform there are probably tools that help you assert the
public API and how it changes over time to help you with this......... unless you're working with Javascript in which
case YOLO.

## Reliable

A platform should be reliable in its functionality. If you say your platform offers functionality and it suddenly breaks
release to release your users will only be so forgiving before moving to a more reliable one. It should be obvious to
any Engineer that you must test what you build but even more important when you're building a platform for other
Engineers. Imagine pressing `<enter>` on your keyboard only to realise it triggers a kernel panic. However you validate
that your platform is reliable ensure that you do and ensure that you constantly evaluate the efficacy of your
validation.

## Side Note

OK, well that's all pretty obvious. But what _is_ a platform? Well something that you can build upon / build things with
is a good enough way to describe a platform for me:

* An SDK.
  * OkHttp - the best one of all.
* An OS.
* A toolkit.
* A framework.
* Github.
* OpenBanking API.
* Weather APIs.
* Your computer.
