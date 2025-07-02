+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2011-07-22T17:35:00Z"
disqus_identifier = "955360ee-cf98-41d4-9713-de2f1215b5c7"
tags = ["programming"]
title = "Unit Testing"

+++

Hello again!

I wanted to share with everyone the importance of the V model approach to testing. I've seen a lot of places (and
people) who don't understand this approach so this is my way of explaining it.

{{< figure figcaption="V Model of testing" >}}
    {{< img src="v-model.png" >}}
{{< /figure >}}

<!--more-->

For those of you who don't know the model can be described with the aid of this lovely picture!

The aim of this to match up a specific phase of testing with the appropriate level of design. The design activities are
on the left and increase in complexity as you go from top to bottom. The phases of testing are on the right and increase
in complexity as you go from top to bottom.

How can you have complex design tested by non complex phases of test? Well that isn't strictly true. The individual
tests at a unit test level are not complex, however the number and test coverage should be wide enough to thoroughly
test all the technological aspects of your solution. Remember at a unit test level you should be focusing of a
particular unit of code in isolation so your tests will be quite specific to that - and your design will be too!

I believe the key to the successful delivery of a solution is to follow this process. Have your testers involved early
in the life cycle and at all levels.

There are many ways to make this easy on yourself or your project. There are a number of tools and frameworks that you
can use to help you with testing. For example on my current project we are building an Enterprise Service Bus that
exposes a number of web services. We test them using a combination of SOAPUI, ANT (for automation), Jenkins (for
Continuous Integration) and JUnit.

Perhaps later I will elaborate on the specifics but for now - happy design and testing.
