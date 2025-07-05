+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2013-01-10T16:27:00Z"
tags = ["programming", "ubuntu"]
title = "Mass Renaming & Restoring USB Drives"

+++

I recently had to rename a lot of files in directory as well as fix a broken USB drive. I reckon I'll need to use this
again at some point so here are the tips. Both for me and for you!

{{< figure figcaption="Coulommiers lait cru" >}}
    {{< img src="rename.jpg" >}}
{{< /figure >}}

<!--more-->

I had over a hundred photos with timestamped names in a folder that I wanted to rename to the folder name followed by an
incremental counter. This is a FOR loop that you can type into a terminal and run this on your directory. Remember to
copy all of this in before pressing ENTER.

````
COUNTER=1; for i in *; do mv $i FileName$COUNTER.jpg; COUNTER=$[COUNTER+1];  done
````

The only problem is that I could work out how to pad the incremental numbers with 0s for example 001, 002, 003 instead
of 1, 2, 3 since in the past without these padded 0s I've sometimes noticed that the sorting is incorrect (1, 10, 11,
12...., 2, 20, 21, 22...).

That part I did by hand.  Fixing a disk drive that isn't responding is always a nightmare. Thankfully this website shows
you [ how to restore your usb drive](http://www.pendrivelinux.com/restoring-your-usb-key-partition/) back to working
health! Work for both Linux and other operating systems. Took me little more than five minutes and I was able to use my
16GB USB disk once more.


I skipped the part labelled C in the guide and instead did that using the [GParted](http://gparted.sourceforge.net/)
tool that comes bundled with [Ubuntu](http://www.ubuntu.com/) and all other Gnome based OSs.

That's it. Now have some cheese!
