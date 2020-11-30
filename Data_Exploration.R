# The file "jpl_master_edited.csv" was too large to commit to Github. 
# The data frame "master" contains all data from the original csv:
  #master <- read.csv("jpl_master_edited.csv")[,1:9]
  #master$depth.to.GW..ft. <- as.numeric(master$depth.to.GW..ft.)
  #master$date <- as.Date(master$date, format = "%m/%d/%y")
library(leaflet)
library(dplyr)
library(ggplot2)
library(jpeg)
library(geojsonio)
library(sf)
library(spatialEco)
library(tidyverse)
library(data.table)
library(lubridate)
load("master.Rda")
head(master)

# Create a histogram of the entire dataset
hist(master$date, 'years', xlab = "Date", freq = TRUE, format = "%Y")

# Create a master list of all wells
master_wells <- distinct(master, mergeOn, .keep_all = TRUE)[,1:7]
# we must keep some columns as chr b/c some have letters
master_wells$NDI <- as.character(master_wells$NDI)

# Create a leaflet map of all wells
master_wells %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(lng = ~lon, 
             lat = ~lat, 
             popup = ~NDI, 
             clusterOptions = markerClusterOptions())

# Load in a geojson file that outlines the central valley
# CV_shape <- FROM_GeoJson(url_file_string = "CA_Bulletin_118_Aquifer_Regions_dissolved.geojson")
CV_shape <- geojsonio::geojson_read("CA_Bulletin_118_Aquifer_Regions_dissolved.geojson", what = "sp")

# Create another leaflet map of wells that have at least 180
leaflet() %>%
  addTiles() %>%
  addPolygons(data = CV_shape, stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1) %>%
  addMarkers(data = master_wells,
              lng = ~lon, 
              lat = ~lat, 
              popup = ~NDI, 
              clusterOptions = markerClusterOptions())

# Create a master_wells.csv file
write.csv(master_wells, file = "master_wells.csv")

# Find datasets that have at least 180 observations (enough data points for monthly data across 15 years)
master_count <- as.data.frame(table(master$mergeOn))

w180_merge <- master_count %>%
  filter(Freq > 180) %>%
  merge(master_wells, by.x = "Var1", by.y = "mergeOn") %>%
  rename(mergeOn = Var1)

# Find 180 wells that fall within CV boundaries
pts <- st_as_sf(x = w180_merge, coords = c("lon", "lat"))
st_crs(pts) <- st_crs(CV_shape)
CV_shape <- st_as_sf(x = CV_shape)


CV_wells <- CV_shape %>%
  st_intersection(pts) %>%
  extract(col = geometry, into = c('long', 'lat'), '\\((.*), (.*)\\)', convert = TRUE) %>%
  as.data.frame() %>%
  subset(select = -c(Basin_Name, Shape_Length, Shape_Area, geometry)) %>%
  subset(select = -c(geometry))


# Next, we need to find the wells that have data that span across at least 15 years.
  ## In addition, we would like to find data with an adequate distribution:
    ### We'll do this by finding data with at least 12 data points per year. 
w15 <- data.frame(c())
for (well in CV_wells$mergeOn) {
  ts <- filter(master, mergeOn == well)
  diff <- as.integer(max(ts$date) - min(ts$date))
  yr_dist <- as.data.frame(table(year(ts$date)))
  add <- TRUE
  if (diff > 5475){
    for (yr in yr_dist$Freq) {
      if (yr < 12){
        add = FALSE
      }
      if(yr > nrow(ts)/nrow(yr_dist)*2){
        add = FALSE
      }
    }
    if (add == TRUE) {
      w15 <- rbind(w15, well)}
  }
}

# This creates a dataframe with data spanning 15 years
w15 <- w15 %>%
  rename(mergeOn = colnames(w15)) %>%
  merge(CV_wells, by = "mergeOn")

# Create another leaflet map...
leaflet() %>%
  addTiles() %>%
  addPolygons(data = CV_shape, stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1) %>%
  addMarkers(data = w15,
             lng = ~long, 
             lat = ~lat, 
             popup = ~mergeOn
             )

# We identified the 5 wells that we'd like to use
test_wells <- c('19N01W32E003M', 
                '19N02E13Q001M', 
                '18N02W18D004M', 
                '18N01W02E002M',
                '19N01E35B001M')

# Create a histogram of observations by year for each well
for (well in test_wells){
  ts <- filter(master, mergeOn == well)
  hist(ts$date, 'years', xlab = "Date", freq = TRUE, format = "%Y", main = well)
}


# Create a histogram of observations by year for all 4 wells
ts <- subset(master, mergeOn %in% test_wells)
hist(ts$date, 'years', xlab = "Date", freq = TRUE, format = "%Y")


