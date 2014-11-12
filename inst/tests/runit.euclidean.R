
.setUp <- function() {
    suppressMessages(library(RcppAnnoy))
}

test01getNNsByVector <- function() {
    f <- 2
    a <- new(AnnoyEuclidean, f)

    a$addItem(0, c(2, 2))
    a$addItem(1, c(3, 2))
    
    a$build(10)
    
    checkEquals(a$getNNsByVector(c(3,3), 2),
                c(1,0),
                msg="getNNsByVector check")
}

test02dist <- function() {
    f <- 2
    a <- new(AnnoyEuclidean, f)
    a$addItem(0, c(0, 1))
    a$addItem(1, c(1, 1))

    checkEquals(a$getDistance(0, 1), 1.0, msg="distance 1")#
}

test03largeIndex <- function() {
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
    for (j in seq(0, 10000, by=2)) {
        checkEquals(a$getNNsByItem(j,   2), c(j,   j+1), msg="getNNsByItem check1")
        checkEquals(a$getNNsByItem(j+1, 2), c(j+1, j),   msg="getNNsByItem check1")
    }
}

test04precision <- function() {

    precision <- function(n, nTrees=10, nPoints=10000) {
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
        checkEquals(nns, nns[order(nns)], msg="checking precision order")  # should be in order
        ## The number of gaps should be equal to the last item minus n-1
        found <- length(nns[ nns < n])
        return( 1.0 * found / n)
    }

    checkEquals(precision(1),   1.0,  msg="precision at 1")
    checkEquals(precision(10),  1.0,  msg="precision at 10")
    checkTrue(precision(100) >= 0.99, msg="precision at 100")
    checkTrue(precision(1000) >= 0.99, msg="precision at 1000")

}
