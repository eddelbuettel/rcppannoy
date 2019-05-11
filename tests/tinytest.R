
if (requireNamespace("tinytest", quietly=TRUE)) {

    ## Set a seed to make the test deterministic
    set.seed(42)

    ## there are several more granular ways to test files in a
    ## tinytest directory, see its package vignette; tests can also
    ## run once the package is installed using the same command
    tinytest::test_package("RcppAnnoy")

}
