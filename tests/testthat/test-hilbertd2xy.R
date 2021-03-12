

#library(testthat)
test_that("Distance to XY-Position works", {
  # test some manual examples
  for (i in 1:10) {
    # 0 must always be at 0,0
    expect_equal(hilbertd2xy(4 ^ i, 0), tibble(x = c(0), y = (0)))
    # test that last element is always at lower right corner
    expect_equal(hilbertd2xy(4 ^ i, 4 ^ i - 1), tibble(x = c((2 ^ i) - 1),
                                                       y = 0))
    #expect the middle element to recieve middle coordinates
    expect_equal(hilbertd2xy(4 ^ i, 4 ^ i / 2), tibble(x = c(2 ^ i / 2), y = (2 ^
                                                                                i / 2)))
  }


  # test for non-negativity
  for (i in 0:127) {
    expect_gte(hilbertd2xy(128, i)[1], 0, "x-position")
    expect_gte(hilbertd2xy(128, i)[2], 0, "y-position")
  }


})



#gghilbertplot(tibble(d = 1:16), d, add_curve = T) + geom_label() + aes(label = d)
