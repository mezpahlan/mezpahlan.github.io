# mezpahlan.github.io

About me website!

This site is built using [Hugo](https://gohugo.io/) and hosted on Github Pages. 

The theme is a port of the original Hyde Jekyll theme also called [Hyde](https://github.com/spf13/hyde/). However I have
customised it ever so slightly.

## Cloning

New computer? Keep in mind that this repo uses submodules (for the Hyde theme) so you will need to also clone that to
the correct path. Luckily `git` can help us.

```bash
$ git clone --recurse-submodules git@github.com:mezpahlan/mezpahlan.github.io.git
```

## Draft

To create a draft do the following on the `main` branch:

1. Run `$ hugo new blog/20YY/MM/DD/post-title` substituting the appropriate date characters.
2. Edit your post.
    - Hard wrap at 120 except Hugo shortcodes.
3. Preview the site by running `$ hugo server`.

## Deploy

To deploy do the following:

1. Commit your changes in the `main` branch.
2. Run `$ ./deploy.sh`.

## Still to do

- [ ] Add portfolio section.
- [ ] Tags, categories on sidebar is broken
- [ ] Custom CNAME.
- [ ] Remove gists. These are deprecated by Hugo so convert them all to markdown. Fewer script tags.
- [ ] Check site.baseURL vs absURL usage.
- [ ] Remove Disqus
- [ ] Remove image resizing options set a single sensible size
- [ ] Remove as much non static stuff as possible
- [ ] Remove Twitter
