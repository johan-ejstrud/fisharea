#Script for assigning ICES Subarea to positions. Currently only works for a couple of ICES areas (14 and 2) at a time. This can quite fast be changed.
#Gives TRUE/FALSE whether positions are within an ICES Subarea. This should be modified so it contains a loop that goes through all possible subareas at a time.
#But I have not found the time to do this yet. Feel free to do that!:)

#Author: Søren Post, GN, May 2022.
#R-version: 4.1.0

#######################################################################-
library(rgdal); library(raster);
library(ggplot2) # fortify() function.
library(rgeos) #gContains() function for checking if points are within polygons (more advanced polygons).

my_spdf <- readOGR(
  #dsn= paste0(getwd(),"/DATA/world_shape_file/") ,
  dsn= ".../Qgis/Boundaries_zones/ICES_areas",
  layer="ICES_Areas_20160601_cut_dense_3857",
  verbose=FALSE
)

summary(my_spdf)
crs(my_spdf) #Check the projection

#Reproject so points with lat and lon can be plotted on this layer
#sp_ICES_Subareas_reprojected  <- spTransform(my_spdf, CRS("+proj=longlat +datum=WGS84"))

#Prepare polygons. #Start by investigating if a station is within one single subarea
#Example on "https://stackoverflow.com/questions/21971447/check-if-point-is-in-spatial-object-which-consists-of-multiple-polygons-holes"
#Projection stuff so polygons matches lat and lon format.
subArea_EastGr_14b2 <- my_spdf[my_spdf$SubArea==14 & my_spdf$Division=='b' & my_spdf$SubDivisio==2,]
subArea_EastGr_14b2 <- spTransform(subArea_EastGr_14b2, CRS("+proj=longlat +datum=WGS84"))
subArea_2a_1 <- my_spdf[my_spdf$SubArea==2 & my_spdf$Division=='a' & my_spdf$SubDivisio==1,]
subArea_2a_1 <- spTransform(subArea_2a_1, CRS("+proj=longlat +datum=WGS84"))
subArea_2a <- my_spdf[my_spdf$SubArea==2 & my_spdf$Division=='a' ,]
subArea_2a <- spTransform(subArea_2a, CRS("+proj=longlat +datum=WGS84"))
#Need to do this for all areas.

sp_SubArea <- subArea_EastGr_14b2 # Choose subarea of interest
# sp_SubArea <- subArea_2a_1
# sp_SubArea <- subArea_2a

nPolys <- sapply(sp_SubArea@polygons, function(x)length(x@Polygons))
region <- sp_SubArea
#region <- sp_SubArea[which(nPolys==max(nPolys)),]
region.df <- fortify(region) #' Convert the shapefile into a data frame with 'fortify'. Not really necessary at this point.

xy <- data.frame(c(-0.158,-38,-38.01), c(64.7827,65,65.01)) #Just to check if some known positions are within the area. 3 positions, in 2a, 14b2 and 14b2.
#xy <- cbind(dfCommercialData_Spatial$Lon, dfCommercialData_Spatial$Lat) #SP: my own data set
names(xy)[1] <- 'Lon' ; names(xy)[2] <- 'Lat'

#xy$id <- 'id_name' #Make unique entrance so observations can be recognized.
# sapply(1:nrow(xy),function(i)
#   list(id=xy[i,]$id,
#        gContains(region,SpatialPoints(xy[i,1:2],proj4string=CRS(proj4string(region))))))
int_InPolygon <- sapply(1:nrow(xy),function(i)
  gContains(region,SpatialPoints(xy[i,1:2],proj4string=CRS(proj4string(region)))))

int_In2a_1 <- sapply(1:nrow(xy),function(i)
  gContains(subArea_2a_1,SpatialPoints(xy[i,1:2],proj4string=CRS(proj4string(region)))))

int_14b2 <- sapply(1:nrow(xy),function(i)
  gContains(subArea_EastGr_14b2,SpatialPoints(xy[i,1:2],proj4string=CRS(proj4string(region)))))
#Get a warning about CRS object. I think/hope this can just be ignored.

xy$in_ICES_Subarea <- int_InPolygon
names(xy)[3] <- paste("in_ICES_Subarea",unique(region$Area_27), sep="_")

xy$in_ICES_Subarea <- int_In2a_1
names(xy)[4] <- paste("in_ICES_Subarea",unique(subArea_2a_1$Area_27), sep="_")

xy$in_ICES_Subarea <- int_14b2
names(xy)[5] <- paste("in_ICES_Subarea",unique(subArea_EastGr_14b2$Area_27), sep="_")

head(xy)

#Now make a script that completes this for all subareas..

