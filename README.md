# ELToD Visualization
Express Lanes Time of Day Model Visualization Toolbox

## Project:
The Express Lanes Time of Day Model (ELToD) is a traffic assignment (path choice) binary logit model to estimate express lane trips by hour. The final outputs are link volume files (VOL.csv) generated at user specified locations usually near toll plazas (defined through pull_links.csv). These links cover both general use lanes and express lanes (a.k.a general use are regular turnpike lanes with fixed tolls and express lanes are dynamically priced tolls on top of general use tolls) and the output files include OD pair, assignment iteration free flow and congested variables by toll and non-toll facility types. The variables include travel times, volumes, capacities and assessed tolls by segment.

This study involved in evaluating the revenue impacts resulting from a change in toll pricing legislation. The old pricing policy charges a minimum toll on express lanes and dynamically increases based on congestion levels. The new pricing policy (a result of new legislation) allows no minimum (tolls set to zero) if there is no congestion. The congestion is measured as density per mile, and since it is extremely hard to measure density in a static travel demand model, congestion is this is computed as volume to capacity ratio (v/c). Based on v/c value service levels are defined as: LOS-A with v/c below 0.3, LOS-B: v/c between 0.3 and 0.5, LOS-C: v/c above 0.5. The recent change in legislation allows users experiencing no congestion (LOS-A, defined as v/c less than 0.3) to take express lanes at no additional toll (beyond the flat toll paid on general use lanes). The dynamic tolls charged based on the LOS are assessed when congestion escalates (from LOS-B: defined as v/c greater than 0.3). The toll pricing curves tested are very similar expect that the initial one charges a minimum toll when there is no congestion and the later is free. The anticipated results were: there will be more LOS-A express lane trips due to free of additional tolls and the toll revenue is going to drop. The study assess the magnitude of the change in revenue for future years.


## Flexdashboard:
Dashboard to view ELToD outputs. The initial tool was built for debugging which later transformed into an analysis tool. Given the frequency of the model runs and reviews, it maybe best to convert the analysis template into summary dashboard.  Currently the outputs are produced to a html dashboard where each tab is defined to show the specific ELToD results that are of interest to finance team. In this version each project corridor is produced as a html document and uses settings file. There is one settings file \*.RMD per corridor (example *ELToD Results_Veterans.RMD*)


## Inputs:
The original debugger read the data straight from the ELToD model working directories. The debugger allowed to display a change in path (toll vs no-toll) for a selected OD pair by assignment iteration. Further this allowed to study probability shares resulting from the binary logit model.

A second tool was developed to tabulate the summary data into excel spreadsheet. This tool also read the data from the same directories and wrote out the summary tables in excel format. This tool uses a pre-existing Excel Template to write out data (template contained excel formats and tool pasted data into the specified rows).

The dashboard is built with same logic but since summaries are already produced via second tool there is no point to redo the same effort. Thus two following options are built into the dashboard.

1. ELToD working directories (old and new toll pricing runs)
2. ELToD Excel Summaries.

The following are the inputs to run this dashboard.

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
