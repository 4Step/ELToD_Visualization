# Plots for reports
# 
# This script produces standard plots in pdf format for use in reports. 
# The following are some standard plots:
# 1. Time of day distribution: Volume % (GU & EL) by driection (NB, SB) - 3 plots (GU vs EL NB and GU vs EL SB, EL by direction)
# 2. v/c by direction (GU vs EL) - 3 plots (GU vs EL NB and GU vs EL SB, EL by direction)
# 3. Diverted Share (EL%) by direction (1 graph)
# 4. Speed by direction (GU vs EL)
# 5. average toll and traffic (2 y-axes)

# Plot GU vs EL shares by time of day
# Using plotly
df %>% filter(Policy == "newPolicy", Year == 2040, Seg == 1) %>%
   plot_ly(x = ~Hour, y = ~EL_NB_SHARE, mode = 'lines', type = "scatter", name = "EL NB") %>%
   add_trace(y = ~EL_SB_SHARE, mode = 'lines', type = "scatter", name = "EL SB")


# Using ggplot
  df %>% filter(Policy == "newPolicy", Year == 2040) %>%
   select("EL_NB_SHARE", "EL_SB_SHARE", "Hour", "Seg") %>%
   gather(Direction, Share, -Hour, - Seg) %>%
   ggplot(aes(x = Hour, y = Share)) + 
   geom_line(aes(color = Direction))+ 
   facet_wrap(Seg ~ Direction, labeller = label_both) +
   theme_linedraw()

# Using plotly 
data <- df %>% filter(Policy == "newPolicy", Year == 2040, Seg == 1)

# Axes settings
x_labels <- list(title = "Hour", 
                 color = "grey", 
                 titlefont = list(color = "black", size = 20, 
                                  family = list("Arial", "Time New Roman")),
                 autotick = FALSE, ticks = "outside", 
                 tick0 = 0, dtick = 1, range = c(0.25,24.5))
y_labels <- list(title = "EL Share (%)",color = "grey", 
                 titlefont = list(color = "black", size = 20, 
                                  family = list("Arial", "Time New Roman")),
                 autotick = FALSE, ticks = "outside", 
                 tick0 = 0, dtick = .05, tickformat = ".0%")
data %>%
   plot_ly(x = ~Hour, y = ~EL_NB_SHARE, mode = 'lines+markers', type = "scatter", name = "EL NB") %>%
   add_trace(y = ~EL_SB_SHARE, mode = 'lines+markers', type = "scatter", name = "EL SB") %>%
   layout(title = "Diverted Percent (EL Share)",
          titlefont = list(color = "black", size = 25, 
                                  family = list("Arial", "Time New Roman")),
          xaxis = x_labels, 
          yaxis = y_labels,
          margin = list(t = 100, b = 100, l = 100, pad = 5))
  
