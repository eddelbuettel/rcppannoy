
suppressMessages(library(RcppAnnoy))

# test01getNNsByVector
f <- 2
a <- new(AnnoyHamming, f)
a$addItem(0, c(2, 2))
a$addItem(1, c(3, 2))
a$addItem(2, c(3, 3))
a$build(10)
checkEqual(a$getNNsByVector(c(4,4), 3), c(0,1,2), msg="getNNsByVector check 1")
checkEqual(a$getNNsByVector(c(1,1), 3), c(2,1,0), msg="getNNsByVector check 2")
checkEqual(a$getNNsByVector(c(5,3), 3), c(2,1,0), msg="getNNsByVector check 3")


# test02getNNsByItem
f <- 2
a <- new(AnnoyHamming, f)
a$addItem(0, c(2, 2))
a$addItem(1, c(3, 2))
a$addItem(2, c(3, 3))
a$build(10)
checkEqual(a$getNNsByItem(0, 3), c(0, 1, 2), msg="getNNsByItem check 1")
checkEqual(a$getNNsByItem(2, 3), c(2, 1, 0), msg="getNNsByItem check 2")


# test03dist
f <- 2
a <- new(AnnoyHamming, f)
a$addItem(0, c(0, 1))
a$addItem(1, c(1, 1))
a$addItem(2, c(0, 0))
checkEqual(a$getDistance(0, 1), 1.0, msg="distance 1")#
checkEqual(a$getDistance(1, 2), 2.0, msg="distance 2")#


## test04largeIndex <- function() {
##     ## Generate pairs of random points where the pair is super close
##     f <- 10
##     #q <- rnorm(f, 0, 10)
##     a <- new(AnnoyHamming, f)
##     set.seed(123)
##     for (j in seq(0, 10000, by=2)) {
##         p <- rnorm(f)
##         x <- 1 + p + rnorm(f, 0, 1.0e-2)
##         y <- 1 + p + rnorm(f, 0, 1.0e-2)
##         a$addItem(j, x)
##         a$addItem(j+1, y)
##     }
##     a$build(10)
##     for (j in seq(0, 10000, by=2)) {
##         checkEquals(a$getNNsByItem(j,   2), c(j,   j+1), msg="getNNsByItem check 1")
##         checkEquals(a$getNNsByItem(j+1, 2), c(j+1, j),   msg="getNNsByItem check 2")
##     }
## }

## test05precision <- function() {

##     precision <- function(n, nTrees=10, nPoints=10000, nRounds=3) {
##         found <- 0
##         for (r in 1:nRounds) {
##             ## create random points at distance x
##             f <- 10
##             a <- new(AnnoyHamming, f)

##             for (j in seq(nPoints)) {
##                 p <- rnorm(f, 0, 1)
##                 nrm <- sqrt(sum(p^2))
##                 x <- p / nrm + j
##                 a$addItem(j, x)
##             }
##             a$build(nTrees)

##             nns <- a$getNNsByVector(rep(0, f), n)
##             checkEquals(nns, nns[order(nns)], msg="checking precision order")  # should be in order
##             ## The number of gaps should be equal to the last item minus n-1
##             found <- found + length(nns[nns <= n])
##         }
##         return(1.0 * found / (n * nRounds))
##     }

##     checkTrue(precision(1)    >= 0.98, msg="precision at 1")
##     checkTrue(precision(10)   >= 0.98, msg="precision at 10")
##     checkTrue(precision(100)  >= 0.98, msg="precision at 100")
##     checkTrue(precision(1000) >= 0.98, msg="precision at 1000")

## }
