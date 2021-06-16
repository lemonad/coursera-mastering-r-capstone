#' Custom geom for plotting NOAA Significant Earthquake data labels on
#' a timeline.


# Although exported, this is how scarce this is documented in ggplot's
# geom_polygon so I assume this is enough here too. I guess if this is
# going to be used directly, one would have to look at the source code
# regardless.
#'
#' @format NULL
#' @usage NULL
#'
#' @importFrom dplyr slice_max
#' @importFrom ggplot2 aes draw_key_blank ggproto Geom
#' @importFrom grid gList gpar grobTree textGrob polylineGrob
#' @importFrom rlang .data
#' @export
GeomTimelineLabel <- ggplot2::ggproto(
  "GeomTimelineLabel",
  ggplot2::Geom,
  extra_params = c("na.rm", "n_max"),
  required_aes = c("x", "label", "magnitude"),
  default_aes = ggplot2::aes(
    y = 0,
    colour = "gray"
  ),
  draw_key = ggplot2::draw_key_blank,

  draw_group = function(data, panel_params, coord, na.rm, n_max) {
    if (!is.na(n_max)) {
      data <- dplyr::slice_max(
        data,
        order_by = .data$magnitude,
        n = n_max,
        with_ties = FALSE
      )
    }
    coords <- coord$transform(data, panel_params)

    ggplot2:::ggname(
      "geom_timeline_label",
      grid::grobTree(
        children = grid::gList(
          grid::polylineGrob(
            x = ggplot2::unit(rep(coords$x, 2), "native"),
            y = ggplot2::unit(c(coords$y, coords$y + 0.08), "native"),
            id = rep(seq_along(coords$x), 2),
            default.units = "npc",
            gp = grid::gpar(col = "gray")
          ),
          grid::textGrob(
            x = ggplot2::unit(coords$x, "native"),
            y = ggplot2::unit(coords$y + 0.1, "native"),
            label = coords$label,
            rot = 45,
            just = c(0, 0.5)
          )
        )
      )
    )
  }
)


#' Plot labels for NOAA Significant Earthquake Data on a timeline.
#'
#' @inheritParams ggplot2::geom_text
#' @param n_max Maximum number of labels to annotate timeline with
#'
#' @examples
#' # Assumes the NOAA earthquake dataset has been obtained per method
#' # in `data-raw/earthquakes.R`.
#' ggplot2::ggplot(
#'   eq_clean_data(earthquakes),
#'   ggplot2::aes(x = date, y = country, colour = deathsTotal),
#'   alpha = 1
#' ) +
#'   geom_timeline() +
#'   geom_timeline_label(
#'     ggplot2::aes(label = locationName, magnitude = eqMagnitude),
#'     n_max = 5
#'   )
#'
#' @importFrom ggplot2 layer
#' @export
geom_timeline_label <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  n_max = NA,
  ...
) {
  ggplot2::layer(
    geom = GeomTimelineLabel,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, n_max = n_max, ...)
  )
}
