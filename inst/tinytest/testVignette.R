
## See #66 for the idea and discussion

vigfile <- system.file("rmd", "UsingAnnoyInCpp.Rmd", package="RcppAnnoy")
if (!file.exists(vigfile)) exit_file("No vignette source found. What's up with that?")

lines <- readLines(vigfile)
starts <- which(lines == "```{Rcpp, eval=FALSE}")
ends <- which(lines=="```")
ends <- ends[findInterval(starts, ends)+1]
code <- lines[unlist(mapply(seq, starts+1, ends-1))]
res <- Rcpp::sourceCpp(code=paste(code, collapse="\n")) # checks everything is compileable.

expect_equal(res$functions, "thingy")   # check we got a function compiled

set.seed(42)
mat <- matrix(runif(1000), 100)
Q <- matrix(runif(100), 10)
res <- thingy(mat, 1, 10, Q, tempfile())
expect_equal(res, 1)

