# Referencia: https://ggplot2tutor.com/streetmaps/streetmaps/ 

library(tidyverse)
library(osmdata)

# Conseguir coordenadas para ggplot
getbb("Granada, España")

# Extraer lugares del mapa
streets <- getbb("Granada, España") %>%
  opq() %>%
  add_osm_feature(key = "highway", value = c("motorway", "primary", "secondary", "tertiary")) %>%
  osmdata_sf()

small_streets <- getbb("Granada, España") %>%
  opq() %>%
  add_osm_feature(key = "highway", value = c("residential", "living_street", "unclassified", "service", "footway")) %>%
  osmdata_sf()

river <- getbb("Granada, España") %>%
  opq() %>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

ggplot() +
  # Calles
  geom_sf(data = streets$osm_lines, inherit.aes = FALSE, color = "#ffbe7f", size = .4, alpha = .8) +
  # Pequeñas calles
  geom_sf(data = small_streets$osm_lines, inherit.aes = FALSE, color = "#ffbe7f", size = .2, alpha = .8) +
  # Ríos
  geom_sf(data = river$osm_lines, inherit.aes = FALSE, color = "#7fc0ff", size = .8, alpha = .5) +
  # Límites del mapa en coordenadas
  coord_sf(xlim = c(-3.65, -3.55), ylim = c(37.13, 37.225), expand = FALSE) +
  theme_void() + 
  # Añadir color de fondo
  theme(plot.background = element_rect(fill = "#282828"))

# Exportación de mapa
ggsave("18.png", width = 6, height = 6)

# Para añadir información sobre la costa
# Descargar la información en OSM de la costa dentro de tu límite del mapa.
# En este ejemplo de Granada no tendría sentido porque no tiene mar, pero por seguir los datos del ejemplo
coastline_data <- opq(c(-3.65, 37.225, -3.55, 37.13)) %>% 
  add_osm_feature(key = 'natural', value = 'coastline') %>% 
  osmdata_sf()

#Introducimos esta línea dentro de la función ggplot como las calles o los ríos
  geom_sf(data = coastline_data$osm_lines, inherit.aes = FALSE, color = "#7fc0ff", size = .8, alpha = .5) +
