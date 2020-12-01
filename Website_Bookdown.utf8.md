--- 
title: "An Analysis of Groundwater Levels in the Central Valley of California"
author: "Michael Stevens"
date: "2020-11-30"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "This website will act as a portfolio for my term project. The methodology, analysis, results, and conclusions will be discussed here."
---
--- 
title: "An Analysis of Groundwater Levels in the Central Valley of California"
author: "Michael Stevens"
date: "2020-11-30"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
biblio-style: apalike
link-citations: yes
description: "This website will act as a portfolio for my term project. The methodology, analysis, results, and conclusions will be discussed here."
---

# Abstract

As groundwater is an essential and over-utilized resource in dry climates like the Western United States, responsibly managing this resource becomes crucial for sustainability. In-situ groundwater level data are often inconsistent, which makes temporal analysis difficult. There are many interpolation methods that can be used to fill in gaps in datasets. Evans, Williams, Jones, Ames, and Nelson (2020) demonstrated an effective imputation method for groundwater data, utilizing an Extreme Learning Machine (ELM). This study will explore the effectiveness of this approach in the Central Valley of California, an extremely productive agricultural area facing groundwater depletion challenges. A study compiled by NASA Jet Propulsion Lab (JPL) compiled a robust dataset of in-situ groundwater level data in the Central Valley. This dataset will be analyzed for appropriate test areas and wells to compare the efficacy of the ELM method in this region against the kriging spatial interpolation method.

<!--chapter:end:index.Rmd-->

# Introduction {#intro}


A study performed by the NASA Jet Propulsion Laboratory (JPL) compiled data entries from over a million wells in the central valley. From this list, representative wells (with a sufficient amount of measurements) were chosen for 1-km grids across the valley. This dataset includes measurements for the depth to groundwater at each well, measured across varying ranges and intervals of time. 

The data consists of 9 different variable. Five of these variables relate to the identification number of each well. Two variables relate to the spatial location (lat/long coordinates) of each well. The wells are distributed all across the Central Valley of California. The final two variables describe the date that each measurement was taken and the value of the measurement itself. The well data begins around 2001 and ends in 2019. Depth to groundwater varies from well to well, but is generally between 0 and 100 feet.

It will be necessary to retrieve ground surface elevation (GSE) data for each well so that the Water Table Elevation (WTE) can be determined, which is the difference between the GSE and the depth to groundwater.

In this study, these measurements will be trimmed down to a smaller area within the valley that will serve as a test case for our study. The area will be chosen based on the spatial and temporal robustness of its data.

<!--chapter:end:01-intro.Rmd-->

# Literature Review


Correctly characterizing groundwater levels and storage in an aquifer can be very difficult without a robust dataset. Often, in-situ data are collected at inconsistent intervals, while wells and monitoring stations are rarely distributed evenly. Because groundwater depends on so many different factors and does not exhibit linear behavior, finding ways to estimate groundwater levels without a complete set of in-situ data becomes a very important task. Some of these methods will be discussed here.  

Many of these methods utilize remote sensing data to analyze groundwater levels. A study performed by @THOMAS2017384 utilizes data from NASA’s Gravity Recovery and Climate Experiment (GRACE) mission to determine changes in groundwater. Satellites measure the changes in Earth’s gravitational field, due to changes in mass distribution, which can measure the redistribution of water. The study normalizes data collected by GRACE to measure changes in groundwater due to drought, which they call the GRACE Groundwater Drought Index (GGDI). Many measures can only account for climatological factors, but the GGDI is able to capture anthropogenic effects as well. This important for groundwater, which is often subjected to increased pumping during droughts. The method demonstrated an effective way to utilize remotely sensed data across a large area to measure groundwater response. However, the authors note that, due to GRACE’s temporal resolution, the GGDI can only be used with confidence to determine droughts after 3 months of indicated drought.  

There are other methods to utilize remotely sensed data to characterize groundwater. @piahs-372-23-2015 used remotely sensed data to track land subsidence during 2007-2014 of over 0.5 m in the San Joaquin Valley (which falls within the Central Valley of California). Land surface depressions were determined using Interferometric Synthetic Aperture Radar (InSAR) and in-situ data from extensometers and Continuous Global Positioning System (CGPS) data. This increase in subsidence coincided with an increase in groundwater pumping, due to drought. These findings agree with a study performed by @Vasco-2019, which analyzed a drop in vertical land surface in the Central Valley during 2015-2018, also observed using InSAR data. Their estimated decrease in groundwater storage in the Tulare basin was similar to other independent estimates, including that of the GRACE mission, another remote sensing data source. This provides reasonable assurances on the accuracy of the method for this area. These findings show promise for the efficacy of using remotely sensed data to measure changes in groundwater levels in the Central Valley.  

Another method for estimating groundwater levels is interpolating measurements based on in-situ data. Since many wells lack consistent and continuous measurements, statistical machine learning methods can be used to fill in these gaps. One such method is the Extreme Learning Machine (ELM), which was described by @HUANG-2006. The ELM is a type of machine learning that can map nonlinear relationships between input data sources. These correlations can then be used to determine missing values in one of the data sources. The ELM method was demonstrated to have a very fast learning time and is flexible to use in many different applications. This particular study has been cited over 7000 times. If the method can be demonstrably more effective and accurate than other methods of data imputation in a groundwater application, it could prove to be a very useful tool.  

This ELM method was demonstrated in a groundwater application in a recent study by @Evans-2019. They demonstrated a method to impute temporal gaps in groundwater data using remotely sensed Earth observation data and the in-situ data as the input datasets. Earth observation data sources included two soil moisture models: the Global Land Data Assimilation System (GLDAS) model and the NOAA Climate Prediction Center (CPC) model. It also included the Palmer Drought Severity Index (PDSI). The ELM was applied well-by-well and observed correlations between the groundwater level measurements from each well and the Earth observation data. This correlation was then used to interpolate data points during temporal ranges that had no data. The method was chosen due to its ability to function without a large amount of in-situ data to “train” the model, which is common among groundwater datasets. To demonstrate its effectiveness, the method was applied to two areas in Utah. The results obtained by the Earth observation method utilizing ELM were significantly more accurate than Kriging (a form a spatial interpolation) in areas of relatively consistent human influences (changes in groundwater pumping, land use changes, etc.). This method provides a more accurate and flexible method to impute groundwater data, which could be very helpful in areas with limited or especially sporadic groundwater data. However, only two areas were analyzed in the paper, demonstrating the need for further testing.   

The Central Valley of California is one of the most productive agricultural areas in the United States. The area produces approximately $17 billion in agronomic value per year and a quarter of the nation’s food (@usgs).  However, due to the dry climate that it sits in, farms in the valley rely heavily on groundwater. In fact, it is the 2nd most-pumped aquifer system in the country, according to the United States Geological Survey (USGS). In fact, groundwater levels in the valley are reaching historically low levels (@THOMAS2017384). Over pumping of aquifers can lead to severe consequences to both people and property through subsidence and can lead to long-term and even permanent changes in hydrologic and aquifer patterns. Due to this extreme amount of groundwater extraction in the area and the resultant threats, regulation now requires more sustainable use of groundwater in the region. Due to the wealth of groundwater data in the area, it is a perfect candidate for testing of groundwater interpolation methods.  

A recent study performed by the Jet Propulsion Laboratory at the California Institute of Technology recently performed a study that compiled all freely available groundwater data in the area from different sources and synthesized it. Data were collected from 5 different sources across two different agencies: the USGS and the California Department of Water Resources (DWR). They eliminated duplicates and invalid data, then used a scoring method to select wells that were evenly distributed and had an appropriately large and consistent set of observations. This study has not yet been published, and so will not be cited in this work. However, this dataset was shared with the author’s research group at BYU and will be used as the base for this study.


<!--chapter:end:02-literature.Rmd-->

# Data Description

This section will describe the data used in this project.

As described in the last section, the data used in this project comes from a recent study performed by NASA's JPL. The study compiled all freely available groundwater data in the Central Valley of CA from different sources and synthesized it. Data were collected from 5 different sources across two different agencies: the USGS and the California Department of Water Resources (DWR). As noted, duplicates and wells without sufficient data were filtered out and a "representative" well was chosen for each square kilometer that had at least one well available.

First, we can load the dataset and inspect. It contains 9 different variables, including 5 that relate to various identification numbers. There are lat/long variables describing the geographic reference, a depth to GW, and a date at which the depth measurement was taken, as seen in Table \@ref(tab:master_tab).

```r
load("code/master.Rda")
head(master)
```

```
##   NDI     site_no SITE_CODE STATION     mergeOn   lat     lon       date
## 1   0 3.23233e+14                   3.23233E+14 32.54 -117.03 2010-03-04
## 2   0 3.23233e+14                   3.23233E+14 32.54 -117.03 2010-03-19
## 3   0 3.23233e+14                   3.23233E+14 32.54 -117.03 2010-05-06
## 4   0 3.23233e+14                   3.23233E+14 32.54 -117.03 2010-05-25
## 5   0 3.23233e+14                   3.23233E+14 32.54 -117.03 2010-07-09
## 6   0 3.23233e+14                   3.23233E+14 32.54 -117.03 2010-09-22
##   depth.to.GW..ft.
## 1            22.93
## 2            22.87
## 3            21.84
## 4            21.22
## 5            20.76
## 6            20.09
```

A histogram can show us the time distribution of measurements for the entire dataset, as shown in Figure \@ref(fig:mast_hist_fig)

```r
# Create a histogram of the entire dataset
hist(master$date, 'years', xlab = "Date", freq = TRUE, format = "%Y")
```

<img src="Website_Bookdown_files/figure-html/mast_hist_fig-1.png" width="672" />

In understanding the spatial locations of these wells, we will need to display each well. However, in order to do this, we need to first extract the wells from the master dataset so that we are not mapping them twice. Once we have that, we can create a map using Leaflet that shows all of the wells in the dataset.A polygon outlining the central valley has also been included in blue.


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(leaflet)
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
```

preserve96d230aacb9f322f

In order to clean this data to make it more manageable, we are going to filter out all wells that do not have more than 180 observations and do not fall within the central valley boundary polygon.

```r
library(sf)
```

```
## Linking to GEOS 3.8.1, GDAL 3.1.1, PROJ 6.3.1
```

```r
library(tidyverse)
```

```
## ── Attaching packages ───────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
## ✓ tibble  3.0.3     ✓ stringr 1.4.0
## ✓ tidyr   1.1.2     ✓ forcats 0.5.0
## ✓ readr   1.4.0
```

```
## ── Conflicts ──────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
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
```

```
## although coordinates are longitude/latitude, st_intersection assumes that they are planar
```

```
## Warning: attribute variables are assumed to be spatially constant throughout all
## geometries
```

After an initial cleaning, the dataset can be further refined to find data that meet our criteria. For this analysis, we'd like as consistent of a database as possible, so we'll filter out data that doesn't span at least 15 years.


```r
library(lubridate)
```

```
## 
## Attaching package: 'lubridate'
```

```
## The following objects are masked from 'package:base':
## 
##     date, intersect, setdiff, union
```

```r
# Next, we need to find the wells that have data that span across at least 15 years.
  ## In addition, we would like to find data with an adequate distribution:
    ### We'll do this by looping through the data to find wells with at least 4 data points per year. 
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
```

Finally, the data can be summarized into 3 month blocks. Then, wells with coverage over the entire timeframe (19 years in this case) will be kept for further analysis. Once those wells are identified, a proper spatial distribution will need to be determined.


```r
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
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
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
```

preserved6303cf49493f586

For this analysis, we need a small cluster of wells that are within a reasonable (~50 km) from each other. A certain distance could be set as a threshold, and R could be used to determine a proper cluster programmatically. However, in this case, it is easier to manually determine a good cluster of wells. Based on the map, wells 25N03W11B003M, 29N03W18M001M, 24N02W29N004M, 24N02W24D003M, and 24N02W03B001M were chosen (the area will be displayed a little later on). A facet-wrapped histogram shows the distribtion of these wells' measurements.

```r
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
```

<img src="Website_Bookdown_files/figure-html/unnamed-chunk-5-1.png" width="672" />

These wells will make up the basis for the remainder of this study. This final map includes a red box identifying the 5 wells that were chosen.


```r
# Final leaflet map with study area in red
leaflet() %>%
  addTiles() %>%
  addPolygons(data = CV_shape, stroke = FALSE, smoothFactor = 0.3, fillOpacity = 0.5) %>%
  addMarkers(data = w76,
             lng = ~long, 
             lat = ~lat, 
             popup = ~mergeOn
  ) %>%
  addRectangles(lng1 = -121.4, lat1 = 38.7, lng2 = -122, lat2 = 39.1, color = "#ff0000", opacity = 0.9, fillColor = "transparent")
```

preserveddbe7cfdf525dd3a



You can write citations, too. For example, we are using the **bookdown** package [@R-bookdown] in this sample book, which was built on top of R Markdown and **knitr** [@xie2015].

<!--chapter:end:03-Data_desc.Rmd-->

# Applications

Some _significant_ applications are demonstrated in this chapter.

## Example one

## Example two

## Example three

<!--chapter:end:04-application.Rmd-->

# Final Words

Here I discuss my conclusions.

<!--chapter:end:05-summary.Rmd-->


# References {-}

Some references

<!--chapter:end:06-references.Rmd-->

