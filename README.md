## RcppAnnoy: Rcpp bindings for [Annoy](https://github.com/spotify/annoy)

[![Build Status](https://travis-ci.org/eddelbuettel/rcppannoy.png)](https://travis-ci.org/eddelbuettel/rcppannoy)
[![CI](https://github.com/eddelbuettel/rcppannoy/workflows/ci/badge.svg)](https://github.com/eddelbuettel/rcppannoy/actions?query=workflow%3Aci)
[![License](https://eddelbuettel.github.io/badges/GPL2+.svg)](http://www.gnu.org/licenses/gpl-2.0.html)
[![CRAN](http://www.r-pkg.org/badges/version/RcppAnnoy)](https://cran.r-project.org/package=RcppAnnoy)
[![Dependencies](https://tinyverse.netlify.com/badge/RcppAnnoy)](https://cran.r-project.org/package=RcppAnnoy)
[![Downloads](http://cranlogs.r-pkg.org/badges/RcppAnnoy?color=brightgreen)](https://www.r-pkg.org:443/pkg/RcppAnnoy)
[![Last Commit](https://img.shields.io/github/last-commit/eddelbuettel/rcppannoy)](https://github.com/eddelbuettel/rcppannoy)

### What is Annoy?

[Annoy](https://github.com/spotify/annoy) is a small, fast and lightweight library for
Approximate Nearest Neighbours with a particular focus on efficient memory use and the
ability to load a pre-saved index.

[Annoy](https://github.com/spotify/annoy) is written by [Erik
Bernhardsson](https://erikbern.com/). See its page for more on features, its (Python) API,
and the other language ports. [Annoy](https://github.com/spotify/annoy) is part of the
esteemed _let us find other music you may like_ algorithm by
[Spotify](https://github.com/spotify/). 

### Why this package?

It provides a nice example for Rcpp Modules and use of templates: Annoy uses
a clean C++ core with templated data type, as well as several distance
measures.  This package shows that it is easy to wrap both aspects from R giving us
multi-lingual approaches to data discovery and machine learning.

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


