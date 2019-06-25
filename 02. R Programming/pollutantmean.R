## Pollutant Mean Calculation

# define a function of pollutantmean with three arguments: directory, pollutant, and id
pollutantmean <- function(directory, pollutant, id = 1:332) {
        #define target file path with the directory argument
        workpath <- paste(getwd(), "/", directory, "/", sep="")
        
        #define an empty data frame first
        totaldata <- data.frame()
        
        #make a loop along ids
        for(i in id){
                #add target data to the empty data frame and renew!
                totaldata<- rbind(totaldata, read.csv(paste(workpath, formatC(i, width=3, flag="0"), ".csv", sep="")))
        }
        
        
        # pollutant conditions
        if (pollutant == "sulfate"){
                output <- mean(totaldata[!is.na(totaldata[,2]),2])
                print(output)
        }
        else if (pollutant == "nitrate"){
                output <- mean(totaldata[!is.na(totaldata[,3]),3])
                print(output)
        }
        else {
                print("Please input any valid pollutant name.")
        }
        
}