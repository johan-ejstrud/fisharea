test_that("identify fish areas", {
  p <-
    dplyr::tribble(
                     ~lat,  ~lon,                       ~ices_ecoregion, ~ices_area, ~nafo_division,  ~feltkode,   ~fixpos,
                     65.3, -39.3,                       "Greenland Sea",   "14.b.2",             NA,    "JP075", "JP07509",
                       40,  -9.5, "Bay of Biscay and the Iberian Coast",      "9.a",             NA,         NA,        NA,
                     38.2, -27.2,                              "Azores",   "10.a.2",             NA,         NA,        NA,
                       55, -10.6,                         "Celtic Seas",      "6.a",             NA,         NA,        NA,
                     59.8,  26.7,                          "Baltic Sea",   "3.d.32",             NA,         NA,        NA,
                     62.9, -26.8,                    "Icelandic Waters",    "5.a.1",             NA,    "HP125", "HP12512",
                     70.6,    43,                         "Barents Sea",      "1.b",             NA,         NA,        NA,
                     61.8,  -7.1,                              "Faroes",  "5.b.1.b",             NA,         NA,        NA,
                     67.8,  -0.7,                       "Norwegian Sea",    "2.a.1",             NA,         NA,        NA,
                     50.5, -20.8,          "Oceanic Northeast Atlantic",     "12.c",             NA,         NA,        NA,
                     47.6, -62.8,                                    NA,         NA,           "4T",         NA,        NA,
                       64, -52.6,                                    NA,         NA,           "1D",         NA,        NA,
                        0,     0,                                    NA,         NA,             NA,         NA,        NA
                     )

  expect_equal(fisharea(p),                            p$ices_area)
  expect_equal(fisharea(p, region = "ICES ecoregion"), p$ices_ecoregion)
  expect_equal(fisharea(p, region = "NAFO division"),  p$nafo_division)
  expect_equal(fisharea(p, region = "Feltkode"),       p$feltkode)
  expect_equal(fisharea(p, region = "Fixpos"),         p$fixpos)
})

test_that("list is converted to vector", {
  input <- list("a", character(0), "b", NA)
  expect <-   c("a", NA, "b", NA)

  expect_equal(list_to_vector_convert_na(input), expect)
})

test_that("an sf object is returned", {
  areas <- fisharea_sf("ICES areas")

  expect_equal(class(areas), c("sf", "tbl_df", "tbl", "data.frame"))
})
