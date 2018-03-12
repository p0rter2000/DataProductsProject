#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Polynomial Fitting"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
       sliderInput("ord",
                   "Order of Polynomial:",
                   min = 1,
                   max = 10,
                   value = 1),
       numericInput("predict", "Enter X Value to Predict:",
                    value = 1, min = 0, max = 25, step = 0.1),
       h4("Predicted Polynomial Output"),
       textOutput("pred1"),
       h4("R-Squared"),
       textOutput("Rsqd")
    ),

    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       h4("Polynomial Coefficients"),
       DT::dataTableOutput("myTable")
    )
  )
))
