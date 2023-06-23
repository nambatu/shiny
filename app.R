rm(list = ls())

{
  if (!require("shiny")) install.packages("shiny"); library(shiny)
  if (!require("leaflet")) install.packages("leaflet"); library(leaflet)
  if (!require("gapminder")) install.packages("gapminder"); library(gapminder)
  if (!require("dplyr")) install.packages("dplyr"); library(dplyr)
  if (!require("geojsonio")) install.packages("geojsonio"); library(geojsonio)
  if (!require("sp")) install.packages("sp"); library(sp)
}


### Shiny-App ###


# define UI
ui <- fluidPage(
  # TODO: implement Layout
  
  theme = bslib::bs_theme(version = 4, bootswatch = "minty"),
  
  sidebarLayout(
    sidebarPanel(
      h1("Explore a dataset"),
      selectInput("data", "Data", c("Life Expectancy", "Population", "GDP per Capita")),
      selectInput("year", "Year", distinct(gapminder, gapminder$year))
    ),
    mainPanel(
      h1("World Map"),
      leafletOutput("map")
    )
  ),
)



# define Server
server <- function(input, output) {
  
  output$map <- renderLeaflet({
    # filter by year
    gapminder_filtered <- gapminder %>% filter(year == input$year)
    
    # read geojson file, filter and merge with gapminder data
    WorldCountry <- geojsonio::geojson_read("./countries.geo.json", what = "sp")
    data_Map <- WorldCountry[WorldCountry$name %in% gapminder_filtered$country, ]
    require(sp) # the trick is that this package must be loaded!
    data_Map <- merge(data_Map, gapminder_filtered, by.x="name", by.y="country")
    
    # define colour palettes for different data sets
    if (input$data == "Life Expectancy"){
      map_data = "lifeExp"
      bins <- c(20, 40, 50, 60, 70, 75, 80, 85) 
      pal <- colorBin("Blues", domain = data_Map$temp, bins = bins) 
      }
    else if (input$data == "Population") {
      map_data = "pop"
      bins <- c(10000, 1*10^6, 10*10^6, 50*10^6, 100*10^6, 200*10^6, 400*10^6, 600*10^6)
      pal <- colorBin("Reds", domain = data_Map$temp, bins = bins) 
      }
    else if (input$data == "GDP per Capita") {
      map_data = "gdpPercap"
      bins <- c(200, 1000, 5000, 10000, 20000, 30000, 40000, 50000)  # Can you find some errors in the data? (Hint: Look at early years in Middle East)
      pal <- colorBin("Greens", domain = data_Map$temp, bins = bins)
      }
    names(data_Map)[names(data_Map) == map_data] <- "temp"  # rename current column so that we can access it easier
    
    # leaflet stuff :)
    Map <- leaflet(data_Map) %>% addTiles() %>% addPolygons()
    labels <- sprintf(
      "<strong>%s</strong><br/>%s: %g",
      data_Map$name, input$data, data_Map$temp) %>% lapply(htmltools::HTML)
    
    Map <- Map %>% addPolygons(
      fillColor = ~pal(data_Map$temp),
      weight = 0.5,
      opacity = 1,
      color = "black",
      dashArray = "1",
      fillOpacity = 0.7,
      highlightOptions = highlightOptions(
        weight = 3,
        color = "black",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto")
    )
    Map
  })
}

shinyApp(ui, server)
