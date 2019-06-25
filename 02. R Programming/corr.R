##Calculate correlation between sulfate and nitrate for monitor IDs with complete observations

#define a function takes two arguments: directory, threshold
corr <- function(directory, threshold = 0) {
        #define target file path with the directory argument
        workpath <- paste(getwd(), "/", directory, "/", sep="")
        
        #define an empty vector first
        corrvector <- vector()
        
        #load target file list
        csvlist <- list.files(path=workpath, pattern =".csv")
        
        #fill totaldata
        for(csv in csvlist){
                #read target csv and store contents in csvdata
                csvdata <- read.csv(paste(workpath, csv, sep=""))
                #clear incomplete observations
                csvdata <- csvdata[complete.cases(csvdata[,c(2,3)]),]
                #check whether the number of complete observations is bigger than threshold 
                #if the number of observations is bigger, calculate correlation between two pollutants
                if(NROW(csvdata) > threshold) {
                        #calculate correlation
                        #x <- csvdata$sulfate 
                        #y <- csvdata$nitrate
                        n <- NROW(csvdata)
                        
                        #claculate mean first
                        x_mean <- mean(csvdata$sulfate)
                        y_mean <- mean(csvdata$nitrate)
                        
                        #calculate deviations
                        x_dev <- csvdata$sulfate - x_mean
                        y_dev <- csvdata$nitrate - y_mean
                        
                        #calculate covariance
                        covariance <- sum(x_dev * y_dev)/n
                        
                        #calculate standard deviations
                        x_sd <- sqrt(sum(x_dev^2)/n)
                        y_sd <- sqrt(sum(y_dev^2)/n)
                        
                        #calculate correlation and add it to corrvector
                        corrvector <- c(corrvector, covariance/(x_sd*y_sd))
                }
        }
        print(corrvector)
}
        