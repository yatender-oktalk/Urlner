## Instructions

We expect you to be familiar with git and Docker.

The question is provided to you on this git repository.
Your solution should be committed back into this repository like you would do in a normal project.
You can commit and push as many times as you want.

For evaluation purpose we need to setup your solution on our own infrastructure easily. For this purpose please make sure you use docker for setting up environment and include all required extra setups like packages, database schema changes, code/dependencies initialization or service startup.


One of the things we definitely do want to see are unit/behavioural tests, so please do not forget those.


## Intro and background info

URL shortening is a technique on the World Wide Web in which a Uniform Resource Locator (URL) may be made substantially shorter and still direct to the required page.

This is achieved by using a redirect which links to the web page that has a long URL.

For example, the URL "http://example.com/about/index.html" can be shortened to "https://goo.gl/aO3Ssc". A friendly URL may be desired for messaging technologies that limit the number of characters in a message (for example SMS).

Other uses of URL shortening are to track clicks.

## Goal 1

Your first goal is to set up a URL shortner project that follows modern software development practices.

This project would provide a RESTful endpoint that accept initial URL and return shortened URL.

The project should be able to serve shortened URL and redirect to initial URL.


## Goal 2

Shortened URL should be expired after 30 days without any click.


## Bonus 1 (optional)

In some cases we need to redirect to the URL by dynamic params that is not known when creating shortened URL.
For such cases we want to send URL by some placeholders like <%token%> and those placeholders would be replace in redirection phase with the same param name.

As an example we call endpoint to create shortened url with the URL "http://example.com/about/index.html?uid=<%token%>" and the endpoint would return "https://goo.gl/aO3Ssc".

In case we open "https://goo.gl/aO3Ssc" it would be redirected to "http://example.com/about/index.html?uid=<%token%>".

In case we opne "https://goo.gl/aO3Ssc?token=94875" it would be redirected to "http://example.com/about/index.html?uid=94875".

## Bonus 2 (optional)

We want to track clicks on a shortened URL in a queryable fashion for analytics purpose.

For this purpose we need to sotre clicks and all request headers in a database. This process shouldn't affect the time that application take to serve shortened URL.

## FAQ

### Can I use 'X'? Can I rewrite 'Y'?

In general, yes. You are free to use any dependency and technology in Elixir.
