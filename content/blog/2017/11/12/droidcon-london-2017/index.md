+++
author = "Mez Pahlan"
categories = ["android"]
date = "2017-11-12T18:57:05Z"
tags = ["android"]
title = "Droidcon London 2017"

+++
A little late but here is my write up on Droidcon London 2017!

{{< figure figcaption="Left a bit.... right a bit" >}}
    {{< img src="droids-landing.jpg" >}}
{{< /figure >}}

<!--more-->

Droidcon is an annual Android developer conference that is held around the world. At the end of October London played
host. This was a special Droidcon for me as it was my first work related conference I had been to and I enjoyed every
moment of it. My only regret is that I wish I had gone to more of these earlier on in my career. I would even go as far
to say that I should have paid for it out of my own pocket and used holiday time to attend. The amount I was exposed to
in terms of how build Android applications and the community was incredible. Oh well, c'est la vie!

# Android: A Retrospective - Chet Haase & Romain Guy
The opening day's keynote was given by Android framework team members [Chet](https://twitter.com/chethaase) and
[Romain](https://twitter.com/romainguy). If you've ever heard the [Android Developer's
Backstage](http://androidbackstage.blogspot.co.uk/) podcast or watched Google IO you'll be familiar with them.

The talk focussed on a high level overview of how Android has changed over the years from way back in 2007 when it was
still a secret project to the present day. Over the years the team faced some interesting challenges working with
limited hardware and increasing expectations of end users. An interesting fact was that screen real estate of the very
first Android phone would be equivalent to that of an icon on today's hardware. This is because phone screen sizes and
pixel densities have increased so much!

# Commonly Overlooked Areas Of Security - Clive Lee
Following on from the keynote the rest of the day focussed on elected sessions. The first of which was a talk by [Clive
Lee](https://twitter.com/CliveHyunGuLee) who is an Android Developer at Ovia Health.

This talk reminded me that whilst there are some great tools for helping with security in your app they aren't to be
taken for granted. Always double check what logs you may be leaving around even in release versions of your app.

Another aspect he touched on was the cost of hiding secret keys in your application. Clive took us on a deep dive of how
you can often hide secret strings by using the NDK but if you *are* going to go down that route realise that it comes
with a hefty development cost. Consider if there are other ways of securing your application first. If available encrypt
information using the secure keystore on the device.

# Android Internals For Developers - Effie Barak
[Effie](https://twitter.com/codingchick) is a Senior Android Developer at Pintrest. Her talk was on a subject that I had
long neglected and was glad that I attended. What the hell are all those references in stacktraces!!!

Effie spoke about what makes Android from the ground up. From the Linux kernel to the additions that the Android team
have made to the kernel (wakelocks, OOM killer) to the start up scripts to just what the heck that Zygote thing is.

* Init - every time the OS starts, this wakes up all other processes.
* Zygote - base process for all other application processes, ready made VM (of sorts) to run apps, gives us the app
  sandbox.
* Android apps get a different UID - this is different to Linux and helps with security.
* Binder IPC - delivers messages between processes, this is how Android apps actually talk to each other.
* System Server - for of the Zygote, also started by Init, includes everything Android specific (Window Manager, Package
  Manager, Activity Manager)

This was probably the most technical talk that I attended. Mostly because I took these concepts for granted in the past.
They *just worked* so I was unfamiliar with them before I attended the talk. But highly enjoyable talk nonetheless!

# From View To Pixel - Britt Barak
The next talk was a very interesting talk on how Android draws things on the screen that we can interact with by [Britt
Barak](https://twitter.com/brittbarak). Some definitions / explanations of commonly heard terms in Android graphics

* Rasterisation - the process that turns an object into a pixel so that it can be displayed.
* CPU --> Display List --> OpenGL --> GPU
* GPU - can buffer frames if the result may produce tearing, this is known as VSync.
* Choreography - ensures that each step in the process happens in order and only up to once.
* Measure - obtain view size, including descendants, maybe called more than once, depends if an animation has yet to
  complete.
* Layout - set position of view, including children, could happen more than once (nested relative layouts), aim to
  minimise layout passes

This was the first talk of the conference where I heard the term Overdraw. This is when a pixel has been drawn more than
once in a given frame. Typically this happens if you draw background objects that are then going to be obscured by
another object. This has the effect of wasting GPU time and starts to become a performance issue if left unchecked. I
began to hear this term more and more over the course of the conference, so it must be important..... right? Anyway,
there are many tools that we have in Android to detect such issues - GPU Overdraw Tool, GPU Profiling Tool, GPU Monitor.

# Doo z z z z z e - Ralf Wondratschek
Next up was a talk by [Ralf Wondratschek](https://twitter.com/vrallev), Android Developer at Evernote, on understanding
the power saving features of Android Doze and how it affects your application.

In Android M a power saving mode was introduced called Doze which detected whether the device was being used or at rest
and shut down non essential components such as network access allowing for maintenance windows where the device would
wake up and send messages in batch. This was later improved in Android N and further restrictions on what power draining
features an app could utilise were introduced in Android O.

In the past developers could schedule jobs to run using a variety of different methods depending on what API you were
targeting. Alarm Manager, Job Scheduler, GCM Network Manager, Job Intent Service. This allows the app to do work during
these maintenance windows if the device is in Doze mode. As you can see deciding which one to use is a non trivial task.
Further to this, Ralf explained, that some of the implementations were quite buggy and had quirks of their own.

Enter [Android-Job](https://github.com/evernote/android-job). This is a library built at Evernote that provides an easy
API to deal with the intricacies of scheduling jobs in Android across different API levels. This is something that is
really promising and that I want to try out at some point. I just need to find an excuse to build something that
requires this functionality!

# Revolutionary Features In Gradle 4.0 - Etienne Studer
[Etienne](https://twitter.com/etiennestuder) is the head of Product Tooling at Gradle. His talk highlights some of the
new features in Gradle 4.0. Since attending the talk I have upgrading Android Studio and along with it the Android
Gradle Plugin and Gradle itself. I didn't quite believe the speed improvements but they are a huge leap forward.

One of the features I would like to start using and take advantage of is the local and remote build caches. As Etienne
explained it, if you are working in a team and one of your colleages builds a module in the code base, not only can
Gradle now cache the build output such that if the source doesn't change the build output can be reused but it can even
now share the build output across the network. So every time you build your project, you are actually helping to build
the project on your colleague's machine too!

# Managing Your Career - Jose Nieto
The first of two short fifteen minute lighten talks, Jose spoke about how his positive attitude and determination got
him where he is today. He spoke about the opportunity cost that faces us daily and how we as developers need to be aware
of that and make sensible decisions that could very well shape our careers. He explained how when he arrived in the UK
he had next to no experience but he got his foot in the door and built from there. He even self funded his first visit
to Droidcon and has gone from strength to strength ever since.

# Three Key Lessons When Migrating To Constraint Layout - Connie Reinholdsson
I've started to use Constraint Layout in my code exclusively as I find it very powerful and a more natural way of
expressing layouts. Having said that, the learning curve was quite steep initially.
[Connie](https://twitter.com/conniereinhold1) shared her experiences of the same thing and some tips on how she used
image recognition software to compare the output of a layout written in Constraint Layout to that written the
traditional way. A different but useful way of approaching Constraint Layout that I had not considered when I started.

# Tips For Library Developers - Lisa Wray
This talk focussed on what it takes to be a successful library developer. I had not thought about ever becoming a
library developer but [Lisa](https://twitter.com/lisawrayz)'s talk opened my mind to simply producing a library that has
small but focussed and reusable utility. It doesn't need to be another Retrofit!

* Building a library to help yourself can also help others if you publish it.
* Maintain a single use case for the library.
* Make it simple to import / install.
* Pick sensible defaults if it is highly configurable.
* Favour delegation / composition over inheritance.
* Politely refuse feature requests that go against the core use case of the library.
* Use your own library!
* Version your library honestly. If it is in alpha..... say so.

{{< figure figcaption="Under his eye" >}}
    {{< img src="droidcon-2017.jpg" >}}
{{< /figure >}}

# Developers Are Users Too - Florina Montenscu
Kicking off day two was a talk by Android Developer Advocate [Florina Muntenescu](https://twitter.com/fmuntenescu).
Developers can also be users and this should be kept in mind when developing apps and even APIs. She spoke of the
applying UX heuristics to API design.

* Keep the user informed - show system state and appropriate feedback.
* Match between system and real world - naming should match API users' expectations.
* User control and freedom - revert / undo operations.
* Consistency and standards - consistent naming and patterns, consistent parameter ordering, avoid multiple parameters
  of the same type (use an object instead), avoid greater than four method parameters, return value adds complexity.
* Error prevention - guide users with default values.
* Recognition rather than recall - use clear and understandable names.
* Flexibility & efficiency of use - allow different ways to do the same thing for advanced use cases, avoid helper or
  utility classes.
* Aesthetic & minimal design - do not expose API logic, do not make the user do what the API could do for them.
* Help users diagnose, recognise, and recover from errors - fail fast, exceptions should only be for exceptional
  circumstances.
* Help & documentation - API should be self documenting, example code should be exemplary.

All of the above lessons are valuable not just to API developers but for User Interaction too. The last lesson was:
above all else do not be dogmatic!

# Testing Android Apps Based On Dagger And RxJava - Fabio Collini
[Fabio](https://twitter.com/fabiocollini) spoke about how to efficiently test Android apps. A lot of the what makes
testing easy on Android is how you define your architecture for the UI (MVP, MVVM, etc) and how you inject dependencies.
[Dagger](https://github.com/google/dagger) helps you do just that and can be use to great effect in tests cases to
remove hard to mock or flaky dependencies.

Also keep in mind that there is more than one kind of test that you can run in Android. Unit testing directly on the
JVM, Integration tests, UI tests, and E2E tests. The trade off is complexity and speed but the benefit is more realistic
test scenarios.

Espresso is a library for Android that can help you with UI tests and above but there are some gotchas that come with
its use. The biggest seems to be with idling resources and asynchronous code. RxJava can help here by offering different
schedulers to use such as the TestScheduler. Taking this all together the lessons are that whilst testing is hard it is
getting better. Advances in tooling and libraries are landing continuously so if you haven't got into testing whilst you
develop you should start now!

# Making Dogfood Builds Testable And Fun - Eric Cochran
I'm not sure I fully learned what *dogfood builds* are from [Eric Cochran](https://twitter.com/eric_cochran)'s talk but
his views on making internal builds more useful were very interesting.

One of the tools he highlighted was a library called [Telescope](https://github.com/mattprecious/telescope) that allows
developers to add easy bug capturing functionality for manual testers. An example he used was to allow automatic
screenshots and upload to Jira directly from the device. Now that is interesting!

# How To Bring A Product To Reality In A Few Days: Design-Dev Cooperation And Fast Android Prototyping - Juhani Lehtimaki & Pierluigi Rufo
[Juhani](https://twitter.com/lehtimaeki) and [Pierluigi](https://twitter.com/pierluigirufo) are a successful developer
and designer team that shared their insights on how to get the best out of this relationship.

They started by explaining that there is always going to trouble if there is no will to change a design based on
learning about it. If the phrase *it is signed off* sends chills down your spine, then it should. They were also both
passionate about the fact that the relationship should never be one sided. If your designer is not willing to compromise
- end it. If your developer is not willing to compromise - end it. Cut your losses sooner rather than later, for
everyone's benefit.

The lessons they found that were common amongst their successful projects were:

* Start from the user's point of view.
* Validate early using prototypes.
* Use existing design patterns, and platform guidance.
* Teach the design team to code layouts themselves.
* Work early with each other.
* Feedback tightly.
* Make sure everyone sees progress, not just yourself.
* Structure & behaviour first, styles second.
* Customisation costs money.
* Use the correct tools for rapid feedback: Sketch -> Zeplin.

# When You App Is Asleep - Britt Barak
Another talk by Britt, this time on how to manage your app's downtime.

{{< figure figcaption="Whilst your app gently sleeps" >}} {{< img src="sleeping-apps.jpg" >}} {{< /figure >}}

User's typically do not use your app for a long time. This means we need to be relevant to the user even when they are
not looking directly at our app. Provide timely and relevant notifications, but do not overwhelm the user.

Notifications are getting richer and richer each Android iteration. API 16 gave us styling, API 19 gave us actions, API
21 gave us Media controls, API24 gave us Reply ability, and so on. However, do not be annoying. In API 26 you can
timeout notifications that are no longer relevant.

Using notifications correctly can enhance your user's experience even when they are not using your app. Use them wisely.

# Sinking Your Teeth Into bytecode - Jake Wharton
The final keynote for the conference was given by Android luminary [Jake Wharton](https://twitter.com/JakeWharton). I'm
a big fan of Jake, his libraries, and his talks. However I can not do justice trying to paraphrase one of his talks. I
think I did better than usual in that I understood up until 20 minutes in this time!

{{< figure figcaption="Nom nom nom..... hmmm bytecode" >}}
    {{< img src="bytecode.jpg" >}}
{{< /figure >}}

Anyway, [here is his talk for you to enjoy](http://jakewharton.com/sinking-your-teeth-into-bytecode/)!
