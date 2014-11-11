
test01setup <- function() {
    suppressMessages(library(RcppAnnoy))
}

test02getNNsByVector <- function() {
    f <- 2
    a <- new(AnnoyEuclidean, f)

    a$addItem(0, c(2, 2))
    a$addItem(1, c(3, 2))
    
    a$build(10)
    
    checkEquals(a$getNNsByVector(c(3,3), 2),
                c(1,0),
                msg="getNNsByVector check")
}

test03dist <- function() {
    f <- 2
    a <- new(AnnoyEuclidean, f)
    a$addItem(0, c(0, 1))
    a$addItem(1, c(1, 1))

    checkEquals(a$getDistance(0, 1), 1.0, msg="distance 1")#
}
