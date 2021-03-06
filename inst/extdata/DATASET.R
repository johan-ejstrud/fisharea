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
