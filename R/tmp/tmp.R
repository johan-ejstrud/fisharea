p <-
  dplyr::tribble(~lng, ~lat, ~expect,
                 65.3, -39.3, "Greenland Sea",
                 40.0,  -9.5, "Bay of Biscay and the Iberian Coast",
                 38.2, -27.2, "Azores",
                 41.0,   6.8, "Western Mediterranean Sea",
                 34.7,  20.3, "Ionian Sea and the Central Mediterranean Sea",
                 42.9,  34.5, "Black Sea",
                 42.9,  15.4, "Adriatic Sea",
                 33.0,  33.1, "Aegean-Levantine Sea",
                 55.0, -10.6, "Celtic Seas",
                 59.8,  26.7, "Baltic Sea",
                 56.5,   3.0, "Greater North Sea",
                 89.0,  40.0, "Arctic Ocean",
                 64.3, -23.8, "Icelandic Waters",
                 70.6,  43.0, "Barents Sea",
                 62.0,  -6.8, "Faroes",
                 70.8,  -8.0, "Norwegian Sea",
                 50.5, -17.3, "Oceanic Northeast Atlantic",
                 0,   0  , NA
  ) %>%
  sf::st_as_sf(coords = c("lat", "lng"), crs = sf::st_crs(ices_areas))

ggplot(ices_areas) +
  geom_sf() +
   geom_sf_label(aes(label = Ecoregion)) +
    geom_sf(data = p, color="red")
