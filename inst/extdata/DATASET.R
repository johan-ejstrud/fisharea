# Download and extract shape files
library(tidyverse)
library(sf)

extdata_dir <- file.path("inst", "extdata")

### Find data sets on: https://www.marineregions.org/downloads.php
download_and_unzip <- function(source) {
  zipdir <- "tmp.zip"
  download.file(source, zipdir)
  unzip(zipdir, exdir = extdata_dir)
  unlink(zipdir)
}

download_and_unzip("http://gis.ices.dk/shapefiles/ICES_ecoregions.zip")
download_and_unzip("http://gis.ices.dk/shapefiles/ICES_SubStatrec.zip")
download_and_unzip("http://gis.ices.dk/shapefiles/ICES_rectangles.zip")
download_and_unzip("http://gis.ices.dk/shapefiles/ICES_areas.zip")
download_and_unzip("https://www.nafo.int/Portals/0/GIS/Divisions.zip")


# The primary geometry in fixpos_feltkode is POINT. This is removed and instead
# the polygon geometry is used.
# The code is commented out because the source data isen't included in the
# package, in order to reduce its size.
# point_path   <- file.path(extdata_dir, 'fixpos_feltkode_point.dbf')
# polygon_path <- file.path(extdata_dir, 'fixpos_feltkode_polygon.dbf')
#
# point_sf <-
#   point_path %>%
#   read_sf() %>%
#   select(feltkode, fixpos, geom_wkt)
#
# point_sf %>%
#   st_drop_geometry() %>%
#   st_as_sf(wkt = "geom_wkt", crs = st_crs(point_sf)) %>%
#   st_write(polygon_path, driver = "ESRI Shapefile", delete_dsn = TRUE)
