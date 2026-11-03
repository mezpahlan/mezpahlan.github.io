+++
author = "Mez Pahlan"
categories = ["android"]
title = "You Want To Write A Library? Now What?"
date = "2026-11-02T19:28:00Z"
tags = ["android", "programming"]
+++

You've built a nice little app and want to share some of its functionality. Great. You extract some code into a
reusable library.

Now what?

Working within an SDK can be really fun and rewarding. It's _almost_ like working in an app. It is typically much
faster to compile and if you're following the [Unix philosophy][1] of "doing one thing and doing it well" it is
typically easier and faster to _reason_ about too. However, you don't get that for free by simply extracting a module
from your app. Here are some tips I have learned about the differences between working in an app versus working on an
SDK.

<!--more-->

# Hide your internals - don't assume it's safe to make that change

Not everything needs to be `public`. This is easily overlooked when working in a multimodule app. You make a breaking
change in one module you just recompile and fix the call site and move on right? In library development you don't have
that luxury. You _cannot_ know all the possible users of your library especially if it is a popular publicly available
library. So why take that risk?

Hide your internals by marking classes with `internal` helps you as an author because it frees up your cognitive
capacity to make safe changes. If something is marked as `internal` you know damn well who the consumer is... it's you
and only you!

Take this one further with the approach that [OkHttp][2] utilises and even set up your package structure to explicitly
call out packages that are not for public dependency.

```kotlin
package okhttp3.internal // oi! what are you doing here?!
```

```kotlin
package okhttp3 // yeah, depend on these instead
```

# Make `public` only what needs to be `public` - be deliberate

A corollary to the point above is to be deliberate about what you want to expose to the world. This can sound obvious,
but it is crucial in library development to be absolutely sure of what you want to expose to consumers. Your `public`
classes and interfaces and constants are the entry points to your library. It's how you let the outside world in.

A great way to ensure that you're in control of this is to only expose the bare minimum that needs exposing... and
nothing more.

# You ~~broke~~ publicise it you ~~bought~~ own it!

Be careful what you publish with releases of your library. Think long and hard about declaring something as `public` and
a potential entry point to your library because when you do you need to assume that someone is going to depend on it.
This means you can't go around and simply drop it in the next release for risk of breaking a consumer. Your users will
only forgive you so much before finding a more stable alternative. Stable here doesn't mean that nothing changes, but
rather that it gives consumers confidence to depend on your SDK with the fear of something that breaks every other
release.

# Use API tooling to help you

Using the IDE to track API surfaces and what you declare as `public` or not is possible but a right hassle. Classes
don't look the same.

Some look like this:

```kotlin
data class Barbell(val weight: Double)
```

And some look like this:

```kotlin
class Dumbbell(val size: Size)
```

Others look like this:

```kotlin
enum class Size {
    Big, Bigger
}
```

Whilst many can look like this:

```kotlin
fun interface Workout {
    fun pump()
}
```

Keeping track of all of these and trying to assert that you've not broken anything is tedious and better left to a
dedicated tool. Just use Kotlin's [Binary Compatibility Validator][3] to keep track of your public API in a way that
machine can easily diff any changes that you might unexpectedly make. Again, you don't tend to have to worry about this
when working within an app because a simple recompilation fixes most of the issues for you. But when you're working with
a library you can't simply recompile something that already been published so it becomes more important to have tools
that allow you to understand how your API changes and when.

# Know Your ~~Customer~~ Dependencies - KYD

Keep your dependencies lean. The more dependencies you have the bigger your dependency graph will be. Each dependency
that you declare in a project will pull in more dependencies transitively. These in turn pull in more dependencies so
you end up with a large amount of dependencies before you even realised it. Now that is fine if you're actually using
these dependencies but if you're not - or could have written the code yourself - then you're increasing the chance of
spreading these to every app that consumes your library.

Why is this a problem? Consider the following:

```kotlin
// your library depends on
implementation("cool-thing:1.0.0")
implementation("awesome-thing:2.0.0")

// your library gets consumed by another project (app or another library)
implementation("your-library:1.0.0")
implementation("cool-thing:1.5.0") // but also this
```

What happens when the other project gets built? Gradle pulls in your library and in order to do that it pulls in (not
really but go with me here) `cool-library:1.0.0` and `awesome-thing:2.0.0` because your library depends on them to work.
But it also tries to pull in `cool-thing:1.5.0` because the other project says it needs that to work too. Gradle is
smart enough to know that it doesn't need two different versions of `cool-thing` so chooses the highest one by default
`cool-thing:1.5.0` on the assumption that this is backwards compatible. But Gradle doesn't know that it is truly
backwards compatible. You run the risk of crashing when users visit a part of the app that makes use of your own
library. You might see `NoSuchMethodError` and a stacktrace that points to your library and angry users posting on your
issue tracker. Your library has assumed that `cool-thing:1.0.0`'s functionality is available but Gradle has upgraded it
to `cool-thing:1.5.0`. Your library can't know this because it is already compiled and doesn't get recompiled. So a
runtime crash awaits your users.

Now this is 100% an issue with the maintainers of `cool-library` that don't know or appreciate backwards compatibility
and API evolution. But consider whether you needed to expose yourself to this in the first place. Do you _really_ need
that `cool-library`?

Use something like Dropbox's [Dependency Guard][4] to capture a record of all of your direct and transitive dependencies
so that you can make sure what you're shipping is exactly what you intend to ship.

# Evolve your own API carefully

This was the hardest for me to get used to but makes the most sense looking back. Coming back to the example from app
development: if you need to change a method somewhere in another module because you've updated your own signatures that
is fine and easy-peasy! The IDE will likely help you do this. But when working with a library you simply cannot know all
of these usages because they won't be in code base you own / have access to. This _doesn't_ mean, however, that you can
never modify your API. You just need to be deliberate and slow. Be deliberate in the sense that you are modifying the
API surface of your library because you're sure that is the right direction to go in and not because you can simply undo
the change again in the next commit like you would when working in an app. Be slow because, I find, this forces you
to be deliberate.

You don't have to necessarily write it down, but I find that having a [COMPATIBILITY.md][5] document in your repository
helps solidify the expectations to consumers of the library. Use Kotlin's `@Deprecated` annotation to its full effect so
that you can enforce when your deprecated symbol is flagging, breaks the build, or simply invisible to _new_ usages. I
even like to create my own `@ApiCompatibility` annotation to use alongside of this. This helps me remember directly in
the source code when I have made these changes, so I don't forget to then move them onto the next API lifecycle phase in
a subsequent release. Something like this:

```kotlin
@Retention(AnnotationRetention.SOURCE)
internal annotation class ApiCompatibility(
    val warningSince: String,
    val errorSince: String = "",
    val hiddenSince: String = ""
)
```

And used like this:

```kotlin
@ApiCompatibility(warningSince = "1.2.0", errorSince = "1.3.0", hiddenSince = "1.4.0")
fun legacyFunction() {
    // Implementation
}
```

# Read the docs? WRITE them!

I must be the only engineer I know (I jest) that _likes_ writing documentation in source code. It helps me think for
one. It also reminds me what the heck I was thinking about when I revisit the source months or years later. Yes of
course, you could simply read the implementation. But who has time for that? Writing documentation also produces another
check and balance to the source code. If you read both the source and the documentation but they don't match up it is
immediately obvious as opposed to guessing that the implementation is correct based on a function name.

Document _at least_ everything you have declared in your public API. Even better use a documentation engine
like [Dokka][6] to automatically output documentation in a fancy webpage that you can host or a JAR that you can
distribute.

# Life on the edge - don't

When I first started to work on apps I used to love updating to the latest version of dependencies. I'd do it once a
week at least. Monday morning coffee, chat to the team, and then look at some `CHANGELOG.md`s to see what's newly
released? This ensured that the apps I worked on were up to date with new functionality and security fixes brilliant. I
liked to live on the edge.

But as a library author I actually want the opposite. This is an important point when you think of libraries / SDKs as
_platforms_. Other people _depend_ on them. They need to be stable (remember this doesn't mean they are unchanged). If
you constantly update versions of the dependencies that you depend on in your own library then you are constantly
shifting the platform that your users are standing on top of. Why? This also comes at the risk of forcing new versions
of transitive dependencies on your consumers.

If you depend on Kotlin `2.0.0` and your library works just fine but JetBrains releases Kotlin `2.1.0` what do you gain
from pushing that update as soon as it is released? Better syntax? Doesn't matter your library is compiled. More
functions? Doesn't matter your library already did what it was supposed to do. Security fixes? OK fair enough. But the
point is that for _most_ such examples I don't believe you have to race to upgrade your dependencies.

I like to have a rough rule of thumb about this. I do update the dependencies but at a slower cadence. Internally I say
once every 6 months unless there is a strong reason to. There are a lot of consumers to my internal company SDK but
let's be honest I could reasonably chat to all of them over the course of a week or two. If this were a public library
good luck! So maybe you want to think a bit slower still. I know some teams hold back forever until a point where they
truly cannot offer the functionality of their library because that would require a dependency update at which point they
do. For an Android developer think of it similarly to supporting lower versions of Android. Who still supports
Lollipop? Hands up!

# Further help

I'm not going to lie... I didn't invent any of this. I stole it all! Mwahaha! I looked at libraries that I admired like
[OkHttp][7] and stole ideas about not just how they write code but how they set up the _infrastructure_ for their SDKs,
how they do releases, and how they respond to issues in their tracker. You should do the same.

[Kotlin has a fantastic section][8] dedicated to this and more that you can read especially and in particular the page
about [backward compatibility][9].


[1]: https://en.wikipedia.org/wiki/Unix_philosophy
[2]: https://github.com/lysine-dev/okhttp/tree/main/okhttp/src/commonJvmAndroid/kotlin/okhttp3/internal
[3]: https://kotlinlang.org/docs/gradle-binary-compatibility-validation.html
[4]: https://github.com/dropbox/dependency-guard
[5]: https://github.com/justeattakeaway/IntervalAnnotatedString/blob/main/COMPATIBILITY.md
[6]: https://kotlinlang.org/docs/dokka-get-started.html
[7]: https://github.com/lysine-dev/okhttp
[8]: https://kotlinlang.org/docs/api-guidelines-introduction.html
[9]: https://kotlinlang.org/docs/api-guidelines-backward-compatibility.html