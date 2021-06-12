library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(testthat)
library(earthquakecapstone)


make_df <- function() {
  data_path <- system.file(
    "extdata",
    "earthquakes.tsv",
    package = "earthquakecapstone",
    mustWork = TRUE
  )
  clean_df <- eq_clean_data(
    suppressWarnings(
      readr::read_delim(data_path, delim = "\t", col_types = cols())
    )
  )
  dplyr::filter(
    clean_df,
    Country %in% c("Mexico", "USA") & lubridate::year(Date) >= 2010
  )
}


test_that("timeline plot has date axis", {
  df <- make_df()
  p <- ggplot(df, aes(x = Date)) + geom_timeline()

  expect_true(is.ggplot(p))
  expect_identical(p$labels$x, "Date")
  expect_false("Country" %in% p$labels)
})


test_that("timeline plot has corresponding axes", {
  df <- make_df()
  p <- ggplot(df, aes(x = Date, y = Country, colour = `Total Deaths`)) +
    geom_timeline()

  expect_true(is.ggplot(p))
  expect_identical(p$labels$x, "Date")
  expect_identical(p$labels$y, "Country")
  expect_identical(p$labels$colour, "Total Deaths")
})


test_that("timeline label plot has corresponding axes", {
  df <- make_df()
  p <- ggplot(df, aes(x = Date)) +
    geom_timeline() +
    geom_timeline_label(
      aes(label = `Location Name`, magnitude = Mag),
      n_max = 5
    )

  expect_true(is.ggplot(p))
  expect_identical(p$labels$x, "Date")
  expect_identical(p$labels$label, "Location Name")
  expect_identical(p$labels$magnitude, "Mag")
})
