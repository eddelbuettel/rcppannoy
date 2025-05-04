
## Suggested by @SamGG in https://github.com/eddelbuettel/rcppannoy/issues/79#issuecomment-2518597494

library(RcppAnnoy)

# IRIS EXAMPLE -----------------------------------------------------------------

data(iris)

# Converts to numeric, ignoring the species
X <- as.matrix(iris[,-5])

# BuildinG index
a <- new(AnnoyEuclidean, ncol(X))
a$setSeed(42)
# Load dataset into index; Annoy uses zero indexing
for (i in 1:nrow(X))
  a$addItem(i - 1, X[i,])
# Build forest with 20 trees
a$build(50)
# Reports about the forest
a$getNItems()
a$getNTrees()

# Performing search
k <- 5 # number of nearest neighbors
nn.index <- matrix(nrow = nrow(X), ncol = k)
for (i in 1:nrow(X))
  nn.index[i,] <- a$getNNsByVector(X[i,], k)
# Annoy uses zero indexing, so index must be incremented
nn.index = nn.index + 1
# The first match is the query itself most of the time
plot(1:nrow(X), nn.index[,1])
# Explore the second nearest neighbor
opar = par(mfrow = c(2, 2))
for (i in 1:ncol(X))
  plot(X[, i], X[nn.index[,2], i], xlab = colnames(X)[i], ylab = "nearest")
par(opar)

# Perform search with distance
k <- 5
nn.index <- matrix(nrow = nrow(X), ncol = k)
nn.distance <- matrix(nrow = nrow(X), ncol = k)
for (i in 1:nrow(X)) {
  res <- a$getNNsByVectorList(X[i,], k, -1, TRUE)
  nn.index[i,] <- res$item
  nn.distance[i,] <- res$distance
}
# Annoy uses zero indexing, so index must be incremented
nn.index = nn.index + 1
# Explore distance to the second nearest neighbor
hist(nn.distance[,2], xlab = "Distance to the 2nd NN",
     main = "Histogram of distance")

# Unload index from memory
a$unload()
rm(a)
