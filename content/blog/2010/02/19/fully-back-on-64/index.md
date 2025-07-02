+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2010-02-19T23:34:00Z"
disqus_identifier = "bf13ac6f-bcdf-4a33-be26-57f189c7270d"
tags = ["ubuntu"]
title = "Fully back on the 64"

+++

A while back I heaped praise on the
[Ubuntuzilla](http://sourceforge.net/apps/mediawiki/ubuntuzilla/index.php?title=Main_Page) project for providing me a
way to watch all Flash content without the need to wrap 32 bit plugins. This was extremely useful to me but I knew that
it would always be a temporary thing.


{{< figure figcaption="Xenon flash" >}}
    {{< img src="flash.jpg" >}}
{{< /figure >}}

<!--more-->

Where ever possible I'd like to use the Ubuntu repositories and having software installed outside of those channels was
risky for me. I should say that it worked first time every time and flawlessly but sadly its time can come to an end.

I've switched back to the 64 bit build of Firefox and am now using [Adobe's 64 bit pre release Flash
plugin](http://labs.adobe.com/downloads/flashplayer10_64bit.html) again. I've always thought that it worked a lot better
on my 64 bit machine but couldn't understand the crashing on certain sites.

To recap: certain sites would cause a particular instruction set to be invoked when running Flash content (Adobe's very
own site being one of them). This caused the whole of Firefox to collapse suddenly and without warning (this is another
gripe I have about Firefox, plugins are still run inside the main browser process so a bad plugin causes the whole
browser to fall over. Not something Chrome, Opera and yes even IE8 do any more. Sad times).

Whilst I have found out that there needs to be a fix for older processors such as mine that needs to come from the
processor manufacturer, no change in Adobe's plugin would make a difference. Luckily the always brilliant people at
Ubuntu Forums came up with an [answer](http://ubuntuforums.org/showthread.php?t=1263905) (actually it was the Gentoo
people but the link explains all that).

This all means I can run Firefox in 64 but mode again and have access to all the Flash content I want! Hurrah!!

I'd like to see in the future more support for 64 bit programs.
