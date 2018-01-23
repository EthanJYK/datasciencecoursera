# JHU Data Science - Explanatory Data Analysis Course Project 2
# Plot5.R
# Plot changes in PM2.5 emissions from motor vehicles from 1999 to 2008
# in the Baltimore City 



# 1. Download, Unzip, and Read Data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName <- "pm25.zip"
folder <- getwd()
if(!file.exists(paste(folder, "/", fileName, sep=""))) {
        download.file(fileURL, fileName)
        unzip(fileName)
}
## load each data if hasn't loaded yet  
if(!exists("nei")){nei <- readRDS("summarySCC_PM25.rds")}
if(!exists("scc")){scc <- readRDS("Source_Classification_Code.rds")}



# 2. Calculate Yearly PM25 Emission from motor vehicles
# NEI onroad sources include emissions from onroad vehicles that use gasoline, 
# diesel, and other fuels. (from EPA, check the page linked below)
# https://www.epa.gov/air-emissions-inventories/national-emissions-inventory-nei

balt_motor_nei <- subset(nei, fips == "24510" & type == "ON-ROAD")
Year <- unique(balt_motor_nei$year)
balt_motor_total <- vector()
for(i in Year){
        balt_motor_sum <- sum(subset(balt_motor_nei, year==i)[,4])
        balt_motor_total <- c(balt_motor_total, balt_motor_sum)
}
## calculate precent changes
balt_motor_per <- paste(round(balt_motor_total/balt_motor_total[1] - 1, digits=2) * 100, "%", sep="")



# 3. Plot and Save as .png
options(scipen = 100) # turn scientific notations off
names(balt_motor_total) <- Year
png("plot5.png", width=480, height=480)
pl <- barplot(balt_motor_total, border=rgb(0,0,0,0.3),
        col=c(rep("gray60", 3), rgb(1,0,0,0.8)),
        xlab="Year", ylab="Tons", ylim=c(0,400),
        main="Yearly PM2.5 Emissions from Motor Vehicles, Baltimore City"
)
## Add percents at the top of bars
text(x = pl, y = balt_motor_total, label = balt_motor_per, pos = 3, cex = 0.8, col = "black")
dev.off()
options(scipen = 0) # reset scientific notations with default



# 4. Clear junks
rm("balt_motor_nei", "balt_motor_sum", "balt_motor_total", "i", "Year", "pl", "balt_motor_per")

## End of Code