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
library(tidyverse)
library(data.table)
library(lubridate)
library(graphics)
load("code/master.Rda")
head(master)

# Create a histogram of the entire dataset
hist(master$date, 'years', xlab = "Date", freq = TRUE, format = "%Y")

# Create a master list of all wells
master_wells <- distinct(master, mergeOn, .keep_all = TRUE)[,1:7]
# we must keep some columns as chr b/c some have letters
master_wells$NDI <- as.character(master_wells$NDI)

# Load in a geojson file that outlines the central valley
CV_shape <- geojsonio::geojson_read("code/CA_Bulletin_118_Aquifer_Regions_dissolved.geojson", what = "sp")

# Create a leaflet map of the all wells in the dataset with the central valley outline
leaflet() %>%
  addTiles() %>%
  addPolygons(data = CV_shape, stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5) %>%
  addMarkers(data = master_wells,
              lng = ~lon, 
              lat = ~lat, 
              popup = ~NDI, 
              clusterOptions = markerClusterOptions())

# Create a master_wells.csv file
write.csv(master_wells, file = "master_wells.csv")

# Find datasets that have at least 180 observations (enough data points for monthly data across 15 years - this is just a screening value)
master_count <- as.data.frame(table(master$mergeOn))
w180 <- master_count %>%
  filter(Freq > 180) %>%
  merge(master_wells, by.x = "Var1", by.y = "mergeOn") %>%
  rename(mergeOn = Var1)

# Find 180 wells that fall within CV boundaries
  # We'll transform the w180 and CV_shape data objects to simple feature geometry objects
pts <- st_as_sf(x = w180, coords = c("lon", "lat"))
st_crs(pts) <- st_crs(CV_shape)
CV_shape <- st_as_sf(x = CV_shape)
  # Now we'll intersect the two data objects and create a data frame
CV_wells <- CV_shape %>%
  st_intersection(pts) %>%
  extract(col = geometry, into = c('long', 'lat'), '\\((.*), (.*)\\)', convert = TRUE) %>%
  as.data.frame() %>%
  subset(select = -c(Basin_Name, Shape_Length, Shape_Area, geometry)) %>%
  subset(select = -c(geometry))

# Next, we need to find the wells that have data that span across at least 15 years.
  ## In addition, we would like to find data with an adequate distribution:
    ### We'll do this by looping through the data to find wells with at least 12 data points per year. 
w15 <- list()
for (well in CV_wells$mergeOn) {
  ts <- filter(master, mergeOn == well)
  diff <- as.integer(max(ts$date) - min(ts$date))
  yr_dist <- as.data.frame(table(year(ts$date)))
  add <- TRUE
  if (diff > 5475){
    for (yr_freq in yr_dist$Freq) {
      if (yr_freq < 4){
        add = FALSE
      }
    }
    if (add == TRUE) {
      w15 <- append(w15, well)
      }
  }
}

# Next, we'll find wells that have at least one measurement every 3 months for 19 years
w76 <- data.frame(c())
for (well in w15){
  ts <- filter(master, mergeOn == well)
  mon_ts <- ts %>%
    mutate(dategroup = lubridate::floor_date(date, "3 months")) %>%
    group_by(dategroup) %>%
    summarize(Mean_depth=mean(depth.to.GW..ft.))
  if (nrow(mon_ts) >= 76){
    w76 <- rbind(w76, well)
  }
}

# This creates a dataframe with wells with data spanning 15 years
w76 <- w76 %>%
  rename(mergeOn = colnames(w76)) %>%
  merge(CV_wells, by = "mergeOn")


# Create another leaflet map of the wells that span 15+ years
leaflet() %>%
  addTiles() %>%
  addPolygons(data = CV_shape, stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5) %>%
  addMarkers(data = w76,
             lng = ~long, 
             lat = ~lat, 
             popup = ~mergeOn
             ) 

# From the map, we identified 5 wells that are grouped together.
test_wells <- c('25N03W11B003M', 
                '29N03W18M001M', 
                '24N02W29N004M', 
                '24N02W24D003M',
                '24N02W03B001M')

# Now we can create a time series list, histogram mosaic, and well list.
test_ts <- subset(master, mergeOn %in% test_wells)
ggplot(test_ts, aes(x=date)) +
  geom_histogram(bins = 19*4) +
  facet_wrap(~mergeOn)

test_wells <- subset(master_wells, mergeOn %in% test_wells)

# Final leaflet map with study area in red
leaflet() %>%
  addTiles() %>%
  addPolygons(data = CV_shape, stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5) %>%
  addMarkers(data = w76,
             lng = ~long, 
             lat = ~lat, 
             popup = ~mergeOn
  ) %>%
  addRectangles(lng1 = -121.4, lat1 = 38.6, lng2 = -122, lat2 = 39.1, color = "#ff0000", opacity = 0.9, fillColor = "transparent")


