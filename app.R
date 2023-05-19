rm(list = ls())

{
  if (!require("shiny")) install.packages("shiny"); library(shiny)
  if (!require("leaflet")) install.packages("leaflet"); library(leaflet)
  if (!require("gapminder")) install.packages("gapminder"); library(gapminder)
  if (!require("dplyr")) install.packages("dplyr"); library(dplyr)
}


### Shiny-App ###


# define UI
ui <- fluidPage(
  textOutput("header"),
  selectInput("data", "Data", c("Life Expectancy", "Population", "GDP per Capita")),
  selectInput("year", "Year", distinct(gapminder, gapminder$year)),
  submitButton("submit", "Apply Changes"),
  leafletOutput("map")
  )


# define Server
server <- function(input, output) {
  output$header <- renderText({
    "Header Placeholder"
  })
  
  output$map <- renderLeaflet({
    
    
    gapminder_filtered <- gapminder %>% filter(year == input$year)
    
    WorldCountry <- geojsonio::geojson_read("C:/Users/julia/Downloads/world.geo.json-master/world.geo.json-master/countries.geo.json", what = "sp")
    data_Map <- WorldCountry[WorldCountry$name %in% gapminder_filtered$country, ]
    
    require(sp) # the trick is that this package must be loaded!
    data_Map <- merge(data_Map, gapminder_filtered, by.x="name", by.y="country")
    
    if (input$data == "Life Expectancy"){
      map_data = "lifeExp"
      names(data_Map)[names(data_Map) == "lifeExp"] <- "test"}
    else if (input$data == "Population") {
      map_data = "pop"}
    else if (input$data == "GDP per Capita") {
      map_data = "gdpPercap"}
    
    input_data <- data.frame(test=data_Map %>% pluck(map_data))
    
    Map <- leaflet(data_Map) %>% addTiles() %>% addPolygons()
    
    bins <- c(10, 20, 40, 50, 60, 70, 80, 90, Inf) #thresholds
    pal <- colorBin("Blues", domain = input_data$test, bins = bins) # color palette
    names(data_Map)[names(data_Map) == map_data] <- "test"
    head(data_Map)
    labels <- sprintf(
      "<strong>%s</strong><br/>life exp: %g",
      data_Map$name, data_Map$test) %>% lapply(htmltools::HTML)
    
    print(labels)
    
    Map <- Map %>% addPolygons(
      fillColor = ~pal(data_Map$test),
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