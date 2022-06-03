#' @title Convert objects to class 'network'
#' 
#' @description This generic function...
#' 
#' @param x An R object to be coerced. See Details.
#' @param ... Additional arguments passed to methods.
#' @return An object of class 'network'.
#' @example inst/examples/as-network.r
#' @export
as_network <- function(x, ...) UseMethod("as_network")

#' @rdname as_network
#' @export
as_network.default <- function(x, ...) {
  x <- ensure_cmplx(x)
  x <- ensure_list(x)
  
  # store vertex IDs
  x_vid <- sort(unique(unlist(x)))
  # reindexed vertex data
  x_vl <- seq(length(x_vid))
  # reindexed edge data
  x_el <- t(sapply(x[sapply(x, length) == 2L], identity))
  x_el[] <- match(x_el, x_vid)
  # create network from vertex and edge data
  res <- network::network(
    x = x_el,
    directed = FALSE,
    hyper = FALSE,
    loops = FALSE,
    multiple = FALSE,
    bipartite = FALSE,
    vertices = data.frame(
      vertex.names = x_vl,
      is_actor = TRUE
    )
  )
  # add vertex IDs as an attribute
  network::set.vertex.attribute(res, "index", x_vid)
}

#' @rdname as_network
#' @export
as_network.Rcpp_SimplexTree <- function(x, ...) {
  
  # create network from vertex and edge data
  res <- network::network(
    x = cbind(
      match(x$edges[, 1L], x$vertices),
      match(x$edges[, 2L], x$vertices)
    ),
    directed = FALSE,
    hyper = FALSE,
    loops = FALSE,
    multiple = FALSE,
    bipartite = FALSE,
    vertices = data.frame(
      vertex.names = seq_along(x$vertices),
      is_actor = TRUE,
      index = as.integer(x$vertices)
    )
  )
  # add isolates
  network::add.vertices(
    res,
    nv = length(x$vertices) - length(res$val),
    vattr = list(list(index = setdiff(x$vertices, unique(as.vector(x$edges)))))
  )
  # return network
  res
}

#' @rdname as_network
#' @export
as_network.simplextree <- function(x, ...) {
  as_network.Rcpp_SimplexTree(x, ...)
}

#' @rdname as_network
#' @export
as_network.igraph <- function(x, ...) {
  # defer to intergraph
  intergraph::asNetwork(x, ...)
}

#' @rdname as_network
#' @export
as_network.network <- function(x, ...) x
