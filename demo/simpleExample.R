
## cf the simple example at https://github.com/spotify/annoy

library(RcppAnnoy)

set.seed(123)                           # be reproducible

f <- 40
a <- new(AnnoyEuclidean, f)
n <- 50                                 # not specified

for (i in seq(n)) {
    v <- rnorm(f)
    a$addItem(i-1, v)
}

a$build(50)                           	# 50 trees
a$save("/tmp/test.tree")


b <- new(AnnoyEuclidean, f)           	# new object, could be in another process
b$load("/tmp/test.tree")		# super fast, will just mmap the file

print(b$getNNsByItem(0, 40))
