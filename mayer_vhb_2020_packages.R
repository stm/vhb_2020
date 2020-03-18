# Code accompanying the session "Tools for Generating and Disseminating Quantitative Research"
# Contributed Session to the Annual Conference of the German Association of Business Research
# March 17-19, 2020, Goethe University Frankfurt

# Author: Stefan Mayer, University of Tübingen
# March 2020


# before we start
#
# make sure you have all the essential packages installed
pkgs <- c("devtools", "roxygen2", "usethis", "testthat2")
requireNamespace("testthat2")
install.packages(pkgs)

# see whether your package is still available
available::available("missingstats", browse = FALSE)

# create the package 'missingstats' from scratch, let usethis handle all the
# things
#
# note: this will create and open a new R project;
#       all following commands should be executed in this new project
usethis::create_tidy_package("~/missingstats")

# create a file 'vhb.R' in which we will place our function
usethis::use_r("vhb")


# the following function definition (and its documentation) should be placed
# in 'vhb.R'

#' Estimate the standard error of the mean.
#'
#' @param x A vector of numbers.
#' @return The standard error of of the mean regarding \code{x}.
#' @export
#' @examples
#' se(1:5)
#' se(c(0,6,9))
se <- function(x) {
  sqrt(var(x)/length(x))
}

# generate the documentation (i.e., convert roxygen description to.Rd)
#
# note that this should be executed in your R console in the R project;
# alternatively, use Ctrl+Shift+D in RStudio
devtools::document()

# set up unit testing (execute in R console)
usethis::use_testthat()

# create unit test file for our functions in vhb.R
usethis::use_test("vhb")

# place the following unit tests in tests/testthat/test-vhb.R
#
# note: if you want to execute this code, make sure the package 'testthat'
#       is loaded
test_that("standard error works as intended", {
  result <- se(c(2,6))
  expect_equal(result, 2)
})

test_that("supplying string should throw error", {
  expect_error(
    se(c("one", 2, 3))
  )
})

test_that("supplying string should throw warning", {
  expect_warning(
    se(c("one", 2, 3))
  )
})

# test all unit tests (execute in R console, or use Ctrl+Shift+D)
devtools::test()

# set up raw data directory
usethis::use_data_raw()

# you could e.g. put the following code that we used to generates our data into
# the file at data-raw/DATASET.R
babynames <- c("Emma", "Liam", "Alex")
cities <- c("Frankfurt", "Cologne")

# add data as available dataset to our package
#
# note: users of your package can then use your data the usual way with e.g.
# data(babynames)
usethis::use_data(babynames, cities)

# document the data
#
# first, create a new R file called 'data.R' for the datasets
usethis::use_r("data")

# put the following roxygen code into this new 'data.R' file

#' Baby names.
#'
#' Full baby name data provided by the SSA. This includes all names with at
#' least 5 uses.
#'
#' @format A data frame with five variables: \code{year}, \code{sex},
#' \code{name}, \code{n} and \code{prop} (\code{n} divided by total number
#' of applicants in that year, which means proportions are of people of
#' that sex with that name born in that year).
"babynames"

# do a final check of the package (will throw errors because of the unit tests
# in which we intentionally put an error
devtools::check() # or Ctrl+Shift+E




