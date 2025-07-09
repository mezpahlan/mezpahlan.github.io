+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2015-05-09T16:49:00Z"
tags = ["programming", "politics"]
title = "The Jive Election 2015"

+++

Throughout March and April of 2015 I have been busy working on a pet project with my friend Ricky Shelton. The idea was
simple. Make the politicians running in the 2015 UK General Election more electable by having them speak Jive.

{{< youtube id="RrZlWw8Di10" loading=lazy >}}

<!--more-->

We came up with the crazy idea at a very slow and depressing day at work one day last year. Ricky quickly mocked up some
code that would listen to the candidate's Twitter feed, grab a Tweet and send it to a Jive Translation service. We had a
few hours worth of giggles over at [Luke's Jive Translator](http://www.luketillo.com/jiveluke.html) so decided to reuse
his back end. The way his service works is by accepting a string of text and replacing predefined values with Jive
values. The results are hilarious. So we thought why not automate it?

Here is the former leader of the Labour Party, [Ed Miliband](https://twitter.com/ed_miliband), saying, "Thanks", for a
hard fought campaign.

{{< figure figcaption="Ed Miliband" >}}
    {{< img src="ed.png" >}}
{{< /figure >}}

And here is his Jive counterpart, [Ed Jiveaband](https://twitter.com/edjiveaband), saying the same.

{{< figure figcaption="Ed Jiveaband" >}}
    {{< img src="ed-jive.png" >}}
{{< /figure >}}

OK, so 3 retweets is not quite up there with 2.7 thousand but I'll take that anyway!

Here are some of my favourites from the other candidates.

[David Cameron](https://twitter.com/david_cameron) wishing the new royal baby well.

{{< figure figcaption="David Cameron" >}}
    {{< img src="dave.png" >}}
{{< /figure >}}

And his Jive counterpart, [David Jiveron](https://twitter.com/DavidJiveron), wishing the same.

{{< figure figcaption="David Jiveron" >}}
    {{< img src="dave-jive.png" >}}
{{< /figure >}}

Finally old [Cleggers](https://twitter.com/nick_clegg) after being flashed by an overexcited student.

{{< figure figcaption="Cleggers" >}}
    {{< img src="nick.png" >}}
{{< /figure >}}

And [Nick Jivegg](https://twitter.com/nickjivegg)'s response.

{{< figure figcaption="Nick Jivegg" >}}
    {{< img src="nick-jive.png" >}}
{{< /figure >}}

At some point I will follow this up with a post on how we made this with some technical details. But if you want to
check it out yourself it is on Github under my [Jive Campaign](https://github.com/mezpahlan/jivecampaign) repository.

There were some very interesting problems that we needed to solve. The worst of which (and an on going one) was that we
were constantly breaking Twitter's 140 character rule since the Jive translator sends back a piece of text that we have
no control over. Some times it fits, sometimes it does not. We also wanted, right from the start, not to translate hash
tags, links, and user mentions but the solution to that turned out to be non trivial. Anyway, I'll get to that in a
later blog post.

To run the service I chose Red Hat's [Open Shift](https://www.openshift.com/) platform as a Service. It is written in
Java and makes extensive use of Yusuke Yamamoto's brilliant [Twitter4J](http://twitter4j.org/en/index.html) library. At
some point I'll also get around to writing unit tests and will use [JUnit](http://junit.org/) and
[Mockito](http://mockito.org/) as my tools.
