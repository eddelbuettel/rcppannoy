## rcppannoy

[![Build Status](https://travis-ci.org/eddelbuettel/rcppannoy.png)](https://travis-ci.org/eddelbuettel/rcppannoy)

Rcpp bindings for [Annoy](https://github.com/spotify/annoy)

### What is Annoy?

[Annoy](https://github.com/spotify/annoy) is a small, fast and lightweight
library for Approximate Nearest Neighbours with a particular focus on
efficient memory use and the ability to load a pre-saved index.

[Annoy](https://github.com/spotify/annoy) is written by Erik Bernhardsson.

### Why this package?

It provides a nice example for Rcpp Modules and use of templates: Annoy uses
a template data type (generally `float` for efficiency) and one of two
distance measures.  This package shows that it is easy to wrap both.

## Status

The package matches the behaviour of the original Python package in the
original Python wrapper for the [Annoy](https://github.com/spotify/annoy)
library. It also replicates all unit tests written for the Python frontend,
including a test for efficiently `mmap`-ing a binary index file.

## Author

Dirk Eddelbuettel



