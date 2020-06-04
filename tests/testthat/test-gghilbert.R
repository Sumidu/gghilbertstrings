test_that("Testing works", {
  library(tibble)
  p <- tibble(val = 1:128,
         size = runif(128, 1, 5),        # create random sizes
         color = rep(c(1,2,3,4),32)) %>% # create random colours
    gghilbertplot(val,
                  color = factor(color), # render color as a factor
                  size = size,
                  add_curve = T)
  testthat::expect_silent(p)
})
