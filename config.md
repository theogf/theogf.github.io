<!--
Add here global page variables to use throughout your website.
-->
+++
author = "Théo Galy-Fajou"
mintoclevel = 2

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Théo Galy-Fajou"
website_descr = "Personal academic website"
website_url   = "https://theogf.github.io"
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\R}{\mathbb R}
\newcommand{\scal}[1]{\langle #1 \rangle}
\newcommand{\package}[3]{
~~~

<div class="corner">
<h3><a class="franklin-content" href=#2>#1</a></h3>
#3
</div>
~~~
}