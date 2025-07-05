+++
author = "Mez Pahlan"
categories = ["android"]
title = "Store This"
date = "2021-01-13T11:43:52Z"
tags = ["android"]
+++

{{< figure figcaption="Obviously I do not condone violence." >}}
    {{< img src="dodge-this.jpg" >}} 
{{< /figure >}}

Hello and Happy New Year! What did you get up to for New Year's? Lockdown you say? Well let's blow all that away and get
reading shall we? This post is about an Android library from Dropbox called [Store](https://github.com/dropbox/Store)
(Store 4 to be precise). It facilitates the repository pattern, has been rebuilt from the ground up using Kotlin
Coroutines, and is a great way to accelerate your app to becoming reactive. I've been using it for about a year in
production during their alpha phase and now that it has recently gone stable I want to share a post of how we use it.

<!--more-->

I should start by saying that whilst I am totally in love with this library I don't use it with Kotlin
[Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html). Sadly I'm still waiting for a chance to
use Coroutines in a project and whilst I have nothing against them I am far more comfortable in
[RxJava](http://reactivex.io/). So the rest of this post will be using examples that are written in RxJava. One of the
reasons I like this library is that it provides Rx bindings (I think that's the right word) to take advantage of this
library even if you are consuming this library from an RxJava project. In fact Store provides support for both RxJava 2
and RxJava 3. I'm also a bit biased because I contributed the RxJava 3 module and added a few extension functions to the
RxJava 2 module.

# Let Us Start With A Problem

Suppose you have an API that you call frequently on more than one page of your app. Say, for example, a list of messages
for the user. The first call might end up merely showing the count of messages, whereas the second might display the
list of messages, and finally the third might display some detail of a selected message.

{{< highlight kotlin >}} // Given this example data type data class Messages(val id: Int, val title: String, val
    message: String)

    // On the first page we want to show a badge if we have messages
    api.fetchMessages(client) // Suppose this returns Single<List<Messages>>
        .flattenAsFlowable { it }
        .count()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribeBy(
            onSuccess = { viewState.value = viewState.value?.copy(unread = it > 0L) },
            onError = { viewState.value = viewState.value?.copy(error = true) }
        )

    // On the second page we want to show the list of messages
    api.fetchMessages(client) // Suppose this returns Single<List<Messages>>
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribeBy(
            onSuccess = { viewState.value = viewState.value?.copy(list = it) },
            onError = { viewState.value = viewState.value?.copy(error = true) }
        )

    // On the third page we want to show the selected of message
    api.fetchMessages(client) // Suppose this returns Single<List<Messages>>
        .flattenAsFlowable { it }
        .filter { it.id == selectedId }
        .firstOrError()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribeBy(
            onSuccess = { viewState.value = viewState.value?.copy(subject = it.title, body = it.message) },
            onError = { viewState.value = viewState.value?.copy(error = true) }
        )
{{< /highlight >}}

This is a rather contrived example but you get the idea. You might find yourself in a situation where you need to carry
out the same operation a number of times for slightly different purposes. Sometimes that might be an expensive network
operation.

The takeaway point here is that we've already fetched the relevant information we need after the first page. Yet we go
on to make two identical calls.

# How Does Store Help With This?

In the simplest form Store gives you an in memory cache implementation. To take advantage of this you need to wrap your
`api` fetching call in a _Store_.

{{< highlight kotlin >}} val repository = StoreBuilder.from<Client, List<Messages>>( fetcher = Fetcher.ofSingle {
    api.fetchMessages(client) } ) .build() {{< /highlight >}}

Now your calls might look like this:

{{< highlight kotlin >}} // On the first page we want to show a badge if we have messages repository.getSingle(client)
    // The first invocation fills the cache from the network .flattenAsFlowable { it } .count()
    .subscribeOn(Schedulers.io()) .observeOn(AndroidSchedulers.mainThread()) .subscribeBy( onSuccess = { viewState.value
        = viewState.value?.copy(unread = it > 0L) }, onError = { viewState.value = viewState.value?.copy(error = true) }
        )

    // On the second page we want to show the list of messages
    repository.getSingle(client) // The second invocation makes no network call (within the policy)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribeBy(
            onSuccess = { viewState.value = viewState.value?.copy(list = it) },
            onError = { viewState.value = viewState.value?.copy(error = true) }
        )

    // On the third page we want to show the selected of message
    repository.getSingle(client) // The third invocation makes no network call (within the policy)
        .flattenAsFlowable { it }
        .filter { it.id == selectedId }
        .firstOrError()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribeBy(
            onSuccess = { viewState.value = viewState.value?.copy(subject = it.title, body = it.message) },
            onError = { viewState.value = viewState.value?.copy(error = true) }
        )
{{< /highlight >}}

Relatively simply you have eliminated two superfluous network calls. Of course you'll have to judge for yourself whether
this is the best thing to do but the rule of thumb I use is this:

>Does the use of data or type of data _require_ it to be fetched again between pages? For example a live price quote
>would not fit this usecase. If the data _freshness_ is not a concern between pages then you can probably proceed.

For _how long_ you want to cache this memory is also something you should consider by default Store will cache 100
unique items for 24 hours. If that doesn't work for you it can be customised.

# A Mental Model

At this point I think it is important to have a mental model of Store and how it works. Or at the very least a
simplified analogy. Like any good cache Store can be thought of as a Map. It has some Keys and it has some Values. You
might have the same Value between entries in your map, but you always have a unique Key. Thinking of Store like this
helps me remove some of the complicated and fancy things it does like in-memory caching for rotation, disk caching for
when users are offline, throttling of API calls when parallel requests are made for the same resource.

It also helps make sense of the way in which you _query_ your Stores. From the docs:

>Store uses generic keys as identifiers for data. A key can be any value object that properly implements toString(),
>equals() and hashCode(). When your Fetcher function is called, it will be passed a particular Key value. Similarly, the
>key will be used as a primary identifier within caches (Make sure to have a proper hashCode()!!).
>
>Note: We highly recommend using built-in types that implement equals and hashcode or Kotlin data classes for complex
>keys.

If I ask Store for a resource, a Key, there's a guarantee that it can determine if it has already carried out this
operation because the Key is either present or not present. Just like how a Map works. The slight shift in your thinking
might be if you are used to passing multiple parameters to your API fetching operation. Instead pass a single data class
that wraps these for the easiest migration path. The data class gives you the equality guarantees easily and so you may
treat it as a value type. Kotlin FTW! Store FTW! Android FTW!

{{< highlight kotlin >}} // Instead of api.fetchMusic("Perry", "Xiola", "Casey")

    // Do this
    data class Listeners(val left: String, val centre: String, val right: String)
    data class Track(val name: String)

    val repository = StoreBuilder.from<Listeners, Track>(
                        fetcher = Fetcher.ofSingle {  api.fetchMusic(it.left, it.centre, it.right) }
                    )
                    .build()

    repository.getSingle(Listeners("Perry", "Xiola", "Casey")) // I'll leave you to guess what that comes out as
{{< /highlight >}}

Now every request to the your Store.... to your Map...... has a unique key associated with it. If it doesn't exist it
must be fetched. If it does exist return the already cached value (subject to policy of course).

# Offline

That's a lot of refactoring just for an in memory cache. I can do that myself. I know. I'm sure we all have at some
point! However whilst the above is the simplest way to use Store the way I'm more exited about is how to enable offline
support.

Store has the concept of a _Fetcher_. That's pretty obvious as to what it does. It is typically a network API call but
it doesn't have to be. It can be any Kotlin [Flow](https://kotlinlang.org/docs/reference/coroutines/flow.html). Here's
where I am a bit hazy because I haven't used Coroutines a lot but these are _similar_ to Flowables from the Reactive
framework. The example above use extension functions to hide the fact that we are actually creating Kotlin Flows when
defining our Fetchers.

Store also has the concept of _Source Of Truth_. This is similar to the caching capability explained above but to a
truly persistent source this time. In the Android world this might be
[Room](https://developer.android.com/jetpack/androidx/releases/room),
[SQLDelight](https://github.com/cashapp/sqldelight). But again, it doesn't have to be...... I'd recommend it is though.

What if, for example, we wanted to show our list of messaged but there was an outage in network. You've driven under a
tunnel (forget for a second that you're checking message whilst driving.... naughty naughty). If you've previously
fetched the data it would be better to at least show it in read only format rather than an error screen. Here's what
you'd have to do:

{{< highlight kotlin >}} val repository = StoreBuilder.from<Client, List<Messages>, List<Messages>>( fetcher =
    Fetcher.ofSingle {  api.fetchMessages(client) }, sourceOfTruth = SourceOfTruth.ofMaybe( reader = { key ->
                        db.read(key) }, write = { key, value -> db.write(value) }, delete = { key -> db.delete(key) },
                        deleteAll = { key -> db.deleteAll()) }, ) ) .build() {{< /highlight >}}

That's it! It's a small extension to what you already have and straight away you've got a repository pattern with
network and database with all the great additions that Store offers. **This** is why I really like this library. Once
you've got the in memory setup, you (pretty much) get a persistence setup for free. None of your consuming API code now
needs to change.

## Side Note: Stale-While-Revalidate

There's two ways in which you can query Store. The first is what I've used in these examples via the extension function
`getSingle`. This retrieves a value from the Store if it is present, otherwise calls the Fetcher to populate the Store
and only then return the value. The other way is `freshSingle` which skips the first check and **always** retrieves a
fresh value from the Fetcher whilst refreshing your Store ready for the next time.

Store offers these two mechanisms as a way to "bust through" the cache for pull to refresh usecases. But the more I
think about `getSingle` the more I am reminded of the [Stale-While-Revalidate](https://web.dev/stale-while-revalidate/)
pattern from the web. Using `getSingle` and a custom cache policy you can achieve this _really_ easily with Store. Neat!

# Where Does Store Go In An App?

I am still discovering the best way to do this so don't take this as any sort of best practice but my thought process
for this was as follows. The Store is _essentially_ a library for the repository pattern. Where would your repository
code sit? As a dependency to your Presenter? As a dependency to your ViewModel? As a dependency to your UseCase (if
you're Uncle Bob'ing it). You'll see in the examples above that I create Stores using the Builder and assign it to a
variable called `repository`. But _where_ do I do this?

I started out initially by creating the repositories within our UseCase for pure convinience like this:


{{< highlight kotlin >}} class UseCase(private val api: Api) : SingleUseCase<Client, List<Messages>> { val repository =
    StoreBuilder.from<Client, List<Messages>>( fetcher = Fetcher.ofSingle {  api.fetchMessages(client) } ) .build()

        override fun execute(params: Client): Single<List<Messages>> {
            return repository.getSingle(client)
                        .flattenAsFlowable { it }
                        .filter { it.id == selectedId }
                        .firstOrError()
                        .subscribeOn(Schedulers.io()) 
                        // Note that we don't directly subscribe here we do that in a layer above.
        }
    }
{{< /highlight >}}

Which _looks_ like it might work but it actually doesn't because upon creation of the UseCase a brand new Store (a brand
new repository) is created too. Therefore even when I made requests from the Store with `getSingle` I noticed the data
was being fetched unnecessarily.

The fix is fairly simple in that you need to treat your repositories as Singletons. After all...... what does it
actually _mean_ to have multiple versions of a repository that represents the same underlying data? It doesn't.

{{< highlight kotlin >}} @Singleton class UseCase @Inject constructor(private val api: Api) : SingleUseCase<Client,
    List<Messages>> { .... } {{< /highlight >}}

This works fairly well but as a slight improvement we now completely extract the Repository object so that our UseCase
is not forced to be a Singleton.

{{< highlight kotlin >}} @Singleton class Repository @Inject constructor( private val api: Api, private val db: DB ) :
    SingleUseCase<Client, List<Messages>> { val store by lazy { StoreBuilder.from<Client, List<Messages>,
    List<Messages>>( fetcher = Fetcher.ofSingle {  api.fetchMessages(client) }, sourceOfTruth = SourceOfTruth.ofMaybe(
        reader = { key -> db.read(key) }, write = { key, value -> db.write(value) }, delete = { key -> db.delete(key) },
        deleteAll = { key -> db.deleteAll()) }, ) ) .build() }

       fun get(): Store<Client, List<Messages>> = store
    }

    // And it's use

    class UseCase @Inject constructor(
        private val repository: Repository
    ) : SingleUseCase<Client, List<Messages>> {

        override fun execute(params: Client): Single<List<Messages>> {
            return repository.get().getSingle(client)
                        .flattenAsFlowable { it }
                        .filter { it.id == selectedId }
                        .firstOrError()
                        .subscribeOn(Schedulers.io())
        }
    }
{{< /highlight >}}

There are a few interesting things happening here. First the UseCase is no longer a Singleton. It doesn't need to be.
Instead it simply depends on a Repository and doesn't know or care where the data is coming from. Secondly the
Repository has been moved to its own object that is marked as a Singleton. This is less jarring than the first example
and makes the responsibility of the two objects clearer. Lastly, the Store is built _lazily_ using the Kotlin `by lazy`
delegate. This ensures that we don't do extra work until we really have to i.e. when the UseCase executes the logic.

# Reactive Apps

I haven't yet got around to doing this in our project but it is something that I want to do in the near future. Making
the UI react to changes in the underlying data is an interesting idea for me. My assumption here is that by using Room
(or SQLDelight) you can very easily make your Source Of Truth reactive. [Room has a RxJava binding
library](https://medium.com/androiddevelopers/room-rxjava-acb0cd4f3757) that lets you observe changes to your database
by having them be emitted as a `Flowable`.

My thought is that if we setup a Store to be from a Flowable Source Of Truth we may benefit from this behaviour. If
anyone has done something similar I'd love to find out how it went. Even if it was with the Coroutines version of Store.

# In Flight Debouncing Of Requests

Thank you Elliot Long for pointing out another cool feature of Store. Suppose you have a screen with multiple points
that each rely on the same data (sliced in a different way but) from the same repository. Add to this maybe a background
operation that is making use of the same repository that just happens to be running. If you request N number of requests
from Store does that mean you will need to fulfil N number of requests from your API?

Luckily not! Store is clever enough to understand that, for an identically requested Key (remember from our mental
model) a request is currently being fulfilled. It can use this to cancel the Fetcher for the requests that are identical
and only process the first to arrive. Once that has completed it can fulfil the other requests from its caching
mechanisms (either in memory or from the Source Of Truth). This is another way in which Store can help alleviate some
concerns about how to perform something similar by hand. Best of all, you get this for free! There's no additional code
you need to write / configure for this!

# Final Note

Whilst Store gives you a lot for free to help cache data and reduce calls on your backend it is not a catch all get out
of jail free card. You will still have you spend time understanding network caching and how that might work with your
backend team. Not all API calls need to go via Store. This will be highly specific to your app. An easy win would be if
you have an expensive network API that fetches a lot of data and different _slices_ of that data are used in different
areas. If this data is _essentially_ static for the lifetime that your app is in use I see that as a good indicator that
Store can be used.
