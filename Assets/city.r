library(leaflet)
library(dplyr)
library(sp)
library(raster)
library(htmlwidgets)
library(lobstr)

  setwd('C:/Users/onomi/Desktop/dsi/projects/DC_DSI10_Team5_Client_Proj/Assets')
  city <- geojsonio::geojson_read("final.geojson", what = "sp")
  #r <- raster("clipped_geotiff.tif")

  bins <- c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.56)

  labels <- sprintf(
    "<strong>City: %s</strong>,
    <br/>Total Population: %s
    <br/>Population Density: %s
    <br/>Number of households: %s
    <br/>Average household size: %s
    <br/>Female headed households: %s
    <br/>Housing owned/paying off: %s
    <br/>Flush toilet connected to sewerage: %s
    <br/>Electricity for lighting: %s
    <br/>No Income: %s",
    city[[1]], city[[2]], city[[6]], city[[10]], city[[11]], city[[12]], city[[13]], city[[14]], city[[16]], city[[17]]
  ) %>% lapply(htmltools::HTML)

  income <- city$map_output_Percent.No.Income
  pal <- colorBin("YlOrRd", domain = income, bins = bins)

  city <- leaflet(city) %>%
    addProviderTiles(providers$CartoDB.Positron, group = 'basic') %>%
    addProviderTiles(providers$OpenTopoMap, group = 'street') %>%
    addProviderTiles(providers$Esri.WorldImagery, group = 'satellite') %>%
    addPolygons(
      stroke = TRUE, smoothFactor = 0.3, fillOpacity = 0.6, weight = 2,
      fillColor = ~pal(income), label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto")) %>%
    #addRasterImage(r, opacity = 0.5, group = 'Population Density') %>%
    addLegend(pal = pal, values = ~city$map_output_Percent.No.Income, opacity = 0.7,
              position = "bottomright", title = "Percent No Income") %>%
    addLayersControl(
      baseGroups = c("basic", "street", 'satellite'),
      #overlayGroups = c("Population Density"),
      options = layersControlOptions(collapsed = FALSE)
    )

saveWidget(city, file="city.html", title = 'johannesburg')
