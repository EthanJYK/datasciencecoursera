# JHU Data Science - Explanatory Data Analysis Course Project 2         
# Plot1.R
# Using the base plotting system, make a plot showing the total PM2.5 emission  
# from all sources for each of the years 1999, 2002, 2005, and 2008.           



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



# 2. Calculate Yearly PM25 Emission
library(dplyr)
Year <- unique(nei$year)
Total_Emission <- vector()
for(i in Year){
        total <- nei %>% filter(year==i)
        Total_Emission <- c(Total_Emission, sum(total[,4]))
}



# 3. Plot and Save as .png
options(scipen = 100) # turn scientific notations off
names(Total_Emission) <- Year
png("plot1.png", width=480, height=480)
barplot(Total_Emission, border=rgb(0,0,0,0.3),
        col=c(rep("gray60", 3), rgb(1,0,0,0.8)),
        xlab="Year", ylab="Tons",
        main="Yearly Total PM2.5 Emissions, United States"
        )
dev.off()
options(scipen = 0) # reset scientific notations with default



# 4. Clear junks
rm("Year", "i", "Total_Emission", "total")

## End of code
