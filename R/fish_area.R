shape_files <-
  dplyr::tribble(~id, ~filename, ~region_col,
                 "ICES areas", "ICES_Areas_20160601_cut_dense_3857.shp", "Area_27",
                 "ICES statistical rectangles", "ICES_Statistical_Rectangles_Eco.shp", "ICESNAME",
                 "ICES statistical subrectangles", "ICES_SubStatrec_20150113_3857.shp", "ICESNAME",
                 "ICES ecoregions", "ICES_ecoregions_20171207_erase_ESRI.shp", "Ecoregion",
                 "NAFO divisions", "NAFO_Divisions_SHP/NAFO_Divisions_2021_poly_clipped.shp", "Division"
                 )

#' Convert list to vector and replace character(0) with NAs.
#'
#' @param l List to convert
list_to_vector_convert_na <- function(l) {
  l %>%
    lapply(function(x) if(identical(x, character(0))) NA_character_ else x) %>%
    unlist()
}

#' @title Get shape file for fishery administration areas
#' @description Returns an sf object with fishery administration areas.
#'
#' @param region Name of classification system to return sf object for.
#' @export
#' @examples
#' ices_areas <- fisharea_sf("ICES areas")
fisharea_sf <- function(region = shape_files$id) {
  region <- match.arg(region)

  shape_files %>%
    dplyr::filter(id == region) %>%
    dplyr::pull(filename) %>%
    system.file("extdata", ., package = "fisharea") %>%
    sf::st_read() %>%
    sf::st_transform(crs = 4326)
}

#' @title Classify coordinates in fishery administration areas
#' @description Find which fishery administration area a set of coordinates
#' lies within to.
#'
#' @param x Data frame containing columns with coordinates.
#' @param lon_col Name of longitude column in data frame.
#' @param lat_col Name of latitude column in data frame.
#' @param region Name of classification system to return names for. Possible
#' values are "ICES areas", "ICES statistical subrectangles",
#' "ICES statistical rectangles", "ICES ecoregions", and "NAFO divisions".
#' @export
#' @examples
#' p <- data.frame(lat = c(65.3, 40.0),
#'                 lon = c(-39.3, -9.5))
#' fisharea(p)
#' #> [1] "14.b.2" "9.a"
#'
#' fisharea(p, region = "ICES statistical rectangles")
#' #> [1] "59B0" "08E0"
fisharea <- function(x, lon_col = "lon", lat_col = "lat",
                      region = shape_files$id) {
  sf::sf_use_s2(FALSE) # Prevents invalid geometry error

  region <- match.arg(region)
  regions <- fisharea_sf(region)

  region_col <-
    shape_files %>%
    dplyr::filter(id == region) %>%
    dplyr::pull(region_col)

  points <-
    x %>%
    dplyr::select(dplyr::all_of(lon_col),
                  dplyr::all_of(lat_col)) %>%
    sf::st_as_sf(coords = c(1, 2), crs = sf::st_crs(regions))

  within_matrix <- sf::st_within(points, regions, sparse = FALSE)

  # Extract vector of region names from 'within_matrix'
  lapply(1:nrow(points), function(i) regions[[region_col]][within_matrix[i,]]) %>%
    list_to_vector_convert_na()
}
