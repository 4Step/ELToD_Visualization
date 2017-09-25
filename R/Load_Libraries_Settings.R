
#======================================================================
# Check and install libraries 
#======================================================================
  required_packages <- c("knitr", "flexdashboard",
                         "dplyr", "tidyr", 
                         "DT", "data.table", "XLConnect", "foreign",
                         "plotly", "rgdal", "leaflet", "webshot")
  
  check_packages <- required_packages %in% rownames(installed.packages())
  missing_packages <- required_packages[check_packages == FALSE]
  
  if (length(missing_packages) > 0) {
    install.packages(missing_packages)
  }
  
  sapply(required_packages, library, character.only = TRUE)
  
  
  # Set chunk options
  opts_knit$set(root.dir=normalizePath('../'))
  opts_chunk$set(
  	echo = FALSE,
  	message = FALSE,
  	warning = FALSE,
  	fig.path = "figures/",
    dev = 'png',
    fig.keep = 'all',
  	dev.args=list(type="cairo")
  )
  
  
  options(DT.options = list(pageLength = 5, language = list(search = 'Filter:')),
          initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({'background-color': '#000', 'color': '#fff'});",
           "}"),
          searchHighlight = TRUE, filter = 'none')

  config(plot_ly(), displaylogo = FALSE, collaborate = FALSE)

