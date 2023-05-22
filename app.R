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
  #hellou
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
     # TODO: clean Code, personalize per chosen data (eg bins), add comments
    
    gapminder_filtered <- gapminder %>% filter(year == input$year)
    
    WorldCountry <- geojsonio::geojson_read("./countries.geo.json", what = "sp")
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
    
    #input_data <- data.frame(test=data_Map %>% pluck(map_data))
    
    Map <- leaflet(data_Map) %>% addTiles() %>% addPolygons()
    
    
    names(data_Map)[names(data_Map) == map_data] <- "test"
    
    bins <- c(10, 20, 40, 50, 60, 70, 80, 90, Inf) #thresholds
    pal <- colorBin("Blues", domain = data_Map$test, bins = bins) # color palette
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%s: %g",
      data_Map$name, input$data, data_Map$test) %>% lapply(htmltools::HTML)
    
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