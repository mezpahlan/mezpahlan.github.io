---
layout: post
title: TITLE
date: 'YYYY-MM-DDTHH:MM:SS.sssZ'
author: Mez Pahlan
disqus_identifier: UUID
tags:
- TAGS
---

TEXT HERE

<!-- more -->

{% responsive_image_block %}
    path: {{ site.responsive_image.base_path | append: page.id | remove_first: page.category | remove_first: "#excerpt" | append: "/IMAGE_FILENAME" }}
    alt: "IMAGE ALT TEXT"
{% endresponsive_image_block %}
