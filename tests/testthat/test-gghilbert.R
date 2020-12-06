test_that("Testing works", {
  library(tibble)
  d1 <- tibble(val = 1:128,
               size = runif(128, 1, 5),        # create random sizes
               color = rep(c(1,2,3,4),32))
  p <- d1 %>% # create random colours
    gghilbertplot(val,
                  color = factor(color), # render color as a factor
                  size = size,
                  add_curve = T)
  testthat::expect_silent(p)




  for (i in 1:8) {
    p <-
      gghilbertplot(tibble(d = 1:2 ^ i), d, add_curve = T) + ggplot2::aes(label = d) + ggplot2::geom_label()
    print(p)
  }
  testthat::expect_silent(p)
})
