
.setUup <- function() {
    suppressMessages(library(RcppAnnoy))
}

test01getNNsByVector <- function() {
    f <- 3
    a <- new(AnnoyAngular, f)

    a$addItem(0, c(1,0,0))
    a$addItem(1, c(0,1,0))
    a$addItem(2, c(0,0,1))
    
    a$build(10)
    
    checkEquals(a$getNNsByVector(c(3,2,1), 3),
                c(0,1,2),
                msg="getNNsByVector check")
}

test02getNNsByItem <- function() {
    f <- 3
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(2,1,0))
    a$addItem(1, c(1,2,0))
    a$addItem(2, c(0,0,1))
    a$build(10)

    checkEquals(a$getNNsByItem(0, 3), c(0,1,2), msg="getNNsByItem check1")
    checkEquals(a$getNNsByItem(1, 3), c(1,0,2), msg="getNNsByItem check2")
}

test03dist <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(0, 1))
    a$addItem(1, c(1, 1))

    checkEquals(a$getDistance(0, 1), 2 * (1.0 - 2^(-0.5)),
                msg="distance 1", tolerance=1e-6)
}

test04dist2 <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(1000, 0))
    a$addItem(1, c(10, 0))

    checkEquals(a$getDistance(0, 1), 0, msg="distance 2")
}

test05dist3 <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(97, 0))
    a$addItem(1, c(42, 42))

    d <- (1 - 2^(-0.5))^2 + (2^(-0.5)) ** 2

    checkEquals(a$getDistance(0, 1), d, msg="distance 3", tolerance=1.0e-6)
}

test06degen <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(1, 0))
    a$addItem(1, c(0, 0))

    checkEquals(a$getDistance(0, 1), 2.0, msg="distance 4", tolerance=1.0e-6)
}

test07largeIndex <- function() {
    ## Generate pairs of random points where the pair is super close
    f <- 10
    a <- new(AnnoyAngular, f)
    set.seed(123)
    for (j in seq(0, 10000, by=2)) {
        p <- rnorm(f)
        f1 <- runif(1) + 1
        f2 <- runif(1) + 1
        x <- f1 * p + rnorm(f, 0, 1.0e-2)
        y <- f2 * p + rnorm(f, 0, 1.0e-2)
        a$addItem(j, x)
        a$addItem(j+1, y)
    }
    a$build(10)
    for (j in seq(0, 10000, by=2)) {
        checkEquals(a$getNNsByItem(j,   2), c(j,   j+1), msg="getNNsByItem check1")
        checkEquals(a$getNNsByItem(j+1, 2), c(j+1, j),   msg="getNNsByItem check1")
    }
}

