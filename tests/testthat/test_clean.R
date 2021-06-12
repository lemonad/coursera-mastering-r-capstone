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
  suppressWarnings(
    readr::read_delim(data_path, delim = "\t", col_types = cols())
  )
}


test_that("cleaned data contains expected columns", {
  df <- make_df()
  expect_true(is.data.frame(df))
  expect_false(
    all(
      c(
        "Country",
        "Date"
      ) %in% colnames(df)
    )
  )

  clean_df <- eq_clean_data(df)
  expect_true(is.data.frame(clean_df))
  expect_true(
    all(
      c(
        "Country",
        "Date",
        "Location Name",
        "Latitude",
        "Longitude",
        "Mag"
      ) %in% colnames(clean_df)
    )
  )
})

test_that("US states are set to have country USA", {
  df <- make_df()
  clean_df <- eq_clean_data(df)
  countries <- dplyr::pull(unique(clean_df["Country"]))
  expect_true("USA" %in% countries)
})
