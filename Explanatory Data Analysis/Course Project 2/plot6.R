# JHU Data Science - Explanatory Data Analysis Course Project 2
# Plot6.R 
# Compare changes in PM2.5 emissions from motor vehicles from 1999 to 2008
# in the Baltimore City and Los Angeles County



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

Year <- as.factor(unique(nei$year))
balt_motor_nei <- subset(nei, fips == "24510" & type == "ON-ROAD")
la_motor_nei <- subset(nei, fips == "06037" & type == "ON-ROAD")

Balt <- vector()
LA <- vector()

for(i in Year){
        balt_motor_sum <- sum(subset(balt_motor_nei, year==i)[,4])
        la_motor_sum <- sum(subset(la_motor_nei, year==i)[,4])
        Balt <- c(Balt, balt_motor_sum)
        LA <- c(LA, la_motor_sum)
}
## merge into a dataframe to apply in ggplot
motor_df <- data.frame(Year, Balt, LA)

## Calculate percent changes
motor_df$Balt_per <- paste(round(Balt/Balt[1] - 1, digits=2) * 100, "%", sep="") 
motor_df$LA_per <- paste(round(LA/LA[1] - 1, digits=2) * 100, "%", sep="") 



# 3. Plot and Save as .png
library(ggplot2)
png("plot6.png", width=640, height=480)

## set a color vector for the legend of the plot
cols <- c("Los Angeles County" = rgb(246,133,130, maxColorValue = 255),
          "Baltimore City" = rgb(79,198,201, maxColorValue = 255))
## plot
ggplot(data=motor_df, aes(x=Year, y=LA, group=1, color="Los Angeles County")) +
        ylim(0,5000) +
        ## Plot Los Angeles County
        geom_point(size=2) +
        geom_text(aes(label=LA_per), vjust = -1, color="black") +
        geom_line(size=1) +
        ## Plot Baltimore City
        geom_point(aes(y=Balt, group=2, color="Baltimore City"), size=2) +
        geom_text(aes(y=Balt, label=Balt_per), vjust = -1, color="black") +
        geom_line(aes(y=Balt, group=2, color="Baltimore City"),size=1) +
        ## Title and Legend
        scale_color_manual(name="Source Types", values=cols) +
        labs(y="Tons", 
             title="PM2.5 from Motor Vehicles, Baltimore City and Los Angeles")
dev.off()



# 4. Clear junks
rm("balt_motor_nei", "balt_motor_sum", "Balt", "i",
   "la_motor_nei", "la_motor_sum", "LA", "Year", "cols", "motor_df")

## End of Code