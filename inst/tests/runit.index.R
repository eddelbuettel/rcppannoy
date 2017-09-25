
## if this is set (eg .travis.yml) then run the tesr
.runThisTest <- Sys.getenv("RunAllRcppAnnoyTests") == "yes"

if (.runThisTest) {

    .setup <- function() {
        suppressMessages(library(RcppAnnoy))
    }

    test01load <- function() {
        a <- new(AnnoyAngular, 10)
        a$load(system.file("tests", "data", "test.tree", package="RcppAnnoy"))

        ## This might change in the future if we change the search
        ## algorithm, but in that case let's update the test
        checkEquals(a$getNNsByItem(0, 10), c(0, 85, 42, 11, 54, 38, 53, 66, 19, 31),
                    msg="check loaded index")
    }

    test02badvalues <- function() {
        a <- new(AnnoyEuclidean, 10)
        v <- rnorm(10)
        checkException(a$addItem(-2, v), msg="check negative index", silent=TRUE)
        checkException(a$addItem(NA, v), msg="check NA index", silent=TRUE)
    }

    test03getItemsVectors <- function() {
        ## modeled after annoy_test.py() and its t
        i <- new(AnnoyAngular, 10)
        i$load(system.file("tests", "data", "test.tree", package="RcppAnnoy"))

        u <- i$getItemsVector(99)
        i$save(tempfile())

        v <- i$getItemsVector(99)
        checkEquals(u, v, msg="getItemVector comparison")

        j <- new(AnnoyAngular, 10)
        j$load(system.file("tests", "data", "test.tree", package="RcppAnnoy"))

        w <- i$getItemsVector(99)
        checkEquals(u, w, msg="getItemVector comparison")
    }


}
