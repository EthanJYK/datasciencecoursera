library(shiny)

shinyUI(fluidPage(
    titlePanel("Central Limit Theorem Visualisation"),
    column(9,
    sidebarLayout(
        sidebarPanel(
            h3("Main Plot"),
            selectInput("select", h4("Distribution Type"), # Distribution Type
                        choices = list("Left-skewed" = "a",
                                       "Right-skewed" = "b",
                                       "Uniform / U-shaped" = "c",
                                       "Normal" = "d",
                                       "Random Wave" = "e"),
                        selected = 1),
            sliderInput("slider", "Skewness", min=1, max=10, value = 7), # skewness
            h5(strong("Mean(μ):")),
            verbatimTextOutput("m1"),
            h5(strong("Standard Deviation(σ):")),
            verbatimTextOutput("sd1")
        ),
        mainPanel(
            h4("Distribution of Numbers"), 
            plotOutput("plot1")
        )
    ),
    sidebarLayout(
        sidebarPanel(
            h3("Sample Mean Plot"),
            sliderInput("N", "Number of samples in a sample group (N)",
                        2, 100, value = 25), # 2~100, Number of samples in a sample group
            h5(strong("Click to add 'n' sample means")),
            actionButton("add5", "5"), # add 5 repeats
            actionButton("add100", "100"), # add 100 repeats
            # actionButton("add1000", "1000"), # add 1000 repeats
            actionButton("clear", "Clear"), # clear
            h5(strong("Number of Sample Means:")),
            verbatimTextOutput("n1"),
            h5(strong("Mean:")),
            verbatimTextOutput("m2"),
            h5(strong("Standard Deviation:")),
            verbatimTextOutput("sd2")
        ),
        mainPanel(
            h4("Distribution of Sample Group Means"),
            plotOutput("plot2")
        )
    )
    ),
    column(3,
    h3("Documentation"),
    br(),
    p("This application shows How Central Limit Theorem works."),
    br(),
    h3("# Main Plot"),
    p("· Choose a", span(strong("Distribution Type")), "to create a pool of numbers."),
    p("· Move slider to adjust", span(strong("skewness."))),
    p("· You can see the", span(strong("mean(μ)")), "and", span(strong("standard deviation(σ)")), "on the left panel."),
    br(),
    br(),
    h3("# Sample Mean Plot"),
    p("· Move slider to adjust", span(strong(" the size of each sample(= N)")), " out of your pool."),
    p("· Click", span(strong("5 or 100 Button")), "to put additional sample means to the plot."),
    p("· Click more and see how the", span(strong("sample mean plot")), "changes."),
    p("· You can see the plot approximates normal as the number of sample means increases."),
    p("· You can also compare the means and standard deviations of two plots."),
    p("· As the number of sample means increase, the mean of your sample means gets closer to the ", span(strong("μ")), ", and their standard deviation becomes closer to", span(strong("σ/√N."))),
    p("· Click", span(strong("Clear")), "to reset your plot.")
           )
))