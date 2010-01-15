                               nisp.emacs
                               ==========



This is a combination of my .emacs and useful libraries intended for
others. Right now there really is no clear distinction and there won't
be for a few days. I hope to release v0.1 in a few days.

I have rougly 3,000 lines of emacs lisp that is right now very
unorganized but some of it implements new functionality others might
like to try. Those libraries will aspire to meet most GNU emacs coding
conventions and will be listed below at the release of v0.1. However
please note that internal variables (defvar, not (defcustom, tend to be
annotated in the common lisp style. eg `*foo*' instead of `foo'. As
these are internal variables and are not intended to be user visible I
have no qualms with breaking this particular style convention. The vast
majority of the others I know about however are followed.

Finally please note that anything under github-forks is a fork of an
existing project that I forked for the intent of using git submodules
and carrying on my own development and integration of patches/forks from
other github forks.

Please send bug reports to i@nixeagle.org labeled clearly as such.

Table of Contents
=================
1 Versioning 
2 Libraries 
    2.1 nisp-paste 


1 Versioning 
~~~~~~~~~~~~~
  For all packages created by myself in this repository versioning is
  done according to [http://semver.org/]. I greatly appreciate this style
  and I was largely adhearing to this idea before I read the page.

  In short any package with a version less then 1.0.0 is beta
  software. Version 1.0.0 represents the first stable _public api_. In
  emacs terms this means customize options won't get renamed, function
  names, required arguments and results are all the same.

  An increment of the second number (0.X.0) means a new feature or
  incompatable api change. An increment of the second number after the
  1.0.0 release means a new feature, backwards compatable change.

  An increment to the last number means a patch or other minior bugfix.

  The idea here is after 1.0.0 I commit to keeping the public api the
  same. If I must change it after this point, it will be a new major
  version... eg 2.0.0.

2 Libraries 
~~~~~~~~~~~~

2.1 nisp-paste 
===============
    - [file:nisp-paste.el]

    Simple pasting to your own web server. Pastes are html and css
    only. No ads, no dependency on some external pasetbin site for
    formatting or highlight. Any buffer in emacs can be pasted [1]

    This has a dependency on [file:nisp-erc.el] which is written by me and
    [file:3rd-party/htmlize.el] which is not. If you have htmlize
    installed by other means, then do not include the 3rd-party path in
    your `load-path'.



[1] Within reason, this pastes _text_.

