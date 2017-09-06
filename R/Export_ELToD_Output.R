# Title: Export ELToD Ouput files
#
# Description: 
# Writes pull link volumes to excel.
# Styles and formulae can also be set from script but it's rather much 
# easier to use a predefined excel template and write to it. 
#  
# 
# Amar Sarvepalli, date:07-21-2017, venkat.sarvepalli@dot.state.fl.us
#
#======================================================================

# model directory, scenarios and years
old_ppath     <- paste(file_path, policy[1], sep="/")
new_ppath     <- paste(file_path, policy[2], sep="/") 

path <- c(old_ppath, new_ppath)
outfiles <- list(old_outfiles, new_outfiles)

#======================================================================
# Write to Excel
#======================================================================
for (p in 1:length(path)) {      # Both policies
  
  for(s in 1:length(scenarios)){
    
    for(d in segments){
      
      # create excel output
      excel_out <- paste(analysis_path, outfiles[[p]][s], sep ="\\") 

      file.copy(excel_template_full_path, excel_out) 
      
      # Get data by segments
      df_seg <- df %>% 
        filter(Policy == policy[p], Year == Years[s], Seg == segments[d]) %>%
        select(-Year, -Seg, -Hour, -Policy)
      
      # write to excel
      writeWorksheetToFile(excel_out, data = df_seg,
                           sheet = sheet_name, 
                           # sheet = "sheet_name", 
                           startRow = seg_data_start_rows[d],
                           startCol = 2, 
                           header = FALSE, 
                           rownames = NULL,
                           styleAction = XLC$STYLE_ACTION.NONE,
                           clearSheets = FALSE)
    }
  }
}

