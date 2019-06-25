##Printing out Complete Observations

#define a function with two arguments: directory, id
complete <- function(directory, id = 1:332){
        #define target file path with the directory argument
        workpath <- paste(getwd(), "/", directory, "/", sep="")
        
        #define nobs as an empty vector in advance, if not, its first value becomes NA 
        nobs <-vector()
        
        #read csvs check numbers of complete cases and put in a vector named nobs
        for(i in id){
                # read target csv and store in totaldata
                totaldata <- read.csv(paste(workpath, formatC(i, width=3, flag="0"), ".csv", sep=""))
                # remove incomplete cases in totaldata
                totaldata <- totaldata[complete.cases(totaldata[,c(2,3)]),] #complete rows only
                # add the numbers of complete observations by ID to nobs  
                nobs <- c(nobs, NROW(totaldata)) #use NROW to check the number of complete cases
        }
        outputdata <- data.frame(cbind(id, nobs)) #the result should be a data frame
        print(outputdata)
}
