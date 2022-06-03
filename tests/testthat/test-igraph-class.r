context("'igraph' objects")

data(karate, package = "igraphdata")
ig_kt <- karate
ig_kt_el <- igraph::as_edgelist(ig_kt, names = FALSE)

test_that("'igraph'-to-'network' conversion preserves vertices", {
  nw_kt <- as_network(ig_kt)
  expect_equal(igraph::gorder(ig_kt), network::network.size(nw_kt))
  expect_true(all(ig_kt_el == network::as.edgelist(nw_kt)))
})

test_that("'igraph'-to-'simplextree' conversion preserves 0,1-simplices", {
  st_kt <- as_simplextree(ig_kt)
  expect_equal(igraph::gorder(ig_kt), st_kt$n_simplices[[1L]])
  expect_true(all(ig_kt_el == st_kt$edges))
})

test_that("'igraph'-to-list conversion preserves 0,1-simplices", {
  cp_kt <- as_cmplx(ig_kt)
  expect_equal(igraph::gorder(ig_kt), length(unique(unlist(cp_kt))))
  expect_true(all(
    ig_kt_el ==
      t(sapply(cp_kt[as.logical(sapply(cp_kt, length) - 1)], identity))
  ))
})

v_id <- 1L + sample(igraph::gorder(ig_kt))
ig_kt <- igraph::set_vertex_attr(ig_kt, "id", value = v_id)
stopifnot("id" %in% igraph::vertex_attr_names(ig_kt))

test_that("'igraph'-to-'network' conversion preserves attributes", {
  nw_kt <- as_network(ig_kt)
  expect_true("id" %in% network::list.vertex.attributes(nw_kt))
})

test_that("'igraph'-to-'simplextree' conversion uses indices", {
  st_kt <- as_simplextree(ig_kt, index = "id")
  ig_id <- igraph::vertex_attr(ig_kt, "id")
  expect_equal(sort(ig_id), st_kt$vertices)
  # reindex and sort edges by index
  el <- sort_el(cbind(ig_id[ig_kt_el[, 1L]], ig_id[ig_kt_el[, 2L]]))
  expect_true(all(el == st_kt$edges))
})