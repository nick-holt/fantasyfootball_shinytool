#
# This is a shiny app that displays fantasypros consensus rankings and 
# projections in a way that allows weights to be applied to each
#

source("fp_rankings_scraper.R")
library(shiny)
library(shinythemes)

scrape_ranks(type_url = "qb_standard")

# server
server <- function(input, output, session) {
        
        data <- reactive({
                scrape_rank_proj(type_url = paste0(tolower(input$type)))
        })

        output$plot <- renderPlot({
                ggplot(data = data(), aes(x = consensus_rank, y = proj_points, color = consensus_rank)) +
                        geom_point() +
                        theme(legend.position = "none") +
                        labs(x = "\nFantasyPros Consensus Ranking", 
                             y = "FantasyPros Consensus Projected Points\n")
        })
        
        output$info <- renderPrint(
                nearPoints(data(), input$hover)
        )
        
        output$result <- renderText({
                paste("You chose", input$type)
        })
}

# Define UI for application that draws a histogram
ui <-  fluidPage(theme = shinytheme("simplex"),
                 
        titlePanel(strong("Player Rankings and Projections from FantasyPros.com")), 
        
        sidebarLayout(
                
                sidebarPanel(
                        selectInput("type", "Choose a Position and Scoring Format:",
                                    list(`Standard` = c("QB_STANDARD", "RB_STANDARD", "WR_STANDARD", "TE_STANDARD", "K_STANDARD", "DST_STANDARD"),
                                         `PPR` = c("RB_PPR", "WR_PPR", "TE_PPR"),
                                         `Half PPR` = c("RB_HALF_PPR", "WR_HALF_PPR", "TE_HALF_PPR"))
                        )
                ), 
                
                mainPanel(
                        h1("Consensus Ranking vs Consensus Projection"),
                        textOutput("result"),
                        plotOutput("plot", hover = "hover"),
                        verbatimTextOutput("info")
                )
        )
)

shinyApp(ui = ui, server = server) # launch app
