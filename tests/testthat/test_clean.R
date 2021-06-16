library(readr)
library(testthat)
library(earthquakecapstone)


test_that("cleaned data contains expected columns", {
  expect_true(is.data.frame(earthquakes))
  expect_false(
    all(
      c("date") %in% colnames(earthquakes)
    )
  )

  clean_df <- eq_clean_data(earthquakes)
  expect_true(is.data.frame(clean_df))
  expect_true(
    all(
      c(
        "country",
        "date",
        "locationName",
        "latitude",
        "longitude",
        "eqMagnitude"
      ) %in% colnames(clean_df)
    )
  )
  expect_true(is.numeric(clean_df$latitude))
  expect_true(is.numeric(clean_df$longitude))
})
