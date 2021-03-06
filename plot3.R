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

## plot3.R is time series plot with multiple variables

par(mfrow=c(1, 1))

plot(data_slice$Sub_metering_1~data_slice$datetime, type="s", ylab="Energy sub Metering", xlab="", col="grey")

lines(data_slice$Sub_metering_2~data_slice$datetime, col="red")
lines(data_slice$Sub_metering_3~data_slice$datetime, col="blue")

legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1), col=c("grey","red","blue"), cex=0.50)
text(family="serif")

dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()