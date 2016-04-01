---
layout: blog
title: Mass Renaming & Restoring USB Drives
date: '2013-01-10T16:27:00.002Z'
author: Mez Pahlan
tags:
- programming
- ubuntu
modified_time: '2013-01-10T16:27:37.389Z'
blogger_id: tag:blogger.com,1999:blog-7057712950286438970.post-1416522405795249244
blogger_orig_url: http://mezsays.blogspot.com/2013/01/mass-renaming-restoring-usb-drives.html
---

I recently had to rename a lot of files in directory as well as fix a broken USB drive. I reckon I'll need to use this again at some point so here are the tips. Both for me and for you!

<!-- more -->

I had over a hundred photos with timestamped names in a folder that I wanted to rename to the folder name followed by an incremental counter. This is a FOR loop that you can type into a terminal and run this on your directory. Remember to copy all of this in before pressing ENTER.

<div style="text-align: center;"><span style="font-size: small;"><span style="font-family: &quot;Courier New&quot;,Courier,monospace;">COUNTER=1; for i in *; do mv $i FileName$COUNTER.jpg; COUNTER=$[COUNTER+1];  done</span></span></div>
The only problem is that I could work out how to pad the incremental numbers with 0s for example 001, 002, 003 instead of 1, 2, 3 since in the past without these padded 0s I've sometimes noticed that the sorting is incorrect (1, 10, 11, 12...., 2, 20, 21, 22...).

That part I did by hand.  Fixing a disk drive that isn't responding is always a nightmare. Thankfully this website shows you <a href="http://www.pendrivelinux.com/restoring-your-usb-key-partition/">how to restore your usb drive</a> back to working health! Work for both Linux and other operating systems. Took me little more than five minutes and I was able to use my 16GB USB disk once more.


I skipped the part labelled C in the guide and instead did that using the <a href="http://gparted.sourceforge.net/">GParted</a> tool that comes bundled with <a href="http://www.ubuntu.com/">Ubuntu</a> and all other Gnome based OSs.

That's it. Now have some cheese!
<div class="separator" style="clear: both; text-align: center;"><a href="https://www.blogger.com/blogger.g?blogID=7057712950286438970" imageanchor="1" style="clear: right; float: right; margin-bottom: 1em; margin-left: 1em;"></a><a href="https://www.blogger.com/blogger.g?blogID=7057712950286438970" imageanchor="1" style="clear: right; float: right; margin-bottom: 1em; margin-left: 1em;"></a><a href="http://commons.wikimedia.org/wiki/File%3ACoulommiers_lait_cru.jpg" style="clear: right; float: right; margin-bottom: 1em; margin-left: 1em;" title="By Myrabella (Own work) [CC-BY-SA-3.0 (http://creativecommons.org/licenses/by-sa/3.0) or GFDL (http://www.gnu.org/copyleft/fdl.html)], via Wikimedia Commons"></a><img alt="Coulommiers lait cru" border="0" src="//upload.wikimedia.org/wikipedia/commons/thumb/d/dc/Coulommiers_lait_cru.jpg/512px-Coulommiers_lait_cru.jpg" style="cursor: move;" width="512" /></div>


