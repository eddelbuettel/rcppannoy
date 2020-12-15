#' Get the Annoy library version
#'
#' Get the version of the Annoy C++ library that RcppAnnoy was compiled with.
#'
#' @param compact Logical scalar indicating whether a compact
#'   \code{\link{package_version}} should be returned.
#'
#' @return An integer vector containing the major, minor and patch version numbers;
#' or if \code{compact=TRUE}, a \code{\link{package_version}} object.
#'
#' @author Aaron Lun
getAnnoyVersion <- function(compact=FALSE) {
    v <- .annoy_version()
    if (compact) as.package_version(paste(unname(v), collapse = "."))
    else v
}
