#------------------------------------------------------------------------------#
# 1. Data Processing
Sys.setlocale("LC_ALL", "English") # set LOCALE
options(scipen=999) # turn scientific notation off

# set file URL and location
URL <-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
fileName <- "StormData.csv.bz2"
folder <- getwd()

# download and import
if(!file.exists(paste(folder, "/", fileName, sep="")))
        {download.file(URL, fileName)}

if(!exists("StormData")){StormData <- read.csv("StormData.csv.bz2", 
                                               stringsAsFactors = F)}
str(StormData)
#------------------------------------------------------------------------------#



#------------------------------------------------------------------------------#
# 2. Reorganize Data: tidy up and simplify messy event types and correct typos
table(StormData$EVTYPE) # check types of EVTYPE values
StormData$EVTYPE <- toupper(StormData$EVTYPE) # capitalize all

# correct marks
a <- StormData$EVTYPE #duplicate first
a <- gsub("\\(.*\\)", "", a) # remove texts and numbers with parenthesis
a <- gsub("/", " ", a) # replace '/'s with spaces
a <- gsub("-", " ", a) # replace '-'s with spaces
a <- gsub("\\\\", " ", a) #replace '\\'s with spaces
a <- gsub("  ", " ", a) # remove double spaces
a <- gsub(";", " ", a) # remove semicolons
a <- gsub("\\.$", "", a) #remove dots at the end of the strings
a <- gsub("S$", "", a) # remove plural 'S's
a <- gsub("^ ", "", a) #remove blanks at the head of the strings
a <- gsub(" $", "", a) #remove blanks at the end of the strings

# tidy up labels and correct typos
# !!CAUTION!! DO NOT CHANGE THE ORDER BELOW
a[grep("AVA", a)] <- "AVALANCHE"
a[grep("BLIZ", a)] <- "BLIZZARD"
a[grep("^(?=.*FLOOD)(?=.*COAS)|(?=.*CSTL)|(?=.*BEACH)", 
                                               a, perl=TRUE)] <- "COASTAL FLOOD"
a[grep("EXTREME ",a)] <- "EXTREME COLD/WIND CHILL"
a[grep("DENSE FOG|^FOG$", a)] <- "DENSE FOG"
a[a=="FOG AND COLD TEMPERATURE"|a=="FREEZING FOG"|a=="ICE FOG"]<- "FREEZING FOG"
a[grep("SMOKE", a)] <- "DENSE SMOKE"
a[grep("DROUGHT", a)] <- "DROUGHT"
a[grep("DUST D", a)] <- "DUST DEVIL"
a[grep("G DUST|DUST S|DUSTS", a)] <- "DUST STORM"
a[grep("E HEAT", a)] <- "EXCESSIVE HEAT"
a[grep("^HEAT|D HEAT", a)] <- "HEAT"
a[grep("^(?=.*HEAVY)(?=.*SNOW)", a, perl=TRUE)] <- "HEAVY SNOW"
a[grep("^(?=.*HEAVY)(?=.*RAIN)|(?=.*PRECI)", a, perl=TRUE)] <- "HEAVY RAIN"
a[grep("SLEET", a)] <- "SLEET"
a[grep("FROST", a)] <- "FROST/FREEZE"
a[grep("^(?=.*FREEZ)(?!.*RAIN)(?!.*SNOW)(?!.*FOG)", 
                                                a, perl=TRUE)] <- "FROST/FREEZE"
a[grep("^(?=.*FREEZ)(?=.*RAIN)", a, perl=TRUE)] <- "WINTER WEATHER"
a[grep("^(?=.*TORN)(?!.*^WATER)", a, perl=TRUE)] <- "TORNADO"
a[a=="LANDSPOUT"] <- "TORNADO"
a[grep("^(?=.*THUN)|(?=.*ERSTO)", a, perl=TRUE)] <- "THUNDERSTORM WIND"
a[grep("^(?=.*TSTM)(?!.*^MARINE)", a, perl=TRUE)] <- "THUNDERSTORM WIND"
a[grep("(?=.*FUNN)(?!.*WATER)", a, perl=TRUE)] <- "FUNNEL CLOUD"
a[grep("^(?=.*HAIL)(?!.*MARINE)", a, perl=TRUE)] <- "HAIL"
a[grep("CURRENT", a)] <- "RIP CURRENT"
a[grep("SURF", a)] <- "HIGH SURF"
a[grep("HURR|TYPH", a)] <- "HURRICANE/TYPHOON"
a[grep("ICE STORM", a)] <- "ICE STORM"
a[grep("(?=.*FLOOD)(?=.*FLASH)", a, perl=TRUE)] <- "FLASH FLOOD"
a[grep("^(?=.*FLOOD)(?!.*FLASH)(?!.*COAST)(?!LAKES)", a, perl=TRUE)] <- "FLOOD"
a[grep("(?=.*URB)(?=.*SM)", a, perl=TRUE)] <- "FLOOD"
a[grep("LIGHTNING|LIGHTING", a)] <- "LIGHTNING"
a[a=="MARINE TSTM WIND"] <- "MARINE THUNDERSTORM WIND"
a[a=="STORM SURGE"|a=="STORM SURGE TIDE"] <- "STORM SURGE/TIDE"
a[grep("^(?=.*TROP)(?=.*STORM)", a, perl=TRUE)] <- "TROPICAL STORM"
a[grep("^(?=.*COAST)(?=.*STORM)", a, perl=TRUE)] <- "TROPICAL STORM"
a[grep("(?=.*VOL)(?=.*ASH)", a, perl=TRUE)] <- "VOLCANIC ASH"
a[grep("SPOUT", a)] <- "WATERSPOUT"
a[grep("FIRE", a)] <- "WILD FIRE"
a[grep("WINTER STORM|SNOWSTORM", a)] <- "WINTER STORM"
a[grep("(?=.*BURST)|(?=.*GUSTN)", a, perl=TRUE)] <- "THUNDERSTORM WIND"
a[grep("(?=.*RAIN)(?!.*LOW)(?!.*SNOW)", a, perl=TRUE)] <- "HEAVY RAIN"
a[grep("(?=.*COLD)(?!.*EXTR)|(?=.*CHIL)(?!.*EXTR)", 
                                             a, perl=TRUE)] <- "COLD/WIND CHILL"
a[grep("(?=.*WIND)(?=.*STORM)(?!.*MARIN)", a, perl=TRUE)] <- "THUNDERSTORM WIND"
a[a=="STORM FORCE WIND"] <- "THUNDERSTORM WIND"
a[a=="WHIRLWIND"] <- "TORNADO"
a[grep("^(?=.*HIGH WIND)(?!.*MARINE)", a, perl=TRUE)] <- "HIGH WIND"
a[grep("^(?=.*WIND)(?!.*MAR)(?!.*CHI)(?!.*HIG)(?!.*STO)(?!.*SNO)", 
                                                 a, perl=TRUE)] <- "STRONG WIND"
a[grep("(?=.*SNOW)(?=.*EXC)|(?=.*SNOW)(?=.*REC)", a, perl=TRUE)] <- "HEAVY SNOW"
a[grep("(?=.*SNOW)(?!.*HEA)(?!.*LAK)", a, perl=TRUE)] <- "WINTER WEATHER"
a[grep("ICE", a)] <- "WINTER WEATHER"
a[a=="WND"] <- "STRONG WIND"
a[grep("(?=.*WIN)(?=.*MIX)(?!.*STO)", a, perl=TRUE)] <- "WINTER WEATHER"
a[grep("HIGH TEMP", a)] <- "HIGH TEMPERATURE"
a[grep("WARM", a)] <- "WARM TEMPERATURE"
a[grep("WET", a)] <- "WET WEATHER"
a[grep("LOW RA", a)] <- "DRYNESS"
a[grep("DRY|DRI", a)] <- "DRYNESS"
a[grep("HOT", a)] <- "HIGH TEMPERATURE" 
a[grep("(?=.*COOL)|(?=.*LOW)(?!.*TIDE)", a, perl=TRUE)] <- "LOW TEMPERATURE"

#apply changes
StormData$EVTYPE <- a
rm(a)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# 3. Reorganize data: calculate economic effects

# Unify the units of the damage costs in the vectors
table(StormData$PROPDMGEXP) ; table(StormData$CROPDMGEXP) # check types of exps

# create lists of exps
# reverse vectors orders in order to prevent 0 -> 10^0 -> 10^1
units <- rev(names(table(StormData$PROPDMGEXP)))
exps <- rev(c(0, 0, 0, 1, 10^0, 10^1, 10^2, 10^3, 10^4, 10^5, 10^6, 10^7, 10^8, 
          10^9, 10^2, 10^2, 10^3, 10^6, 10^6))

# replace values
for(i in 1:19)
        {StormData$PROPDMGEXP[StormData$PROPDMGEXP == units[i]] <- exps[i]
         StormData$CROPDMGEXP[StormData$CROPDMGEXP == units[i]] <- exps[i]}

# deal with "k"s in CROPDMGEXP
StormData$CROPDMGEXP[StormData$CROPDMGEXP == "k"] <- 10^3 

# Calculate economic damages
prop.damages <- StormData$PROPDMG * as.numeric(StormData$PROPDMGEXP)
crop.damages <- StormData$CROPDMG * as.numeric(StormData$CROPDMGEXP)
#------------------------------------------------------------------------------#



#------------------------------------------------------------------------------#
# 4. Make a tidy data 
TidyData <- data.frame(as.factor(StormData$EVTYPE), # factorize event types 
                   StormData$FATALITIES, # population health #1
                   StormData$INJURIES,   # population health #2
                   prop.damages, # property damages
                   crop.damages) # crop damages

# data for casualties
Casualty.Data <- data.frame(tapply(TidyData[,2], TidyData[,1], sum),
                            tapply(TidyData[,3], TidyData[,1], sum))
Casualty.Data$Total <- rowSums(Casualty.Data)
Casualty.Data <- Casualty.Data[order(-Casualty.Data$Total),]
colnames(Casualty.Data) <- c("Fatalities", "Injuries", "Total")

# data for economic losses
Economy.Data <- data.frame(tapply(TidyData[,4], TidyData[,1], sum),
                           tapply(TidyData[,5], TidyData[,1], sum))
Economy.Data$Total <- rowSums(Economy.Data)
Economy.Data <- Economy.Data[order(-Economy.Data$Total),]
colnames(Economy.Data) <- c("Property Damages", "Crop Damages", "Total")

rm(units, exps, prop.damages, crop.damages, i) # remove remnants
#------------------------------------------------------------------------------#



#------------------------------------------------------------------------------#
# 5. Answering Question #1 
Top.Casualty <- Casualty.Data[1:10,]

# change plot margins
par(mar=c(10.1, 5.1, 4.1, 2.1))

# plot casualties
barplot(Top.Casualty$Total, names.arg=rownames(Top.Casualty), las=2, 
        cex=0.8, cex.axis=0.9,
        main="Top 10 Weather Events Causing Health Damages",
        col=c("brown1", rep("mistyrose2", 9)))
mtext(side = 2, "Total Casualty", line = 4)
#------------------------------------------------------------------------------#



#------------------------------------------------------------------------------#
# 6. Answering Question #2
Top.Economy <- Economy.Data[1:10,]

# plot economic losses
barplot(round(Top.Economy$Total / 10^6), 
        names.arg=rownames(Top.Economy), las=2, 
        cex=0.8, cex.axis=0.9,
        main="Top 10 Weather Events Causing Economic Losses",
        col=c("turquoise4", rep(rgb(157,209,203, maxColorValue = 255), 9)))
mtext(side = 2, "Total Loss  (Million U.S.$)", line = 4)

# reset plot margins
par(mar=c(5.1, 4.1, 4.1, 2.1))
#------------------------------------------------------------------------------#