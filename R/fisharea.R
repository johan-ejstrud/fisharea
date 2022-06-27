
extdata_dir <- file.path("inst", "extdata")

ices_areas <- sf::st_read(file.path(extdata_dir, "ICES_ecoregions_20171207_erase_ESRI.shp"))

p <-
  dplyr::tribble(~lng, ~lat,
                 65.37370068764517, -39.3544785888973,
                 64.38265863518154, -23.835783601976626
                 ) %>%
  sf::st_as_sf(coords = c("lat", "lng"), crs = sf::st_crs(ices_areas))

sf::st_within(p, ices_areas[1, ])

ggplot(ices_areas) +
  geom_sf() +
  geom_sf(data = p, color="red")
