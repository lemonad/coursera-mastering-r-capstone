#' Plots earthquake events on a map.

#' Helper function to create html labels for events.
#'
#' @param data Earthquake dataframe
#' @return List of html labels for events
#'
#' @examples
#' # Assumes the NOAA earthquake dataset has been obtained per method
#' # in `data-raw/earthquakes.R`.
#' dplyr::mutate(
#'   eq_clean_data(earthquakes),
#'   popup_text = eq_create_label(.data)
#' )
#'
#' @export
eq_create_label <- function(data) {
  empty_if_na <- function(value, title) {
    ifelse(
      is.na(value),
      "",
      paste0("<strong>", title, ":</strong> ", value)
    )
  }

  paste(
    empty_if_na(data$locationName, "Location"),
    empty_if_na(data$eqMagnitude, "Magnitude"),
    empty_if_na(data$deathsTotal, "Total deaths"),
    sep = "<br/>"
  )
}


#' Map of earthquake events.
#'
#' @param data Earthquake dataframe
#' @param annot_col Name of column containing data for event popups
#' @return Leaflet map
#'
#' @examples
#' # Assumes the NOAA earthquake dataset has been obtained per method
#' # in `data-raw/earthquakes.R`.
#' eq_map(
#'   dplyr::mutate(
#'     eq_clean_data(earthquakes),
#'     popup_text = eq_create_label(.data)
#'   ),
#'   annot_col = "popup_text"
#' )
#'
#' @importFrom dplyr filter pull
#' @importFrom leaflet addCircleMarkers addTiles leaflet
#' @importFrom rlang .data
#' @export
eq_map <- function(data, annot_col) {
  locations <- dplyr::filter(
    data,
    !is.na(.data$longitude) & !is.na(.data$latitude)
  )
  leaflet::addCircleMarkers(
    # Add default OpenStreetMap map tiles.
    leaflet::addTiles(
      leaflet::leaflet()
    ),
    lng = locations$longitude,
    lat = locations$latitude,
    # Use paste here in case column is not a string.
    popup = paste(dplyr::pull(locations, annot_col)),
    radius = locations$eqMagnitude,
    stroke = TRUE,
    fillOpacity = 0.3,
    weight = 2
  )
}
