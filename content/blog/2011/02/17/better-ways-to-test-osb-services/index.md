+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2011-02-17T09:23:00Z"
disqus_identifier = "242e17b9-e007-448e-a1d5-6c58c1ee9d89"
tags = ["programming"]
title = "Better ways to test OSB services"

+++

This week I have been trying to find out more about how to unit test Oracle Service Bus services in a way that lends
itself to automation and continuous integration.

<!--more-->

Currently the best way to achieve this is to run long integration tests in this way using SOAPUI as a test driver and
stub. Whilst this is the accepted solution for testing OSB services it does mean that some of the subtly of unit testing
is lost. Your system becomes a black box and is tested as such. For some that is OK. But it always unsettled me.

The tooling for Oracle Service (workshop for Weblogic) does indeed provide a way to unit test your services whilst you
are debugging and building them. But you can't automate this. I see this as a serious shortfall in building robust
services. You have to put faith in the fact that you can't 'see' what a single service is doing when you chain three or
four together and run an integration tests through them.

They could be doing all sorts of logic that you don't have access to as long as it comes out with the correct value at
the end. That is no way to test.

Having said all that what can we do now whilst Oracle get their ass in gear? I have already stated that we can run
integration tests using SOAPUI in an automatic fashion. We can also run manual unit test through the Oracle tooling. Can
we combine the two?

What if there was a way to directly invoke a proxy service and not have it output to its business service or another
proxy service? Could you then automate that test with SOAPUI? Granted you aren't testing the transportation layer or the
security, but these can form part of your integration tests at a later stage. This way you are white box testing your
services independent of anything else so when you chain them together you have confidence that they are functioning as
you intended before creating dependencies on other services. Just as you would with a JUnit test.

So far I have not been able to make this a reality. My two options are limited by my knowledge of Java and access to the
underlying source of the OSB. So now I turn to you.

Is there a way of either directly invoking the debug window for a service without using the GUI? Some scripting using
ANT would then possibly allow automation using SOAPUI. Alternatively is there a way to dynamically change the transport
type and output for a proxy service. That way, again, SOAPUI could invoke the service and assert results from the
output. The first is ideal since you don't need to modify the way you code your service. You can also have different
transport mechanisms since these are bypassed by the direct invocation of the service. The hunt for proper unit testing
in the OSB continues.
