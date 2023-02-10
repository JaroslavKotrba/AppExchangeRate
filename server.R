# server
server <- function(input, output) {
  options(scipen = 999)
  
  output$name <- renderText({ 
    
    NAME <- function(name){
      if (name == 'EUR'){
        return('Euro')
      }
      else if (name == 'USD'){
        return('US Dollar')
      }
      else if (name == 'CHF'){
        return('Swiss Franc')
      }
      else if (name == 'NOK'){
        return('Norway Crown')
      }}
    
    NAME(input$select_currency)
  })
  
  output$fair_amount_fx <- renderText({
    library(priceR)
    CZK_vs_FX = historical_exchange_rates(from = "CZK", to = input$select_currency, start_date = Sys.Date(), end_date = Sys.Date()); CZK_vs_FX
    
    # CZK to FX
    value_CZK = input$czk
    CZK_to_FX = value_CZK * CZK_vs_FX[[2]]
    
    paste("Fair amount:", round(CZK_to_FX, 2), input$select_currency)
  })
  
  output$fair_amount_czk <- renderText({
    library(priceR)
    FX_vs_CZK = historical_exchange_rates(from = input$select_currency, to = "CZK", start_date = Sys.Date(), end_date = Sys.Date()); FX_vs_CZK
    
    # FX to CZK
    value_FX = input$fx
    FX_to_CZK = value_FX * FX_vs_CZK[[2]]    
    
    paste("Fair amount:", round(FX_to_CZK, 2), "CZK")
  })
  
  output$fair_amount_diff_czk <- renderText({
    library(priceR)
    CZK_vs_FX = historical_exchange_rates(from = "CZK", to = input$select_currency, start_date = Sys.Date(), end_date = Sys.Date()); CZK_vs_FX
    FX_vs_CZK = historical_exchange_rates(from = input$select_currency, to = "CZK", start_date = Sys.Date(), end_date = Sys.Date()); FX_vs_CZK
    
    # CZK to FX
    value_CZK = input$czk
    CZK_to_FX = value_CZK * CZK_vs_FX[[2]]
    
    # FX to CZK
    value_FX = input$fx
    FX_to_CZK = value_FX * FX_vs_CZK[[2]]
    
    # Difference in CZK
    diff_CZK = value_CZK - FX_to_CZK
    
    paste("You are paying on fees:", round(diff_CZK, 2), "CZK")
  })
  
  output$fair_amount_diff_per <- renderText({
    library(priceR)
    CZK_vs_FX = historical_exchange_rates(from = "CZK", to = input$select_currency, start_date = Sys.Date(), end_date = Sys.Date()); CZK_vs_FX
    FX_vs_CZK = historical_exchange_rates(from = input$select_currency, to = "CZK", start_date = Sys.Date(), end_date = Sys.Date()); FX_vs_CZK
    
    # CZK to FX
    value_CZK = input$czk
    CZK_to_FX = value_CZK * CZK_vs_FX[[2]]
    
    # FX to CZK
    value_FX = input$fx
    FX_to_CZK = value_FX * FX_vs_CZK[[2]]
    
    # Difference in CZK
    diff_CZK = value_CZK - FX_to_CZK
    
    paste0("You are paying on fees ", round(diff_CZK/(value_CZK/100), 2), "%" , " from the original amount.")
  })
  
  output$plot <- renderPlotly({
    # Visualisation
    FX = input$select_currency
    start_date = input$date
    
    library(data.table)
    dt = data.table(historical_exchange_rates(from = FX, to = "CZK", start_date = start_date, end_date = Sys.Date())); dt
    colnames(dt) = c('ds', 'y')
    
    library(ggplot2)
    library(plotly)
    g <- ggplot(data = dt, aes(x=ds, y=y)) +
      geom_line(col="cornflowerblue", lwd=0.5, aes(text = paste0("Date: ", as.Date(..x.., origin = "1970-01-01"),
                                                                 "<br>Rate: ", round(..y.., 2), " ", FX))) +
      geom_smooth(method = "gam", col="red", lwd=0.5, se=FALSE, linetype = "dashed", aes(text = paste0("Date: ", as.Date(..x.., origin = "1970-01-01"),
                                                                                                       "<br>Rate: ", round(..y.., 2), " ", FX))) +
      xlab("Time") +
      ylab("Rate") +
      scale_x_date(date_labels = "%Y-%b", date_breaks = input$breaks) +
      theme_bw()
    
    g <- ggplotly(g, tooltip = c("text"))
  })
  
  url1 <- a("https://cran.r-project.org/web/packages/priceR/index.html", href="https://cran.r-project.org/web/packages/priceR/index.html")
  output$link1 <- renderUI({
    tagList("Source:", url1)
  })
  
  url2 <- a("https://jaroslavkotrba.com", href="https://jaroslavkotrba.com")
  output$link2 <- renderUI({
    tagList("Other projects:", url2)
  })
}