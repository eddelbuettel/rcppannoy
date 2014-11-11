
test01setup <- function() {
    suppressMessages(library(RcppAnnoy))
}

test02getNNsByVector <- function() {
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

test03getNNsByItem <- function() {
    f <- 3
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(2,1,0))
    a$addItem(1, c(1,2,0))
    a$addItem(2, c(0,0,1))
    a$build(10)

    checkEquals(a$getNNsByItem(0, 3), c(0,1,2), msg="getNNsByItem check1")
    checkEquals(a$getNNsByItem(1, 3), c(1,0,2), msg="getNNsByItem check2")
}

test04dist <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(0, 1))
    a$addItem(1, c(1, 1))

    checkEquals(a$getDistance(0, 1), 2 * (1.0 - 2^(-0.5)),
                msg="distance 1", tolerance=1e-6)
}

test05dist2 <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(1000, 0))
    a$addItem(1, c(10, 0))

    checkEquals(a$getDistance(0, 1), 0, msg="distance 2")
}

test06dist3 <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(97, 0))
    a$addItem(1, c(42, 42))

    d <- (1 - 2^(-0.5))^2 + (2^(-0.5)) ** 2

    checkEquals(a$getDistance(0, 1), d, msg="distance 3", tolerance=1.0e-6)
}

test07degen <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(1, 0))
    a$addItem(1, c(0, 0))

    checkEquals(a$getDistance(0, 1), 2.0, msg="distance 4", tolerance=1.0e-6)
}
