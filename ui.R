library(shinydashboard)
library(shiny)
library(ggmap)
library(leaflet)
library(plotly)

  palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

  dbHeader <- dashboardHeader()
  dbHeader$children[[2]]$children <-  tags$a(tags$img(src='easyJetLogo.JPG',height='50',width='220',align="left"),title="EJ")
  dbHeader$children[[1]]$children <-  tags$a(title="easyJet Analytics Dashboard")
  dashboardPage(
  #skin="red",  
  dbHeader,
  
  dashboardSidebar(
    # selectInput('Forecasting',"Forecasting", names(Bus)),
    #selectInput("Input1", "Number of Years to Forecast:", choices = c('1','2','3','4','5','6','7','8','9','10'))
    
  ),
  
  dashboardBody(
    tabsetPanel(type = "tabs",
                #tabPanel("easyJet Airlines Sentiment Graph",includeHTML("www/DashboardTam.html"))
                tabPanel("Polarity Graph",plotlyOutput('TwitterPolarityReport')),
                tabPanel("Tweeting Period",plotlyOutput('Period')),
                tabPanel("Domain Tweets",plotlyOutput('senti')),
                tabPanel("Domain Sentiments", dataTableOutput('text1')),
                tabPanel( "easyJet Airlines Sentiments", dataTableOutput('text')),
                tabPanel("Twitter Sentiment Maps", leafletOutput("mymap")),
                tags$head(tags$script(src="d3_tam.min.js")),
                tags$head(tags$style("tfoot {display: table-header-group;}"))
    )))
