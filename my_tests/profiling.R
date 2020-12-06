{
  testthat::skip_on_cran()
  requireNamespace("profvis", quietly = TRUE)
  #Rcpp::sourceCpp("src/code.cpp")
  library(gghilbertstrings)
  library(profvis)

  size_exponent <- 10
  limit <- 4 ^ size_exponent

  print(paste("Running", limit, "cases."))
  profvis({
    values <- 1:limit
    ggh <- hilbertd2xy(n = limit, values)
  })

  profvis({
    for (i in 1:limit) {
      # d2xy(n = limit, d = i)
    }
  })


  # Compare with HilbertCurve Package if necessary
  if (FALSE) {
    library(HilbertCurve)
    profvis({
      hc <- HilbertCurve(0, limit, size_exponent)
    })
  }

}
