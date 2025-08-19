


shinyServer(function(input, output, session) {
  myCSV <- reactive({
    if (input$TheFile=="Data_test.csv"){
    test_data_corrosion<-read.csv("Data_test.csv")
    }
    else {
        train_data_corrosion<-read.csv("Data_train.csv")
    }
    })
  
  #-----------------------------------------------------------------------------
  #  render data table
  #-----------------------------------------------------------------------------
  
  output$dataTable <- DT::renderDataTable(
    myCSV(), # data
    class = "display nowrap compact", # style
    filter = "top" # location of column filters
  )
  
  
  observeEvent(input$getinput,{
    
    log.predict<-eventReactive(input$getinput,{
     
        user_input<-as.matrix(t(c(input$Fe,input$Cr,input$Ni,input$Mo,input$W,input$N,input$Nb,
                         input$C,input$Si,input$Mn,input$Cu,input$P,input$S,
                         input$Al,input$Ce,input$Ti,input$NaCl,input$Temp)))
        #print(dim(user_input))             
        #nrow(user_input)<-1 
        #print(user_input)
        #Loaded_Model<-load(paste0("/home/sunidhi/Desktop/Corrosion_ML/Trained_Models/svrModel20_Log10_iPass_Model.rda"))
        #Loaded_Model <- load(paste0("/Users/sunidhigarg/Desktop/Corrosion_Scully_Group/Corrosion_ML/Trained_Models/svrModel20_Log10_iPass_Model.rda"))
        ML_prediction<-ModelPredictTrainfunction(user_input)
        return(ML_prediction)
      
    })
    
    Ml_pred<- function(){
      pred<-log.predict()
      colnames(pred)<-c('Predicted Log10_iPass (A/cm^2)', 'Uncertainty')
      rownames(pred) <- c('Machine Learning Model', 'Analytical Model')
      print("Checkpoint: 2")
      print(pred)
      return(pred)
      
    }
    output$ML_table <- renderTable(
      Ml_pred(), rownames=T, bordered=T
    )
    
    output.func<-eventReactive(input$getinput,{
      print("CHECKPOINT: 1")
      temp <- input$Fe+input$Cr+input$Ni+input$Mo+input$W+input$N+input$Nb+
        input$C+input$Si+input$Mn+input$Cu+input$P+input$S+
        input$Al+input$Ce+input$Ti
      print(temp)
      print(class(temp))
      if ((input$Fe+input$Cr+input$Ni+input$Mo+input$W+input$N+input$Nb+
           input$C+input$Si+input$Mn+input$Cu+input$P+input$S+
           input$Al+input$Ce+input$Ti)==100.00) {
        tableOutput("ML_table")
      } 
      else {
        print("WHY AM I HERE?")
        paste0("The chosen alloy composition currently adds to ", input$Fe+input$Cr+input$Ni+input$Mo+input$W+input$N+input$Nb+
                 input$C+input$Si+input$Mn+input$Cu+input$P+input$S+
                 input$Al+input$Ce+input$Ti,". It should add up to 100. Please readjust the chemical composition and try again.", sep="")
      }
    })
    output$ML_results <-renderUI({
      output.func()
     })
    
   
      #sink()
      #observeEvent(input$getinput, {
      # Show a modal when the button is pressed
      #  shinyalert("Oops!", "The alloy composition should add up to 100. Please adjust composition again.", type = "error")
      #})
    
  })
  
  
  output$PDP_Plot <- renderImage({
    filename <- normalizePath(file.path('www/',
                                        paste('POSTHOC_PDP_Plot_20Log10_iPass_',input$PDP_Plots,'.png', sep='')))
    list(src = filename,
         width = 700,
         height = 600)
  },deleteFile = FALSE)
  
  pdpimage.func<-eventReactive(input$getpdp,{
    imageOutput("PDP_Plot")
  })
  output$pdpfile<-renderUI({
    pdpimage.func()
  })


  
})


