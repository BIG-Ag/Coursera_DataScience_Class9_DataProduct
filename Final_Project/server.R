### This is the Shiny web app for Coursera DataScience Developing Data Product Final Project
### Charles 09/24/2017

library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
        data <- read.csv("Experiment_Data.csv", header = TRUE)
        dataWheel <- data[2:nrow(data),] %>%
                select(1:4) %>%
                'colnames<-'(c("FB","RL","RW","LW")) %>%
                mutate(RWSpeed = as.numeric(as.character(RW)) * 4) %>%
                mutate(LWSpeed = as.numeric(as.character(LW)) * 4)
        fitRight <- lm(RWSpeed ~ as.numeric(as.character(FB)) + as.numeric(as.character(RL)), data = dataWheel)
        fitLeft <- lm(LWSpeed ~ as.numeric(as.character(FB)) + as.numeric(as.character(RL)), data = dataWheel)
        dataWheel$FB <- as.numeric(as.character(dataWheel$FB))

  output$plotRightWheel <- renderPlot({
          
          dataPoint <- data.frame(FB = input$FB, RL = input$RL)
          dataPoint <- mutate(dataPoint, speedR = predict(fitRight, dataPoint)) %>%
                       mutate(speedL = predict(fitLeft, dataPoint))
          gRight <- ggplot(dataWheel, aes(x=FB, y=RWSpeed, color = RL, group = RL)) +
                  geom_point() +
                  geom_line() +
                  geom_smooth(method = lm) +
                  geom_point(data=dataPoint, aes(x=FB, y=speedR), 
                             size=6,color="#CC0000") +
                  xlab("Forward/Backward(V)") +
                  ylab("RightWheel_Speed(rpm)") +
                  scale_x_continuous(breaks = round(seq(min(dataWheel$FB), max(dataWheel$FB), by = 0.5),1)) +
                  guides(color=guide_legend(title="Right/Left"))
          gRight
    
  }, width = 600, height = 400)
  output$plotLeftWheel <- renderPlot({
          dataPoint <- data.frame(FB = input$FB, RL = input$RL)
          dataPoint <- mutate(dataPoint, speedR = predict(fitRight, dataPoint)) %>%
                  mutate(speedL = predict(fitLeft, dataPoint))
          gLeft <- ggplot(dataWheel, aes(x=FB, y=LWSpeed, color = RL, group = RL)) +
                  geom_point() +
                  geom_line() +
                  geom_smooth(method = lm) +
                  geom_point(data=dataPoint, aes(x=FB, y=speedL), 
                             size=6,color="#CC0000") +
                  xlab("Forward/Backward(V)") +
                  ylab("LeftWheel_Speed(rpm)") +
                  scale_x_continuous(breaks = round(seq(min(dataWheel$FB), max(dataWheel$FB), by = 0.5),1)) +
                  guides(color=guide_legend(title="Right/Left"))
          gLeft
          
  }, width = 600, height = 400)
  output$speedR <- renderText({
          dataPoint <- data.frame(FB = input$FB, RL = input$RL)
          dataPoint <- mutate(dataPoint, speedR = predict(fitRight, dataPoint)) %>%
                  mutate(speedL = predict(fitLeft, dataPoint))
          dataPoint$speedR
          })
  output$speedL <- renderText({
          dataPoint <- data.frame(FB = input$FB, RL = input$RL)
          dataPoint <- mutate(dataPoint, speedR = predict(fitRight, dataPoint)) %>%
                  mutate(speedL = predict(fitLeft, dataPoint))
          dataPoint$speedL
          })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
})