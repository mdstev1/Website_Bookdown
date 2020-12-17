# library(gstat)
# library(sp)
library(Metrics)
library(dplyr)

# Load the datasets created previously
load("master.Rda")
master_wells <- read.csv(file = 'master_wells.csv')
test_wells <- read.csv(file = 'test_wells.csv')
test_ts_3mon <- read.csv(file = 'test_ts_3mon.csv')

# Extract the year from the date column
test_ts_3mon[,"date"] <- as.Date(test_ts_3mon[,"date"])

# Create the dates list that we want to interpolate
dates <- c("2012-01-01", "2012-04-01", "2012-07-01", "2012-10-01", 
           "2013-01-01", "2013-04-01", "2013-07-01", "2013-10-01",
           "2014-01-01", "2014-04-01", "2014-07-01", "2014-10-01",
           "2015-01-01", "2015-04-01", "2015-07-01", "2015-10-01")

library(dplyr)
# Loop through and perform the IDW calculation for each well at each time step
interp_values <- as.data.frame(c())
for (well in test_wells$mergeOn){
  for (dt in dates){
    sample <- test_ts_3mon %>%
      filter(mergeOn != well) %>%
      filter(date == dt) %>%
      select(-lat, -lon, -Elev) %>%
      merge(test_wells, by = "mergeOn") %>%
      select(mergeOn, date, lat, lon, Elev, Mean_depth, WTE)
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
}

# Rename the columns and set to proper data types
colnames(interp_values) <- c("mergeOn", "date", "WTE_IDW")
interp_values$date <- as.Date(interp_values$date)
interp_values$WTE_IDW <- as.numeric(interp_values$WTE_IDW)

# Create new dataset that combines observed values with IDW values
comp_data <- merge(interp_values,test_ts_3mon,by=c("mergeOn","date"))
comp_data_experiment <- test_ts_3mon %>%
  filter(mergeOn == well) %>%
  left_join(interp_values,by=c("date", "mergeOn"))

# Plot all observed values vs. the IDW values for Well 29N03W18M001M
library(ggplot2)
comp_data_experiment %>%
  ggplot(aes(x = date)) + 
  geom_line(aes(y = WTE, color = "steelblue")) +
  geom_line(aes(y = WTE_IDW, color = "orange")) +
  scale_color_discrete(name = "", labels = c("IDW Data", "Observed Data")) +
  xlab("Date") +
  ylab("Water Table Elevation (ft above sea level)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "bottom")

# Plot 2012-2015 observed values vs. the IDW values
comp_data %>%
  ggplot(aes(x = date)) + 
  geom_line(aes(y = WTE, color = "steelblue")) +
  geom_line(aes(y = WTE_IDW, color = "orange")) +
  scale_color_discrete(name = "", labels = c("IDW Data", "Observed Data")) +
  xlab("Date") +
  ylab("Water Table Elevation (ft above sea level)") +
  ggtitle("All Wells") +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "bottom") +
  facet_wrap(~mergeOn)

# Calculate a set of error metrics for each well's data
library(Metrics)
error_metrics_summary <- data.frame()
for (well in test_wells$mergeOn) {
  comp_data_well <- comp_data %>%
    filter(mergeOn == well)
  rmse_error <-rmse(comp_data_well$WTE, comp_data_well$WTE_IDW)
  rsq <- cor(comp_data_well$WTE, comp_data_well$WTE_IDW)^2
  error_metrics_summary <- rbind(error_metrics_summary, c(well, rmse_error, rsq))
}
colnames(error_metrics_summary) <- c("Well ID", "RMSE", "R^2")
error_metrics_summary$RMSE <- as.numeric(error_metrics_summary$RMSE)
error_metrics_summary$'R^2' <- as.numeric(error_metrics_summary$'R^2')
error_metrics_summary[,-1] <-round(error_metrics_summary[,-1],3)
View(error_metrics_summary)


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
