source("libraries.R")
#source("/Users/sunidhigarg/Desktop/Corrosion_Scully_Group/Corrosion_WebApp/ModelPredTrain.R")
source("ModelPredTrain.R")

ui<- navbarPage(inverse = TRUE, "ML for Corrosion Science",
                
                #First Page - Dataset
                tabPanel("Dataset",
                         fluidPage(fluidRow(selectInput("TheFile", "File", 
                                                        choices = c("Data_train.csv", "Data_test.csv"))),
                                   fluidRow(column(12, div(dataTableOutput("dataTable")))))
                         
                ),
                
                tabPanel("ML Prediction",
                         #sidebarLayout(
                         #fluidPage(
                        #   useShinyalert(),  # Set up shinyalert
                        #   actionButton("getinput", "Preview")
                        # ),
                         
                         titlePanel("Inputs"),
                           sidebarPanel(
                             #shinythemes::themeSelector(),
                             HTML(("<h4>Select the Composition, NaCl concentration & Temperature.</h4>")),
                             #tableOutput("ML_table")
                             ),
                        
                            # br(),
                             #fluidRow(column(12,
                             mainPanel(
                                             div(style="display: inline-block; width: 265px;",sliderInput("Fe","Fe",min = 48,max=87, value=50, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Cr","Cr",min = 1, max=30,value = 30, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Ni","Ni",min = 0, max=23,value = 9, step = 0.1)),
                                             br(),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Mo","Mo",min = 1, max=30,value = 1, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("W","W",min = 0, max=0.7,value = 0, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("N","N",min = 0, max=2.5,value = 0, step = 0.01)),
                                             br(),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Nb","Nb",min = 0, max=1,value = 0, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("C","C",min = 0, max=1.5,value = 0, step = 0.01)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Si","Si", min = 0, max=2,value = 0, step = 0.001)),
                                             br(),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Mn", "Mn",min = 0, max=15,value = 0, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Cu", "Cu",min = 0, max=3.4,value = 0, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("P", "P",min = 0, max=0.05,value = 0, step = 0.001)),
                                             br(),
                                             div(style="display: inline-block; width: 265px;",sliderInput("S", "S",min = 0, max=1,value = 0, step = 0.01)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Al", "Al",min = 0, max=10,value = 10, step = 0.25)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Ce", "Ce",min = 0, max=0.01,value = 0, step = 0.001)),
                                             br(),
                                             #setSliderColor(c("DeepPink ", "#FF4500"), c(17, 18)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Ti", "Ti",min = 0, max=1,value = 0, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("NaCl", "NaCl Concentration",min = 0, max=4,value = 1, step = 0.1)),
                                             div(style="display: inline-block; width: 265px;",sliderInput("Temp", "Temperature",min = 20, max=30,value = 21, step = 1)),
                                             br(),
                                             #useShinyalert(),
                                             fluidRow(column(12,actionButton("getinput", "ML Prediction"))),
                                             br(),
                                             br(),
                                             tags$style(type="text/css",
                                                        ".shiny-output-error { visibility: hidden; }",
                                                        ".shiny-output-error:before { visibility: hidden; }"
                                             ),
                                             uiOutput("ML_results"),
                                             #textOutput("ML_table"),
                                             br(),
                                             br()
                                             
                             #))
                             ),
                        
                             
                           #),
                           #mainPanel(
                            # tags$style(type="text/css",
                            #           ".shiny-output-error { v  isibility: hidden; }",
                            #           ".shiny-output-error:before { visibility: hidden; }"
                             #),
                             #br(),
                            # br(),
                             #tableOutput("ML_table")
                           #)
                         #)
                ),
                
                tabPanel("PDP Plots",
                         fluidPage(fluidRow(selectInput("PDP_Plots", "Element", 
                                                        choices = c("Fe","Cr","Ni","Mo","W",
                                                                    "N","Nb","C","Si","Mn","Cu",
                                                                    "P","S","Al","Ce","Ti"))),
                                   fluidRow(column(12,actionButton("getpdp", "Print PDP Plots"))),
                                   fluidRow(column(12, div(imageOutput("pdpfile")))))
                ),
                
)

