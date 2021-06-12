library(dplyr)
library(ggplot2)
library(leaflet)
library(lubridate)
library(readr)
library(stringr)
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
    Country %in% c("Mexico") & lubridate::year(Date) >= 2010
  )
}


test_that("map plot is leaflet", {
  df <- make_df()
  p <- eq_map(df, annot_col = "Mag")
  expect_s3_class(p, "leaflet")
})


test_that("map plot contains locations in Mexico", {
  df <- make_df()
  p <- eq_map(df, annot_col = "Mag")
  lat <- p$x$limits$lat
  lng <- p$x$limits$lng

  # Baja California.
  expect_true(between(32, lat[1], lat[2]))
  expect_true(between(-115, lng[1], lng[2]))

  # Oaxaca.
  expect_true(between(17.7, lat[1], lat[2]))
  expect_true(between(-95.7, lng[1], lng[2]))
})


test_that("labels are created", {
  df <- make_df()
  labels <- eq_create_label(df)
  expect_type(labels, "character")
  expect_true(length(labels) > 1)
  expect_true(any(stringr::str_detect(labels, "Location:")))
  expect_true(any(stringr::str_detect(labels, "Magnitude:")))
  expect_true(any(stringr::str_detect(labels, "Total deaths:")))
})
