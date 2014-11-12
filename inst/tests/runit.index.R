
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

}
