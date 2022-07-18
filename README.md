# fisharea

<!-- badges: start -->
<!-- badges: end -->

The `fisharea` package classify which fishery administration areas a set of  coordinates lies within.

The user can choose from a series of fishery administration areas. See `?fisharea::fisharea` for complete list.

The package doesn't do anything miraculous. It's just combines the shape files for the fishery areas, with the logic for determining if a point is inside a rectangle.


## Installation

Install `fisharea` by running:

``` r
devtools::install_github("johan-ejstrud/fisharea")
```

## Example
``` r
library(fisharea)
p <- data.frame(lat = c(65.3, 40.0), 
                lon = c(-39.3, -9.5))
fisharea(p)
> [1] "14.b.2" "9.a"

fisharea(p, region = "ICES statistical rectangles")
> [1] "59B0" "08E0"
```

## GitHub page

https://github.com/johan-ejstrud/fisharea

## Citations

- ICES Spatial Facility, ICES, Copenhagen. (https://www.ices.dk/data/guidelines-and-policy/Pages/ICES-data-policy.aspx)

## Versioning

When a new version is ready
1. Run `devtools::check()`.
1. Run `usethis::use_version("patch/minor/major")`.
1. Update `NEWS.md` and commit.
1. Run `./tag_release.sh`.
1. Open https://github.com/johan-ejstrud/fisharea/tags
1. Click 'Create release'.
1. Click 'Publish release'.
