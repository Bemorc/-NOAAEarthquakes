#' \code{GeomTimeline} defines the ggplot2 geom.
#' Use the \code{geom_timeline} function to create these layers.
#' The aesthetic \code{x} determines the placement of the circles along the line
#' and is required.
#' The aesthetics \code{color}, \code{size}, and \code{alpha} define the color,
#' radius and transparency of the circle and are optional.
#' The aesthetic \code{y} can be used for making multiple stratified timelines
#' and is also optional.
#'
#' @importFrom ggplot2 ggproto aes draw_key_point Geom
#' @importFrom grid circleGrob gpar
#' @importFrom scales alpha
#'
#' @return \code{Geom*} object for rendering timelines on plots
#'
#' @examples
#'
#' \dontrun{
#' # All deadly earthquakes in JAPAN, CHINA and NEPAL since 2000
#'
#' data <- eq_clean_data() %>%
#'      dplyr::filter(!is.na(TOTAL_DEATHS)) %>%
#'      dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'      tidyr::drop_na() %>%
#'      dplyr::filter(YEAR > 1999, COUNTRY %in% c("JAPAN", "CHINA","NEPAL"))
#'
#' # Plot Timeline
#'
#' ggplot2::ggplot() +
#'     ggplot2::layer(geom = GeomTimeline,
#'                    mapping = aes(x = data$DATE,
#'                                  y = data$COUNTRY,
#'                                  size  = data$MAG,
#'                                  color = data$TOTAL_DEATHS),
#'                    data        = data,
#'                    stat        = 'identity',
#'                    position    = 'identity',
#'                    show.legend = NA,
#'                    inherit.aes = TRUE,
#'                    params = list(na.rm = FALSE))
#' }
#'
#' @export
GeomTimeline <- ggplot2::ggproto(`_class`   = "GeomTimeline",
                                 `_inherit` = ggplot2::Geom,

                                 required_aes = c("x"),
                                 optional_aes = c('y',
                                                  'color',
                                                  'size',
                                                  'alpha'),

                                 default_aes = ggplot2::aes(pch = 21,
                                                            colour = "black",
                                                            size = 0.01,
                                                            fill = 'grey',
                                                            alpha = 0.4,
                                                            stroke = 1),

                                 draw_key = ggplot2::draw_key_point,

                                 draw_panel = function(data,panel_params,coord) {
                                     # Scale size between 0.0 and 1.0
                                     data$size <- data$size/max(data$size)
                                     coords <- coord$transform(data, panel_params)

                                     grid::circleGrob(coords$x,
                                                      coords$y,
                                                      r = coords$size/25,
                                                      gp = grid::gpar(col = scales::alpha(coords$colour,
                                                                                          coords$alpha),
                                                                      fill = scales::alpha(coords$colour,
                                                                                           coords$alpha),
                                                                      alpha = coords$alpha,
                                                                      fontsize = coords$size,
                                                                      lwd = coords$stroke))
                                })  # end: ggproto

#' Wrapper for creating a \code{GeomTimeline} layer for ggplot2. See \code{\link{GeomTimeline}}.
#'
#' @importFrom ggplot2 layer
#'
#' @inheritParams ggplot2::geom_point
#'
#' @returns A ggplot2 layer containing a \code{\link{GeomTimeline}} object.
#'
#' @examples
#'
#' \dontrun{
#'
#'  # All deadly earthquakes in JAPAN, CHINA and NEPAL since 2000
#' data <- eq_clean_data() %>%
#'      dplyr::filter(!is.na(TOTAL_DEATHS)) %>%
#'      dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'      tidyr::drop_na() %>%
#'      dplyr::filter(YEAR > 1999, COUNTRY %in% c("JAPAN", "CHINA","NEPAL")) %>%
#'
#'     ggplot2::ggplot(aes(x = DATE,
#'                         y = COUNTRY,
#'                         size = MAG,
#'                         color = TOTAL_DEATHS)) +
#'
#'         geom_timeline()
#' }
#'
#' @export
geom_timeline <- function(mapping = NULL,
                          data = NULL,
                          stat = "identity",
                          position = "identity",
                          na.rm = FALSE,
                          show.legend = NA,
                          inherit.aes = TRUE, ...){
    ggplot2::layer(geom = GeomTimeline,
                   mapping = mapping,
                   data = data,
                   stat = stat,
                   position = position,
                   show.legend = show.legend,
                   inherit.aes = inherit.aes,
                   params = list(na.rm = na.rm,...))
    }

#' \code{GeomTimelineLabel} defines the ggplot2 geom which draws line markers and text.
#' Use \code{\link{geom_timeline_label}} to add a GeomTimelineLabel layer to ggplot.
#' The aesthetic \code{x} specifies where to place a marker and is required.
#' The aesthetic \code{mag} determines what quantity is used from the input data
#' to determine which observations are marked and is required.
#' The aesthetic \code{label} determines the column used in the input data for labels.
#' The aesthetics \code{y}, \code{color}, and \code{alpha} determines the stratification,
#' color, and transparency and are optional.
#' The aesthetic \code{n_max} determines how many markers to place and is optional.
#'
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggproto aes draw_key_polygon Geom
#' @importFrom grid textGrob gTree gpar gList segmentsGrob
#' @importFrom dplyr slice_max
#' @importFrom utils head
#'
#' @return \code{Geom*} object for marking and labeling timelines on plots
#'
#' @examples
#'
#' \dontrun{
#'
#' # All deadly earthquakes in JAPAN, CHINA and NEPAL since 2000
#' data <- eq_clean_data() %>%
#'      dplyr::filter(!is.na(TOTAL_DEATHS)) %>%
#'      dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'      tidyr::drop_na()
#'
#'     ggplot2::ggplot() +
#'
#'     ggplot2::layer(geom = GeomTimelineLabel,
#'                    mapping = aes(x = data$DATE,
#'                                  y = data$COUNTRY,
#'                                  size = data$MAG,
#'                                  color = data$TOTAL_DEATHS),
#'                    data = data,
#'                    stat = 'identity',
#'                    position = 'identity',
#'                    show.legend = NA,
#'                    inherit.aes = TRUE,
#'                    params = list(na.rm = FALSE))
#' }
#'
#' @export
GeomTimelineLabel <-
    ggplot2::ggproto("GeomTimelineLabel",
                     ggplot2::Geom,

                     required_aes = c("x", "mag","label"),
                     optional_aes = c('y',
                                      'color',
                                      'alpha',
                                      'n_max'),

                     default_aes  = ggplot2::aes(shape = 21,
                                                 colour = "black",
                                                 size = 15.0,
                                                 fill = 'black',
                                                 alpha = 0.4,
                                                 stroke = 2,
                                                 n_max = 3),

                     draw_key = ggplot2::draw_key_point,

                     draw_panel = function(data, panel_params, coord) {

                         # Sorts and filters data based on n_max aesthetic
                         data <- data %>%
                             dplyr::slice_max(order_by = mag,n = data$n_max[1])

                         coords <- coord$transform(data, panel_params)

                         # Create vertical lines
                         lines <- grid::segmentsGrob(x0 = coords$x,
                                                     y0 = coords$y,
                                                     x1 = coords$x,
                                                     y1 = coords$y + 0.15,
                                                     default.units = "npc",
                                                     gp = grid::gpar(col = coords$colour,
                                                                     alpha = coords$alpha,
                                                                     fontsize = coords$size,
                                                                     lwd = coords$stroke))

                         # Create label
                         texts <- grid::textGrob(label = coords$label,
                                                 x = coords$x,
                                                 y = coords$y + 0.15,
                                                 just = "left",
                                                 rot = 45,
                                                 check.overlap = TRUE,
                                                 default.units = "npc",
                                                 gp = grid::gpar(col = coords$colour,
                                                                 fontsize = coords$size * 1.5,
                                                                 lwd = coords$stroke))

                         # Plotzle
                         grid::gTree(children = grid::gList(lines, texts))
                     })

#' Wrapper for creating a \code{GeomTimelineLabel} layer for ggplot2.
#' See \code{\link{GeomTimelineLabel}}.
#'
#' @inheritParams ggplot2::geom_point
#'
#' @importFrom ggplot2 layer
#'
#' @return A ggplot2 layer containing a \code{\link{GeomTimelineLabel}} object.
#'
#' @examples
#'
#' \dontrun{
#'  # All deadly earthquakes in JAPAN, CHINA and NEPAL since 2000
#' data <- eq_clean_data() %>%
#'      dplyr::filter(!is.na(TOTAL_DEATHS)) %>%
#'      dplyr::select(DATE, YEAR, COUNTRY, REGION, LONGITUDE, LATITUDE, MAG, TOTAL_DEATHS) %>%
#'      tidyr::drop_na() %>% dplyr::filter(COUNTRY == "JAPAN", YEAR >= 1900) %>%
#'      ggplot2::ggplot(aes(x = DATE,
#'                          y = COUNTRY,
#'                          size = MAG,
#'                          color = TOTAL_DEATHS,
#'                          label = REGION,
#'                          mag = MAG)) +
#'                  geom_timeline() +
#'                  geom_timeline_label(aes(n_max = 5))
#' }
#'
#' @export
geom_timeline_label <- function(mapping = NULL,
                                data = NULL,
                                stat = "identity",
                                position = "identity",
                                show.legend = NA,
                                inherit.aes = TRUE,
                                ..., na.rm = FALSE
                                ) {
                        ggplot2::layer(geom = GeomTimelineLabel,
                                       mapping = mapping,
                                       data = data,
                                       stat = stat,
                                       position = position,
                                       show.legend = show.legend,
                                       inherit.aes = inherit.aes,
                                       params = list(na.rm = na.rm, ...)
                                       )
                        }
