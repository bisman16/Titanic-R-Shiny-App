
# Calling the shiny library
library(shiny)

# Reading and saving the train data from Kaggle into df
trainingData <- read.csv("train.csv")
df <- trainingData


# Define UI for application that makes a table and a plot
ui <- navbarPage("Machine Learning from Titanic Disaster",
                 
                 # Create description panel
                 tabPanel(strong("Description"), strong('About the Titanic Disaster'), htmlOutput("text"), hr()),
                 
                 # Create table tab and side tab panels for table tab
                 tabPanel(strong('Table'), sidebarLayout(sidebarPanel(
                          fluidRow(
                            
                            # Tab panel for 'Sex'
                            column(4, checkboxGroupInput("Sex", "Sex:",
                                               choices = list('male','female'),
                                               selected = c('male','female'))),
                            
                            # Tab panel for 'pClass'
                            column(4, checkboxGroupInput("pclass",
                                               "Passenger Class:",
                                               choices = list('1','2','3'),
                                               selected = c('1','2','3'))),
                            
                            # Tab Panel for 'age'
                            column(4, checkboxGroupInput("age",
                                               "Passenger Age Group:",
                                               choices = list('1-15','15-30','30-45','45-60','60-75', '75-90'),
                                               selected = c('1-15','15-30','30-45','45-60','60-75', '75-90'))),
                           
                            # Tab panel for Passenger survival
                             column(4, checkboxGroupInput("survivedornot",
                                                      "Passenger Survival:",
                                                      choices = list('Yes','No'),
                                                      selected = c('Yes','No'))
                            
                          ))
                          ),
                         
                       # Showing the table ouput from the server side    
                       mainPanel(tableOutput('table')))
                  ),

                 # Create plot tab
                  tabPanel(strong("Plot"),
                  sidebarLayout(
                  
                    # Create side bar panels for plot tab
                    sidebarPanel(
                
                  # Choose the sample size - how many data points you want to plot 
                  # out of a total of 831 points. Default value - 600 entries
                  sliderInput('sampleSize', 'Choose Sample Size', min=1, max=nrow(df),
                  value=min(600, nrow(df)), step=100, round=0),
                  
                  br(),
                  
                  # Choose X and Y variables for the plot
                  
                  # Choosing Pclass as the default X variable as it is most important varaible
                  selectInput('x', 'X-axis variable', c(Age="Age", pclass="Pclass",sex="Sex",embarked="Embarked",survived="Survived"), selected = "Pclass"),
                  br(),
                  
                  # Choosing Survived as the default Y varaible
                  selectInput('y', 'Y-axis variable', c(Age="Age", pclass="Pclass",sex="Sex",embarked="Embarked",survived="Survived"), selected = "Survived"),
                  
                  # Chossing Sex as the default variable to distinuigh via color
                  selectInput('color', 'Color', selected = "Sex" , c('None', c(Age="Age", pclass="Pclass",sex="Sex",embarked="Embarked",survived="Survived"))),
                  
                  br(),
                  
                  # Choose if you want Jitter or Smooth plot
                  checkboxInput('jitter', 'Jitter'),
                  checkboxInput('smooth', 'Smooth'),
                  
                  # Use go button to see the results(non-reactive way)
                  br(),
                  actionButton("goButton", "Go!")),
                  

                  
                  # Showing the plot output from the server side
                  mainPanel(plotOutput('plot')))
                  
                  )
                  )

                 