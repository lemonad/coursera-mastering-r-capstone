#' Custom geom for plotting NOAA Significant Earthquake data on a timeline.


# Although exported, this is how scarce this is documented in ggplot's
# geom_polygon so I assume this is enough here too. I guess if this is
# going to be used directly, one would have to look at the source code
# regardless.
#'
#' @format NULL
#' @usage NULL
#'
#' @importFrom ggplot2 aes draw_key_point ggproto Geom
#' @importFrom grid gList gpar grobTree linesGrob pointsGrob
#' @export
GeomTimeline <- ggplot2::ggproto(
  "GeomTimeline",
  ggplot2::Geom,
  required_aes = c("x"),
  default_aes = ggplot2::aes(
    y = 0,
    colour = "black",
    size = 3,
    alpha = 0.5,
    shape = 19
  ),
  draw_key = ggplot2::draw_key_point,

  draw_group = function(data, panel_params, coord) {
    coords <- coord$transform(data, panel_params)

    ggplot2:::ggname(
      "geom_timeline",
      grid::grobTree(
        children = grid::gList(
          grid::linesGrob(
            x = c(0.01, 0.99),
            y = ggplot2::unit(coords$y, "native"),
            default.units = "npc",
            gp = grid::gpar(col = "gray", lwd = 2)
          ),
          grid::pointsGrob(
            x = ggplot2::unit(coords$x, "native"),
            y = ggplot2::unit(coords$y, "native"),
            pch = coords$shape,
            size = ggplot2::unit(coords$size / 4, "char"),
            gp = grid::gpar(
              alpha = coords$alpha,
              col = coords$colour,
              fontsize = coords$size * ggplot2::.pt
            )
          )
        )
      )
    )
  }
)


#' Plot NOAA Significant Earthquake Data on a timeline.
#'
#' @seealso
#'   [geom_point()] for parameters and options.
#' @inheritParams ggplot2::geom_point
#'
#' @examples
#' # Assumes the NOAA earthquake dataset has been obtained per method
#' # in `data-raw/earthquakes.R`.
#' ggplot2::ggplot(
#'   eq_clean_data(earthquakes),
#'   ggplot2::aes(x = date, y = country, colour = deathsTotal),
#'   alpha = 1
#' ) +
#'   geom_timeline()
#'
#' @importFrom ggplot2 layer
#' @export
geom_timeline <- function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
) {
  ggplot2::layer(
    geom = GeomTimeline,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}
