# Title: Reads ELToD Summary files from 
#
# Amar Sarvepalli, date:07-21-2017, venkat.sarvepalli@dot.state.fl.us
#
#=====================================================================
old_ppath     <- paste(file_path, policy[1], sep="/")
new_ppath     <- paste(file_path, policy[2], sep="/") 

path <- c(old_ppath, new_ppath)
outfiles <- list(old_outfiles, new_outfiles)

#======================================================================
# Read from Excel
#======================================================================
for (p in 1:length(path)) {      # Both policies
  
  for(s in 1:length(scenarios)){
    
    for(d in segments){
      
      # create excel output
      excel_out <- paste(analysis_path, outfiles[[p]][s], sep ="\\") 
      wb = loadWorkbook(excel_out)
      
      # Start and end rows
      start_row <- seg_data_start_rows[d] - 1
      end_row <- seg_data_start_rows[d] + 23
      
      # read from excel
      df_vol <- readWorksheet(wb, sheet = sheet_name, 
                     startRow = start_row, startCol = 2, 
                     endRow = end_row, endCol = 18,
                     useCachedValues = TRUE)
      
      colnames(df_vol) <- c("GU_NB_VOL", "GU_SB_VOL", "EL_NB_VOL", "EL_SB_VOL",     
                            "Corridor", 
                            "EL_NB_SHARE", "EL_SB_SHARE", 
                            "GU_NB_VC_RATIO", "GU_SB_VC_RATIO", 
                            "EL_NB_VC_RATIO", "EL_SB_VC_RATIO",
                            "GU_NB_CSPD", "GU_SB_CSPD", 
                            "EL_NB_CSPD", "EL_SB_CSPD",
                            "EL_NB_TOLL", "EL_SB_TOLL")  
      
      # append scenario Year and Hour
      df_vol$Policy <- policy[p]
      df_vol$Seg <- d
      df_vol$Hour <- c(1:24)
      df_vol$Year <- Years[s]
      
      # consolidate all data
      ifelse(p ==1 & d == 1 & s == 1, df <- df_vol, df <- rbind(df,df_vol)) 
      
    }
  }
}



