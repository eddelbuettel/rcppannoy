#include "RcppAnnoy.h"

// [[Rcpp::export(.annoy_version)]]
Rcpp::IntegerVector annoy_version() {
    return Rcpp::IntegerVector::create(Rcpp::Named("major")=RCPPANNOY_VERSION_MAJOR,
                                       Rcpp::Named("minor")=RCPPANNOY_VERSION_MINOR,
                                       Rcpp::Named("patch")=RCPPANNOY_VERSION_PATCH);
}
