
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

# Create leaflet map with project
map <- leaflet() %>%
      
      # Add background tiles and set view
      addProviderTiles("Stamen.Toner",group = "Stamen") %>%
      addProviderTiles('CartoDB.Positron') %>%
      addTiles(group = "OSM") %>%
      setView(lng = -82.5381, lat = 28.0679, zoom = 11) %>%
  
      # Add shapefile contents
      addPolylines(data = shapeData_FreeLinks, stroke = TRUE, smoothFactor = 1, weight = 2, 
                  color = "blue", group = "General Use") %>%
      addPolylines(data = shapeData_expLinks, stroke = TRUE, smoothFactor = 1, weight = 3, 
                  color = "green", group = "Express Way") %>%
      addPolylines(data = shapeData_accessLinks, stroke = TRUE, smoothFactor = 1, weight = 7, 
                  color = "orange", group = "On Ramps") %>%
      addPolylines(data = shapeData_egressLinks, stroke = TRUE, smoothFactor = 1, weight = 7, 
                  color = "pink", group = "Off Ramps") %>%
      addPolylines(data = shapeData_other, stroke = TRUE, smoothFactor = 0, weight = 1, 
                  color = "grey", group = "All Other Roads")

# Check if pull links are coded in the shape file
if('PULLLINK' %in% colnames(shapeData@data)) {
    shapeData_pulllinks  <- subset(shapeData, shapeData$PULLLINK  == 1)
    map <- map %>% 
            addPolylines(data = shapeData_pulllinks, 
                         stroke = TRUE, smoothFactor = 1, weight = 10, 
                         color = "red", group = "Pull Location",
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
    )
  
map