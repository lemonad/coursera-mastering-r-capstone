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
#' eq_location_clean("CALIFORNIA:  SANTA BARBARA")
#' eq_location_clean("MEXICO:  BAJA CALIFORNIA: LORETO")
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
#' \dontrun{
#' # Assumes data has been downloaded as `earthquakes.tsv`.
#' readr::read_delim("./earthquakes.tsv", delim = "\t") %>%
#'   eq_clean_data(df)
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom stringr str_replace
#' @export
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
      stringr::str_to_title(
        stringr::str_replace(`Location Name`, ":.*$", "")
      ),
      paste0(
        "(",
        # Note that Georgia is also a country, so lets not replace that.
        paste(
          stringr::str_to_title(
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
