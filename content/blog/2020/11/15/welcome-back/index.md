+++
author = "Mez Pahlan"
categories = ["personal"]
title = "Welcome Back"
date = "2020-11-15T22:17:40Z"
disqus_identifier = "2c2dcaaa-24ce-06f0-96dc-baefb6802d5b"
tags = ["fun"]
+++

I'm back! With a slight redesign of the blog. Can you tell?

{{< figure figcaption="Françoise Foliot, CC BY-SA 4.0, via Wikimedia Commons" >}}
    {{< img src="dumuzid.jpg" >}} 
{{< /figure >}}

<!--more-->

It's been a long time. A long long long long long time. Well..... [almost two years]({{< relref
"/blog/2018/09/24/kotcha" >}}) to be precise. The short answer is "work has been very busy". The longer answer is that I
will aim to blog more in the future.

Let's start with the blog redesign. I've not gone crazy this time around. Most of the changes are in the underlying
static page generator. The site is now powered by [Hugo](https://gohugo.io/). The main selling point here is that it is
stupid fast. I mean blazing fast. Whilst porting the site from [Jekyll](https://jekyllrb.com/) I had to build the site
and make sure all the images and links worked multiple times. This often meant deleting all the resized images. If
memory serves me correctly a full site rebuild would take about 2 minutes or so using Jekyll. I never had to wait longer
than 8 seconds with Hugo. It's really good!

The theme is also very similar. It's still a Hyde based theme but I've tweaked it ever so slightly because the Hugo
theme I am using is not as feature rich as the Jekyll one the old site was using. I am still in the process of finishing
the port but as a minimal viable blogging site this is good enough for now.

Having said that Hugo wasn't without it's difficulties. The documentation is not great. I was fortunate enough to have
been battle tested with Jekyll enough to _sort of_ know the lingo and the kind of questions I needed to type into Google
to get this site working. The quick start in Hugo is great....... but it's not really meant for porting a fully working
site. Part of my issues in porting the site was that the old Jekyll based site used a different directory structure to
the new Hugo one. Whilst everything _seemed_ to render correctly I wanted to take the opportunity to simplify a lot of
the up keep of the site. _One_ of the reasons that I haven't posted anything in a while is that it was a lot of work to
set everything up and start writing. I want a workflow that is easy so I can simply jot a few ideas down and before you
know it I have a post! Hopefully this is it?

My old directory structure in Jekyll looked something like this:

{{< highlight bash >}}
posts/
      2009-01-01-my-first-post.md
      2009-11-02-my-second-post.md
      2020-03-01-my-third-post.md
{{< / highlight >}}

However in Hugo I have something that should look like this:

{{< highlight bash >}}
posts/
      2009/
           01/
              my-first-post/
                            index.md
                            image.jpg
                            image2.jpg
           11/
              my-second-post/
                             index.md
      2020/
           03/
              01/
                 my-third-post/
                               index.md
{{< / highlight >}}

So I had to _un_flatten about 261 posts. Ewwwwwww not fun. To help me with this I whipped up a few bash scripts.

{{< highlight bash >}}
for i in `ls *.md`; 
    do [[ $i =~ [0-9][0-9][0-9][0-9]-([0-9][0-9])-([0-9][0-9])-([^.]*).md ]] ; 
    mkdir -p ${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/${BASH_REMATCH[3]} ; 
done
{{< / highlight >}}

Apologies people with small screens this isn't going to be pretty. This is a "simple" regex that works in conjunction
with a search in the current directory for all of the files ending in `.md`. From here I capture the `YYYY`, `MM`, and
`DD` values from the file name and use them to create directories that didn't exist in the old structure. Note the
`mkdir -p` command. This is tells Bash to create the parent directory if it does not exist. If it does exist then it
doesn't overwrite anything which is precisely want we want here.

My next problem was to do with images. If you are inquisitive enough you'll notice that the image served to your device
depends on the capability of your device. I try and only server you the highest quality image that your device can
comfortably display and not a large one that I might have. This saves you bandwidth. See [Responsive
Images](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images) for details on
how to achieve this. Thankfully there are some neat solutions to help with this even back when I was using Jekyll to
generate the site. However with Hugo you'll notice that my images are now next to the posts themselves in the directory
structure as opposed to in a separate unconnected directory. Again, one less thing for me to worry about long term but
whilst porting I needed to trash the resized images from Jekyll days and let Hugo regenerate them again. 

{{< highlight bash >}}
find . -type d -name 'resized' -execdir rm -rf '{}' \;
{{< / highlight >}}

This command finds all directories (`-type d`) named `resized` (that's what Jekyll called them) and runs the command `rm
-rf`. Which is a remove command. Simple! Now when the Hugo site is rebuilt it will create its own resized images.
Lovely.

Finally you'll notice that I used to have the title of the post in the filename in the old site but now they are named
`index.md` because the directory contains the post name. That's another simple fix:

{{< highlight bash >}}
find . -type f -name "*.md" -execdir rename 's/.+\.md/index.md/' '{}' \;
{{< / highlight >}}

This time we find all files (`-type f`) that have `md` as an extension and run a rename command. Phew!

And that's mostly it. I had to mess around with the CSS a little to get it looking like it used to but that wasn't too
difficult since the theme does most of the work and I'm only tweaking it here and there.

So hopefully now I can start blogging again more regularly on what I'm up to? See you in five years!

# Credits
The following sites were inspirational in getting me moving when I saw no way out.

1. Laura Kalbag's [Processing Responsive Images With Hugo](https://laurakalbag.com/processing-responsive-images-with-hugo/).
2. Linx Journal's [Bash Regular Expressions](https://www.linuxjournal.com/content/bash-regular-expressions).
3. This Ask Ubuntu answer about [the find syntax in bash](https://askubuntu.com/a/196983/112819).
4. Glenn McComb's [How To Build Custom Hugo Pagination](https://glennmccomb.com/articles/how-to-build-custom-hugo-pagination/).
5. CSS Trick's [A Guide To FlexBox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/).