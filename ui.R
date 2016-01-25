library(shiny)
library(shinyIncubator)

# Define UI for application
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Predict Next Word"),
        helpText("This application will predict the next word by probability."),
        
        # Sidebar 
        sidebarLayout(
                sidebarPanel(      
                        helpText("Enter the text for which you want to predict the next word."),
                        
                        textInput("texto", "text", "Coursera predict"),           
                        br()   
                )
                ,
                
                # Main panel
                mainPanel(
                        #progressInit(),
                        h3("next words with high probability"),
                        br(),
                        br(),
                        verbatimTextOutput("result")      
                )
        )
))