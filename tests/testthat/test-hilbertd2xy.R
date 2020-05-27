test_that("Distance to XY-Position works", {
  # test some manual examples
  expect_equal(hilbertd2xy(64,0), c(0,0))
  expect_equal(hilbertd2xy(64,63), c(0,7))
  expect_equal(hilbertd2xy(128,63), c(7,0))

  # test for non-negativity
  for (i in 0:127) {
    expect_gte(hilbertd2xy(128,i)[1], 0, "x-position")
    expect_gte(hilbertd2xy(128,i)[2], 0, "y-position")
  }


})
