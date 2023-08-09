# Libraries
library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(plotly)

# ui
ui <- fluidPage(
  theme = shinytheme("flatly"),
  tags$head(tags$link(rel="shortcut icon", href="https://cdn-icons-png.flaticon.com/512/3593/3593460.png")),
  title = "Fair Exchange Rate",
  br(),
  
  h3("Select ", code("foreign CURRENCY"), "from the box below:", style = "color: cornflowerblue"),
  br(),
  
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
      ),
      
      p("Change the theme:"),
      checkboxInput(
        inputId = "themeToggle",
        label = icon("moon"),
        TRUE
      )
    ),
    
    mainPanel(
      fluidRow(
        # Title of the graph
        column(6, verbatimTextOutput("name")),
        column(6, verbatimTextOutput("amount_czk"))
      ),
      verbatimTextOutput("fair_amount_fx"),
      verbatimTextOutput("fair_amount_czk"),
      verbatimTextOutput("fair_amount_diff_czk"),
      verbatimTextOutput("fair_amount_diff_per"),
      
      plotlyOutput("plot") # plotly
    )
  ),
  
  tags$script( # theme changing
    "
        // define css theme filepaths
        const themes = {
            dark: 'shinythemes/css/darkly.min.css',
            light: 'shinythemes/css/flatly.min.css'
        }

        // function that creates a new link element
        function newLink(theme) {
            let el = document.createElement('link');
            el.setAttribute('rel', 'stylesheet');
            el.setAttribute('text', 'text/css');
            el.setAttribute('href', theme);
            return el;
        }

        // function that remove <link> of current theme by href
        function removeLink(theme) {
            let el = document.querySelector(`link[href='${theme}']`)
            return el.parentNode.removeChild(el);
        }

        // define vars
        const darkTheme = newLink(themes.dark);
        const lightTheme = newLink(themes.light);
        const head = document.getElementsByTagName('head')[0];
        const toggle = document.getElementById('themeToggle');

        // define extra css and add as default
        const extraDarkThemeCSS = '.dataTables_length label, .dataTables_filter label, .dataTables_info {       color: white!important;} .paginate_button { background: white!important;} thead { color: white;}'
        const extraDarkThemeElement = document.createElement('style');
        extraDarkThemeElement.appendChild(document.createTextNode(extraDarkThemeCSS));
        head.appendChild(extraDarkThemeElement);


        // define event - checked === 'light'
        toggle.addEventListener('input', function(event) {
            // if checked, switch to light theme
            if (toggle.checked) {
                removeLink(themes.dark);
                head.removeChild(extraDarkThemeElement);
                head.appendChild(lightTheme);
            }  else {
                // else add darktheme
                removeLink(themes.light);
                head.appendChild(extraDarkThemeElement)
                head.appendChild(darkTheme);
            }
        })
  "),
  p("\n"),
  uiOutput("link1", style="padding-left: 0px"),
  uiOutput("link2", style="padding-left: 0px")
)
