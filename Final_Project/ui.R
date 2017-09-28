### This is the Shiny web app for Coursera DataScience Developing Data Product Final Project
### Charles 09/24/2017

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Permobil C500 Electrical Wheelchair Wheel Speed Estimation"),
  
  sidebarLayout(
    sidebarPanel(
        h3("Choose the input signal value (v)"),
       sliderInput("FB", "Input signal - Forward/Backward:", min = 4.5, max = 7.5, value = 6, step = 0.1),
       sliderInput("RL", "Input signal - Right/Left", min = 4.5, max = 7.5, value = 6, step = 0.1),
       br(),
       br(),
       h3("Wheel Speed (rpm)"),
       p("Right Wheel: "), textOutput("speedR"),
       br(),
       p("Left Wheel: "), textOutput("speedL")
    ),
    
    mainPanel(
            h3("Introduction:"),
            p("Electric Wheelchair Permobil C500 uses two signals to control the speed of two wheels, thus control the movement
of the wheelchair.
               These two signals are Forward/Backward and Right/Left.
               The range for both signals is from 4.5 V to 7.5 V.
               In order to estimate the movement of wheelchair for research experiment purpose, we need to know the relationship
               between these two signals and the wheel speed (rpm)."),
            p("This app could calculate the speed of two wheels according to the two input signals.
                On the left hand side, you can use the slider to choose the input signals.
                In the graph below, the red dot represents the status of the wheelchair according
                to the input signals you choose.
                While on the bottom left side, the app shows the value of the speed of two wheels.
               More details could see: "), tags$a(href="https://rpubs.com/CharlesD/311471", "More details"),
            plotOutput("plotRightWheel"),
            plotOutput("plotLeftWheel")
    )
  )
))
