#' @name AnnoyIndex
#'
#' @aliases
#' AnnoyEuclidean Rcpp_AnnoyEuclidean-class Rcpp_AnnoyEuclidean
#' AnnoyAngular   Rcpp_AnnoyAngular-class   Rcpp_AnnoyAngular
#' AnnoyManhattan Rcpp_AnnoyManhattan-class Rcpp_AnnoyManhattan
#' AnnoyHamming   Rcpp_AnnoyHamming-class   Rcpp_AnnoyHamming
#'
#' @title Approximate Nearest Neighbors with Annoy
#'
#' @description
#' Annoy is a small library written to provide fast and memory-efficient
#' nearest neighbor lookup from a possibly static index which can be
#' shared across processes.
#'
#' @section Usage:
#' \preformatted{
#' a <- new(AnnoyEuclidean, vectorsz)
#'
#' a$setSeed(0)
#' a$setVerbose(0)
#'
#' a$addItem(i, dv)
#'
#' a$getNItems()
#'
#' a$getItemsVector(i)
#' a$getDistance(i, j)
#'
#' a$build(n_trees)
#'
#' a$getNNsByItem(i, n)
#' a$getNNsByItemList(i, n, search_k, include_distances)
#'
#' a$getNNsByVector(v, n)
#' a$getNNsByVectorList(v, n, search_k, include_distances)
#'
#' a$save(fn)
#' a$load(fn)
#' a$unload()
#' }
#'
#' @section Details:
#'
#' \code{new(Class, vectorsz)}
#' Create a new Annoy instance of type \code{Class} where \code{Class}
#' is on of the following:
#' \code{AnnoyEuclidean},
#' \code{AnnoyAngular},
#' \code{AnnoyManhattan},
#' \code{AnnoyHamming}.
#' \code{vectorsz} denotes the length of the vectors that the Annoy instance
#' will be indexing.
#'
#' \code{$addItem(i, v)}
#' Adds item \code{i} (any nonnegative integer) with vector \code{v}.
#' Note that it will allocate memory for \code{max(i) + 1} items.
#'
#' \code{$build(n_trees)}
#' Builds a forest of \code{n_trees} trees.
#' More trees gives higher precision when querying.
#' After calling \code{build}, no more items can be added.
#'
#' \code{$save(fn)}
#' Saves the index to disk as filename \code{fn}.
#' After saving, no more items can be added.
#'
#' \code{$load(fn)}
#' Loads (mmaps) an index from filename \code{fn} on disk.
#'
#' \code{$unload()}
#' Unloads index.
#'
#' \code{$getDistance(i, j)}
#' Returns the distance between items \code{i} and \code{j}
#'
#' \code{$getNNsByItem(i, n)}
#' Returns the \code{n} closest items as an integer vector of indices.
#'
#' \code{$getNNsByVector(v, n)}
#' Same as \code{$getNNsByItem}, but queries by vector \code{v} rather than
#' index \code{i}.
#'
#' \code{$getNNsByItemList(i, n, search_k = -1, include_distances = FALSE)}
#' Returns the n closest items to item \code{i} as a list.
#' During the query it will inspect up to \code{search_k} nodes which
#' defaults to \code{n_trees * n} if not provided.
#' \code{search_k} gives you a run-time tradeoff between better accuracy and
#' speed.
#' If you set \code{include_distances} to \code{TRUE},
#' it will return a length 2 list with elements \code{"item"} &
#' \code{"distance"}.
#' The \code{"item"} element contains the \code{n} closest items as an integer
#' vector of indices.
#' The optional \code{"distance"} element contains the corresponding distances
#' to \code{"item"} as a numeric vector.
#'
#' \code{$getNNsByVectorList(i, n, search_k = -1, include_distances = FALSE)}
#' Same as \code{$getNNsByItemList}, but queries by vector \code{v} rather than
#' index \code{i}
#'
#' \code{$getItemsVector(i)}
#' Returns the vector for item \code{i} that was previously added.
#'
#' \code{$getNItems()}
#' Returns the number of items in the index.
#'
#' \code{$setVerbose()}
#' If \code{1} then messages will be printed during processing.
#' If \code{0} then messages will be suppressed during processing.
#'
#' \code{$setSeed()}
#' Set random seed for annoy (integer).
#'
#' @examples
#' library(RcppAnnoy)
#'
#' # BUILDING ANNOY INDEX ---------------------------------------------------------
#' vector_size <- 10
#' a <- new(AnnoyEuclidean, vector_size)
#'
#' a$setSeed(42)
#'
#' # Turn on verbose status messages (0 to turn off)
#' a$setVerbose(1)
#'
#' # Load 100 random vectors into index
#' for (i in 1:100) a$addItem(i - 1, runif(vector_size)) # Annoy uses zero indexing
#'
#' # Display number of items in index
#' a$getNItems()
#'
#' # Retrieve item at postition 0 in index
#' a$getItemsVector(0)
#'
#' # Calculate distance between items at postitions 0 & 1 in index
#' a$getDistance(0, 1)
#'
#' # Build forest with 50 trees
#' a$build(50)
#'
#'
#' # PERFORMING ANNOY SEARCH ------------------------------------------------------
#'
#' # Retrieve 5 nearest neighbors to item 0
#' # Returned as integer vector of indices
#' a$getNNsByItem(0, 5)
#'
#' # Retrieve 5 nearest neighbors to item 0
#' # search_k = -1 will invoke default search_k value of n_trees * n
#' # Return results as list with an element for distance
#' a$getNNsByItemList(0, 5, -1, TRUE)
#'
#' # Retrieve 5 nearest neighbors to item 0
#' # search_k = -1 will invoke default search_k value of n_trees * n
#' # Return results as list without an element for distance
#' a$getNNsByItemList(0, 5, -1, FALSE)
#'
#'
#' v <- runif(vector_size)
#' # Retrieve 5 nearest neighbors to vector v
#' # Returned as integer vector of indices
#' a$getNNsByVector(v, 5)
#'
#' # Retrieve 5 nearest neighbors to vector v
#' # search_k = -1 will invoke default search_k value of n_trees * n
#' # Return results as list with an element for distance
#' a$getNNsByVectorList(v, 5, -1, TRUE)
#'
#' # Retrieve 5 nearest neighbors to vector v
#' # search_k = -1 will invoke default search_k value of n_trees * n
#' # Return results as list with an element for distance
#' a$getNNsByVectorList(v, 5, -1, TRUE)
#'
#'
#' # SAVING/LOADING ANNOY INDEX ---------------------------------------------------
#'
#' # Create a tempfile, replace with a local file to keep
#' treefile <- tempfile(pattern="annoy", fileext="tree")
#'
#' # Save annoy tree to disk
#' a$save(treefile)
#'
#' # Load annoy tree from disk
#' a$load(treefile)
#'
#' # Unload index from memory
#' a$unload()
NULL

## ensure module gets loaded
loadModule("AnnoyAngular", TRUE)
loadModule("AnnoyEuclidean", TRUE)
loadModule("AnnoyManhattan", TRUE)
loadModule("AnnoyHamming", TRUE)
