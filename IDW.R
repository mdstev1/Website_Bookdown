#IDW
library(gstat)
library(sp)

test_ts_yr[,"year"] <- format(test_ts_yr[,"date"], "%Y")

filter(test_wells, mergeOn != well)$lat

yr=2012
depth <- test_ts_yr %>%
  filter(mergeOn != well) %>%
  filter(year == yr) %>%
  select(Mean_depth) %>%
  as.list()

yrs <- c(2012:2015)
interp_values <- as.data.frame(c())

for (well in test_wells$mergeOn){
  for (yr in yrs){
    lat <- filter(test_wells, mergeOn != well)$lat
    long <- filter(test_wells, mergeOn != well)$lon
    depth <- test_ts_yr %>%
      filter(mergeOn != well) %>%
      filter(year == yr) %>%
      select(Mean_depth) %>%
      as.list()
    sample <- data.frame(lat, long, depth)
    coordinates(sample) = ~long+lat
    proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")
    loc <- data.frame(
      long = filter(test_wells, mergeOn == well)$lon, 
      lat = filter(test_wells, mergeOn == well)$lat)
    coordinates(loc)  <- ~ long + lat
    proj4string(loc) <- CRS("+proj=longlat +datum=WGS84")
    new <- idw(formula=Mean_depth ~ 1, locations = sample, newdata = loc, idp = 2.0)
    interp_values <- rbind(interp_values, c(well, yr, new@data$var1.pred)
  }
}
colnames(interp_values) <- c("mergeOn", "year", "value")

lat <- filter(test_wells, mergeOn != well)$lat
long <- filter(test_wells, mergeOn != well)$lon
depth <- test_ts_yr %>%
  filter(mergeOn != well) %>%
  filter(year == yr) %>%
  select(Mean_depth) %>%
  as.list()
sample <- data.frame(lat, long, depth)
coordinates(sample) = ~long+lat
proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")
loc <- data.frame(
  long = filter(test_wells, mergeOn == well)$lon, 
  lat = filter(test_wells, mergeOn == well)$lat)
coordinates(loc)  <- ~ long + lat
proj4string(loc) <- CRS("+proj=longlat +datum=WGS84")
new <- idw(formula=Mean_depth ~ 1, locations = sample, newdata = loc, idp = 2.0)
new@data$var1.pred
interp_values <- c(well, yr, new@data$var1.pred)
interp_values <- rbind(interp_values, c(well, yr)
rbind(interp_values, c(well, yr, new@data$var1.pred))
interp_values



lat <-  test_wells$lat
long <- test_wells$lon
depth <- filter(test_ts_yr, date == "2012-01-01") %>%
  select(Mean_depth) %>%
  as.list()

sample <- data.frame(lat, long, depth)
coordinates(sample) = ~long+lat
proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")

loc <- data.frame(long = -119.90, lat = 36.38)
coordinates(loc)  <- ~ long + lat
proj4string(loc) <- CRS("+proj=longlat +datum=WGS84")

oo <- idw(formula=Mean_depth ~ 1, locations = sample, newdata = loc, idp = 2.0)
oo@data$var1.pred
