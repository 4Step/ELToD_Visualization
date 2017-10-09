# Plots for reports
# 
# This script produces standard plots in pdf format for use in reports. 
# The following are some standard plots:
# 1. Time of day distribution: Volume % (GU & EL) by driection (NB, SB) - 
#    3 plots (GU vs EL NB and GU vs EL SB, EL by direction)
# 2. v/c by direction (GU vs EL) - 3 plots (GU vs EL NB and GU vs EL SB, EL by direction)
# 3. Diverted Share (EL%) by direction (1 graph)
# 4. Speed by direction (GU vs EL)
# 5. average toll and traffic (2 y-axes)

# Plot GU vs EL shares by time of day

#===============================================================================
# Function to plot diverted shares
#===============================================================================
 report_plots <- function(data, plot_title, type) {
  
  # Axes settings
  x_labels <- list(title = "Hour", 
                   color = "grey", 
                   titlefont = list(color = "black", size = 20, 
                                    family = list("Arial", "Time New Roman")),
                   autotick = FALSE, ticks = "outside", 
                   tick0 = 0, dtick = 1, range = c(0.25,24.5))
  
  # Y-axis for EL Shares
  y_labels_share <- list(title = "EL Share (%)",color = "grey", 
                   titlefont = list(color = "black", size = 20, 
                                    family = list("Arial", "Time New Roman")),
                   autotick = FALSE, ticks = "outside", 
                   tick0 = 0, dtick = .05, tickformat = ".0%")
  
  # Y-axis for V/C ratios
  y_labels_vc <- list(title = "v/c ratio",color = "grey", 
                   titlefont = list(color = "black", size = 20, 
                                    family = list("Arial", "Time New Roman")),
                   autotick = FALSE, ticks = "outside", 
                   tick0 = 0, dtick = .1,range = c(0,1.2))

  # Y-axis for V/C ratios
  y_labels_speed <- list(title = "Speed (MPH)",color = "grey", 
                   titlefont = list(color = "black", size = 20, 
                                    family = list("Arial", "Time New Roman")),
                   autotick = FALSE, ticks = "outside", 
                   tick0 = 0, dtick = 10, range= c(0, 80))
  
  # Y-axis for TOD Shares
  y_labels_tod <- list(title = "Hourly Distribution (%)",color = "grey", 
                   titlefont = list(color = "black", size = 20, 
                                    family = list("Arial", "Time New Roman")),
                   autotick = FALSE, ticks = "outside", 
                   tick0 = 0, dtick = .05, tickformat = ".0%")
 
  # Y-axis for Toll  
  y_labels_toll <- list(title = "Average Toll ($)", color = "red", 
                   titlefont = list(color = "red",size = 20, 
                        family = list("Arial", "Time New Roman")), 
                   overlaying = "y", side = "right",  
                   ticks = "outside",
                   tickprefix = "$", tick0 = 0, dtick = 0.05, 
                   tickformat = ".2f", 
                   tickfont = list(family = list("Arial"), size = 10))
                    
  if(type == "shares") {y_labels = y_labels_share}  
  if(type == "vc") {y_labels = y_labels_vc} 
  if(type == "speeds") {y_labels = y_labels_speed}
  if(type == "tod") {y_labels = y_labels_tod} 
  if(type == "revenue") {y_labels = y_labels_tod} 
 
  # Plot data
  plot <- data %>%
          plot_ly(x = ~Hour, 
                 y = ~Values,
                 split = ~Type,
                 mode = 'lines+markers', type = "scatter", showlegend = T)
  
  # Layout
  if(type == "revenue"){
    # Double plots
    plot <-  plot %>% 
    add_bars(x = ~Hour, y = ~Values2, yaxis = "y2", split = ~Type,
              type = "bar", showlegend = T) %>%
    layout(title = plot_title, 
            titlefont = list(color = "black", size = 25, 
                             family = list("Arial", "Time New Roman")),
            xaxis = x_labels, 
            yaxis = y_labels,
            yaxis2 = y_labels_toll,
            margin = list(t = 100, b = 100, l = 100, r = 100, pad = 5))  
   } else {
    # Single plots
    plot <-  plot %>%
    layout(title = plot_title, 
            titlefont = list(color = "black", size = 25, 
                             family = list("Arial", "Time New Roman")),
            xaxis = x_labels, 
            yaxis = y_labels,
            margin = list(t = 100, b = 100, l = 100, pad = 5))
   }

}
  
#===============================================================================  
# Apply for new policy only, loop by year and segments
#===============================================================================
  
#===============================================================================
# 1. plot diverted_el_shares 
diverted_el_shares <- df %>% 
       filter(Policy == "newPolicy", Year == 2040, Seg == 1) %>%
       select(NB = EL_NB_SHARE, SB = EL_SB_SHARE, Hour) %>%
       gather(Type, Values, -Hour) %>%
       report_plots("Diverted Percent (EL Share)", "shares")


#===============================================================================    
# 2. plot vc ratio 
vc_ratio <- df %>% 
       filter(Policy == "newPolicy", Year == 2040, Seg == 1) %>%
       select(`GUL NB` = GU_NB_VC_RATIO, `GUL SB` = GU_SB_VC_RATIO,
              `EL NB` = EL_NB_VC_RATIO, `EL SB` = EL_SB_VC_RATIO, 
               Hour) %>%
       gather(Type, Values, -Hour) %>%
       report_plots("v/c Ratio", "vc")


#===============================================================================
# 3. plot speeds
speeds <- df %>% 
       filter(Policy == "newPolicy", Year == 2040, Seg == 1) %>%
       select(`GUL NB` = GU_NB_CSPD, `GUL SB` = GU_SB_CSPD,
              `EL NB` = EL_NB_CSPD, `EL SB` = EL_SB_CSPD, 
               Hour) %>%
       gather(Type, Values, -Hour) %>%
       report_plots("Congested Speeds (MPH)", "speeds")


#===============================================================================
# 4. plot GU and EL shares by time of day
df_tod <- df %>% 
       filter(Policy == "newPolicy", Year == 2040, Seg == 1) %>%
       mutate(`GUL NB` = GU_NB_VOL / sum(GU_NB_VOL),
              `GUL SB` = GU_SB_VOL / sum(GU_SB_VOL),
              `EL NB` = EL_NB_VOL / sum(EL_NB_VOL),
              `EL SB` = EL_SB_VOL / sum(EL_SB_VOL))
# NB  
tod_shares_NB <- df_tod %>% 
       select(`GUL NB`, `EL NB`, Hour) %>%
       gather(Type, Values, -Hour) %>%
       report_plots("GUL and EL Hourly Distribution (NB)", "tod")

#  SB
tod_shares_SB <- df_tod %>% 
       select(`GUL SB`, `EL SB`, Hour) %>%
       gather(Type, Values, -Hour) %>%
       report_plots("GUL and EL Hourly Distribution (SB)", "tod")

#===============================================================================
# 5. plot EL Toll and Traffic
toll_revenue <- df %>% 
       filter(Policy == "newPolicy", Year == 2040, Seg == 1) %>%
       mutate(`Revenue NB` = EL_NB_VOL * EL_NB_TOLL / sum(EL_NB_VOL * EL_NB_TOLL),
              `Revenue SB` = EL_SB_VOL * EL_SB_TOLL / sum(EL_SB_VOL * EL_SB_TOLL)) %>%
       select(`Revenue NB`, `Revenue SB`, EL_NB_TOLL, EL_SB_TOLL, Hour) %>%
       gather(Type, Values, -Hour) %>%
       mutate(temp = ifelse(Type %in% c("Revenue NB", "Revenue SB"), "Revenue", "Toll"),
              dir = ifelse(Type %in% c("Revenue NB", "EL_NB_TOLL"), "NB", "SB")) %>%
       select(-Type) %>%
       spread(temp, Values) %>%
       select(Hour, Type = dir,Values = Revenue, Values2 = Toll) %>%
       report_plots("Toll and Revenue", "revenue")


# Save plots
export(diverted_el_shares, "diverted_el_shares.png")
export(vc_ratio, "vc_ratio.png")
export(speeds, "speeds.png")
export(tod_shares_NB, "tod_shares_NB.png")
export(tod_shares_SB, "tod_shares_SB.png")
export(toll_revenue, "toll_revenue.png")

# Putting plots together
library(png)
library(gridExtra)






  
