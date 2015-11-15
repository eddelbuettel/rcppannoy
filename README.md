## RcppAnnoy [![Build Status](https://travis-ci.org/eddelbuettel/rcppannoy.png)](https://travis-ci.org/eddelbuettel/rcppannoy) [![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![CRAN](http://www.r-pkg.org/badges/version/RcppAnnoy)](http://cran.rstudio.com/package=RcppAnnoy) [![Downloads](http://cranlogs.r-pkg.org/badges/RcppAnnoy?color=brightgreen)](http://cran.rstudio.com/package=RcppAnnoy)

Rcpp bindings for [Annoy](https://github.com/spotify/annoy)

### What is Annoy?

[Annoy](https://github.com/spotify/annoy) is a small, fast and lightweight
library for Approximate Nearest Neighbours with a particular focus on
efficient memory use and the ability to load a pre-saved index.

[Annoy](https://github.com/spotify/annoy) is written by 
[Erik Bernhardsson](http://erikbern.com).

### Why this package?

It provides a nice example for Rcpp Modules and use of templates: Annoy uses
a template data type (generally `float` for efficiency) and one of two
distance measures.  This package shows that it is easy to wrap both.

### Status

The package matches the behaviour of the original Python package in the
original Python wrapper for the [Annoy](https://github.com/spotify/annoy)
library. It also replicates all unit tests written for the Python frontend,
including a test for efficiently `mmap`-ing a binary index file.

The package originally built on Linux and OS X, and thanks to a patch by
[Qiang Kou](https://github.com/thirdwing) now also builds on Windows.

### Installation

You can either install from source via this repo, or install
[the CRAN package](http://cran.r-project.org/web/packages/RcppAnnoy/index.html)
the usual way from [R](http://www.r-project.org).

### Author

Dirk Eddelbuettel

### License

GPL (>= 2)


