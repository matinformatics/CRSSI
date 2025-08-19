


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
      if ((input$Fe+input$Cr+input$Ni+input$Mo+input$W+input$N+input$Nb+
           input$C+input$Si+input$Mn+input$Cu+input$P+input$S+
           input$Al+input$Ce+input$Ti)==100){
        tableOutput("ML_table")
      } else {
        paste0("The alloy composition  currently is ", input$Fe+input$Cr+input$Ni+input$Mo+input$W+input$N+input$Nb+
                 input$C+input$Si+input$Mn+input$Cu+input$P+input$S+
                 input$Al+input$Ce+input$Ti,". It should add up to 100. Please try again.", sep="")
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
  
  observeEvent(input$getpdp,{
  print(input$PDP_Plots)
  output$pdpfile<-renderImage({
    #req(input$PDP_Plots)   
    #filename <- normalizePath(file.path('/home/sunidhi/Desktop/Corrosion_WebApp/www',
     #                                   paste('POSTHOC_PDP_Plot_20Log10_iPass_',input$PDP_Plots,'.tiff', sep='')))
    list(src = file.path("/home/sunidhi/Desktop/Corrosion_WebApp/www/POSTHOC_PDP_Plot_20Log10_iPass_", paste0(input$PDP_Plots, ".tiff")),
         width = 400,
         height = 300,
         alt = paste("Image number", input$PDP_Plots))
  }, deleteFile=FALSE)
  })
  
})


