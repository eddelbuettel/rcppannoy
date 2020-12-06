#include "RcppAnnoy.h"

//' Get the Annoy library version
//'
//' Get the version of the Annoy C++ library that RcppAnnoy was compiled with.
//'
//' @return An integer vector containing the major, minor, patch and development version numbers.
//'
//' @author Aaron Lun
//' @export
// [[Rcpp::export]]
Rcpp::IntegerVector version () {
    return Rcpp::IntegerVector::create(
        Rcpp::Named("major")=RCPPANNOY_VERSION_MAJOR,
        Rcpp::Named("minor")=RCPPANNOY_VERSION_MINOR,
        Rcpp::Named("patch")=RCPPANNOY_VERSION_PATCH,
        Rcpp::Named("devel")=RCPPANNOY_VERSION_MICRO
    );
}
