# fisharea

<!-- badges: start -->
<!-- badges: end -->

The `fisharea` package classify which fishery administration areas a set of  coordinates lies within.

The user can choose from a series of fishery administration areas. 

The package doesn't do anything miraculous. It's just combines the shape files for the fishery areas, and the logic for determining if a point is inside a rectangle, in one package. 


## Installation

Install `fisharea` by running:

``` r
devtools::install_github("johan-ejstrud/fisharea")
```

## Example
``` r
library(fisharea)
fish_area(data.frame(lat = c(65.3, 40.0), 
                     lng = c(-39.3, -9.5)))
#> [1] "Greenland Sea" "Bay of Biscay and the Iberian Coast"
```

## GitHub page

https://github.com/johan-ejstrud/fisharea

## Citations

- ICES Spatial Facility, ICES, Copenhagen. (https://www.ices.dk/data/guidelines-and-policy/Pages/ICES-data-policy.aspx)

## Versioning

When a new version is ready
1. Run `devtools::check().
1. Run `usethis::use_version("patch/minor/major")`.
1. Update `NEWS.sh` and commit.
1. Run `./tag_release.sh`.
1. Open https://github.com/johan-ejstrud/buffersam/tags
1. Click 'Create release'.
1. Click 'Publish release'.
  p <-
    dplyr::tribble(~lat, ~lng, ~expect,
                   65.3, -39.3, "Greenland Sea",
                   40.0,  -9.5, "Bay of Biscay and the Iberian Coast",
                   38.2, -27.2, "Azores",
