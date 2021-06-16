# NOAA Significant Earthquake dataset.

library(dplyr, warn.conflicts = FALSE)
library(jsonlite)
library(usethis)


api_uri <- "https://www.ngdc.noaa.gov/hazel/hazard-service/api/v1/earthquakes"
f <- jsonlite::read_json(api_uri, simplify = TRUE)
earthquakes <- dplyr::as_tibble(f$items)

usethis::use_data(earthquakes, overwrite = TRUE)
