+++
author = "Mez Pahlan"
categories = ["personal"]
date = "2015-07-06T19:25:00Z"
tags = ["programming"]
title = "Deconstructing Tweets"

+++

As part of my personal project for Spring, and to coincide with the UK 2015 General Election, I decided to create some
bots that mirrored the main party candidates and translated their tweets to Jive. They are still running so you can find
them on Twitter: [Ed Jiveaband](https://twitter.com/edjiveaband), [Nick Jivegg](https://twitter.com/nickjivegg), [David
Jiveron](https://twitter.com/davidjiveron).

{{< figure figcaption="Deconstructing Tweets" >}}
    {{< img src="deconstructing.png" >}}
{{< /figure >}}

One of the more interesting problems that I faced was how to prevent special Tweet Entities being erroneously translated
by the Jive translator. You may be asking what is a Tweet Entity? Let me explain about them first and then go on to
explain how I can tackle such a problem.

<!--more-->

### Tweet Entities

Tweet Entities are special portions of your tweet that you can click. Depending on the entity your click may produce
different results. One of the more common entities that you might know is the
[#hashtag](https://en.wikipedia.org/wiki/Hashtag). Other entities are the URL link, the Media link, and the user
@mention. It is clearly quite important that we don't translate these using the Jive translator service otherwise links
may not work, #hashtags may be incorrect, and the wrong user may be @mentioned.

### The Problem

To start tackling this I needed to know how to break down a tweet into its constituent parts. I started with the
assumption that this was possible and that the Twitter API would help with this. Sort of.....

It turned out that Twitter didn't do all the work for me. What I did have access to is the **start** and **end**
positions within the tweet string of where these entities are. Naively I thought that I could simply translate the whole
string and replace each entity at their original start and end positions. Sadly I quickly realised that this couldn't be
done. When we use the Jive translation service it returns a string that we cannot guarantee to be the same number of
characters as the input. If we can't guarantee this then our assumption that we can simply splice the original start and
end positions into the new translated string falls apart.

Here's an example:

```java
// Extract status as text
this.statusText = status.getText();

// Begin entity extract
this.entities = new ArrayList<EntitiesModel>();

// Get URL Entities
for (int i = 0; i < status.getURLEntities().length; i++) {
 URLEntity urlEntities = status.getURLEntities()[i];
 entities.add(new EntitiesModel(urlEntities.getStart(),
                                urlEntities.getEnd(),
                                urlEntities.getText(),
                                urlEntities.getClass().getName()));
}

// Get Media Entities
for (int i = 0; i < status.getMediaEntities().length; i++) {
 MediaEntity mediaEntities = status.getMediaEntities()[i];
 entities.add(new EntitiesModel(mediaEntities.getStart(),
                                mediaEntities.getEnd(),
                                mediaEntities.getText(),
                                mediaEntities.getClass().getName()));
}

// Get UserMentionEntity if they exists
for (int i = 0; i < status.getUserMentionEntities().length; i++) {
 UserMentionEntity userMentionEntities = status.getUserMentionEntities()[i];
 entities.add(new EntitiesModel(userMentionEntities.getStart(), 
                                userMentionEntities.getEnd(),
                                userMentionEntities.getText(),
                                userMentionEntities.getClass().getName()));
}

// Get HashtagEntity if they exists
for (int i = 0; i < status.getHashtagEntities().length; i++) {
 HashtagEntity hashTagEntities = status.getHashtagEntities()[i];
 entities.add(new EntitiesModel(hashTagEntities.getStart(),
                                hashTagEntities.getEnd(),
                                hashTagEntities.getText(),
                                hashTagEntities.getClass().getName()));
}

// Order the List of Entities by start position
Collections.sort(entities);

// Translate the tweet to jive
String jive = JiveHelper.translateToJive(statusText, entities);
```

The input string has 11 characters. The hashtag entity **starts** at character 7 and **ends** at character 11.

Suppose the translation service comes back with the following string.

```java
String translated = "yyy #newtag";
```

The translated string is, coincidently in this example, still 11 characters long. However the #hashtag has been
erroneously translated losing the original meaning. Under our original assumption we could say that we would splice the
old #hashtag into the translated string at the *original* **start** and **end** positions. Let's see what happens when
we do that.

```java
 String output = "yyy #ne#tag";
 ```

Hmmm... not good!

### The Solution

I need to be able to understand where each entity starts and ends in order to translate only the parts of tweets that
fall outside of these ranges. In order to do this I needed a way of creating an ordered collection of all the entities
dynamically.

```java
// Extract status as text
this.statusText = status.getText();

// Begin entity extract
this.entities = new ArrayList<EntitiesModel>();

// Get URL Entities
for (int i = 0; i < status.getURLEntities().length; i++) {
 URLEntity urlEntities = status.getURLEntities()[i];
 entities.add(new EntitiesModel(urlEntities.getStart(),
                                urlEntities.getEnd(),
                                urlEntities.getText(),
                                urlEntities.getClass().getName()));
}

// Get Media Entities
for (int i = 0; i < status.getMediaEntities().length; i++) {
 MediaEntity mediaEntities = status.getMediaEntities()[i];
 entities.add(new EntitiesModel(mediaEntities.getStart(),
                                mediaEntities.getEnd(),
                                mediaEntities.getText(),
                                mediaEntities.getClass().getName()));
}

// Get UserMentionEntity if they exists
for (int i = 0; i < status.getUserMentionEntities().length; i++) {
 UserMentionEntity userMentionEntities = status.getUserMentionEntities()[i];
 entities.add(new EntitiesModel(userMentionEntities.getStart(), 
                                userMentionEntities.getEnd(),
                                userMentionEntities.getText(),
                                userMentionEntities.getClass().getName()));
}

// Get HashtagEntity if they exists
for (int i = 0; i < status.getHashtagEntities().length; i++) {
 HashtagEntity hashTagEntities = status.getHashtagEntities()[i];
 entities.add(new EntitiesModel(hashTagEntities.getStart(),
                                hashTagEntities.getEnd(),
                                hashTagEntities.getText(),
                                hashTagEntities.getClass().getName()));
}

// Order the List of Entities by start position
Collections.sort(entities);

// Translate the tweet to jive
String jive = JiveHelper.translateToJive(statusText, entities);
```

There is a few things happening in the above snippet. First you'll notice that I create an empty List of what I call
*EntitiesModel*. This is a custom model I use to store interesting information about the entities. In particular the
**start** and **end** positions. Here is what it looks like (minus all the guff of getters and setters and the
constructor).

```java
public class EntitiesModel implements Comparable<EntitiesModel>{
 private int start;
 private int end;

        ...
 
 @Override
 public int compareTo(EntitiesModel o) {
  return this.getStart() - o.getStart();
 }

}
```

Notice that I've implemented a comparable interface which allows me to sort the resulting list based on the start
position of the entity. This becomes important because after I've extracted all the entities into a List of Entities
they might not be in order.

Putting it all together I have an ordered List of Entities. So now what?

```java
public static String translateToJive(String inputText, List<EntitiesModel> entities) {
  int position = 0;
  int entitySize = entities.size();
  String sub;
  String jive = "";

  // Do we have entities? If not translate the input. If so substring and translate.
  if (!(entitySize > 0)) {
   jive = JiveHelper.jiveRequest(inputText);
  } else {
   for (int i = 0; i < entitySize; i++) {
    EntitiesModel entity = entities.get(i);
    sub = inputText.substring(position, entity.getStart());
    if (sub.length() > 0) {
     jive += JiveHelper.jiveRequest(sub)
       + " "
       + inputText.substring(entities.get(i).getStart(), entities.get(i).getEnd())
       + " ";
    } else {
     jive += inputText
       .substring(entities.get(i).getStart(), entities.get(i).getEnd())
       + " ";
    }

    position = entities.get(i).getEnd() + 1;
   }
   // Here we have no more entities but could still have text to jivelate
   if (position < inputText.length()) {
    sub = inputText.substring(position);
    jive += JiveHelper.jiveRequest(sub);
   }
  }

  return TextHelper.twitterWorkarounds(jive);

 }
```

The snippet above shows how we can substring the original input string until we reach an element in the Entities list,
translate this string, splice the original entity back into the correct place in the translated string, and repeat until
the rest of the input string is translated skipping over and splicing back in each entity as we find it.

Phew!! Finally. So that's how I tackle the Tweet Entity problem problem. Maybe next time I'll write about how I overcame
the 140 Twitter character problem.

{{< figure figcaption="Tweet Entities" >}}
    {{< img src="tweet-entities.png" >}}
{{< /figure >}}
