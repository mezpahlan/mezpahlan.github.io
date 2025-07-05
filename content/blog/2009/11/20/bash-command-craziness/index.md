+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2009-11-20T21:24:00Z"
tags = ["programming"]
title = "Bash command craziness!"

+++

I had the following problem yesterday and it has taken me about 24 hours to work it out. The problem is as follows.

{{< figure figcaption="Pingus The Basher" >}}
    {{< img src="basher.png" >}}
{{< /figure >}}

<!--more-->

I have a compilation album called [Short Music For Short People](http://www.fatwreck.com/record/detail/591) that
contains 100+ tracks. When I looked at the directory all these files were stored in I saw that most of the files were
numbered 01, 02, 03, 15, 56, 89 etc to denote their track number. However the ones 100 and above were 100, 101, 102 etc.
Being as anal as I am, I wanted all my files to have three digit file numbers e.g. 001, 015, 089, 100 etc. Simple right?

Not really.

To effectively pad all two digit file names with a leading 0 I finally came up with this command that I could run with
one line from the bash shell:

``` bash
ls | grep "^[0-9][0-9]\-" > list ; while read i; do mv "$i" "0$i" ; done < list ; rm list
```

Let's look at this one bit at a time:

The first section `ls | grep "^[0-9][0-9]\-" > list` means list all files in the directory and pipe that output to a
command called **grep**. grep takes this list and searches it line by line (not technically but it is easier to think of
it doing so for the purpose of the explanation) and outputs only those lines that match `"^[0-9][0-9]\-"`. This is a
[Regular Expression](http://en.wikipedia.org/wiki/Regular_expression) that tells grep to only match items that start
with (`^`) two digits of any number from 0-9 (`[0-9][0-9]`) and are followed by a dash (`\-`). The *followed by* bit is
important because otherwise we would also match 100, 101, 015 etc because they too start with two digits at the
beginning of the line. The only difference is they have another digit straight after. The \ simply denotes an *escape*
character because I wasn't sure if grep would interpret - as a literal character or some special magic character like it
does ^. This new list is saved to a file called list. `> list`

Next we take the two digit list and cycle through it one by one and rename each filename in that list with a leading 0.
`while read i; do mv "$i" "0$i" ; done < list `. This really has to be read as one so I should explain it as one. The
`while...done < list` is a while loop that reads from the list file we created and goes through it one by one until it
has read all the lines. It also creates a temporary variable `i` that later is referred to as `$i`. The `do mv "$i"
"0$i"` pads each file in the list with a leading 0.

Finally we have to remove the list file with `rm list`.

All done!
