
#======================================================================
# FUNCTION To produce v/c graphs
plot_voc <- function(df) {
  
  # Create Buttons
  n_dir <- 2
  n_ltype <- 2
  #n_year <- 2
  
  n_seg <- length(unique(df$direction)) / (n_dir * n_ltype )  # Two directions
  visibility <- rep(c(FALSE),  n_dir * n_ltype, each = n_seg)
  buttons_Segment <- list()
  
  # Create Segment Buttons
  for (s in 1:n_seg){
    visible_Seg <- visibility
    true_4 <- rep(c(TRUE), n_dir * n_ltype)
    visible_Seg[(4 * s - 3) : (4 * s)] <- true_4

    buttons_Segment = c(buttons_Segment, list( list(method = "restyle",
                                                    args = list("visible", visible_Seg),
                                                    label = paste0("Segment-",s)))) 
  }
  # Add "All" Segments button (to reset)
  buttons_Segment = c(buttons_Segment, list( list(method = "restyle",
                                                args = list("visible", rep(c(TRUE),n_dir * n_ltype, each = n_seg) ),
                                                label = "ALL"))) 
      
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
          # Drop downmenus
          updatemenus = list(
            # Add Direction
            list(
              yanchor = "top",
              # type = "buttons",
              type = "dropdown",
              bgcolor = "darkgreen",
              font = list(color = "white"),
              bordercolor = "darkred",
              # direction = "right",
              x = 0,
              y = 1.1,
              buttons = list(
                # Both directions
                list(method = "restyle",
                     args = list("visible", list(TRUE, TRUE)),
                     label = "Both"),
                # Northbound
                list(method = "restyle",
                     args = list("visible", list(TRUE, FALSE)),
                     label = "Northbound"),
                #Southbound
                list(method = "restyle",
                     args = list("visible", list(FALSE, TRUE)),
                     label = "Southbound")
                )
              ),
             # Add Segments
             list(
              # type = "buttons",
              type = "dropdown",
              yanchor = "top",
              xanchor = "center",
              direction = "down",
              bgcolor = "darkblue",
              font = list(color = "lightgrey"),
              bordercolor = "blue",
              x = 1.2,
              y = 1.1,
              buttons = buttons_Segment 
              )
            ),
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
                    y0 = 0.5, y1 = 0.8, yref = "y"),
               list(type = "rect",
                    fillcolor = "grey", line = list(color = "grey"), opacity = 0.15,
                    x0 = "0", x1 = "24", xref = "x",
                    y0 = 0.8, y1 = 1.1, yref = "y")
               ),
         
         # Add LOS 
         annotations = list( 
           list(x = 3, y = 0.15, text = " LOS A = v/c below 0.3 ", 
                font = list(family = 'Arial',color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 3, y = 0.4, text = " LOS B = v/c 0.3 to 0.5 ", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 3, y = 0.6, text = " LOS C = v/c 0.5 to 0.8", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 3, y = 0.95, text = " LOS D & Above = v/c above 0.8 ", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE)
         )
         
    ) 
}



#======================================================================
# FUNCTION To produce LOS bar graphs
plot_los <- function(df){
  
  df <-  df %>% 
          gather(-Seg, -LOS, -Year, key = Policy, value = Trips) %>%
          mutate(seg_policy = paste(Seg, Policy, sep = "_"))
  
  # Create Segment Buttons
  n_seg <- length(unique(df$seg_policy))/2  # Two directions
  visibility <- rep(c(FALSE,FALSE), n_seg)
  buttons_Segment <- list()
  
  for (s in 1:n_seg){
    visible_Seg <- visibility
    visible_Seg[(2 * s - 1) : (2 * s)] <- c(TRUE,TRUE)
    buttons_Segment = c(buttons_Segment, list( list( method = "restyle",
                                                     args = list("visible", visible_Seg),
                                                     label = paste0("Segment-",s))))    
  }
  
  # Add All segments
  visibility <- rep(c(TRUE,TRUE), n_seg)
  buttons_Segment = c(list(list( method = "restyle",
                            args = list("visible", visibility),
                            label = "All")), buttons_Segment)  
  
  # Bar Plot
  df %>% 
  plot_ly(x = ~LOS, y = ~Trips, split = ~seg_policy, type = 'bar', showlegend = T) %>%  
  # add_trace(y = ~newPolicy, name = 'New Policy') %>%
  layout(yaxis = list(title = ' '), barmode = 'group', 
         updatemenus = list(
                          list(
                              type = "buttons",
                              yanchor = "top",
                              xanchor = "center",
                              direction = "right",
                              bgcolor = "lightblue",
                              font = list(color = "darkgrey"),
                              bordercolor = "lightgrey",
                              x = 0.0,
                              y = 1.5,
                              buttons = buttons_Segment
                              )
                          )
         )

}