## Q1
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "./data/q1survey.csv")
data <- data.frame(read.csv("./data/q1survey.csv"))
names(data)
spl <- strsplit(names(data), "wgtp")
spl[[123]]

## Q2
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", "./data/q2gdp.csv")
data <- read.csv("./data/q2gdp.csv")
data <- data[5:330,]
data <- data[1:190,]
View(data)
data<-data[,c(1,2,4,5)]
rownames(data) <- NULL
data[,4] <- gsub(",","",data[,4])
str(data)
data[,4] <- as.numeric(data[,4])
mean(data[,4])

## Q3
grep(“^United”,countryNames), 3

## Q4
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", "q4edu.csv")
edu <- read.csv("./q4edu.csv")
colnames(data) <- c("CountryCode", "GDP.rank", "CountryName", "GDP")
merge(data, edu, "CountryCode")
merged <- merge(data, edu, "CountryCode")
View(merged)
table(grepl("end: [Jj]une", merged[,13]))

## Q5
install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
library(lubridate)
date <- as.data.frame(ymd(sampleTimes))
table(grepl("^2012", date[,1]))
date$wday<-wday(date[,1])
b <- date[date[,2]==2,]
View(b)
table(grepl("^2012", b[,1]))
