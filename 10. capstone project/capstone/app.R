library(shiny)
library(shinythemes)
library(data.table)
library(stringr)
library(stringdist)
library(quanteda)
library(tictoc)
quanteda_options(threads = 8)
setDTthreads(8)

# load data
load("./data/capstone_data_final.RData", envir=.GlobalEnv)

# load functions
source("functions.R")

#------------------------------------------------------------------------------#
# UI
ui <- fluidPage(theme = shinytheme("flatly"),
                
                mainPanel(
                    
                    tags$head(tags$style(type="text/css", ".container-fluid {min-width: 970px; max-width: 970px;}")),
                    
                    # title
                    h1("Predictive Text Application", align = "center"),
                    br(),
                    
                    textInput("text", h4("Input:"), value = ""),
                    tags$head(tags$style(type="text/css", "#text {width:600px}")),
                    
                    # output
                    actionButton("select1", label=textOutput("results1"), class = "btn-secondary"),
                    actionButton("select2", label=textOutput("results2"), class = "btn-success"),
                    actionButton("select3", label=textOutput("results3"), class = "btn-info"),
                    actionButton("select4", label=textOutput("results4"), class = "btn-warning"),
                    actionButton("select5", label=textOutput("results5"), class = "btn-danger"),
                    actionButton("dot", label=".", class = "btn-primary"),
                    actionButton("space", label="SPACE", class = "btn-primary"),
                    
                    
                    HTML('<p><img src="keyboard.png" width="600"/></p>'),
                    
                    #br(),
                    
                    h6(textOutput("time"), "seconds elapsed")
            
                ),
                
                sidebarPanel(width=4,
                           br(),br(),br(),br(),
                           HTML('<p><img src="bar.png" align="center"/></p>'),
                           HTML('<p><img src="howto.png" align="center"/></p>'),
                           tags$head(tags$style(type="text/css",".well {min-width: 280px; max-width: 280px;}" ))
                           )
            
                
        )

#------------------------------------------------------------------------------#



#------------------------------------------------------------------------------#
# Server
server <- function(input, output, session){

    # run prediction
    prediction <- reactive({
        text <- input$text
        tic()
        a <- run(text)
        b <- toc()
        c(as.character(b$toc - b$tic), a)
    })
    
    # send results to output buttons
    output$results1 <- renderText({ifelse(is.na(prediction()[2]), "", prediction()[2])})
    output$results2 <- renderText({ifelse(is.na(prediction()[3]), "", prediction()[3])})
    output$results3 <- renderText({ifelse(is.na(prediction()[4]), "", prediction()[4])})
    output$results4 <- renderText({ifelse(is.na(prediction()[5]), "", prediction()[5])})
    output$results5 <- renderText({ifelse(is.na(prediction()[6]), "", prediction()[6])})
    output$time <- renderText(prediction()[1])
    
    # accept button click
    observeEvent(input$select1, {
        updateTextInput(session, "text", value = paster(input$text, prediction()[2]))
    })
    observeEvent(input$select2, {
        updateTextInput(session, "text", value = paster(input$text, prediction()[3]))
    })
    observeEvent(input$select3, {
        updateTextInput(session, "text", value = paster(input$text, prediction()[4]))
    })
    observeEvent(input$select4, {
        updateTextInput(session, "text", value = paster(input$text, prediction()[5]))
    })
    observeEvent(input$select5, {
        updateTextInput(session, "text", value = paster(input$text, prediction()[6]))
    })
    observeEvent(input$dot, {
        updateTextInput(session, "text", value = paster(input$text, "."))
    })
    observeEvent(input$space, {
        updateTextInput(session, "text", value = paster(input$text, " "))
    })
    
}



#------------------------------------------------------------------------------#
# run app
shinyApp(ui = ui, server = server)