library(shinydashboard)
library(shiny)
library(ggmap)
library(leaflet)
library(plotly)
palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

shinyServer(function(input, output, session) {
  
  
  # Combine the selected variables into a new data frame
  
  
  output$text <- renderDataTable({
    easyJet.sentiments <- read.csv("twitter_final_feed_20_30_jan.csv")
    Sentiment_txt <- easyJet.sentiments[,c(21,19,20)]
    names(Sentiment_txt) <- c("Tweet","Polarity","Emotion")
    Sentiment_txt$Text <- as.vector(Sentiment_txt$Text)
    Sentiment_txt
  })
  
  output$text1 <- renderDataTable({
    easyJet.sentiments <- read.csv("twitter_final_feed_20_30_jan.csv")
    Sentiment_txt <- easyJet.sentiments[,c(22,21,19)]
    names(Sentiment_txt) <- c("Domain","Tweet","Polarity")
    Sentiment_txt$Text <- as.vector(Sentiment_txt$Text)
    Sentiment_txt
  })
  
  
  output$senti <- renderPlotly({
     f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = 'rgb(240, 88, 0)' 
    )
    x <- list(
      title = "PAX Journey Tweet areas",
      titlefont = f
    )
    y <- list(
      title = " Tweet counts",
      titlefont = f
    )
    
    easyJet_Domain_Tweets <- read.csv("easyJet_Domain_20_30.csv")
    tweethist <- plot_ly(easyJet_Domain_Tweets, x = easyJet_Domain_Tweets$Handle,y=easyJet_Domain_Tweets$freq, color = easyJet_Domain_Tweets$Polarity,colors=c("#FFA500","#FF0000","#008000"),type="scatter",mode="lines") %>% layout(xaxis = x, yaxis = y,title="Tweet Counts Across Domains")
    tweethist
  })
  
  output$Period <- renderPlotly({
    f <- list(
      family = "Courier New, monospace",
      size = 18,
      color = 'rgb(240, 88, 0)' 
    )
    x <- list(
      title = "Time",
      titlefont = f
    )
    y <- list(
      title = " Tweet counts",
      titlefont = f
    )
    
    #aggdata_time_graph <- count(processed_feed_test,c("DayCat"))
    easyJet_TweetTime <- read.csv("agg_time_graph_20_30.csv")
    tweethist <- plot_ly(easyJet_TweetTime, x =easyJet_TweetTime$Time,y=easyJet_TweetTime$freq, color = easyJet_TweetTime$DayCat,colors=c("#008000","#FF0000","#FFA500"),type="bar") %>%
      layout(xaxis = x, yaxis = y,title="Tweet Counts Across Time Duration:21st Jan-31st Jan")
    tweethist
  })
  
  output$TwitterPolarityReport <- renderPlotly({
    polarity_graph <- read.csv("easyJet_Domain_20_30.csv")
    easyJet_TweetTime <- read.csv("easyJet_Tweet_Time.csv")
    p <- plot_ly(polarity_graph, x = polarity_graph$Polarity, y = polarity_graph$freq, type = 'bar', name = 'Polarity',color=I("orange"),text=c("Customer Sentiments")) %>% layout(title = "Twitter 21st JAN - 31st JAN Polarity Report",xaxis = list(title = "Polarity"),yaxis = list(title = "Tweet Count"))
    p
    #par(mfrow = c(2,2))
    #p <- plot_ly(emotion_graph, x = emotion_graph$`easyJet.sentiments$Emotions`, y = emotion_graph$V1, type = 'bar', name = 'Polarity',color=I("orange"),text=c("Customer Emotions")) %>% layout(title = "Twitter JAN 3rd- JAN 13th Polarity Report",xaxis = list(title = "Emtions"),yaxis = list(title = "Tweet Count"))
    #p
  })
  
  
    output$showfile <- renderUI({
    HTML(readLines("www/DashboardTam.html"))
    #includeHTML("www/Dashboard.html")
  })
  
  output$mymap <- renderLeaflet({
    #locations_res <- read.csv("vistara_locations.csv")
    #locations <- read.csv("lufthansa_process.csv")
    #american_airlines_locations1 <- read.csv("american_airlines_locations1.csv")
    #result <- transform((table(locations$polarity)),percentage_column=Freq/nrow(locations)*100)
    #result <- transform((table(american_airlines_locations1$polarity)),percentage_column=Freq/nrow(american_airlines_locations1)*100)
    #result1 <- ifelse(result$percentage_column>50,"Positive Tweet=51.87688",ifelse(result$percentage_column>21 & result$percentage_column<=30,"Negative=27.47989","Comments=20.64343"))
    #result1 <- as.factor(result1)
    #Color_Assets <- colorFactor(c("orange","red","green"),levels = result1,ordered=FALSE)
    #3pal <- colorNumeric(
    #  palette = "YlGnBu",
    #  domain = result$percentage_column
    #)
    
    #locations <- read.csv("locations_lufthansa.csv")
    easyJet_Tweet_Locations <- read.csv("locations_Without_null1.csv")
    m <- leaflet() %>%
      
      addTiles() %>%  # Add default OpenStreetMap map tiles
      
      addMarkers(easyJet_Tweet_Locations$lon, easyJet_Tweet_Locations$lat,popup=easyJet_Tweet_Locations$polarity)# %>%   #%>%
      #addLegend("bottomright", pal = Color_Assets, values = result1,title = "+/- Tweets",opacity = 1)
    m
    
  })
})