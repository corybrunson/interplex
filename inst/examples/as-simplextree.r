# convert a TDA filtration object
rf <- TDA::ripsFiltration(TDA::circleUnif(4L), maxdimension = 2L, maxscale = 1)
print(rf$cmplx)
st_rf <- as_simplextree(rf)
plot(st_rf)
st_rf2 <- as_simplextree(rf$cmplx)
plot(st_rf2)

# convert an igraph object
g <- igraph::graph(c(1,2, 2,3, 1,3, 3,4))
plot(g)
st_g <- as_simplextree(g)
plot(st_g)

# convert a network object
el <- data.frame(tails = c(1, 2, 1, 3), heads = c(2, 3, 3, 4))
n <- network::network.edgelist(el, network::network.initialize(4))
plot(n)
st_n <- as_simplextree(n)
plot(st_n)
