rankall <- function(outcome, num = "best") {
        ## Read outcome data
        ## Check that state and outcome are valid
        ## For each state, find the hospital of the given rank
        ## Return a data frame with the hospital names and the
        ## (abbreviated) state name
        
        #read data
        data <- read.csv("outcome-of-care-measures.csv", na.strings = "Not Available", stringsAsFactors = FALSE)
        
        #extract necessary data only
        if(outcome == "heart attack") {
                data <- data[complete.cases(data[,11]),c(2,7,11)]
        }
        else if(outcome == "heart failure") {
                data <- data[complete.cases(data[,17]),c(2,7,17)]
        }
        else if(outcome == "pneumonia") {
                data <- data[complete.cases(data[,23]),c(2,7,23)]
        }
        else {stop("invalid outcome")}
        
        #unify column names
        colnames(data) <- c("Hospital.Name", "State", "value")
        
        #sort
        if (num == "worst"){
                num <-1
                data <- data[order(data$value, data$Hospital.Name, na.last=TRUE, decreasing = c(TRUE, TRUE)),]
        }
        else{
                data <- data[order(data$value, data$Hospital.Name, na.last=TRUE, decreasing = c(FALSE, TRUE)),]
                if (num == "best") num <-1
        }
        
        #list states
        State <- sort(unique(data$State))
        
        #an empty dataframe
        table <- data.frame()
        
        #loop
        for (i in State){
                temp <- data[data$State==i,]
                temp$rank <- 1:nrow(temp)
                table <- rbind(table, temp)
        }

        #output
        output1 <- merge(as.data.frame(State), table[table$rank==num, c(1,2)], all=TRUE)
        output <- output1[,(2:1)]
        rownames(output) <- output$State
        return(output)
}