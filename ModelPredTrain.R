ModelPredictTrainfunction=function(user_input){
  Loaded_Model <- load(paste0("svrModel25_Log10_ipass_Model.rda"))
  Loaded_Model_eXGBoost <- readRDS(paste0("eXGBoost_50_Log10_ipass_Model.model"))
  #Loaded_Model_analytical <- load(paste0("ipass_analytical_model.rda"))
  nboot<-25
  #output=output
  train.pred=NULL
  rsq.pred=NULL
  rsq <- function (x, y) cor(x, y) ^ 2
  train_performance <- user_input
  i=1
  repeat{
    train.pred[[i]] = predict(get(Loaded_Model)[[i]], train_performance)
    i=i+1
    if(i>nboot) break ()
  }
  #train.pred = predict(get(Loaded_Model), train_performance)
  train.pred.df <- as.data.frame(train.pred)
  train.pred.df.mean = rowMeans(as.matrix(train.pred.df))
  train.pred.df.sd = rowSds(as.matrix(train.pred.df))
  
  rsq.pred <- rsq(train_performance[,dim(train_performance)[2]], train.pred.df.mean)
  
  #### eXGBoost Model ####
  n_bootstrap <- 50
  xgb.pred <- NULL
  for (i in 1:n_bootstrap) {
    xgb.pred[[i]] = predict(Loaded_Model_eXGBoost[[i]],train_performance,reshape=T)
  }
  
  xgb.pred.df <- t(data.frame(matrix(unlist(xgb.pred), nrow=length(xgb.pred), byrow=TRUE)))
  
  pred_mean_test <- rowMeans(xgb.pred.df)             # Mean prediction
  pred_sd_test <- apply(xgb.pred.df, 1, sd)           # SD prediction
  
  results_test_exgboost <- data.frame(
    #actual = test.label,
    predicted_mean = pred_mean_test,
    predicted_sd = pred_sd_test
    #ci_lower = pred_ci[, 1],
    #ci_upper = pred_ci[, 2]
  )
  
  
  #### Analytical Model ####
  #analytical <- NULL
  #print("CHECKPOINT 1:")
  #print(str(train_performance))
  #train_performance <- data.frame(train_performance)
  #print(train_performance)
  
  #colnames(train_performance) <- c("Fe", "Cr", "Ni", "Mo", "W", "N", "Nb", "C", "Si",
  #                                 "Mn", "Cu", "P", "S", "Al", "Ce", "Ti", "NaCl_Conc_M", "Temperature")
  
  #x2_NaCl <- train_performance$NaCl_Conc_M^2
  #MoN <- (train_performance$Mo*train_performance$N)^2
  #Cu <- train_performance$Cu
  #Mo <- train_performance$Mo
  #Ni <- train_performance$Ni
  #Al <- train_performance$Al
  #x2_Cu <- train_performance$Cu^2
  #term1 <- train_performance$Ti/(train_performance$Mo-train_performance$C)
  #term2 <- (train_performance$Fe*train_performance$Nb)*(train_performance$Cu-train_performance$Mo)
  
  #beta <- (Ti*(NaCl_Conc_M^2-Cr))/(Nb^2+Mn^2+Ni*((Ni*N)-1)-S)
  
  #new_data_set <- data.frame(cbind(Ni, Cu, Mo, Al, x2_NaCl, x2_Cu, MoN, term1, term2))
  #colnames(new_data_set) <- c("Ni", "Cu", "Mo", "Al", "x2_NaCl", "x2_Cu", "MoN", "Term1", "Term2")
  #print(head(new_data_set))
  
  
  #analytical <- posterior_predict(model_bayes, new_data_set)
  #analytical_colmeans <- colMeans(analytical)
  #analytical_sd <- colSds(analytical)
  #### END Analytical Model ####
  
  train_results <- NULL
  train_results_analytical <- NULL
  train_results_exgboost <- NULL
  train_results <- cbind(train.pred.df.mean, train.pred.df.sd)
  #train_results_analytical <- cbind(analytical_colmeans, analytical_sd)
  train_results_exgboost <- cbind(pred_mean_test, pred_sd_test)
  print("XGBoost prediction CHECK")
  print(train_results)
  print(train_results_exgboost)
  print("END XGBoost prediction CHECK")
  train_results_final <- NULL
  train_results_final <- rbind(train_results, train_results_exgboost)
  
  print("TRAIN prediction FINAL CHECK")
  print(dim(train_results))
  print(train_results_final)
  print("END TRAIN prediction CHECK")
  #train_output <- cbind(train_performance, train_results_final)
  #jpeg(file = paste("train_Performance_Plot_",toString(nboot), toString(output_name),".jpg",sep="")
  #     ,res = 300, width = 1500, height = 1500) 
  #plot(train_output,train_r2.df[,2], pch=19, col="cadetblue3", cex=0.75, xlab="Number of Bootstrap Samples", ylab="R^2")
  #p <- qplot(train_performance[,dim(train_performance)[2]], train.pred.df.mean)+
    #xlim(min(train_performance[,dim(train_performance)[2]])-1,max(train_performance[,dim(train_performance)[2]])+1)+
    #ylim(min(train_performance[,dim(train_performance)[2]])-1,max(train_performance[,dim(train_performance)[2]])+1)+
    #labs(x="Actual", y="ML Predicted" )+
    #theme(text = element_text(size=20))+
    #geom_errorbar(aes(x=train_performance[,dim(train_performance)[2]], 
     #                 ymin=train.pred.df.mean-train.pred.df.sd, 
      #                ymax=train.pred.df.mean+train.pred.df.sd), width=0.25)+geom_abline()
  #png(paste("Train_Performance_Plot_",toString(nboot), toString(output_name),".png",sep=""))
  #print(p)
  #dev.off()
  
  #write.table(train_output, paste0("Train_Performance_", toString(nboot),"_", toString(output), ".csv", sep=""), sep=",", 
              #row.names=F)

  return(train_results_final)
}

#print("Training predictions loaded successfully")
