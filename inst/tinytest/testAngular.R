
suppressMessages(library(RcppAnnoy))

f <- 3
a <- new(AnnoyAngular, f)
a$addItem(0, c(0,0,1))
a$addItem(1, c(0,1,0))
a$addItem(2, c(1,0,0))
a$build(10)
checkEqual(a$getNNsByVector(c(3,2,1), 3), c(2,1,0), msg="getNNsByVector check 1")
checkEqual(a$getNNsByVector(c(1,2,3), 3), c(0,1,2), msg="getNNsByVector check 1")
checkEqual(a$getNNsByVector(c(2,0,1), 3), c(2,0,1), msg="getNNsByVector check 1")


f <- 3
a <- new(AnnoyAngular, f)
a$addItem(0, c(2,1,0))
a$addItem(1, c(1,2,0))
a$addItem(2, c(0,0,1))
a$build(10)
checkEqual(a$getNNsByItem(0, 3), c(0,1,2), msg="getNNsByItem check1")
checkEqual(a$getNNsByItem(1, 3), c(1,0,2), msg="getNNsByItem check2")


f <- 2
a <- new(AnnoyAngular, f)
a$addItem(0, c(0, 1))
a$addItem(1, c(1, 1))
checkEqual(a$getDistance(0, 1), (2.0 * (1.0 - 2^(-0.5)))^0.5, msg="distance 1", tolerance=1e-6)


f <- 2
a <- new(AnnoyAngular, f)
a$addItem(0, c(1000, 0))
a$addItem(1, c(10, 0))
checkEqual(a$getDistance(0, 1), 0, msg="distance 2")


f <- 2
a <- new(AnnoyAngular, f)
a$addItem(0, c(97, 0))
a$addItem(1, c(42, 42))
d <- ((1 - 2^(-0.5))^2 + (2^(-0.5))^2)^0.5
checkEqual(a$getDistance(0, 1), d, msg="distance 3", tolerance=1.0e-6)


f <- 2
a <- new(AnnoyAngular, f)
a$addItem(0, c(1, 0))
a$addItem(1, c(0, 0))

checkEqual(a$getDistance(0, 1), 2.0^0.5, msg="distance 4", tolerance=1.0e-6)


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
res <- TRUE
for (j in seq(0, 10000, by=2)) {
    #expect_equal(a$getNNsByItem(j,   2), c(j,   j+1), msg="getNNsByItem check1")
    #expect_equal(a$getNNsByItem(j+1, 2), c(j+1, j),   msg="getNNsByItem check1")
    res <- res &&
        all.equal(a$getNNsByItem(j,   2), c(j,   j+1)) &&
        all.equal(a$getNNsByItem(j+1, 2), c(j+1, j))
}
checkTrue(res)
