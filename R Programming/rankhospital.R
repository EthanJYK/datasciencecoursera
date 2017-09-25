##Functions for R Programming (JHU/Coursera), Programming Assignment 3

##Function for Q.3

rankhospital <- function(state, outcome, num = "best") {
        ## Read outcome data
        ## Check that state and outcome are valid
        ## Return hospital name in that state with the given rank
        ## 30-day death rate
        
        #read data
        data <- read.csv("outcome-of-care-measures.csv", na.strings = "Not Available", stringsAsFactors = FALSE)
        
        #checking arguments
        if((state %in% data$State)==FALSE){stop("invalid state")}
        
        #main
        #extract target data
        tempdata <- data[data$State==state,]
        
        #shorten column names
        colnames(tempdata)[c(11,17,23)] <- c("HA", "HF", "PM")
        
        if(outcome == "heart attack") {
                tempdata <- tempdata[order(tempdata$HA, tempdata$Hospital.Name, na.last=TRUE, decreasing = c(FALSE, TRUE)),]
                tempdata <- tempdata[complete.cases(tempdata$HA),]
                }
        else if(outcome == "heart failure") {
                tempdata <- tempdata[order(tempdata$HF, tempdata$Hospital.Name, na.last=TRUE, decreasing = c(FALSE, TRUE)),]
                tempdata <- tempdata[complete.cases(tempdata$HF),]
                }
        else if(outcome == "pneumonia") {
                tempdata <- tempdata[order(tempdata$PM, tempdata$Hospital.Name, na.last=TRUE, decreasing = c(FALSE, TRUE)),]
                tempdata <- tempdata[complete.cases(tempdata$PM),]
                }
        else {stop("invalid outcome")}

        #"best" / "worst" conditional printing
        if (num=="best") print(tempdata[1,2])
        else if (num=="worst") print(tempdata[nrow(tempdata),2])
        else print(tempdata[num,2])
}