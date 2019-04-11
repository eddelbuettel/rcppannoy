
## if this is set (eg .travis.yml) then run the tesr
.runThisTest <- Sys.getenv("RunAllRcppAnnoyTests") == "yes"

if (.runThisTest) {

    .setup <- function() {
        suppressMessages(library(RcppAnnoy))
    }

    test01seeds <- function() {
        f <- 2

        a <- new(AnnoyHamming, f)
        a$setSeed(123)
        a$addItem(0, c(0, 1))
        a$addItem(1, c(1, 1))
        a$addItem(2, c(0, 0))

        b <- new(AnnoyHamming, f)
        b$setSeed(456)
        b$addItem(0, c(0, 1))
        b$addItem(1, c(1, 1))
        b$addItem(2, c(0, 0))

        c <- new(AnnoyHamming, f)
        c$setSeed(456)
        c$addItem(0, c(0, 1))
        c$addItem(1, c(1, 1))
        c$addItem(2, c(0, 0))

        checkEquals(a$getDistance(0, 1), c$getDistance(0, 1), msg="a and c are equal")
        checkTrue(a$getDistance(0, 1) != b$getDistance(0, 1), msg="a abd b not equal")
    }
}
