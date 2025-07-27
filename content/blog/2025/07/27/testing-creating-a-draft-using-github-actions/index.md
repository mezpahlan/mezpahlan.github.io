+++
author = "Mez Pahlan"
categories = ["personal"]
title = "Testing Creating A Draft Using Github Actions"
date = "2025-07-27T22:02:33+01:00"
tags = ["blog"]
+++

How useful this will be... I don't know. But I now have a way to create a draft blog post from my mobile using GitHub Actions. Here's how.

<!--more-->

First I have a GitHub Action that creates and commits a file. This uses the GitHub bot that is present in all Action workflows. 

Secondly creating the file is done via Hugo. The Hugo commands know how to create posts using the `new` keyword. I rely on the fact that I already have a template file set up that creates the skeleton of a post with the correct front matter.

Lastly I trigger the Action using a `workflow_dispatch`. This lets me input a file name before I start the Acton. That's it. A draft is created ready for new to start editing. 

The editing experience on mobile isn't great. So I will limit myself to short posts that only require text. Maybe that's a good thing in the long run. But I still have the ability to create larger more media rich drafts that will wait for me when I get home to finalise. 

This post was entirely created on mobile. Excuse any spelling mistakes.