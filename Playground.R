library(sf)
library(tidyverse)

pts <- st_as_sf(x = w240_merge,
                coords = c("lon", "lat")
                )
st_crs(pts) <- st_crs(CV_shape)

new_CV_shape <- st_as_sf(x = CV_shape)

new_shape <- new_CV_shape %>%
  st_intersection(pts) %>%
  extract(col = geometry, into = c('long', 'lat'), '\\((.*), (.*)\\)', convert = TRUE)



library(data.table)
dt <- fread("listing_id    date    city    type    host_id availability
703451  25/03/2013  amsterdam   Entire_home/apt 3542621 245
703451  20/04/2013  amsterdam   Entire_home/apt 3542621 245
703451  28/05/2013  amsterdam   Entire_home/apt 3542621 245
703451  15/07/2013  amsterdam   Entire_home/apt 3542621 245
703451  30/07/2013  amsterdam   Entire_home/apt 3542621 245
703451  19/08/2013  amsterdam   Entire_home/apt 3542621 245")
dt$date <- as.Date(dt$date, "%d/%m/%Y")
