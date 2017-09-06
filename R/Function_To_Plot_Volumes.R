
# FUNCTION To produce volume graphs
# TODO: 
# Do both old and new plots in the same layout but as two graphs to use same Y-axis
plot_volumes <- function(df, max_volume, isGL) {
  
   if(isGL){
     ls_colors <-  c('rgb(208,28,139)',
                   'rgb(241,182,218)',
                   'rgb(184,225,134)',
                   'rgb(77,172,38)')
   } else {
      ls_colors <-  c('rgb(228,26,28)',
                   'rgb(55,126,184)',
                   'rgb(77,175,74)',
                   'rgb(152,78,163)')
   }
   
  
  # create color list
  for (c in 1:length(ls_colors)){
     ifelse( c == 1, bar_colors <- rep(ls_colors[c],24), bar_colors <- c(bar_colors, rep(ls_colors[c],24)))
  }
  
  df %>% 
  plot_ly(
    x = ~Hour,
    y = ~Volume,    
    split = ~Segment,
    # marker = list(color = bar_colors,
    #               line = list(color = bar_colors)),
    type = 'bar',
    mode = 'lines',
    showlegend = T
  )  %>%
  layout(title = "Volumes by Segment",
         
         # Add LOS-B, LOS-C Highlighers
          shapes = list(
               list(type = "rect",
                    fillcolor = "orange", line = list(color = "orange"), opacity = 0.15,
                    x0 = "8", x1 = "10", xref = "x",
                    y0 = 0, y1 = max_volume, yref = "y"),
               list(type = "rect",
                    fillcolor = "orange", line = list(color = "orange"), opacity = 0.15,
                    x0 = "16", x1 = "18", xref = "x",
                    y0 = 0, y1 = max_volume, yref = "y")             
               ),
         
         # Add AM and PM Peaks 
         annotations = list( 
           list(x = 9, y = -50, text = " AM: 8:00 - 10:00 ", 
                font = list(family = 'Arial',color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 17, y = -50, text = " PM: 16:00 - 18:00 ", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE)
         ),
         
         yaxis = list(range = c(0, max_volume))
     )
}




#======================================================================
# FUNCTION to accumulate frames for animation
accumulate_by <- function(dat, var) {
  var <- lazyeval::f_eval(var, dat)
  lvls <- plotly:::getLevels(var)
  dats <- lapply(seq_along(lvls), function(x) {
    cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
  })
  dplyr::bind_rows(dats)
}


#======================================================================
# FUNCTION To produce animated scatter graph
# TODO: Do both old and new plots in the same layout but as two graphs to use same Y-axis
plot_volumes_ami <- function(df) {
  df %>% 
  plot_ly(
    x = ~Hour,
    y = ~Volume,    
    split = ~Segment,
    frame = ~frame,
    type = 'scatter',
    mode = 'lines',
    showlegend = T
  )  %>%
  layout(title = "Volumes by Segment",
         updatemenus = list(
            list(
              type = "buttons",
              y = 0.8,
              buttons = list(
        
                list(method = "restyle",
                     args = list("type", "bar"),
                     label = "Bar"),
        
                list(method = "restyle",
                     args = list("type", "scatter"),
                     label = "Scatter")
                )
              )
            ),
          
         # Add LOS-B, LOS-C Highlighers
          shapes = list(
               list(type = "rect",
                    fillcolor = "orange", line = list(color = "orange"), opacity = 0.15,
                    x0 = "8", x1 = "10", xref = "x",
                    y0 = 0, y1 = 1500, yref = "y"),
               list(type = "rect",
                    fillcolor = "orange", line = list(color = "orange"), opacity = 0.15,
                    x0 = "16", x1 = "18", xref = "x",
                    y0 = 0, y1 = 1500, yref = "y")             
               ),
         
         # Add AM and PM Peaks 
         annotations = list( 
           list(x = 9, y = -50, text = " AM: 8:00 - 10:00 ", 
                font = list(family = 'Arial',color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE),
           list(x = 17, y = -50, text = " PM: 16:00 - 18:00 ", 
                font = list(family = 'Arial', color = 'rgba(49,130,189, 1)', size = 12), 
                showarrow = FALSE)
         ),
         
         yaxis = list(domain = c(0, 1500))
         
     ) %>%
  animation_opts(
    frame = 60, 
    transition = 0, 
    redraw = FALSE
  ) 
}

