

#======================================================================
# FUNCTION To produce v/c graphs
plot_voc <- function(df) {
  df %>% 
  plot_ly(
    x = ~Hour,
    y = ~VC,    
    type = 'scatter',
    mode = 'lines',
    color = ~direction,
    showlegend = T
  )  %>%

  layout(title = "V/C by Lane Type",

          # Add LOS-B, LOS-C Highlighers
          shapes = list(
               list(type = "rect",
                    fillcolor = "yellow", line = list(color = "yellow"), opacity = 0.15,
                    x0 = "0", x1 = "24", xref = "x",
                    y0 = 0.0, y1 = 0.3, yref = "y"),
               list(type = "rect",
                    fillcolor = "green", line = list(color = "green"), opacity = 0.15,
                    x0 = "0", x1 = "24", xref = "x",
                    y0 = 0.3, y1 = 0.5, yref = "y"),
               list(type = "rect",
                    fillcolor = "orange", line = list(color = "orange"), opacity = 0.15,
                    x0 = "0", x1 = "24", xref = "x",
                    y0 = 0.5, y1 = 0.75, yref = "y")
               ),
         
         # Add LOS 
         annotations = list( 
           list(x = 3, y = 0.15, text = " LOS A = V/C below 0.3 ", 
                font = list(family = 'Arial',color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 3, y = 0.4, text = " LOS B = V/C 0.3 to 0.5 ", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 3, y = 0.6, text = " LOS C = V/C above 0.5 ", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE)
         )
         
    ) 
}