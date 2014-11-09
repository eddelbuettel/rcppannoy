
library(RcppAnnoy)

set.seed(123)                           # be reproducible

testGetNNsByVector <- function() {
    f <- 3
    a <- new(AnnoyAngular, f)

    a$addItem(0, c(1,0,0))
    a$addItem(1, c(0,1,0))
    a$addItem(2, c(0,0,1))
    
    a$build(10)
    
    print(a$getNNsByVector( c(3,2,1), 3 ))  # c(0,1,2) 
}

testGetNNsByItem <- function() {
    f <- 3
    a <- new(AnnoyAngular, f)

    a$addItem(0, c(2,1,0))
    a$addItem(1, c(1,2,0))
    a$addItem(2, c(0,0,1))
    
    a$build(10)
    
    print(a$getNNsByItem( 0, 4 ))  # c(0,1,2) 
    print(a$getNNsByItem( 1, 4 ))  # c(1,0,2) 
}

testDist <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(0,1))
    a$addItem(1, c(1,1))
    
    print(a$getDistance(0,1))
}

testDist2 <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(1000,1))
    a$addItem(1, c(10,1))
    
    print(a$getDistance(0,1))
}

testDist3 <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(97,0))
    a$addItem(1, c(42,42))
    
    print(a$getDistance(0,1))
    print( (1 - 2^(-0.5))^2 + (2^(-0.5))^2)
}

testDistDegen <- function() {
    f <- 2
    a <- new(AnnoyAngular, f)
    a$addItem(0, c(1,0))
    a$addItem(1, c(0,0))
    
    print(a$getDistance(0,1))
}



testGetNNsByVector()
testGetNNsByItem()
testDist()
testDist2()
testDist3()
testDistDegen()
