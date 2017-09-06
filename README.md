# ELToD_Visualization

## Project:
The Express Lanes Time of Day Model (ELToD) is a traffic assignment (path choice) binary logit model to estimate express lane trips by hour. The final outputs are link volume files (VOL.csv) near toll plazas (user defined pull links). These links cover both fixed toll links (aka turnpike and other flat toll general purpose lanes) as well as dynamic toll links (express lane tolls) and the output files include, free flow and congested travel times, volumes, capacities and assessed tolls by segment, OD pair and assignment iteration.

The recent study involved in evaluating the revenue impacts of a change in toll pricing legislation. The current system charges dynamic tolls on express lanes irrespective of congestion (all level of service users pay a minimum toll). The recent change in legislation allows users experiencing no congestion (LOS-A, defined as v/c less than 0.3) to take express lanes at no additional toll (beyond the flat toll paid on general use lanes). The dynamic tolls charged based on the LOS are assessed when congestion escalates (from LOS-B: defined as v/c greater than 0.3). The toll pricing curves tested are very similar expect that the initial one charges a minimum toll when there is no congestion and the later is free. The anticipated results were: there will be more LOS-A express lane trips due to free of additional tolls and the toll revenue is going to drop. The study assess the magnitude of the revenue drop for future years.

## Background:
Dashboard to view ELToD outputs. The initial tool was built for debugging, later transformed into an analysis tool. Given the frequency of the model runs and reviews, it maybe best to convert the analysis template into summary dashboard.  

## Flexdashboard
Currently the outputs are produced to a html dashboard where each tab is manually defined to show the ELToD results for each of the Toll Segments. This need to be automated to generate the same dashboard for all projects where each project can have multiple toll segments.

## Inputs:
The initial debugging template read data straight from the working directories. The analysis tool read the data from the same directories but wrote out the summary tables in excel format. The dashboard is built on top of these two tools and should allow both methods to exists.

1. ELToD working directories (old and new toll pricing policy)
2. ELToD Excel Summaries.

Building from Excel Summaries reduces the number of raw data file to maintain and will be consistent with the files delivered to finance department.
