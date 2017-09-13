# ELToD Visualization
Express Lanes Time of Day Model Visualization Toolbox

## Project:
The Express Lanes Time of Day Model (ELToD) is a traffic assignment (path choice) binary logit model to estimate express lane trips by hour. The final outputs are link volume files (VOL.csv) near toll plazas (user defined pull links). These links cover both fixed toll links (aka turnpike and other flat toll general purpose lanes) as well as dynamic toll links (express lane tolls) and the output files include, free flow and congested travel times, volumes, capacities and assessed tolls by segment, OD pair and assignment iteration.

The recent study involved in evaluating the revenue impacts of a change in toll pricing legislation. The current system charges dynamic tolls on express lanes irrespective of congestion (all level of service users pay a minimum toll). The recent change in legislation allows users experiencing no congestion (LOS-A, defined as v/c less than 0.3) to take express lanes at no additional toll (beyond the flat toll paid on general use lanes). The dynamic tolls charged based on the LOS are assessed when congestion escalates (from LOS-B: defined as v/c greater than 0.3). The toll pricing curves tested are very similar expect that the initial one charges a minimum toll when there is no congestion and the later is free. The anticipated results were: there will be more LOS-A express lane trips due to free of additional tolls and the toll revenue is going to drop. The study assess the magnitude of the revenue drop for future years.

## Background:
Dashboard to view ELToD outputs. The initial tool was built for debugging, later transformed into an analysis tool. Given the frequency of the model runs and reviews, it maybe best to convert the analysis template into summary dashboard.  

## Flexdashboard:
Currently the outputs are produced to a html dashboard where each tab is defined to show the ELToD results for each of the toll segments. In this version each corridor is produced as a html document via settings file. There is one setting \*.RMD per corridor (example *ELToD Results_Veterans.RMD*)

## Inputs:
The initial debugging template reads data straight from the working directories. The analysis tool reads the data from the same directories but writes out the summary tables in excel format. The dashboard is built on top of these two tools and allows both methods to exists. The following are the inputs to run this dashboard.

1. ELToD working directories (old and new toll pricing runs)
2. ELToD Excel Summaries.

#### 1: Path Settings
     dir_path     <- "C:/projects/R-projects/ELToD_Visualization"  
     dir.Data     <- "Data"  
     **dir.Scenario <- "HEFT"**  
     dir.ELToD    <- "ELToD Results"  
     dir.Analysis <- "Analysis"  
     dir.Shape    <- "Project_Shape"  

#### 2: Scenario settings
     policy    <- c("oldPolicy", "newPolicy")  
     scenarios <- c("Y2020Rev", "Y2040Rev")  
     Years     <- c(2020, 2040)  

#### 3A: Option 1: Raw file and pull-links
*These datasets are not used if read from Excel Summaries*  

     filenames <- paste0("VOL",c(1:24),".csv")  
     pull_link <- "Pull_Link_Dir.csv"  
     excel_template <- "Template.xlsx"  
     export_summaries_to_excel <- FALSE
 *Data rows in Excel files: When read_from_excel is false (Option 1), should it write to excel summaries*  

#### 3B: Option 2: Excel Summary file
     read_from_excel <- TRUE
 *A choice to read data from excel spreadsheets instead of standard ELToD outputs. This key automatically acts as toggle to choose between the two options. The pull link files are not used if above option 1 is used*  

Segment starting rows: These settings are used to write to excel (option 1) and read from excel in (option2)  

     segments <- c(1:7)  
     seg_data_start_rows <- c(6, 51, 96, 141, 186, 231, 276)  
     sheet_name = "Output"  
     old_outfiles <- c("Output_2020A1.xlsx", "Output_2040A1.xlsx")  
     new_outfiles <- c("Output_2020A2.xlsx", "Output_2040A2.xlsx")  

#### 4: Display project on map (Dashboard 'Summary' tab)
Optional display of project shape file overlaying on webmap (Open Street Map). To use this, user is required to export CUBE .NET file to .shp file and add .prj file (since CUBE doesn't write out a projection file). A quick shortcut is to use any projection file (from other projects or downloaded from web) and rename it to be the shape file name.  

     display_Project <- TRUE  
     shape_file      <- "HEFT_40v7.shp"  
     map_center_lat  <-  25.7178387  
     map_center_lng  <- -80.3259419  
     map_zoom        <-  11  
     map_title       <- "HEFT Expressway"    

Building from Excel Summaries (option 2) reduces the number of raw data files to maintain in the data repo and will be consistent with the files delivered to the finance department.
