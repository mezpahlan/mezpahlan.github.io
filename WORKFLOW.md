# Workflow

## Tools Used

The site is built using Jekyll and hosted on GitHub pages. However, it uses a number of plugins that are not in the GitHub safe list. In order to serve the site from GitHub we have to first render all of the HTML ourselves first.

+ [Jekyll](https://jekyllrb.com/)
+ [GitHub Pages](https://pages.github.com/)
+ [Ruby](https://www.ruby-lang.org/en/)
+ [Rake](https://github.com/ruby/rake)
+ [Bundler](https://bundler.io/)
+ [Git](https://git-scm.com/)

There are two git branches: `source` and `master`. `master` is only ever committed to by scripts and is where the generated site lives. You don't need to worry about this in general. Ensure that you are working from the `source` branch.

## Steps

In general the following steps will be applicable:

1. Start A Post
2. Preview Site
3. Publish A Draft
4. Build Site
5. Deploy The Site

If you are editing an already published post then you can start at step 3 after you have committed your changes.

### Starting A post

Post will be created in a draft mode. The included Rake file has a task to help create drafts.

```shell
rake draft[<draft_name>]
```

This will produce a draft post in the `_drafts` folder. From here start typing. Include your TAGS.

If you want to include pictures use the following format to have automatically responsive pictures with captions. Place the source image in the following folder `assets/images/_fullsize/<post year>/<post month>/<post day>/<post name dash separated>`

```markdown
<figure>
{% picture {{ page.id | remove_first: "/blog/" }}/<picturefile> alt="<picture caption>" class="captioned-picture"%}
<figcaption><picture caption></figcaption>
</figure>
```

NOTE: You need to create the source image directory structure yourself. This is not supported at present.

### Preview Site

When you are ready to preview your site prior to publishing run the following Rake task.

```shell
rake serve
```

NOTE: Pictures in draft mode will not be viewable. This is not supported yet.

### Publish A Draft

If you are happy with your changes run the following:

```shell
rake publish_draft[<draft_file_name>]
```

This will move the draft to the `_posts` folder with the appropriate timestamps.

NOTE: Make sure you include the `.md` extension when describing your draft.

### Build Site

Now commit your newly created post using Git and then run:

```shell
rake generate
```

### Deploy The Site

When you want to deploy the site to GitHub pages run the following:

```shell
rake deploy
```

NOTE: This will ask you for your GitHub credentials.
