#======================================================================
# 1. Read all csv files and create a dataframe
#======================================================================
# load all files
for (p in 1:length(policy)){
  for (s in 1:length(scenarios)){
    for (f in 1:length(filenames)){
      
      # read all files 
      df_vol <- read.csv(paste(file_path,policy[p],scenarios[s],filenames[f], sep ="\\"))
      
      # append scenario Year and Hour
      df_vol$Policy <- policy[p]
      df_vol$Hour <- f
      df_vol$Year <- Years[s]
      
      # consolidate all data
      ifelse(p ==1 & f == 1 & s == 1, df <- df_vol, df <- rbind(df,df_vol)) 
    }
  }
}


#======================================================================
# 2. read pull links
#======================================================================
df_pulllink <- read.csv(pull_link) %>%
  mutate(key = paste(A, B, sep = "-")) %>%
  select(-A, -B, -PULL)

#======================================================================
# 3. Process data 
#======================================================================
df     <- df %>% 
          mutate(key = paste(A, B, sep = "-")) %>% 
          left_join(df_pulllink, by = "key")  %>%
          mutate(LType_Dir = paste(LType, Dir, sep ="_")) %>% 
          select(Policy, Year, Seg, Hour, LType_Dir,
                VOL = TOTAL_VOL, CSPD, TOLL, VC_RATIO) %>%          
          gather(-Policy, -Year, -Seg, -LType_Dir, -Hour,  key = name, value = value ) %>%
          mutate(LType_Dir_name =  paste(LType_Dir, name, sep ="_")) %>%
          select(-LType_Dir, -name) %>%
          spread(LType_Dir_name, value) %>%
          mutate(EL_NB_SHARE = EL_NB_VOL / (GU_NB_VOL + EL_NB_VOL),
                 EL_SB_SHARE = EL_SB_VOL / (GU_SB_VOL + EL_SB_VOL),
                 Corridor = GU_NB_VOL + EL_NB_VOL + GU_SB_VOL + EL_SB_VOL) %>%
          arrange(Policy, Year, Seg, Hour)


# select only specific columns          
dir_ltype  <- c("GU_NB","GU_SB", "EL_NB", "EL_SB")
dir_ELtype <- dir_ltype[3:4]
df_order   <- c("Policy", "Year", "Seg", "Hour", 
               paste(dir_ltype,"_VOL",sep=""), 
               "Corridor",
               paste(dir_ELtype,"_SHARE",sep=""),
               paste(dir_ltype,"_VC_RATIO",sep=""), 
               paste(dir_ltype,"_CSPD",sep=""),
               paste(dir_ELtype,"_TOLL",sep=""))

# Column sort
df <- df %>% select(df_order)  

