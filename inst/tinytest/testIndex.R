
## if this is set (eg .travis.yml) then run the test
if (Sys.getenv("RunAllRcppAnnoyTests") != "yes") exit_file("Skip this test")

suppressMessages(library(RcppAnnoy))

a <- new(AnnoyAngular, 10)
a$load(system.file("tinytest", "data", "test.tree", package="RcppAnnoy"))

## This might change in the future if we change the search
## algorithm, but in that case let's update the test
checkEqual(a$getNNsByItem(0, 10), c(0, 85, 42, 11, 54, 38, 53, 66, 19, 31),
           msg="check loaded index")

a <- new(AnnoyEuclidean, 10)
v <- rnorm(10)
expect_error(a$addItem(-2, v))#, msg="check negative index", silent=TRUE)
expect_error(a$addItem(NA, v))#, msg="check NA index", silent=TRUE)

## modeled after annoy_test.py() and its t
i <- new(AnnoyAngular, 10)
i$load(system.file("tinytest", "data", "test.tree", package="RcppAnnoy"))

u <- i$getItemsVector(99)
i$save(tempfile())

v <- i$getItemsVector(99)
checkEqual(u, v, msg="getItemVector comparison")

j <- new(AnnoyAngular, 10)
j$load(system.file("tinytest", "data", "test.tree", package="RcppAnnoy"))

w <- i$getItemsVector(99)
checkEqual(u, w, msg="getItemVector comparison")
