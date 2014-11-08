
## cf the simple example at https://github.com/spotify/annoy

library(RcppAnnoy)

set.seed(123)                           # be reproducible

f <- 40
a <- new(Annoy, f)

n <- 150                                # not specified

for (i in seq(n)) {
    v <- rnorm(f)
    a$addItem(i-1, v)
}

a$build(n)                           	# 50 trees
a$save("/tmp/test.tree")


b <- new(Annoy, f)               	# new object, could be in another process
b$load("/tmp/test.tree")		# super fast, will just mmap the file

print(b$getNNsByItem(0, 1000))
