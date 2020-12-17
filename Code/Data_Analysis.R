library(ggplot2)
library(dplyr)
library(data.table)


# Load in the datasets created in the last section
load("master.Rda")
master_wells <- read.csv(file = 'master_wells.csv')
test_wells <- read.csv(file = 'test_wells.csv')


# Create dataset with all well data in 3 month increments
test_ts_3mon <- data.frame(c())
for (well in test_wells$mergeOn){
  ts <- filter(master, mergeOn == well)
  w3mon_ts <- ts %>%
    mutate(date = lubridate::floor_date(date, "3 months"), mergeOn = mergeOn) %>%
    group_by(date, mergeOn) %>%
    summarize(Mean_depth=-1*mean(depth.to.GW..ft.))
  test_ts_3mon <- as.data.frame(rbind(test_ts_3mon, w3mon_ts))
  #assign(paste(well, "_3mon_ts", sep = ""), mon_ts)
}
test_ts_3mon <- merge(test_ts_3mon, test_wells, by = "mergeOn")
test_ts_3mon$WTE <- test_ts_3mon$Elev + test_ts_3mon$Mean_depth
test_ts_3mon <- subset(test_ts_3mon, select = -c(X))
write.csv(test_ts_3mon, file = "test_ts_3mon.csv")

# Now let's create time series graphs of these yearly means
test_ts_3mon %>%
  ggplot(aes(x = date, y = Mean_depth)) + 
  geom_line() +
  xlab("Date") +
  ylab("Depth (ft)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~mergeOn)

# Create lat/long objects that will be used to obtain the proper pdsi data.
well_lat <- mean(filter(test_wells, mergeOn == well)$lat)
well_long <- mean(filter(test_wells, mergeOn == well)$lon)

# Store pdsi data in dataframe and print metadata
library(ncdf4)
climate_output_sc <- nc_open("Data/pdsi.mon.mean.selfcalibrated.nc")
print(climate_output_sc)

# Obtain the lat,long, and time arrays from the data
lat <- ncvar_get(climate_output_sc,"lat")
lon <- ncvar_get(climate_output_sc,"lon")
time <- ncvar_get(climate_output_sc,"time")
# tail(time)
# tunits <- ncatt_get(climate_output_sc,"time","units")
# tunits

# Obtain pdsi data and store in array
pdsi_array <- ncvar_get(climate_output_sc,"pdsi")
dim(pdsi_array)
head(pdsi_array[,,1980])
# Find the lat/long coordinates that are closest to the average well_long and well_lat
ncd_lon <- which(abs(lon-well_long)==min(abs(lon-well_long)))
lon[ncd_lon]
ncd_lat <- which(abs(lat-well_lat)==min(abs(lat-well_lat)))
lat[ncd_lat]


# This is code to demonstrate how to work with the dates in the netCDF
st_date <- as.Date("1800-01-01")
date <- as.Date("2012-01-01")
date_diff <- as.numeric((date-st_date)*24)
which(time == date_diff)
as.Date(date_diff/24, origin = "1800-01-01")


# ELM CODE

# generate random input weights, W1
#W1=np.random.normal(size=[N, h]) # np is the numpy library
W1 <- matrix(rnorm(1*500), 1, 500) 
# X is a matrix of input training data, size MxN  (this is M columns by N rows)
# M is number of time steps 
# N is the number of input time series (17 in our case)
# h is the number of neurons (500 in our case)

# generate bias vector, b
#b=np.random.normal(size=[h])
b <- rnorm(500)

# Create a time series of the PDSI data for the selected lat/long
ncdf_ts <- pdsi_array[ncd_lon,ncd_lat,]
ncdf_ts <- mutate(as.data.frame(ncdf_ts), PDSI = ncdf_ts, date = time, .keep = "none")
ncdf_ts$date <- as.Date(ncdf_ts$date/24, origin = "1800-01-01")

# Create a ts file of the PDSI data with 3 month averages and a time frame lining up with the well data
X <- c()
X <- ncdf_ts %>%
  mutate(date = lubridate::floor_date(date, "3 months")) %>%
  group_by(date) %>%
  summarize(PDSI=mean(PDSI)) %>%
  subset(date %in% w3mon_ts$date)
Y <- subset(w3mon_ts, date %in% X$date)
Y <- Y$Mean_depth

# generate the A matrix (Eq 6)
#a=np.dot(X,W1)+b 
# Dot product
a <- (X$PDSI %*% W1)
ab <- a + rep(b, each = nrow(a))
#theta=np.maximum(a,0,a) # basis function
A <- pmax(ab, 0)

# compute the output weights, W2
# I=np.identity(N) # generate an identity matrix, NxN
I = diag(1)
lamb = 100
lamb_I <- lamb*I

# fit using numpy library, uses a Moore-Penrose pseudoinverse of the matrix
#W2=np.linalg.lstsq(theta.T.dot(theta) + lamb * I, theta.T.dot(Y)[0] 
# lamb is the regularization parameter (in our case 100)
  # Y are the observed well data
  # this is from Eq 8
W2 <- solve(t(A) %*% A + rep(lamb_I, each = nrow(t(A))), t(A) %*% Y)
test <- t(A) %*% A

# Predict – X is a matrix of Earth observation data, W1, W2, and b are saved from above
  # a=np.dot(X,W1)+b  this is X dot W1
  # theta=np.maximum(a,0,a) # basis function 
  # Y_imputed= np.dot(theta,W2)
  
# Y_imputed needs to be re-scaled before use
