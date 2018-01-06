# JHU Data Science - Explanatory Data Analysis Course Project 2
# Plot3.R   
# Use the ggplot2 plotting system, make a plot showing changes in 
# PM2.5 emissions of each source type from 1999 to 2008 



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



# 2. Calculate yearly total emissions in the Baltimore City by source types 

## extract Baltimore City data
balt <- subset(nei, fips == "24510")[,-c(1,2,3)]

## distinguish types and years
Type <- unique(balt$type)
Year <- as.factor(unique(balt$year))

## calculate yearly sums by types and save as a matrix 
matrix_balt <- matrix(0, 4, 4)
for(i in 1:4){
        for(j in 1:4){
                matrix_balt[j,i] <- 
                        sum(subset(balt, type==Type[i]&year==Year[j])[,1])
        }
}

## convert into a data frame and rename columns
balt_sum <- data.frame(Year, matrix_balt)
colnames(balt_sum) <- c("Year", "Point", "Nonpoint", "Onroad", "Nonroad")

## calculate percent changes 
balt_sum$Point_per <- paste(round(balt_sum$Point/balt_sum$Point[1] - 1, digits=2) * 100, "%", sep="")
balt_sum$Nonpoint_per <- paste(round(balt_sum$Nonpoint/balt_sum$Nonpoint[1] - 1, digits=2) * 100, "%", sep="")
balt_sum$Onroad_per <- paste(round(balt_sum$Onroad/balt_sum$Onroad[1] - 1, digits=2) * 100, "%", sep="")
balt_sum$Nonroad_per <- paste(round(balt_sum$Nonroad/balt_sum$Nonroad[1] - 1, digits=2) * 100, "%", sep="")



# 3. Plot and Save as .png
library(ggplot2)

png("plot3.png", width=640, height=480)

## set a color vector to draw the legend of the plot
cols <- c("Point" = rgb(246,133,130, maxColorValue = 255),
          "Nonpoint" = rgb(144,184,66, maxColorValue = 255),
          "Onroad" = rgb(79,198,201, maxColorValue = 255),
          "Nonroad" = rgb(202,133,255, maxColorValue = 255))

ggplot(data=balt_sum, aes(x=Year, y=Point, group=1, color="Point")) +
        ylim(0,2250) +
        ## Plot POINT
        geom_point(size=2) +
        geom_text(aes(label=Point_per), vjust = -1, color=cols[1]) +
        geom_line(size=1) +
        ## Plot NONPOINT
        geom_point(aes(y=Nonpoint, group=2, color="Nonpoint"), size=2) +
        geom_text(aes(y=Nonpoint, label=Nonpoint_per), vjust = -1, color=cols[2]) +
        geom_line(aes(y=Nonpoint, group=2, color="Nonpoint"),size=1) +
        ## Plot ONROAD
        geom_point(aes(y=Onroad, group=3, color="Onroad"), size=2) +
        geom_text(aes(y=Onroad, label=Onroad_per), vjust = 1.5, color=cols[3]) +
        geom_line(aes(y=Onroad, group=3, color="Onroad"),size=1) +
        ## Plot NONROAD
        geom_point(aes(y=Nonroad, group=4, color="Nonroad"), size=2) +
        geom_text(aes(y=Nonroad, label=Nonroad_per), vjust = -1, color=cols[4]) +
        geom_line(aes(y=Nonroad, group=4, color="Nonroad"),size=1) +
        ## Title and Legend
        scale_color_manual(name="Source Types", values=cols,
                           breaks=c("Point", "Nonpoint", "Onroad", "Nonroad")) + 
        labs(y="Tons", 
             title="Changes in PM2.5 emissions by sources, Baltimore City")
dev.off()



# 4. Clear junks
rm("Year", "Type", "balt", "i", "j", "matrix_balt", "balt_sum", "cols")

## End of Plot