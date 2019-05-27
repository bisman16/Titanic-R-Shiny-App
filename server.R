
# Calling the required libraries
library(shiny)
library(readxl)
library(ggplot2)

# Reading and saving the training data into df after converting 'Survived' into factors - 0 & 1
trainingData <- read.csv("train.csv")
trainingData$Survived <- factor(trainingData$Survived)
trainingData$Survived <- ifelse(trainingData$Survived == 1, "Yes","No")
df <- trainingData

# Define server logic required to display data table and plot
shinyServer(function(input, output) {
  
  
# Render/Create text output for Description tab - using HTML
 output$text <- renderText({
   
   HTML('<br>The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  
      On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, 
      killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international
      community and led to better safety regulations for ships. <br>

      <br>One of the reasons that the shipwreck led to such loss of life was that there were not enough 
      lifeboats for the passengers and crew. Although there was some element of luck involved in 
      surviving the sinking, some groups of people were more likely to survive than others,   
      such as women, children, and the upper-class. <br>
        
      <br> Using the train data from Kaggle, I made an interactive/reactive table and a plot with a 
      Go button (non-reactive). <br>
        
       <br> <strong>Table <br></strong> 
        Using reactive table, you can visaulize what kind of people survived the disaster based on
        Sex, Passenger class or Age. <br>
  
         <br><strong>Plot <br></strong>
          Using Plots with a go button, you can plot various factors that could be the reasons for
          survival on X and Y axis. You can choose your sample size by sliding the scrolling option.
          You can also make Jitter or/and Smooth plots. You can also use color option to distinguish 
          based on the values of categorical variable.<br>
          <br> The plot will help to anlayze the possible reasons why certain groups of people
          had a higher survival rate.')

 })
  
  
   
  # Render/Create data table for table tab
  output$table <- renderTable({
    
    
    # Read input file and store it in df
    df <- read.csv("train.csv")
    
    # Ignoring variables that don't matter for the anlysis, variables that have low statistical signficance 
    df$PassengerId <- NULL
    df$Name <- NULL
    df$Parch <-NULL
    df$Fare <- NULL
    df$Cabin <- NULL
    df$Ticket <- NULL
    df$Embarked <-NULL
    df$SibSp <- NULL

    
    # Converting 'Survived' variable into factors - 0 & 1
    df$Survived <- ifelse(df$Survived == 1, "Yes","No")
    
    # Omit NA values from the df and take values in df without it
    na.omit(df)
    df <- df[complete.cases(df),]
    
    # Filter the data according to Sex, Passenger class & Survived as per user input
    data1 <- df[df$Sex %in% input$Sex & df$Survived %in% input$survivedornot & df$Pclass %in% input$pclass,]
    
    # Using aobve filtered dataset (data1), further filter down by Age after converting it into
    # different age intervals (difference of 15 units)
    
    if (input$age == "1-15")
    { f <- c(0.00:15.00)
      data2 <- data1[data1$Age %in% f,]}
     
    else if (input$age == "15-30")
    { p <- c(16.00:30.00)
    data2 <- data1[data1$Age %in% p,]}
      
    else if (input$age == "30-45")
    { r <- c(31.00:45.00)
    data2 <- data1[data1$Age %in% r,]}
    
    else if (input$age == "45-60")
    { s <- c(46.00:60.00)
    data2 <- data1[data1$Age %in% s,]}
    
    else if (input$age == "60-75")
    { t <- c(61.00:75.00)
    data2 <- data1[data1$Age %in% t,]}
    
    else
      {data2 <- data1}
    
    
      # Return table data2 to the 'table' output
      return(data2)
    })
    
  
  # Choosing sample size
  dataset <- reactive (function() {
  
  trainingData[sample(nrow(trainingData), input$sampleSize), ]})
  
  # Render/Create plot for Plot tab
  output$plot <- reactivePlot(function() {
    
    # Go button for the changes to take place as per user input
    input$goButton
    
    # After go button is pressed, following changes are made
    isolate({
    dataset <- trainingData[sample(nrow(trainingData), input$sampleSize), ]
    
    p <- ggplot(dataset, aes_string(x=input$x, y=input$y)) + geom_point()
    
    if (input$color != 'None') 
      as.factor(input$color)
     
    p <- p + aes_string(color=input$color)
    
    if (input$jitter)
      p <- p + geom_jitter()
    
    if (input$smooth)
      p <- p + geom_smooth()
    
    # Print the rquired plot
    print(p)})
    
  }, height=500)
  
  })
