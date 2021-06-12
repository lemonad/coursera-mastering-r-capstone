#' Plots earthquake events on a map.

#' Helper function to create html labels for events.
#'
#' @param data Earthquake dataframe
#' @return List of html labels for events
#'
#' @examples
#' \dontrun{
#' # Assumes data has been downloaded as `earthquakes.tsv`.
#' readr::read_delim("./earthquakes.tsv", delim = "\t") %>%
#'   eq_clean_data() %>%
#'   dplyr::mutate(popup_text = eq_create_label(.))
#' }
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
    empty_if_na(data$`Location Name`, "Location"),
    empty_if_na(data$Mag, "Magnitude"),
    empty_if_na(data$`Total Deaths`, "Total deaths"),
    sep = "<br/>"
  )
}


#' Map of earthquake events.
#'
#' @param data Earthquake dataframe
#' @param annot_col Name of column containing data for event popups
#' @return Leaflet map
#'
#' \dontrun{
#' # Assumes data has been downloaded as `earthquakes.tsv`.
#' readr::read_delim("./earthquakes.tsv", delim = "\t") %>%
#'   eq_clean_data() %>%
#'   dplyr::mutate(popup_text = eq_create_label(.)) %>%
#'   eq_map(annot_col = "popup_text")
#' }
#'
#' @importFrom dplyr filter pull
#' @importFrom leaflet addCircleMarkers addTiles leaflet
#' @export
eq_map <- function(data, annot_col) {
  locations <- dplyr::filter(data, !is.na(Longitude) & !is.na(Latitude))
  leaflet::addCircleMarkers(
    # Add default OpenStreetMap map tiles.
    leaflet::addTiles(
      leaflet::leaflet()
    ),
    lng = locations$Longitude,
    lat = locations$Latitude,
    # Use paste here in case column is not a string.
    popup = paste(dplyr::pull(locations, annot_col)),
    radius = locations$Mag,
    stroke = TRUE,
    fillOpacity = 0.3,
    weight = 2
  )
}
