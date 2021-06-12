# Should not be included if this was a proper module
# but this makes it so the file can be sourced.
library(dplyr)
library(stringr)
library(datasets)


eq_location_clean <- function(loc) {
  stringr::str_to_title(stringr::str_replace(loc, ".*:\\s*", ""))
}


eq_clean_data <- function(df) {
  dplyr::mutate(
    df[!is.na(df$Year) & df$Year > 0,],
    Date = as.Date(
      paste(
        paste(
          Year,
          ifelse(is.na(Mo), 1, Mo),
          ifelse(is.na(Dy), 1, Dy),
          sep = "-"
        )
      )
    ),
    # Set US states to have USA as a country.
    Country = stringr::str_replace(
      stringr::str_replace(`Location Name`, ":.*$", ""),
      paste0(
        "(",
        # Note that Georgia is also a country, so lets not replace that.
        paste(
          toupper(
            setdiff(datasets::state.name, "Georgia")
          ),
          collapse = "|"
        ),
        ")"
      ),
      "USA"
    ),
    `Location Name` = eq_location_clean(`Location Name`),
    Latitude = as.numeric(Latitude),
    Longitude = as.numeric(Longitude),
    .before = "Year"
  )
}