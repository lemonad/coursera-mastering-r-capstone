# Should not be included if this was a proper module
# but this makes it so the file can be sourced.
library(dplyr)
library(ggplot2)
library(grid)


# Although exported, this is how scarce this is documented in ggplot's
# geom_polygon so I assume this is enough here too. I guess if this is
# going to be used directly, one would have to look at the source code
# regardless.
#' 
#' @format NULL
#' @usage NULL
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
            x = unit(rep(coords$x, 2), "native"),
            y = unit(c(coords$y, coords$y + 0.08), "native"),
            id = rep(seq_along(coords$x), 2),
            default.units = "npc",
            gp = grid::gpar(col = "gray")
          ),
          grid::textGrob(
            x = unit(coords$x, "native"),
            y = unit(coords$y + 0.1, "native"),
            label = coords$label,
            rot = 45,
            just = c(0, 0.5)
          )
        )
      )
    )
  }
)


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