library(shiny)

#------------------------------------------------------------------------------#
# histogram 2 function
plot.sample.mean <- function(sample.mean){
    brks <- ceiling(max(sample.mean)*100) - floor(min(sample.mean)*100)
    par(mar=c(4.1, 4.1, 0, 1))
    hist(sample.mean, 
         probability = TRUE, 
         xlim=c(-0.5,0.5), 
         # ylim = c(0,length(sample.mean)/2),
         ylim = c(0, 30),
         xlab="",
         main="",
         breaks = brks, 
         xaxt='n',
         border="white",
         col="dodgerblue")
    axis(side=1, at=seq(-0.5,0.5,0.1), labels=seq(-0.5,0.5,0.1))
    abline(v=mean(sample.mean), col="salmon")
}

# blank histogram: plot 2 base
plot.dummy <- function(){
    brks <- 20
    par(mar=c(4.1, 4.1, 0, 1))
    hist(seq(-0.1, 0.1, 0.01), 
         probability = TRUE, 
         xlim=c(-0.5,0.5), 
         # ylim = c(0,length(sample.mean)/2),
         ylim = c(0, 40),
         xlab="",
         main="",
         breaks = brks, 
         xaxt='n',
         border="white",
         col="white")
    axis(side=1, at=seq(-0.5,0.5,0.1), labels=seq(-0.5,0.5,0.1))
}
#------------------------------------------------------------------------------#



shinyServer(function(input,output){
    # set stored values
    values <- reactiveValues()
    
    pool <- reactive({
        # input parameters 
        skew <- input$slider 
        value <- 11 - skew
        sigma <- 0.03 + 0.015 * (value-1)
        select <- input$select
        
        # random wave percent pre-calculation
        r <- vector()
        for(i in 1:3){r <- c(r, sample(1:(100-sum(r)),1))}
        r <- c(r, 100-sum(r))*100
        
        pool <- switch(select, "a" = {rbeta(10000, 10, value) - 0.5},
                       "b" = {rbeta(10000, value, 10) - 0.5},
                       "c" = {rbeta(10000, value/10, value/10) - 0.5},
                       "d" = {rnorm(10000,0,sigma)},
                       "e" = {c(rbeta(r[1], 10, value) - 0.5,
                                rbeta(r[2], value, 10) - 0.5,
                                rbeta(r[3], value/10, value/10) - 0.5,
                                rnorm(r[4],0,sigma))})
    })
    
    # plot 1
    output$plot1 <- renderPlot({
        par(mar=c(4.1, 4.1, 0, 1))
        pool <- pool()
        brks <- ceiling(max(pool)*50) - floor(min(pool)*50)
        hist(pool, 
             probability = TRUE, 
             xlim=c(-0.5,0.5), 
             ylim = c(0,10), 
             breaks = brks, 
             xlab = "",
             main = "",
             xaxt='n',
             border="white",
             col="gray20")
        axis(side=1, at=seq(-0.5,0.5,0.1), labels=seq(-0.5,0.5,0.1))
        abline(v=mean(pool), col="red")
        values$mean <- vector()
        output$plot2 <- renderPlot({plot.dummy()}) # reset plot 2 
    }) #, height = 400, width = 650)
    
    # value output
    output$m1 <- renderPrint({mean(pool())})
    output$sd1 <- renderPrint({sd(pool())})
        
    # plot 2 input
    values$mean <- vector()
    N <- reactive({input$N})
    
    # plot 2 base
    output$plot2 <- renderPlot({plot.dummy()}) #, height = 400, width = 650)
    
    # click 5
    addmean5 <- observeEvent(input$add5,{
        repeats <- 5
        for(i in 1:repeats){
            values$mean <- c(values$mean, mean(sample(pool(), N())))
        }
        output$plot2 <- renderPlot(plot.sample.mean(values$mean)) #, height = 400, width = 650)
    })
    
    # click 100
    addmean100 <- observeEvent(input$add100,{
        repeats <- 100
        for(i in 1:repeats){
            values$mean <- c(values$mean, mean(sample(pool(), N())))
        }
        output$plot2 <- renderPlot(plot.sample.mean(values$mean)) #, height = 400, width = 650)
    })
    
    # click 1000
#    addmean1000 <- observeEvent(input$add1000,{
#        repeats <- 1000
#        for(i in 1:repeats){
#            values$mean <- c(values$mean, mean(sample(pool(), N())))
#        }
#        output$plot2 <- renderPlot(plot.sample.mean(values$mean))
#    })
    
    # click clear
    clear <- observeEvent(input$clear,{
        values$mean <- vector()
        output$plot2 <- renderPlot({plot.dummy()}) #, height = 400, width = 650)
    })
    
    # clear when N changes
    clear2 <- observeEvent(input$N, {
        values$mean <- vector()
        output$plot2 <- renderPlot({plot.dummy()}) #, height = 400, width = 650)
    })
    
    # value output
    output$n1 <- renderPrint({length(values$mean)})
    output$m2 <- renderPrint({mean(values$mean)})
    output$sd2 <- renderPrint({sd(values$mean)})
})


