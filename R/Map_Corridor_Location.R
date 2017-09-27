
# read shape file
layer_name <- strsplit(shape_file, "\\.")[[1]][1]
shapeData <- readOGR(shape_file_full_path,
                  layer = layer_name, verbose = FALSE)


# Transform to WGS84 datum
shapeData <- spTransform(shapeData, CRS("+proj=longlat +datum=WGS84 +no_defs"))

# Create link subsets
shapeData_expLinks    <- subset(shapeData, shapeData$FTYPE == 96)
shapeData_accessLinks <- subset(shapeData, shapeData$FTYPE == 97)
shapeData_egressLinks <- subset(shapeData, shapeData$FTYPE == 98)
shapeData_FreeLinks   <- subset(shapeData, shapeData$FTYPE == 91)
shapeData_other       <- subset(shapeData, shapeData$FTYPE  < 91)


  link_colors <- c("blue", "green", "orange", "pink", "grey", "red")
  link_labels <- c("General Use", "Express Way", "On Ramps", "Off Ramps", 
                   "All Other Roads", "Toll Plaza")
  
  legend_colors <- rgb(t(col2rgb(link_colors)) / 255)
  
# Create leaflet map with project
map <- leaflet() %>%
      
      # Add background tiles and set view
      addProviderTiles("Stamen.Toner",group = "Stamen") %>%
      addProviderTiles('CartoDB.Positron') %>%
      addTiles(group = "OSM") %>%
      setView(lng = map_center_lng, lat = map_center_lat, zoom = map_zoom) %>%
  
      # Add shapefile contents
      addPolylines(data = shapeData_FreeLinks, stroke = TRUE, smoothFactor = 1, weight = 2, 
                  color = link_colors[1], group = link_labels[1]) %>%
      addPolylines(data = shapeData_expLinks, stroke = TRUE, smoothFactor = 1, weight = 3, 
                  color = link_colors[2], group = link_labels[2]) %>%
      addPolylines(data = shapeData_accessLinks, stroke = TRUE, smoothFactor = 1, weight = 7, 
                  color = link_colors[3], group = link_labels[3]) %>%
      addPolylines(data = shapeData_egressLinks, stroke = TRUE, smoothFactor = 1, weight = 7, 
                  color = link_colors[4], group = link_labels[4]) %>%
      addPolylines(data = shapeData_other, stroke = TRUE, smoothFactor = 0, weight = 1, 
                  color = link_colors[5], group = link_labels[5])

# Check if pull links are coded in the shape file
if('PULLLINK' %in% colnames(shapeData@data)) {
    shapeData_pulllinks  <- subset(shapeData, shapeData$PULLLINK  == 1)
    map <- map %>% 
            addPolylines(data = shapeData_pulllinks, 
                         stroke = TRUE, smoothFactor = 1, weight = 10, 
                         color = link_colors[6], group = link_labels[6],
                         popup = ~paste("A - B = <b>", paste(A,B,sep = "-") , "</b><br/>") 
            )
  } 

  # Add layer controls
  map <- map %>% 
    addLayersControl(
       baseGroups = c("OSM", "Stamen"),
       overlayGroups = c( "General Use", "Express Way", "On Ramps", "Off Ramps", 
                          "All Other Roads", "Pull Location"), 
       options = layersControlOptions(collapsed = FALSE)
    ) %>% 
    addLegend("bottomright", colors = legend_colors, labels = link_labels,
    title = "Veterans Expressway",
    opacity = 1
  )
    

  
