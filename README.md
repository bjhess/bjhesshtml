Basically copying https://tdarb.org/blog/my-static-blog-publishing-setup.html

CSS reset from https://www.joshwcomeau.com/css/custom-css-reset/

Also inspired by http://ankarstrom.se/~john/articles/html/

Hosting viewed through this lens https://kevq.uk/comparing-static-site-hosts-best-host-for-a-static-site/

### Workflow

This shall evolve.

- Run webserver (with Python3 installed):
  	python3 -m http.server
- Go to http://0.0.0.0:8000/
- Copy folder from prior post
- Remove any images assets if they are not necessary
- Edit post text in Seamonkey WYSIWYG editor
	- Change page title
- Adjust any CSS in that same folder
- Edit RSS/Atom feed
- Add post to blog/index.html page
- Deploy/Publish

### Publishing on GitHub Pages

- Set up your [custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-a-subdomain)
- Make sure your repository is public
- Select your publishing branch at Settings > Pages
- Wait

### Validation

https://validator.w3.org/nu/
https://validator.w3.org/feed/

### Tools

- [SeaMonkey](https://www.seamonkey-project.org/releases/) for editing pages WYSIWYG style.
