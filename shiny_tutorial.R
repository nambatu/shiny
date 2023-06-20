### R Shiny Tutorial ###

# preliminaries 
# clear the environment
rm(list = ls())
# install or load all required packages
{
  if (!require("shiny")) install.packages("shiny"); library(shiny)
  
  if (!require("gapminder")) install.packages("gapminder"); library(gapminder)
  
  if (!require("dplyr")) install.packages("dplyr"); library(dplyr)
}

# First shiny example to see the structure of shiny

#viewing dataset
View(faithful)

runExample("01_hello")

### How to run the apps:

# Execute each example in the Console by highlighting the code and either:
#       1. using the keyboard shortcut (Ctrl/Cmd + Enter  windows/mac)
#       2. copying and pasting into the console and pressing Enter


#       ** clicking "Run App" will not work correctly

###########################################################
####                  ui Examples                      ####
###########################################################

### Example 1: input and output--------------------------------

ui <- fluidPage(
  textInput(inputId = "name", label = "What's your name?",value="Thomas"),
  textOutput(outputId = "greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name, "!")
  })
}
shinyApp(ui, server)

#_________________________________________________________



### Example 2: Input free text------------------------------

ui <- fluidPage(
  textInput("hometown", "Where are you from?"),
  passwordInput("password", "What's your password?"),
  textAreaInput("career", "Tell me about your career", rows = 3)
)

server <- function(input, output) {
  
}

shinyApp(ui, server)

#_________________________________________________________



### Example 3: Input numeric values-----------------------------

ui <- fluidPage(
  numericInput("num1", "Number one", value = 5, min = 0, max = 100),
  sliderInput("num2", "Number two", value = 10, min = 0, max = 100,step = 10,
              animate = animationOptions(interval = 1000, loop = TRUE)),
  sliderInput("rng", "Range", value = c(10, 50), min = 0, max = 100)
)


server <- function(input, output) {
}

shinyApp(ui, server)

#_________________________________________________________

### Example 4: Input limited choices-----------------------------

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

ui <- fluidPage(
  selectInput("animal", "What's your favourite animal?", animals,selected = "cat"),
  radioButtons("rb", "What's your mood now?",
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  )#choiceNames allows any type of UI object to be passed through (tag objects, icons, HTML code, ...), instead of just simple text
)


server <- function(input, output) {
}

shinyApp(ui, server)

#_________________________________________________________



### Example 5: Input buttons-----------------------------

ui <- fluidPage(
  actionButton(inputId = "goButton", label = "Go!", class = "btn-success"),
  br(),
  br(),
  submitButton(text = "refresh", icon =icon("fas fa-sync")),
  br(),
  actionButton(inputId = "dangerButton", label = "be carefull",class = "btn-danger", icon = icon("fire"))
)

server <- function(input, output) {
}

shinyApp(ui, server)

#_________________________________________________________

### Example 6: Output text-----------------------------

ui <- fluidPage(
  textOutput("text"),
  verbatimTextOutput("code")
)
server <- function(input, output, session) {
  output$text <- renderText({ 
    "Good afternoon!" 
  })
  output$code <- renderPrint({ 
    rnorm(10)
  })
}

shinyApp(ui, server)

#_________________________________________________________


### Example 7: Output tables-----------------------------

ui <- fluidPage(
  tableOutput("static"),
  dataTableOutput("dynamic")
)
server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
}
shinyApp(ui, server)


#_________________________________________________________


### Example 8: Output plots-----------------------------

ui <- fluidPage(
  plotOutput("plot", width = "400px")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(curve(1/x,from = 0,to=10,col=2))
}
shinyApp(ui, server)


#### exercise 1 ####

#1. build a web application with the following inputs and outputs:

# A slider with inputId "carat_range" to select the range of carat (0.2-5.2, initial range is 0.2-2), step is 0.2

# A select box with inputId "cut_type" to select the cut type, the vector is already provided for you

# A action button with inputId "display", label "Display!"

# A dynamic data table output with outputId "diamond_filtered"

library(shiny)
library(dplyr)
library(ggplot2)
cut<-c("Fair", "Good", "Very Good", "Premium", "Ideal")
ui <- fluidPage(
  
  titlePanel("manipulate the dataset diamond"),
  # solution
  
  sliderInput("carat_range", "Please select the carat range", min=0.2, max=5.2, value =c(0.2,2),step = 0.2),
  selectInput("cut_type", "Please select the cut type",cut,selected="Fair"),
  
  actionButton(inputId = "display", label = "Display!", class = "btn-success"),
  
  dataTableOutput("diamond_filtered"),
  
  # solution
  
)



server <- function(input, output) {
  #filtered_data <- reactive({
  # diamonds%>%
  #filter(carat>=input$carat_range[1] &  carat<= input$carat_range[2]&cut==input$cut_type)
  #  })
  
  #data<-eventReactive(input$display,{filtered_data()})
  #output$diamond_filtered <- renderDataTable(data(),options = list(pageLength = 5))
}

shinyApp(ui, server)

###########################################################
####                  Layout                           ####
###########################################################

#_________________________________________________________

# fluidPage() function
# Layout the UI by placing elements in the fluidPage function

ui <- fluidPage(
  titlePanel("Shiny"),
  sidebarLayout(
    #position = "right",            #appeares by default on the left side
    sidebarPanel("really cool"),
    mainPanel("is cool")
  )
)

server <- function(input, output) {

}

shinyApp(ui, server)

#_________________________________________________________

# Grid Layout: fluidRow() and column() function are used to build a layout from a grid system
# can be used anywhere within fluidPage & nested in each other
# the number of units should always add up to 12
# wellPanel creates a box with grey background

ui <- fluidPage(
  
  fluidRow(
    column(2, wellPanel("Column width 2")),
    column(10, wellPanel("Column width 10"))),
  fluidRow(
    column(4, wellPanel("Column width 4")),
    column(8, wellPanel("Column width 8"),
           fluidRow(
             column(6, wellPanel("Column width 6")),
             column(6, wellPanel("Column width 6"))
           )
    )
  )
)


server <- function(input, output) {
  
}

shinyApp(ui, server)

#_________________________________________________________

# TabsetPanel(): to subdivide the UI into discrete sections
# Tabs are located on top by default

#_________________________________________________________


# navbarPage(): creates a horizontal menu
# replaces fluidPage() & requires a title

ui <- navbarPage(
  "Shiny App",
  tabPanel("Statistics", "is the discipline that concerns the collection, organization, analysis, interpretation, and presentation of data."),
  tabPanel("Visualisations", "the physical or imagining creation of images, diagrams, or animations to communicate a message"),
  navbarMenu(
    "and more",
    tabPanel("Using"),
    tabPanel("R", "is a programming language for statistical computing and graphics.")
    )
)


server <- function(input, output) {
  
}

shinyApp(ui, server)

#_________________________________________________________
### Example X: Reactive Content ###

ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100),
)
server <- function(input, output, session) {
  input$count = 10  # this will not work since the input argument is read-only
}
shinyApp(ui, server)


#_________________________________________________________


### Example X: Reactive Content ###

ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100),
  verbatimTextOutput("reactive"),
  verbatimTextOutput("direct")
)
server <- function(input, output, session) {
  reactiveValue <- reactive(log2(input$count))
  output$reactive <- renderPrint(reactiveValue())
  output$direct <- renderPrint(input$count)
}
shinyApp(ui, server)


#_________________________________________________________


### Example X: Reactive Content ###

ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100),
  plotOutput("hist")
)
server <- function(input, output, session) {
  #inputValue <- reactive(input$count)
  output$hist <- renderPlot(hist(rnorm(input$count)))
}
shinyApp(ui, server)






#_________________________________________________________

### Backup ###

## Only run examples in interactive R sessions
if (interactive()) {
  
  ui <- fluidPage(
    uiOutput("moreControls")
  )
  
  server <- function(input, output) {
    output$moreControls <- renderUI({
      tagList(
        sliderInput("n", "N", 1, 1000, 500),
        textInput("label", "Label")
      )
    })
  }
  shinyApp(ui, server)
}


