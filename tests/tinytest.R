if (requireNamespace("tinytest", quietly=TRUE)) {
    set.seed(42) 	# Set a seed to make the test deterministic
    tinytest::test_package("RcppAnnoy")
}
