library(dplyr)
library(leaflet)


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


eq_map <- function(data, annot_col) {
  locations <- dplyr::filter(data, !is.na(Longitude) & !is.na(Latitude))
  addCircleMarkers(
    # Add default OpenStreetMap map tiles.
    addTiles(
      leaflet()
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