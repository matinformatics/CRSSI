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
     
        user_input<-as.matrix(t(c(input$Fe,input$Cr,input$Ni,input$Mo,input$N,input$Nb,
                         input$C,input$Si,input$Mn,input$Cu,input$P,input$S,
                         input$Al, input$V, input$Ta, input$Ce,input$Ti, input$Co, input$Y,
                         input$As, input$pH, input$Temp, input$NaCl, input$F, input$A, input$M)))
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
      rownames(pred) <- c('Machine Learning Model: eSVR', 'Machine Learning Model: eXGBoost')
      print("Checkpoint: 2")
      print(pred)
      return(pred)
      
    }
    output$ML_table <- renderTable(
      Ml_pred(), rownames=T, bordered=T
    )
    
    output.func<-eventReactive(input$getinput,{
      print("CHECKPOINT: 1")
      temp <- input$Fe+input$Cr+input$Ni+input$Mo+input$N+input$Nb+input$C+input$Si+
        input$Mn+input$Cu+input$P+input$S+input$Al+ 
        input$V+input$Ta+input$Ce+input$Ti+input$Co+input$Y+input$As
      print(temp)
      print(class(temp))
      if ((input$Fe+input$Cr+input$Ni+input$Mo+input$N+input$Nb+input$C+input$Si+
           input$Mn+input$Cu+input$P+input$S+input$Al+ 
           input$V+input$Ta+input$Ce+input$Ti+input$Co+input$Y+input$As)==100.00) {
        tableOutput("ML_table")
      } 
      else {
        print("WHY AM I HERE (Alloy Composition)?")
        paste0("The chosen alloy composition currently adds to ", input$Fe+input$Cr+input$Ni+input$Mo+input$N+input$Nb+input$C+input$Si+
                 input$Mn+input$Cu+input$P+input$S+input$Al+ 
                 input$V+input$Ta+input$Ce+input$Ti+input$Co+input$Y+input$As,". It should add up to 100. Please readjust the chemical composition and try again.", sep="")
      }
      
      print("CHECKPOINT: Phase Sum")
      phase_sum <- input$F + input$A + input$M
      print(phase_sum)
      print(class(phase_sum))
      if ((input$F + input$A + input$M)==100.00) {
        tableOutput("ML_table")
      } 
      else {
        print("WHY AM I HERE (PHASE)?")
        paste0("The chosen phase composition (sum of Ferrite + Austenite + Martensite) currently adds to ", 
               input$F + input$A + input$M,". It should add up to 100. Please readjust the phase fraction and try again.", sep="")
      }
    })
    output$ML_results <-renderUI({
      output.func()
     })
  })
  
  output$PDP_Plot <- renderImage({
    filename <- normalizePath(file.path('www/',
                                        paste('eXGBoost_PDP_50_',input$PDP_Plots,'_Log10_ipass.png', sep='')))
    print(filename)
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


