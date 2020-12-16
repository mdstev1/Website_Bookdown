#IDW
library(gstat)
library(sp)

# Load the datasets created previously
load("master.Rda")
master_wells <- read.csv(file = 'master_wells.csv')
test_wells <- read.csv(file = 'test_wells.csv')
test_ts_3mon_IDW <- read.csv(file = 'test_ts_3mon.csv')

# Extract the year from the date column
test_ts_3mon_IDW[,"date"] <- as.Date(test_ts_3mon_IDW[,"date"])
test_ts_3mon_IDW[,"year"] <- format(test_ts_3mon_IDW[,"date"], "%Y")

# filter(test_wells, mergeOn != well)$lat


dates <- c("2012-01-01", "2012-04-01", "2012-07-01", "2012-10-01", 
           "2013-01-01", "2013-04-01", "2013-07-01", "2013-10-01",
           "2014-01-01", "2014-04-01", "2014-07-01", "2014-10-01",
           "2015-01-01", "2015-04-01", "2015-07-01", "2015-10-01"
)
interp_values <- as.data.frame(c())
# Loop through and perform the IDW calculation for each well at each time step
#for (well in test_wells$mergeOn){
  for (dt in dates){
    sample <- test_ts_3mon_IDW %>%
      filter(mergeOn != well) %>%
      filter(date == dt) %>%
      select(-lat, -lon, -Elev) %>%
      merge(test_wells, by = "mergeOn") %>%
      select(mergeOn, date, lat, lon, year, Elev, Mean_depth, WTE)
    coordinates(sample) = ~lon+lat
    proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")
    poi <- data.frame(
      lon_poi = filter(test_wells, mergeOn == well)$lon, 
      lat_poi = filter(test_wells, mergeOn == well)$lat)
    coordinates(poi)  <- ~ lon_poi + lat_poi
    proj4string(poi) <- CRS("+proj=longlat +datum=WGS84")
    new <- idw(formula=WTE ~ 1, locations = sample, newdata = poi, idp = 2.0)
    interp_values <- rbind(interp_values, c(well, dt, new@data$var1.pred))
  }
#}

# Rename the columns and set to proper data types
colnames(interp_values) <- c("mergeOn", "date", "WTE_IDW")
interp_values$date <- as.Date(interp_values$date)
interp_values$WTE_IDW <- as.numeric(interp_values$WTE_IDW)

# Create new dataset that combines observed values with IDW values
comp_data <- merge(interp_values,test_ts_3mon_IDW,by=c("mergeOn","date"))
comp_data_experiment <- test_ts_3mon_IDW %>%
  filter(mergeOn == well) %>%
  left_join(interp_values,by=c("date"))

# Plot the observed values vs. the IDW values
comp_data_experiment %>%
  ggplot(aes(x = date)) + 
  geom_line(aes(y = WTE), color = "steelblue") +
  geom_line(aes(y = WTE_IDW), color = "orange") +
  xlab("Date") +
  ylab("Water Table Elevation (ft above sea level)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5))
  #facet_wrap(~mergeOn)

comp_data %>%
  ggplot(aes(x = date)) + 
  geom_line(aes(y = WTE), color = "steelblue") +
  geom_line(aes(y = WTE_IDW), color = "orange") +
  xlab("Date") +
  ylab("Water Table Elevation (ft above sea level)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5))
#facet_wrap(~mergeOn)


# yr=2012
# dt="2012-10-01"
# sample <- test_ts_3mon_IDW %>%
#   filter(mergeOn != well) %>%
#   filter(year == yr) %>%
#   filter(date == dt) %>%
#   select(-lat, -lon, -Elev) %>%
#   merge(test_wells, by = "mergeOn") %>%
#   select(mergeOn, date, lat, lon, year, Elev, Mean_depth, WTE)
# coordinates(sample) = ~lon+lat
# proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")
# poi <- data.frame(
#   lon_poi = filter(test_wells, mergeOn == well)$lon, 
#   lat_poi = filter(test_wells, mergeOn == well)$lat)
# coordinates(poi)  <- ~ lon_poi + lat_poi
# proj4string(poi) <- CRS("+proj=longlat +datum=WGS84")
# new <- idw(formula=WTE ~ 1, locations = sample, newdata = poi, idp = 2.0)
# new@data$var1.pred

# interp_values <- c()
# interp_values <- rbind(interp_values, c(well, yr, new@data$var1.pred))


# lat <-  test_wells$lat
# long <- test_wells$lon
# depth <- filter(test_ts_yr, date == "2012-01-01") %>%
#   select(Mean_depth) %>%
#   as.list()
# 
# sample <- data.frame(lat, long, depth)
# coordinates(sample) = ~long+lat
# proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")
# 
# loc <- data.frame(long = -119.90, lat = 36.38)
# coordinates(loc)  <- ~ long + lat
# proj4string(loc) <- CRS("+proj=longlat +datum=WGS84")
# 
# oo <- idw(formula=Mean_depth ~ 1, locations = sample, newdata = loc, idp = 2.0)
# oo@data$var1.pred


# lat <- filter(test_wells, mergeOn != well)$lat
# long <- filter(test_wells, mergeOn != well)$lon
# depth <- test_ts_3mon_IDW %>%
#   filter(mergeOn != well) %>%
#   filter(year == yr) %>%
#   select(Mean_depth) %>%
#   as.list()
# sample <- data.frame(lat, long, depth)
