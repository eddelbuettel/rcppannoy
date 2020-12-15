//                                               Emacs make this -*- mode: C++; -*-
// RcppAnnoy
//
// R bindings for the 'Annoy' Approximate Nearest Neighbor Library

#ifndef RCPPANNOY_H
#define RCPPANNOY_H

// -- include Rcpp headers
#define R_NO_REMAP
#define STRICT_R_HEADERS
#include <Rcpp.h>


// -- define a few things needed for Annoy
#if defined(__MINGW32__)
#undef Realloc
#undef Free
#endif

// define R's REprintf as the 'local' error print method for Annoy
#define __ERROR_PRINTER_OVERRIDE__  REprintf

#include "annoylib.h"
#include "kissrandom.h"


// -- some version housekeeping not provided by Annoy

#define ANNOY_VERSION_MAJOR 1
#define ANNOY_VERSION_MINOR 17
#define ANNOY_VERSION_PATCH 0

// create a single 'comparable' number out of version, minor and patch
#define Annoy_Version(v,m,p)   (((v) * 65536) + ((m) * 256) + (p))

// current build is encoded in ANNOY_VERSION
#define ANNOY_VERSION 	Annoy_Version(ANNOY_VERSION_MAJOR,ANNOY_VERSION_MINOR,ANNOY_VERSION_PATCH)


// -- same for RcppAnnoy

#define RCPPANNOY_VERSION_MAJOR 0
#define RCPPANNOY_VERSION_MINOR 0
#define RCPPANNOY_VERSION_PATCH 18
#define RCPPANNOY_VERSION_MICRO 0

#define RcppAnnoyVersion(maj, min, rev, dev)  	(((maj)*1000000) + ((min)*10000) + ((rev)*100) + (dev))
#define RCPPANNOY_VERSION			RcppAnnoyVersion(RCPPANNOY_VERSION_MAJOR,RCPPANNOY_VERSION_MINOR,RCPPANNOY_VERSION_PATCH,RCPP_ANNOY_VERSION_MICRO)


// -- convenience typedefs
//    prefixed with Rcpp to ensure we are most unlikely to clash with upstream defines
//    usage of these is entire optional

#ifdef ANNOYLIB_MULTITHREADED_BUILD
  typedef AnnoyIndexMultiThreadedBuildPolicy RcppAnnoyIndexThreadPolicy;
#else
  typedef AnnoyIndexSingleThreadedBuildPolicy RcppAnnoyIndexThreadPolicy;
#endif

#endif
