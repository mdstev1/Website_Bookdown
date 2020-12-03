load("master.Rda")
master_wells <- read.csv(file = 'master_wells.csv')
test_wells <- read.csv(file = 'test_wells.csv')

test_ts_3mon <- data.frame(c())
for (well in test_wells$mergeOn){
  ts <- filter(master, mergeOn == well)
  w3mon_ts <- ts %>%
    mutate(date = lubridate::floor_date(date, "3 months"), mergeOn = mergeOn) %>%
    group_by(date, mergeOn) %>%
    summarize(Mean_depth=-1*mean(depth.to.GW..ft.))
  test_ts_3mon <- as.data.frame(rbind(test_ts_3mon, yr_ts))
  #assign(paste(well, "_3mon_ts", sep = ""), mon_ts)
}

# Now let's create time series graphs of these yearly means
test_ts_3mon %>%
  ggplot(aes(x = date, y = Mean_depth)) + 
  geom_line() +
  xlab("Date") +
  ylab("Depth (ft)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~mergeOn)


well_lat <- mean(filter(test_wells, mergeOn != well)$lat)
well_long <- mean(filter(test_wells, mergeOn != well)$lon)


library(ncdf4)
climate_output <- nc_open("pdsi.mon.mean.nc")
climate_output_sc <- nc_open("pdsi.mon.mean.selfcalibrated.nc")
print(climate_output_sc)

lat <- ncvar_get(climate_output_sc,"lat")
lon <- ncvar_get(climate_output_sc,"lon")
time <- ncvar_get(climate_output_sc,"time")
tail(time)
tunits <- ncatt_get(climate_output_sc,"time","units")
tunits
pdsi_array <- ncvar_get(climate_output_sc,"pdsi")
dim(pdsi_array)
pdsi_array[,,1980]
ncd_lon <- which(abs(lon-well_long)==min(abs(lon-well_long)))
lon[ncd_lon]
ncd_lat <- which(abs(lat-well_lat)==min(abs(lat-well_lat)))
lat[ncd_lat]


# This is just code to demonstrate how to work with the dates in the netCDF
st_date <- as.Date("1800-01-01")
date <- as.Date("2012-01-01")
date_diff <- as.numeric((date-st_date)*24)
which(time == date_diff)
as.Date(date_diff/24, origin = "1800-01-01")


# ELM CODE

# generate random input weights, W1
#W1=np.random.normal(size=[N, h]) # np is the numpy library
W1 <- matrix(rnorm(1*500), 1, 500) 
# X is a matrix of input training data, size MxN
# M is number of time steps 
# N is the number of input time series (17 in our case)
# h is the number of neurons (500 in our case)

# generate bias vector, b
#b=np.random.normal(size=[h])
b <- rnorm(500)

# generate the A matrix (Eq 6)
#a=np.dot(X,W1)+b 
X <- pdsi_array[ncd_lon,ncd_lat,]
X <- mutate(as.data.frame(X), PDSI = X, date = time, .keep = "none")
X$date <- as.Date(X$date/24, origin = "1800-01-01")

# Create a ts file of the PDSI data with 3 month averages and a time frame lining up with the well data
ncdf_ts <- c()
ncdf_ts <- X %>%
  mutate(date = lubridate::floor_date(date, "3 months")) %>%
  group_by(date) %>%
  summarize(PDSI=mean(PDSI)) %>%
  subset(date %in% test_ts_3mon$date)
Y <- subset(w3mon_ts, date %in% ncdf_ts$date)
X <- subset(X, date %in% Y$date)


# Dot product
a <- (ncdf_ts$PDSI %*% W1)
ab <- a + rep(b, each = nrow(a))
#theta=np.maximum(a,0,a) # basis function
A <- pmax(ab, 0)

# compute the output weights, W2
# I=np.identity(N) # generate an identity matrix, NxN
I = diag(1)
lamb = 100
lamb*I

# fit using numpy library, uses a Moore-Penrose pseudoinverse of the matrix
#W2=np.linalg.lstsq(theta.T.dot(theta) + lamb * I, theta.T.dot(Y)[0] 
# lamb is the regularization parameter (in our case 100)
  # Y are the observed well data
  # this is from Eq 8
W1 <- limsquare_function(t(A) %*% A + lamb*I, t(A) %*% Y)

# Predict – X is a matrix of Earth observation data, W1, W2, and b are saved from above
  # a=np.dot(X,W1)+b 
  # theta=np.maximum(a,0,a) # basis function 
  # Y_imputed= np.dot(theta,W2)
  
# Y_imputed needs to be re-scaled before use
