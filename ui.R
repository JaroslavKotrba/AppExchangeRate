# Libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)

# ui
ui <- fluidPage(
  title = "Fair Exchange Rate",
  br(),
  
  h3("Select ", code("foreign CURRENCY"), "from the box below:", style = "color: cornflowerblue"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "select_currency",
        label = "Select currency:",
        choices = c("EUR", "USD", "CHF", "NOK"),
        selected = "EUR"
      ),
      
      numericInput(
        inputId = "czk",
        label = "Select amount in CZK:",
        value = 10000,
        min = 0, step = 100
      ),
      
      numericInput(
        inputId = "fx",
        label = "Select amount in FX:",
        value = 400,
        min = 0, step = 10
      ),
      
      dateInput(
        inputId = "date",
        label = "Select date:",
        value = "2020-01-01",
        startview = "year",
        min = "2000-01-01",
        max = as.character(Sys.Date())
      ),
      
      selectInput(
        inputId = "breaks",
        label = "Select date breaks:",
        choices = c("1 month", "4 months", "6 months", "12 months", "24 months", "36 months"),
        selected = "6 months"
      )
    ),
    
    mainPanel(
      # Title of the graph
      verbatimTextOutput("name"),
      verbatimTextOutput("fair_amount_fx"),
      verbatimTextOutput("fair_amount_czk"),
      verbatimTextOutput("fair_amount_diff_czk"),
      verbatimTextOutput("fair_amount_diff_per"),
      
      plotlyOutput("plot") # plotly
    )
  ),
  
  p("\n"),
  uiOutput("link1", style="padding-left: 0px"),
  uiOutput("link2", style="padding-left: 0px")
)
