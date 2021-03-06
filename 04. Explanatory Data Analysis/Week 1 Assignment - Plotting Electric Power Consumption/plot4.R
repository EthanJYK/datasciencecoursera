# Plot 4

#-----------------------------------------------------------------------------------------------------#
# 1. Download Data

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "hpc.zip"
folder <- getwd()
if(!file.exists(paste(folder, "/", filename, sep=""))){
        download.file(fileURL, filename)
        unzip(filename)
}
#-----------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------#
# 2. Load Data
rawdata <- read.csv("household_power_consumption.txt", sep=";", stringsAsFactors = FALSE)
#-----------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------#
# 3. Reform Data
rawdata$Date <- as.Date(rawdata$Date, format = "%d/%m/%Y") # reform date
library(chron)
rawdata$Time <- times(rawdata$Time) # reform time
data <- subset(rawdata, Date == "2007-02-01" | Date == "2007-02-02") # extract necessary data
rownames(data) <- NULL # reset row numbers
for(i in 3:8){data[,i] <- as.numeric(data[,i])} # reform strings into numbers
#-----------------------------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------#
# 4. Plot 4
Sys.setlocale("LC_TIME", "C") #set English as locale print language  
date <- as.POSIXct(paste(data$Date, data$Time))
png("plot4.png", width=480, height=480)

par(mfrow=c(2,2)) #set plot matrix

# (1,1)
plot(date, data$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# (1,2)
plot(date, data$Voltage, type="l", xlab="datetime", ylab="Voltage")

# (2,1)
plot(date, data$Sub_metering_1, type='l', xlab="", ylab="Energy sub metering")
lines(date, data$Sub_metering_2, col="red")
lines(date, data$Sub_metering_3, col="blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, bty="n")

# (2,2)
plot(date, data$Global_reactive_power, type="l", xlab="datetime", ylab="Global_Reactive_Power")
dev.off()
#-----------------------------------------------------------------------------------------------------#
