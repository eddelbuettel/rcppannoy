
## if this is set (eg .travis.yml) then run the test
if (Sys.getenv("RunAllRcppAnnoyTests") != "yes") exit_file("Skip this test")

suppressMessages(library(RcppAnnoy))

f <- 2

set.seed(123456)   # R Seed for next two vectors
n <- 100
x <- rnorm(n)
y <- rnorm(n)

v1 <- new(AnnoyHamming, f)
v1$setSeed(123)
for (i in 1:n) v1$addItem(i-1, c(x[i], y[i]))
v1$build(f)

v2 <- new(AnnoyHamming, f)
v2$setSeed(456)  # different
for (i in 1:n) v2$addItem(i-1, c(x[i], y[i]))
v2$build(f)

v3 <- new(AnnoyHamming, f)
v3$setSeed(123)  # as first
for (i in 1:n) v3$addItem(i-1, c(x[i], y[i]))
v3$build(f)

checkEqual(v1$getNNsByVector(c(0.5,0.5), 20),
           v3$getNNsByVector(c(0.5,0.5), 20)) # msg="v1 and v3 are equal")
checkTrue(any(v1$getNNsByVector(c(0.5,0.5), 20) !=
              v2$getNNsByVector(c(0.5,0.5), 20))) # msg="v1 and v2 are not equal")
