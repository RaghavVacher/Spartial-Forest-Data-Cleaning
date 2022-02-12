library(ncdf4)
library(fields)
library(caret)
library(dplyr)
set.seed(691)

nc <- nc_open(choose.files())
nc

#extracting longitudes and latitudes for mapping
long <- ncvar_get(nc, "longitude")
lati <- ncvar_get(nc, "latitude")
time <- ncvar_get(nc, "time")

#Formatting Date into a YYYY-MM-DD format
time <- time/24
time <- as.Date(time, origin = "1900-01-01")

#sorting longitudes and latitudes 
longs <- sort(long)
latis <- sort(lati)

#extracting the 7 variables in the data set on the bases of: longitude, latitude, time
tp <- ncvar_get(nc, "tp", start = c(1 ,1, 1), count = c(-1 , -1, -1))
e <- ncvar_get(nc, "e", start = c(1 ,1 , 1), count = c(-1 , -1, -1))
skt <- ncvar_get(nc, "skt", start = c(1 ,1 , 1), count = c(-1 , -1, -1))
lai_hv <- ncvar_get(nc, "lai_hv", start = c(1 ,1 , 1), count = c(-1 , -1, -1))
lavi_lv <- ncvar_get(nc, "lai_lv", start = c(1 ,1 , 1), count = c(-1 , -1, -1))
d2m <- ncvar_get(nc, "d2m", start = c(1 ,1 , 1), count = c(-1 , -1, -1))
src <- ncvar_get(nc, "src", start = c(1 ,1 , 1), count = c(-1 , -1, -1))

#Combining Longitude and Latitude
lonlat <- as.matrix(expand.grid(long,lati, time))
dim(lonlat)

#Extracting variable values to convert into a data set
count <- list(tp, e, skt, lai_hv, lavi_lv, d2m, src)

values<- sapply(X = count, FUN = as.vector)

#Creating Complied Data set
dF <- data.frame(cbind(lonlat,values))
names(dF) <- c("Longitude","Latitude", "time", "tp", "e", "skt", "lai_hv", "lavi_lv", "d2m", "src")
dF <- na.omit(dF)

#Extracting Unique Values
dFa <- distinct(dF, Longitude, Latitude, .keep_all= TRUE) 


