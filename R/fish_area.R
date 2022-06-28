sf::sf_use_s2(FALSE)

extdata_dir <- file.path("inst", "extdata")
ices_file <- file.path(extdata_dir, "ICES_ecoregions_20171207_erase_ESRI.shp")
ices_areas <- sf::st_read(ices_file)

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
  points <-
    x %>%
    dplyr::select(lat_col, lng_col) %>%
    sf::st_as_sf(coords = c(1, 2),
                 crs = sf::st_crs(ices_areas))

   within_matrix <- sf::st_within(points, ices_areas, sparse = FALSE)

   lapply(1:nrow(points), function(i) ices_areas$Ecoregion[within_matrix[i,]]) %>%
     list_to_vector_convert_na()
}
