## this script analyzes a large data set (TXT file type) which includess data on 
## Individual household electric power consumption

library(data.table)

## using fast read 'fread' command to speed up the process
## adding arguments for na strings = "?" otherwise the column class won't be read in correctly

mydata<-fread("household_power_consumption.txt", na.strings = c("NA", "?"))

## converting character vector to 'date' class
mydata$Date <- as.Date(mydata$Date, format="%d/%m/%Y")

## function to specify date range and then splice data into small file size

date_range <- function(x,y){mydata[mydata$Date >= x & mydata$Date <= y,]}

startdate <- as.Date("2007-02-01")
enddate <- as.Date("2007-02-02")

data_slice <- date_range(startdate,enddate)

## removes my memory large file
rm(mydata)

## creates new column that combines data and time character vectors
datetime <- paste(data_slice$Date, data_slice$Time)

## adds timestamp column ('vector') to existing data frame and converts to 'date' class
data_slice$datetime <- datetime
data_slice$datetime <- as.POSIXct(data_slice$datetime)

## plot1.R is a histogram

par(mfrow=c(1, 1))

hist(data_slice$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kW)", col="red", breaks = 20
)

dev.copy(png, file="./figure/plot1.png", height=480, width=480)
dev.off()