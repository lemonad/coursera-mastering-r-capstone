#' Makes the NOAA Significant Earthquake data easier to use.
#'
#' * Combines date columns into a single `Date` column.
#' * Extracts countries from the location column.
#' * If location is a US state, sets country to USA.


#' Clean location names.
#'
#' Removes country, etc. from locations.
#'
#' @param loc Earthquake location name
#' @return Cleaned location name
#'
#' @examples
#' earthquakecapstone:::eq_location_clean("CALIFORNIA:  SANTA BARBARA")
#' earthquakecapstone:::eq_location_clean("MEXICO:  BAJA CALIFORNIA: LORETO")
#'
#' @importFrom stringr str_replace str_to_title
eq_location_clean <- function(loc) {
  stringr::str_to_title(stringr::str_replace(loc, ".*:\\s*", ""))
}


#' Clean NOAA Significant Earthquake Data.
#'
#' @param df Dataframe containing earthquake data
#' @return Cleaned dataframe
#'
#' @examples
#' # Assumes the NOAA earthquake dataset has been obtained per method
#' # in `data-raw/earthquakes.R`.
#' eq_clean_data(earthquakes)
#'
#' @importFrom dplyr mutate
#' @importFrom rlang .data
#' @importFrom stringr str_replace
#' @export
eq_clean_data <- function(df) {
  ace_df <- dplyr::filter(
    df,
    !is.na(.data$year) & .data$year > 0
  )
  dplyr::mutate(
    ace_df,
    date = as.Date(
      paste(
        paste(
          .data$year,
          ifelse(is.na(.data$month), 1, .data$month),
          ifelse(is.na(.data$day), 1, .data$day),
          sep = "-"
        )
      )
    ),
    country = ifelse(
      .data$country == "USA",
      .data$country,
      stringr::str_to_title(.data$country)
    ),
    locationName = eq_location_clean(.data$locationName),
    latitude = as.numeric(.data$latitude),
    longitude = as.numeric(.data$longitude),
    .before = "year"
  )
}
