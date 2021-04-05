
limit <- 9
#library(testthat)
test_that("0 is always at 0,0", {
  # test some manual examples
  for (i in 1:limit) {
    # 0 must always be at 0,0
    expect_equal(hilbertd2xy(4 ^ i, 0), tibble(x = c(0), y = (0)))
  }
})


test_that("n is always at 2^i-1,0 ", {

  #prep
  testthat::expect_equal((2^1) - 1, 1)
  testthat::expect_equal((2^2) - 1, 3)
  testthat::expect_equal((2^3) - 1, 7)
  testthat::expect_equal((2^4) - 1, 15)
  testthat::expect_equal((2^5) - 1, 31)
  testthat::expect_equal((2^6) - 1, 63)
  testthat::expect_equal((2^7) - 1, 127)
  testthat::expect_equal((2^8) - 1, 255)
  testthat::expect_equal((2^9) - 1, 511)

  d <- data.frame()
  for (i in 1:limit) {
    # test that last element is always at lower right corner
    vec <- c(i = i, hilbertd2xy(4^i, 4^i - 1))
    d <- rbind(d, vec)
  }
  write.csv(d, "output.csv")
  print(d)

  #testthat::skip_if(grepl("i386", sessionInfo()$platform))

  # test some manual examples
  for (i in 1:limit) {
    # test that last element is always at lower right corner
    testthat::expect_equal(hilbertd2xy(4 ^ i, 4 ^ i - 1), tibble::tibble(x = c((2 ^ i) - 1), y = c(0)))
  }
})

test_that("n/2 is always at the top", {
  # test some manual examples
  for (i in 1:limit) {
    #cat(paste0("At i:", i, "\n"))
    #expect the middle element to recieve middle coordinates
    expect_equal(hilbertd2xy(4 ^ i, 4 ^ i / 2),
                 tibble(x = c(2 ^ i / 2), y = (2 ^ i / 2))
                 )
  }
})

test_that("Hilbert Curves are never negative", {
  for (i in 0:127) {
    expect_gte(hilbertd2xy(128, i)[1], 0, "x-position")
    expect_gte(hilbertd2xy(128, i)[2], 0, "y-position")
  }


})

test_that("Testing order4 function", {
  for(i in 1:9999) {
    testthat::expect_lte(i, 4^gghilbertstrings:::order4(i))
    testthat::expect_gte(i, 4^(gghilbertstrings:::order4(i)-1))
  }
})




if(FALSE){

  #x <- 23182765654
  #microbenchmark::microbenchmark(
  #  gghilbertstrings:::order4(x),
  #  gghilbertstrings:::order4b(x),
  #  times = 1000
  #)

  #library(tidyverse)
  #library(tibble)
  gghilbertplot(tibble(d = 1:16), d, add_curve = T) + geom_label() + aes(label = d)
  gghilbertplot(tibble(d = 1:63), d, add_curve = T) + geom_label() + aes(label = d)
  gghilbertplot(tibble(d = 1:257), d, add_curve = T) + geom_label() + aes(label = d)

}

