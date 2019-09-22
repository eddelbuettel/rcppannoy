
suppressMessages(library(RcppAnnoy))

f <- 2  # arbitrary
a <- new(AnnoyEuclidean, f)

diskfile <- tempfile(pattern="annoy", fileext="bin")
expect_true(a$onDiskBuild(diskfile))

a$addItem(0, c(2, 2))
a$addItem(1, c(3, 2))
a$addItem(2, c(3, 3))
a$build(10)

expect_equal(a$getNNsByVector(c(4,4), 3), c(2,1,0)) #, msg="getNNsByVector check 1")
expect_equal(a$getNNsByVector(c(1,1), 3), c(0,1,2)) #, msg="getNNsByVector check 2")
expect_equal(a$getNNsByVector(c(5,3), 3), c(2,1,0)) #, msg="getNNsByVector check 3")

a$unload()
a$load(diskfile)
expect_equal(a$getNNsByVector(c(4,4), 3), c(2,1,0)) #, msg="getNNsByVector check 1")
expect_equal(a$getNNsByVector(c(1,1), 3), c(0,1,2)) #, msg="getNNsByVector check 2")
expect_equal(a$getNNsByVector(c(5,3), 3), c(2,1,0)) #, msg="getNNsByVector check 3")

b <- new(AnnoyEuclidean, f)
b$load(diskfile)
expect_equal(b$getNNsByVector(c(4,4), 3), c(2,1,0)) #, msg="getNNsByVector check 1")
expect_equal(b$getNNsByVector(c(1,1), 3), c(0,1,2)) #, msg="getNNsByVector check 2")
expect_equal(b$getNNsByVector(c(5,3), 3), c(2,1,0)) #, msg="getNNsByVector check 3")
