shape_files <-
  dplyr::tribble(~id, ~filename, ~region_names,
                 "ICES Ecoregions", "ICES_ecoregions_20171207_erase_ESRI.shp", "Ecoregion",
                 "ICES Statistical subrectangles", "ICES_SubStatrec_20150113_3857.shp", "ICESNAME",
                 "ICES Statistical rectangles", "ICES_Statistical_Rectangles_Eco.shp", "ICESNAME"
                 )

#' Convert list to vector and replace character(0) with NAs.
#'
#' @param l List to convert
list_to_vector_convert_na <- function(l) {
  l %>%
    lapply(function(x) if(identical(x, character(0))) NA_character_ else x) %>%
    unlist()
}


#' Locate point in Fishery administration areas
#'
#' @param x Data frame with columns 'lng' and 'lat'.
#' @param lng_col Name of longitude column in data frame.
#' @param lat_col Name of latitude column in data frame.
fish_area <- function(x, lng_col = "lng", lat_col = "lat") {
  sf::sf_use_s2(FALSE) # Prevents invalid geometry error for ICES Ecoregions

  region <- "ICES Ecoregions"

  filename <-
    shape_files %>%
    dplyr::filter(id == region) %>%
    dplyr::pull(filename)

  region_name <-
    shape_files %>%
    dplyr::filter(id == region) %>%
    dplyr::pull(region_names)

  # Catch error for no matching filename

  areas <-
    system.file("extdata", filename, package = "fisharea") %>%
    sf::st_read()

  points <-
    x %>%
    dplyr::select(dplyr::all_of(lng_col),
                  dplyr::all_of(lat_col)) %>%
    sf::st_as_sf(coords = c(1, 2), crs = sf::st_crs(areas))

  within_matrix <- sf::st_within(points, areas, sparse = FALSE)

  lapply(1:nrow(points), function(i) areas[[region_name]][within_matrix[i,]]) %>%
    list_to_vector_convert_na()
}
