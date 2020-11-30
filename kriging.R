kriging


#IDW
library(gstat)
library(sp)

lat <-  c(36.09, 36.20, 36.27, 36.36)
long <- c(-120.12, -119.91, -120.18, -119.59)
depth <- c(8.222411, 8.19931, 8.140428, 8.100752)

sample <- data.frame(lat, long, depth)
coordinates(sample) = ~long+lat
proj4string(sample) <- CRS("+proj=longlat +datum=WGS84")

loc <- data.frame(long = -119.90, lat = 36.38)
coordinates(loc)  <- ~ long + lat
proj4string(loc) <- CRS("+proj=longlat +datum=WGS84")

oo <- idw(formula=depth ~ 1, locations = sample, newdata = loc, idp = 2.0)
oo@data$var1.pred
