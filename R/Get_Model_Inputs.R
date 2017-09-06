# A script to pull all model input specifications
library(dplyr)
library(tidyr)
library(knitr)


path <- "C:/projects/ExpressLanes_Documentation"
corridors <- c("Veterans")
parameter_file <- c("Parameters_2020.PRN", "Parameters_2040.PRN")

cnt <- 0

for (c in corridors) {
  for (p in parameter_file){
    params <- read.csv(paste(c, p, sep ="\\"))
    year <- sapply(strsplit(p, "\\.")[[1]][1], function(x) strsplit(x, "_")[[1]][2])
    colnames(params) <- year
    ifelse(cnt == 0, all_params <- params, all_params <- cbind(all_params,params))
    cnt =+ 1
  }
}


# clean up names
att_names <- rownames(params)
att_names <- trimws(att_names, which = c("both"))

                 
# Get list of parameters by group
group_names <- c("Link Attribute Name",
                  "Assignment Parameters", 
                  "Pricing Policy", 
                  "Volume Delay Function Parameters",
                  "Choice Model Coefficients")
groups <- list()
for (g in 1:length(group_names)){
  if ( g != length(group_names) ) {
    groups[group_names[g]] <- list(att_names[(which(att_names == group_names[g]) + 1) : (which(att_names == group_names[g+1]) - 1)])
  } else {
    groups[group_names[g]] <- list(att_names[(which(att_names == group_names[g]) + 1) : length(att_names)])
  }
}


# Function to get parameters names
getParams <- function(df, g) {
  
  att_names <- trimws(rownames(df), which = c("both"))
  x <- df %>% 
     add_rownames() %>%
     filter(att_names %in% groups[[names(groups)[g]]]) 

  colnames(x) <- c(group_names[g], colnames(x)[2:ncol(x)])
  return(x)
}

# Get all tables
for (g in 1: length(group_names)){
   x <- all_params %>% getParams(g)
   write.csv(x, paste0(path,"\\",group_names[g],".csv"))
}



