## RcppAnnoy [![Build Status](https://travis-ci.org/eddelbuettel/rcppannoy.png)](https://travis-ci.org/eddelbuettel/rcppannoy) [![License](https://eddelbuettel.github.io/badges/GPL2+.svg)](http://www.gnu.org/licenses/gpl-2.0.html) [![CRAN](http://www.r-pkg.org/badges/version/RcppAnnoy)](https://cran.r-project.org/package=RcppAnnoy) [![Downloads](http://cranlogs.r-pkg.org/badges/RcppAnnoy?color=brightgreen)](http://www.r-pkg.org/pkg/RcppAnnoy)

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
[the CRAN package](https://cran.r-project.org/package=RcppAnnoy) the usual
way from [R](https://www.r-project.org).

### Author

Dirk Eddelbuettel

### License

GPL (>= 2)


