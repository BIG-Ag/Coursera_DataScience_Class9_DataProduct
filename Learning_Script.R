### This is the learning script of Coursera DataScience Class 9 Data Product
### Charles 09/13/2017

setwd("C:/Study/Coursera/1 Data-Science/2 RStudio/9 Class 9/Coursera_DataScience_Class9_DataProduct")

############################ Week 1 ##########################
### Shiny
install.packages("shiny")
library(shiny)

# ui.R
shinyUI(pageWithSidebar(
        headerPanel("Data science FTW!"),
        sidebarPanel(
                h3('Sidebar text')
        ),
        mainPanel(
                h3('Main Panel text')
        )
))

# Example
library(shiny)
shinyUI(fluidPage(
        titlePanel("Slider App"),
        sidebarLayout(
                sidebarPanel(
                        h1("Move the Slider!"),
                        sliderInput("slider1", "Slide Me!", 0, 100, 0)
                ),
                mainPanel(
                        h3("Slider Value:"),
                        textOutput("text")
                )
        )
))
library(shiny)
shinyServer(function(input, output) {
        output$text <- renderText(input$slider1)
})

# Example
library(shiny)
shinyUI(fluidPage(
        titlePanel("Plot Random Numbers"),
        sidebarLayout(
                sidebarPanel(
                        numericInput("numeric", "How Many Random Numbers Should be Plotted?", 
                                     value = 1000, min = 1, max = 1000, step = 1),
                        sliderInput("sliderX", "Pick Minimum and Maximum X Values",
                                    -100, 100, value = c(-50, 50)),
                        sliderInput("sliderY", "Pick Minimum and Maximum Y Values",
                                    -100, 100, value = c(-50, 50)),
                        checkboxInput("show_xlab", "Show/Hide X Axis Label", value = TRUE),
                        checkboxInput("show_ylab", "Show/Hide Y Axis Label", value = TRUE),
                        checkboxInput("show_title", "Show/Hide Title")
                ),
                mainPanel(
                        h3("Graph of Random Points"),
                        plotOutput("plot1")
                )
        )
))
library(shiny)
shinyServer(function(input, output) {
        output$plot1 <- renderPlot({
                set.seed(2016-05-25)
                number_of_points <- input$numeric
                minX <- input$sliderX[1]
                maxX <- input$sliderX[2]
                minY <- input$sliderY[1]
                maxY <- input$sliderY[2]
                dataX <- runif(number_of_points, minX, maxX)
                dataY <- runif(number_of_points, minY, maxY)
                xlab <- ifelse(input$show_xlab, "X Axis", "")
                ylab <- ifelse(input$show_ylab, "Y Axis", "")
                main <- ifelse(input$show_title, "Title", "")
                plot(dataX, dataY, xlab = xlab, ylab = ylab, main = main,
                     xlim = c(-100, 100), ylim = c(-100, 100))
        })
})

# Horsepower prediction
library(shiny)
shinyUI(fluidPage(
        titlePanel("Predict Horsepower from MPG"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderMPG", "What is the MPG of the car?", 10, 35, value = 20),
                        checkboxInput("showModel1", "Show/Hide Model 1", value = TRUE),
                        checkboxInput("showModel2", "Show/Hide Model 2", value = TRUE),
                        submitButton("Submit") # New!
                ),
                mainPanel(
                        plotOutput("plot1"),
                        h3("Predicted Horsepower from Model 1:"),
                        textOutput("pred1"),
                        h3("Predicted Horsepower from Model 2:"),
                        textOutput("pred2")
                )
        )
))
library(shiny)
shinyServer(function(input, output) {
        mtcars$mpgsp <- ifelse(mtcars$mpg - 20 > 0, mtcars$mpg - 20, 0)
        model1 <- lm(hp ~ mpg, data = mtcars)
        model2 <- lm(hp ~ mpgsp + mpg, data = mtcars)
        
        model1pred <- reactive({
                mpgInput <- input$sliderMPG
                predict(model1, newdata = data.frame(mpg = mpgInput))
        })
        
        model2pred <- reactive({
                mpgInput <- input$sliderMPG
                predict(model2, newdata = 
                                data.frame(mpg = mpgInput,
                                           mpgsp = ifelse(mpgInput - 20 > 0,
                                                          mpgInput - 20, 0)))
        })
        output$plot1 <- renderPlot({
                mpgInput <- input$sliderMPG
                
                plot(mtcars$mpg, mtcars$hp, xlab = "Miles Per Gallon", 
                     ylab = "Horsepower", bty = "n", pch = 16,
                     xlim = c(10, 35), ylim = c(50, 350))
                if(input$showModel1){
                        abline(model1, col = "red", lwd = 2)
                }
                if(input$showModel2){
                        model2lines <- predict(model2, newdata = data.frame(
                                mpg = 10:35, mpgsp = ifelse(10:35 - 20 > 0, 10:35 - 20, 0)
                        ))
                        lines(10:35, model2lines, col = "blue", lwd = 2)
                }
                legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16, 
                       col = c("red", "blue"), bty = "n", cex = 1.2)
                points(mpgInput, model1pred(), col = "red", pch = 16, cex = 2)
                points(mpgInput, model2pred(), col = "blue", pch = 16, cex = 2)
        })
        
        output$pred1 <- renderText({
                model1pred()
        })
        
        output$pred2 <- renderText({
                model2pred()
        })
})


# Tabs
library(shiny)
shinyUI(fluidPage(
        titlePanel("Tabs!"),
        sidebarLayout(
                sidebarPanel(
                        textInput("box1", "Enter Tab 1 Text:", value = "Tab 1!"),
                        textInput("box2", "Enter Tab 2 Text:", value = "Tab 2!"),
                        textInput("box3", "Enter Tab 3 Text:", value = "Tab 3!")
                ),
                mainPanel(
                        tabsetPanel(type = "tabs", 
                                    tabPanel("Tab 1", br(), textOutput("out1")), 
                                    tabPanel("Tab 2", br(), textOutput("out2")), 
                                    tabPanel("Tab 2", br(), textOutput("out3"))
                        )
                )
        )
))
library(shiny)
shinyServer(function(input, output) {
        output$out1 <- renderText(input$box1)
        output$out2 <- renderText(input$box2)
        output$out3 <- renderText(input$box3)
})

# Interactive Graphics
library(shiny)
shinyUI(fluidPage(
        titlePanel("Visualize Many Models"),
        sidebarLayout(
                sidebarPanel(
                        h3("Slope"),
                        textOutput("slopeOut"),
                        h3("Intercept"),
                        textOutput("intOut")
                ),
                mainPanel(
                        plotOutput("plot1", brush = brushOpts(
                                id = "brush1"
                        ))
                )
        )
))
library(shiny)
shinyServer(function(input, output) {
        model <- reactive({
                brushed_data <- brushedPoints(trees, input$brush1,
                                              xvar = "Girth", yvar = "Volume")
                if(nrow(brushed_data) < 2){
                        return(NULL)
                }
                lm(Volume ~ Girth, data = brushed_data)
        })
        output$slopeOut <- renderText({
                if(is.null(model())){
                        "No Model Found"
                } else {
                        model()[[1]][2]
                }
        })
        output$intOut <- renderText({
                if(is.null(model())){
                        "No Model Found"
                } else {
                        model()[[1]][1]
                }
        })
        output$plot1 <- renderPlot({
                plot(trees$Girth, trees$Volume, xlab = "Girth",
                     ylab = "Volume", main = "Tree Measurements",
                     cex = 1.5, pch = 16, bty = "n")
                if(!is.null(model())){
                        abline(model(), col = "blue", lwd = 2)
                }
        })
})


### Shiny Gadget
library(shiny)
library(miniUI)

myFirstGadget <- function() {
        ui <- miniPage(
                gadgetTitleBar("My First Gadget")
        )
        server <- function(input, output, session) {
                # The Done button closes the app
                observeEvent(input$done, {
                        stopApp()
                })
        }
        runGadget(ui, server)
}

myFirstGadget()

# Another example
multiplyNumbers <- function(numbers1, numbers2) {
        ui <- miniPage(
                gadgetTitleBar("Multiply Two Numbers"),
                miniContentPanel(
                        selectInput("num1", "First Number", choices=numbers1),
                        selectInput("num2", "Second Number", choices=numbers2)
                )
        )
        server <- function(input, output, session) {
                observeEvent(input$done, {
                        num1 <- as.numeric(input$num1)
                        num2 <- as.numeric(input$num2)
                        stopApp(num1 * num2)
                })
        }
        runGadget(ui, server)
}
multiplyNumbers(1:5, 1:5)

# Graphics 
pickTrees <- function() {
        ui <- miniPage(
                gadgetTitleBar("Select Points by Dragging your Mouse"),
                miniContentPanel(
                        plotOutput("plot", height = "100%", brush = "brush")
                )
        )
        server <- function(input, output, session) {
                output$plot <- renderPlot({
                        plot(trees$Girth, trees$Volume, main = "Trees!",
                             xlab = "Girth", ylab = "Volume")
                })
                observeEvent(input$done, {
                        stopApp(brushedPoints(trees, input$brush,
                                              xvar = "Girth", yvar = "Volume"))
                })
        }
        
        runGadget(ui, server)
}


### GoogleVis
library(googleVis)
suppressPackageStartupMessages(library(googleVis))
M <- gvisMotionChart(Fruits, "Fruit", "Year",
                     options=list(width=600, height=400))
print(M,"chart")
plot(M)

G <- gvisGeoChart(Exports, locationvar="Country",
                  colorvar="Profit",options=list(width=600, height=400))
print(G,"chart")
plot(G)


### Plotly
install.packages("plotly")
library(plotly)
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter") # mode = "markers"
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", color = ~factor(cyl))
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", color = ~disp)
plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", 
        color = ~factor(cyl), size = ~hp)
# 3D plot
set.seed(2016-07-21)
temp <- rnorm(100, mean = 30, sd = 5)
pressue <- rnorm(100)
dtime <- 1:100
plot_ly(x = ~temp, y = ~pressue, z = ~dtime,
        type = "scatter3d", color = ~temp)

# Line Graphs
data("airmiles")
plot_ly(x = ~time(airmiles), y = ~airmiles, type = "scatter", mode = "lines")

library(tidyr)
library(dplyr)
data("EuStockMarkets")
head(EuStockMarkets)

stocks <- as.data.frame(EuStockMarkets) %>%
        gather(index, price) %>%
        mutate(time = rep(time(EuStockMarkets), 4))

plot_ly(stocks, x = ~time, y = ~price, color = ~index, type = "scatter", mode = "lines")

# Choropleth Maps
# Create data frame
state_pop <- data.frame(State = state.abb, Pop = as.vector(state.x77[,1]))
# Create hover text
state_pop$hover <- with(state_pop, paste(State, '<br>', "Population:", Pop))
# Make state borders white
borders <- list(color = toRGB("red"))
# Set up some mapping options
map_options <- list(
        scope = 'usa',
        projection = list(type = 'albers usa'),
        showlakes = TRUE,
        lakecolor = toRGB('white')
)
plot_ly(z = ~state_pop$Pop, text = ~state_pop$hover, locations = ~state_pop$State, 
        type = 'choropleth', locationmode = 'USA-states', 
        color = state_pop$Pop, colors = 'Blues', marker = list(line = borders)) %>%
        layout(title = 'US Population in 1975', geo = map_options)



### Leaflet
### Interactive maps
install.packages("leaflet")
library(leaflet)
my_map <- leaflet() %>% 
        addTiles()
my_map

# Add markers
my_map <- my_map %>%
        addMarkers(lat=39.2980803, lng=-76.5898801, 
                   popup="Jeff Leek's Office")
my_map

# Add more markers
set.seed(2016-04-25)
df <- data.frame(lat = runif(20, min = 39.2, max = 39.3),
                 lng = runif(20, min = -76.6, max = -76.5))
df %>% 
        leaflet() %>%
        addTiles() %>%
        addMarkers()

# Custom Icon
hopkinsIcon <- makeIcon(
        iconUrl = "http://brand.jhu.edu/content/uploads/2014/06/university.shield.small_.blue_.png",
        iconWidth = 31*215/230, iconHeight = 31,
        iconAnchorX = 31*215/230/2, iconAnchorY = 16
)

hopkinsLatLong <- data.frame(
        lat = c(39.2973166, 39.3288851, 39.2906617),
        lng = c(-76.5929798, -76.6206598, -76.5469683))

hopkinsLatLong %>% 
        leaflet() %>%
        addTiles() %>%
        addMarkers(icon = hopkinsIcon)
# Add websites
hopkinsSites <- c(
        "<a href='http://www.jhsph.edu/'>East Baltimore Campus</a>",
        "<a href='https://apply.jhu.edu/visit/homewood/'>Homewood Campus</a>",
        "<a href='http://www.hopkinsmedicine.org/johns_hopkins_bayview/'>Bayview Medical Center</a>",
        "<a href='http://www.peabody.jhu.edu/'>Peabody Institute</a>",
        "<a href='http://carey.jhu.edu/'>Carey Business School</a>"
)

hopkinsLatLong %>% 
        leaflet() %>%
        addTiles() %>%
        addMarkers(icon = hopkinsIcon, popup = hopkinsSites)

# Mapping Clusters
df <- data.frame(lat = runif(500, min = 39.25, max = 39.35),
                 lng = runif(500, min = -76.65, max = -76.55))
df %>% 
        leaflet() %>%
        addTiles() %>%
        addMarkers(clusterOptions = markerClusterOptions())

# Add circle markers
df <- data.frame(lat = runif(20, min = 39.25, max = 39.35),
                 lng = runif(20, min = -76.65, max = -76.55))
df %>% 
        leaflet() %>%
        addTiles() %>%
        addCircleMarkers()

# Drawing circles
md_cities <- data.frame(name = c("Baltimore", "Frederick", "Rockville", "Gaithersburg", 
                                 "Bowie", "Hagerstown", "Annapolis", "College Park", "Salisbury", "Laurel"),
                        pop = c(619493, 66169, 62334, 61045, 55232,
                                39890, 38880, 30587, 30484, 25346),
                        lat = c(39.2920592, 39.4143921, 39.0840, 39.1434, 39.0068, 39.6418, 38.9784, 38.9897, 38.3607, 39.0993),
                        lng = c(-76.6077852, -77.4204875, -77.1528, -77.2014, -76.7791, -77.7200, -76.4922, -76.9378, -75.5994, -76.8483))
md_cities %>%
        leaflet() %>%
        addTiles() %>%
        addCircles(weight = 1, radius = sqrt(md_cities$pop) * 30)

# Drawing rectangles
leaflet() %>%
        addTiles() %>%
        addRectangles(lat1 = 37.3858, lng1 = -122.0595, 
                      lat2 = 37.3890, lng2 = -122.0625)

# Add legend
df <- data.frame(lat = runif(20, min = 39.25, max = 39.35),
                 lng = runif(20, min = -76.65, max = -76.55),
                 col = sample(c("red", "blue", "green"), 20, replace = TRUE),
                 stringsAsFactors = FALSE)

df %>%
        leaflet() %>%
        addTiles() %>%
        addCircleMarkers(color = df$col) %>% 
        addLegend(labels = LETTERS[1:3], colors = c("blue", "red", "green"))


### Quiz 2
library(leaflet)
chnRestMap <- data.frame(name = c("Chong Qing Special Noodles",
                                  "Szechuan Impression",
                                  "Tasty Garden Restaurant",
                                  "101 Noodle Express",
                                  "Blackball",
                                  "Chengdu Taste",
                                  "Half & Half Tea House MP",
                                  "MaMa Lu's Dumpling House",
                                  "Elite Restaurant",
                                  "Liang's Kitchen",
                                  "Jiouding Hot Pot",
                                  "Lao Sze Chuan"),
                         lat = c(34.103302,
                                 34.076859,
                                 34.077989,
                                 34.078805,
                                 34.079277,
                                 34.079995,
                                 34.063663,
                                 34.062745,
                                 34.053675,
                                 34.052429,
                                 34.051904,
                                 34.147087),
                         lng = c(-118.091836,
                                 -118.144757,
                                 -118.124901,
                                 -118.109591,
                                 -118.103708,
                                 -118.082519,
                                 -118.134557,
                                 -118.121667,
                                 -118.135503,
                                 -118.136388,
                                 -118.090359,
                                 -118.254455))
restSites <- c(
        "<a href= 'https://www.yelp.com/biz/%E9%87%8D%E5%BA%86%E5%B0%8F%E9%9D%A2-best-noodle-house-rosemead?osq=chongqing+noodle'>Chongqing Special Noodles</a>",
        "<a href= 'https://www.yelp.com/biz/szechuan-impression-alhambra-3'>Szechuan Impression</a>",
        "<a href= 'https://www.yelp.com/biz/tasty-garden-alhambra'>Szechuan Impression</a>",
        "<a href= 'https://www.yelp.com/biz/101-noodle-express-alhambra'>101 Noodle Express</a>",
        "<a href= 'https://www.yelp.com/biz/blackball-taiwanese-dessert-san-gabriel-2'>Blackball</a>",
        "<a href= 'https://www.yelp.com/biz/chengdu-taste-rosemead-5'>Chengdu Taste</a>",
        "<a href= 'https://www.yelp.com/biz/half-and-half-tea-express-monterey-park-monterey-park'>Half & Half Tea House MP</a>",
        "<a href= 'https://www.yelp.com/biz/mamas-lu-dumpling-house-monterey-park-4'>MaMa Lu's Dumpling House</a>",
        "<a href= 'https://www.yelp.com/biz/elite-restaurant-monterey-park'>Elite Restaurant</a>",
        "<a href= 'https://www.yelp.com/biz/liangs-kitchen-monterey-park'>Liang's Kitchen</a>",
        "<a href= 'https://www.yelp.com/biz/jiouding-hot-pot-rosemead'>Jiouding Hot Pot</a>",
        "<a href= 'https://www.yelp.com/biz/lao-sze-chuan-glendale-4'>Lao Sze Chuan</a>"
)
chnRestMap %>%
        leaflet() %>%
        addTiles() %>%
        addMarkers(popup = restSites,
                   clusterOptions = markerClusterOptions())

"<a href= ''></a>"



########## Week3 R Packages
system("R CMD build newpackage")
system("R CMD check newpackage")


### project2
library(plotly)
library(grid)
library(gridExtra)

# Load data
data <- read.csv("Experiment_Data.csv", header = TRUE)
head(data)

# Transform data
dataWheel <- data[2:nrow(data),] %>%
        select(1:4) %>%
        'colnames<-'(c("FB","RL","RW","LW")) %>%
        mutate(RWSpeed = as.numeric(as.character(RW)) * 4) %>%
        mutate(LWSpeed = as.numeric(as.character(LW)) * 4)
head(dataWheel)

# Plot graph
gRight <- ggplot(dataWheel, aes(x=FB, y=RWSpeed, color = RL, group = RL)) +
        geom_point() +
        geom_line() +
        xlab("Forward/Backward(V)") +
        ylab("RightWheel_Speed(rpm)")
gLeft <- ggplot(dataWheel, aes(x=FB, y=LWSpeed, color = RL, group = RL)) +
        geom_point() +
        geom_line() +
        xlab("Forward/Backward(V)") +
        ylab("LeftWheel_Speed(rpm)")
grid.arrange(gRight,gLeft,ncol=1)
g <- arrangeGrob(gRight,gLeft,ncol=1)
ggsave("OriginalPoint.png",g, width = 8.5, height = 11, units = "in")

# Fit linear regression model
fitRight <- lm(RWSpeed ~ as.numeric(as.character(FB)) + as.numeric(as.character(RL)), data = dataWheel)
fitLeft <- lm(LWSpeed ~ as.numeric(as.character(FB)) + as.numeric(as.character(RL)), data = dataWheel)
summary(fitRight)
summary(fitLeft)

# Try to predict
dataWheel2 <- mutate(dataWheel, SpeedR=predict(fitRight,dataWheel)) %>%
        mutate(speedL=predict(fitLeft,dataWheel))
gRight <- ggplot(dataWheel2, aes(x=FB, y=RWSpeed, color = RL, group = RL)) +
        geom_point() +
        geom_line() +
        xlab("Forward/Backward(V)") +
        ylab("RightWheel_Speed(rpm)")
gRight

geom_line(dataWheel2, aes(x=FB, y=SpeedR, color=RL, group=RL)) +
        


gRightFit <- ggplot(dataWheel, aes(x=FB, y=RWSpeed, color = RL, group = RL)) +
        geom_point() +
        geom_line() +
        geom_smooth(method = lm) +
        xlab("Forward/Backward(V)") +
        ylab("RightWheel_Speed(rpm)")
gLeftFit <- ggplot(dataWheel, aes(x=FB, y=LWSpeed, color = RL, group = RL)) +
        geom_point() +
        geom_line() +
        geom_smooth(method = lm) +
        xlab("Forward/Backward(V)") +
        ylab("LeftWheel_Speed(rpm)")
grid.arrange(gRightFit,gLeftFit,ncol=1)
g <- arrangeGrob(gRightFit,gLeftFit,ncol=1)
ggsave("FitLinearModel.png",g, width = 8.5, height = 11, units = "in")

# Test
dataPoint <- data.frame(FB = 5, RL = 7, RW = 1, LW = 1, RWSpeed = 1, LWSpeed =1)
dataPoint <- data.frame(FB = 5, RL = 7)
dataPoint <- mutate(dataPoint, speedR = predict(fitRight, dataPoint)) %>%
        mutate(speedL = predict(fitLeft, dataPoint))

geom_point(dataPoint, aes(x=FB, y=speedR)) +
        



############ Week 4
### Swirl
install.packages("swirl")
library(swirl)
install.packages("swirlify")
library(swirlify)

swirlify("Lesson 1", "My First Course")

wq_command()
wq_text()
test_lesson()
add_to_manifest()
demo_lesson()


get_current_lesson()

new_lesson("lesson2", "My First Course")

wq_multiple()
wq_figure()

### Shiny app
install.packages("rsconnect")
library(rsconnect)
rsconnect::setAccountInfo(name='charlesd',
                          token='9168722A2F6DF3B02AD31C00B2E1B7A5',
                          secret='JkeZWJY43ZjWw9rCzCMjKEvFCkT2TZNdpKHIGTQs')
Sys.setlocale(locale="English")
install.packages("devtools")
library(devtools)




























































