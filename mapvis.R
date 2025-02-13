library(leaflet)
library(sf)
library(geojsonio)



ndvi_tiles <- "https://guybh10.github.io/squirrelopt-tiles/NDVI_tiles/{z}/{x}/{y}.png"

basemap_tiles <- "https://guybh10.github.io/squirrelopt-tiles/Tiles_Basemap/{z}/{x}/{y}.png"

points_url <- "https://raw.githubusercontent.com/GuyBH10/squirrelopt-tiles/main/popups.geojson"

AOI_url <- "https://raw.githubusercontent.com/GuyBH10/squirrelopt-tiles/main/AOI.geojson"

# Load the GeoJSON data
popups <- geojson_read(points_url, what = "sp")
AOI <- geojson_read(AOI_url, what = "sp")

popup_content <- paste0(
  "<b>NDVI 2024:</b> ", popups$NDVI_2024, "<br>",
  "<b>NDVI 2017:</b> ", popups$NDVI_2017, "<br>",
  "<b>Habitat:</b> ", ifelse(is.na(popups$Habitat), "NA", popups$Habitat), "<br>",
  "<b>Owner Class:</b> ", ifelse(is.na(popups$OwnerClass), "NA", popups$OwnerClass)
)


# ndvi legend
ndvi_categories <- c(1, 2, 3, 4, 5)
ndvi_labels <- c("\u2265 0.2", "\u2265 0.5", "\u2265 0.6", "\u2265 0.7", "\u2265 1") # u2265 unicode for less than eq to
ndvi_colors <- c("#a77640", "#377193", "#de546c", "#7757e9", "#9fcc7a")



m = leaflet() %>% 
  setView(lng = -120.832838, lat = 45.858146, zoom = 10) %>% 
  # # basemap
  # addTiles(urlTemplate = basemap_tiles, group = "True Color Basemap") %>%
  
  addProviderTiles("CartoDB.Positron", group = "Base Map") %>% 
  
  #ndvi
  addTiles(urlTemplate = ndvi_tiles, group = "2024 NDVI") %>%
  # NDVI Legend
  addLegend(
    position = "bottomright",
    colors = ndvi_colors,
    labels = ndvi_labels,
    title = "NDVI Classification",
    opacity = 1,
    # group needed so it toggles with the tiles
    group = "2024 NDVI") %>%
  
  # points
  addCircleMarkers(
    data = popups,
    radius = 5,
    color = "blue",
    fill = TRUE,
    fillOpacity = 0.7,
    popup = popup_content,  # Click to show popup
    # label = popup_content   # Hover to show popup
  ) %>% 
  
  # AOI
  addPolylines(
    data = AOI,
    color = "red",  # Outline color
    weight = 2,
    opacity = 1
  ) %>%
  
  addLayersControl(
    baseGroups = c("Base Map"),
    overlayGroups = c("2024 NDVI"),
    options = layersControlOptions(collapsed = FALSE)  # Keep the control expanded
  )

m  
