+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2017-02-19T19:02:17Z"
disqus_identifier = "732af28b-5c55-4834-b598-d2914afe71fe"
tags = ["blog"]
title = "Under The Hood Optimisations"

+++

I've spent the last few weeks wrestling with Ruby and making some site changes to my blog. It's been enjoyable. I've
learned more about Ruby and more about responsive images on the web. I still don't like Ruby, but at least now I have
made my peace with it.

{{< figure figcaption="Man looks under the hood of an old jeep from world war two" >}}
    {{< img src="under-the-hood.png" >}}
{{< /figure >}}

<!--more-->

The first change that I have made was to simplify the structure of the site to make it easier to work with. I have moved
files around so that now their directory structure better reflects what their intended use is. I have made this change
for both the site templates and the Ruby Rakefiles. Whilst everything worked before, there was no structure to the site
which made it hard for me to extend.

The second major change was to switch the use of one responsive image Jekyll plugin to another. This allowed me to
define my own custom template for how I want the responsive images to be defined in the outputted HTML. I now use
[Jekyll Responsive Image](https://github.com/wildlyinaccurate/jekyll-responsive-image) that allows me to do exactly
that. There were a few teething problems in switching over such as being able to use images within the excerpt section
but these were overcome with some help of the plugin's author.

Now that these changes are out of the way I feel I can start to improve the look and load time of the site. I want to
look to removing unnecessary network calls and make better use of Bootstrap. I have a lot more divs that I actually need
at the moment in my markup which isn't great for page load and usability especially on a mobile device.

Whilst these changes won't be obvious to the end user they will allow me to update the site in a more clean fashion in
the future.
