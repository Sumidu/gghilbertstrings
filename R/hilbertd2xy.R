Rcpp::sourceCpp("src/code.cpp")
#' Hilbert conversion, distance to coordinates
#'
#' @param n Size (must be a 2^k value, such as 4,8,16,32)
#' @param d the value to convert to coordinates
#'
#' @return vector of x and y
#' @export
#'
#' @examples
#' hilbertd2xy(64,31)
hilbertd2xy <- function(n,d){

  vd2xy <- Vectorize(FUN = d2xy, vectorize.args = c("d"))

  res <- as_tibble(t(vd2xy(n,d)), .name_repair = "minimal")
  names(res) <- c("x", "y")
  res
}



