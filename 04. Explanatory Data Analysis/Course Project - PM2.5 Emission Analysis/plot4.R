# JHU Data Science - Explanatory Data Analysis Course Project 2 
# Plot4.R 
# Plot changes in PM2.5 emissions from coal combustion-related sources
# from 1999 to 2008 across the United States 



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



# 2. Calculate Yearly PM25 Emission from Coal-related sources 
## extract scc codes of coal combustion-related sources 
coalscc <- as.character(scc[grep("Coal", scc$EI.Sector),1])

## create a subset of NEI with selected scc codes
coalnei <- subset(nei, SCC %in% coalscc)

## sum up yearly emission records
Year <- unique(coalnei$year)
total_coal <- vector()
for(i in Year){
        yearsum <- sum(subset(coalnei, year==i)[,4])
        total_coal <- c(total_coal, yearsum)
}
## calculate precent changes
total_coal_per <- paste(round(total_coal/total_coal[1] - 1, digits=2) * 100, "%", sep="")



# 3. Plot and Save as .png
options(scipen = 100) # turn scientific notations off
names(total_coal) <- Year
png("plot4.png", width=480, height=480)
pl <- barplot(total_coal, border=rgb(0,0,0,0.3),
        col=c(rep("gray60", 3), rgb(1,0,0,0.8)),
        xlab="Year", ylab="Tons", ylim = c(0,600000),
        main="Yearly PM2.5 Emissions from Coal Combustions, United States"
)
## Add percents at the top of bars
text(x = pl, y = total_coal, label = total_coal_per, pos = 3, cex = 0.8, col = "black")
dev.off()
options(scipen = 0) # reset scientific notations with default



# 4. Clear junks
rm("coalnei", "i", "coalscc", "total_coal", "yearsum", "Year", "pl", "total_coal_per")

## End of Code