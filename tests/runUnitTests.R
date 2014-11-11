
## runUnitTests.R --- Run RUnit tests
##
## with credits to package fUtilities in RMetrics
## which credits Gregor Gojanc's example in CRAN package  'gdata'
## as per the R Wiki http://wiki.r-project.org/rwiki/doku.php?id=developers:runit
## and changed further by Martin Maechler
## and more changes by Murray Stokely in HistogramTools
##
## Dirk Eddelbuettel, Nov 2014

stopifnot(require(RUnit, quietly=TRUE))
stopifnot(require(RcppAnnoy, quietly=TRUE))

## Set a seed to make the test deterministic
set.seed(42)

## Define tests
testSuite <- defineTestSuite(name="RcppAnnoy Unit Tests",
                             dirs=system.file("tests", package="RcppAnnoy"),
                             testFuncRegexp = "^[Tt]est+")

## This package does not require external resources (cf package RcppRedis)
## so the default is to run the tests
runTests <- TRUE

## Tests for test run
if (runTests) {
    ## Run tests
    tests <- runTestSuite(testSuite)

    ## Print results
    printTextProtocol(tests)

    ## Return success or failure to R CMD CHECK
    if (getErrors(tests)$nFail > 0) {
        stop("TEST FAILED!")
    }
    if (getErrors(tests)$nErr > 0) {
        stop("TEST HAD ERRORS!")
    }
    if (getErrors(tests)$nTestFunc < 1) {
        stop("NO TEST FUNCTIONS RUN!")
    }
}
