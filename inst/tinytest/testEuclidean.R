
suppressMessages(library(RcppAnnoy))

## getNNsByVector
f <- 2
a <- new(AnnoyEuclidean, f)
a$addItem(0, c(2, 2))
a$addItem(1, c(3, 2))
a$addItem(2, c(3, 3))
a$build(10)
checkEqual(a$getNNsByVector(c(4,4), 3), c(2,1,0), msg="getNNsByVector check 1")
checkEqual(a$getNNsByVector(c(1,1), 3), c(0,1,2), msg="getNNsByVector check 1")
checkEqual(a$getNNsByVector(c(4,2), 3), c(1,2,0), msg="getNNsByVector check 1")


## getNNsByItem
f <- 2
a <- new(AnnoyEuclidean, f)
a$addItem(0, c(2, 2))
a$addItem(1, c(3, 2))
a$addItem(2, c(3, 3))
a$build(10)
checkEqual(a$getNNsByItem(0, 3), c(0, 1, 2), msg="getNNsByItem check 1")
checkEqual(a$getNNsByItem(2, 3), c(2, 1, 0), msg="getNNsByItem check 2")


### test03dist
f <- 2
a <- new(AnnoyEuclidean, f)
a$addItem(0, c(0, 1))
a$addItem(1, c(1, 1))
a$addItem(2, c(0, 0))
checkEqual(a$getDistance(0, 1), 1.0^0.5, msg="distance 1")
checkEqual(a$getDistance(1, 2), 2.0^0.5, msg="distance 2", tolerance=1e-6)



## test04largeIndex
## Generate pairs of random points where the pair is super close
f <- 10
#q <- rnorm(f, 0, 10)
a <- new(AnnoyEuclidean, f)
set.seed(123)
for (j in seq(0, 10000, by=2)) {
    p <- rnorm(f)
    x <- 1 + p + rnorm(f, 0, 1.0e-2)
    y <- 1 + p + rnorm(f, 0, 1.0e-2)
    a$addItem(j, x)
    a$addItem(j+1, y)
}
a$build(10)
res <- TRUE
for (j in seq(0, 10000, by=2)) {
    #expect_equal(a$getNNsByItem(j,   2), c(j,   j+1), msg="getNNsByItem check1")
    #expect_equal(a$getNNsByItem(j+1, 2), c(j+1, j),   msg="getNNsByItem check1")
    res <- res &&
        all.equal(a$getNNsByItem(j,   2), c(j,   j+1)) &&
        all.equal(a$getNNsByItem(j+1, 2), c(j+1, j))
}
expect_true(res)



## test05precision
precision <- function(n, nTrees=10, nPoints=10000, nRounds=3) {
    found <- 0
    for (r in 1:nRounds) {
        ## create random points at distance x
        f <- 10
        a <- new(AnnoyEuclidean, f)

        for (j in seq(nPoints)) {
            p <- rnorm(f, 0, 1)
            nrm <- sqrt(sum(p^2))
            x <- p / nrm * j
            a$addItem(j, x)
        }
        a$build(nTrees)

        nns <- a$getNNsByVector(rep(0, f), n)
        checkEqual(nns, nns[order(nns)], msg="checking precision order")  # should be in order
        ## The number of gaps should be equal to the last item minus n-1
        found <- found + length(nns[ nns <= n])
    }
    return(1.0 * found / (n * nRounds))
}

checkTrue(precision(1)    >= 0.98)#, msg="precision at 1")
checkTrue(precision(10)   >= 0.98)#, msg="precision at 10")
checkTrue(precision(100)  >= 0.98)#, msg="precision at 100")
checkTrue(precision(1000) >= 0.98)#, msg="precision at 1000")
