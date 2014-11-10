#!/usr/bin/r

library(RcppAnnoy)

testGetNNsByVector <- function() {
    f <- 3
    a <- new(AnnoyAngular, f)

    a$addItem(0, c(1,0,0))
    a$addItem(1, c(0,1,0))
    a$addItem(2, c(0,0,1))
    
    a$build(10)
    
    print(a$getNNsByVector( c(3,2,1), 3 ))  # c(0,1,2) 
}

testGetNNsByVector()
