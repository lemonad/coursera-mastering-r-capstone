library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(testthat)
library(earthquakecapstone)


make_df <- function() {
  dplyr::filter(
    eq_clean_data(earthquakes),
    country %in% c("Mexico", "USA") & lubridate::year(date) >= 2010
  )
}


test_that("timeline plot has date axis", {
  df <- make_df()
  p <- ggplot(df, aes(x = date)) + geom_timeline()

  expect_true(is.ggplot(p))
  expect_identical(p$labels$x, "date")
  expect_false("country" %in% p$labels)
})


test_that("timeline plot has corresponding axes", {
  df <- make_df()
  p <- ggplot(df, aes(x = date, y = country, colour = deathsTotal)) +
    geom_timeline()

  expect_true(is.ggplot(p))
  expect_identical(p$labels$x, "date")
  expect_identical(p$labels$y, "country")
  expect_identical(p$labels$colour, "deathsTotal")
})


test_that("timeline label plot has corresponding axes", {
  df <- make_df()
  p <- ggplot(df, aes(x = date)) +
    geom_timeline() +
    geom_timeline_label(
      aes(label = locationName, magnitude = eqMagnitude),
      n_max = 5
    )

  expect_true(is.ggplot(p))
  expect_identical(p$labels$x, "date")
  expect_identical(p$labels$label, "locationName")
  expect_identical(p$labels$magnitude, "eqMagnitude")
})
