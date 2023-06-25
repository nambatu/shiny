###########################################################
####                R Shiny tutorial                   ####
###########################################################

# preliminaries-----------------------------------------------------------------

# clear the environment
rm(list = ls())

# install or load shiny
if (!require("shiny")) install.packages("shiny"); library(shiny)
if (!require("dplyr")) install.packages("dplyr"); library(dplyr)


###########################################################
####                 What is Shiny?                    ####
###########################################################

# First shiny example to see the structure of shiny-----------------------------

# Viewing dataset
View(faithful)

# Run shiny example
runExample("01_hello")

### How to run the apps:--------------------------------------------------------

# Execute each example in the Console by highlighting the code and either:
#       1. using the keyboard shortcut (Ctrl/Cmd + Enter  windows/mac)
#       2. copying and pasting into the console and pressing Enter


#       ** clicking "Run App" will not work correctly

###########################################################
####                  ui Examples                      ####
###########################################################

### Example 1: input and output-------------------------------------------------

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

#_______________________________________________________________________________

### Example 2: Input free text--------------------------------------------------

ui <- fluidPage(
  textInput("hometown", "Where are you from?",width = "300px"),
  passwordInput("password", "What's your password?"),
  textAreaInput("career", "Tell me about your career",rows = 3)
)


server <- function(input, output) {
  
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 3: Input numeric values---------------------------------------------

ui <- fluidPage(
  numericInput("num1", "Number one", value = 5, min = 0, max = 100,step=0.1),
  sliderInput("num2", "Number two", value = 10, min = 0, max = 100,step = 10,
              animate = animationOptions(interval = 1000, loop = TRUE)),
  sliderInput("rng", "Range", value = c(10,50), min = 0, max = 100)
)

server <- function(input, output) {
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 4: Input limited choices--------------------------------------------

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

ui <- fluidPage(
  selectInput("animal", "What's your favourite animal?",choices = animals,selected = "cat",
              multiple =TRUE ),
  radioButtons("rb", "What's your mood now?",
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  ),#choiceNames allows any type of UI object to be passed through (tag objects,
  #icons, HTML code, ...), instead of just simple text
  textOutput("txt")
)

server <- function(input, output) {
  output$txt <- renderText({
    paste("You are", input$rb,"!")
  })
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 5: Input buttons----------------------------------------------------

ui <- fluidPage(
  actionButton(inputId = "goButton", label = "Go!", class = "btn-success"),
  actionLink("infoLink", "Information Link", class = "btn-info"),
  br(),
  br(),
  submitButton(text = "refresh", icon =icon("fas fa-sync")),
  br(),
  actionButton(inputId = "dangerButton", label = "be carefull",class = "btn-danger", icon = icon("fire"))
)# change the appearance using "btn-primary", "btn-success", "btn-info", "btn-warning", or "btn-danger"
# change the size with "btn-lg", "btn-sm", "btn-xs","btn-block"

server <- function(input, output) {
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 6: Output text------------------------------------------------------

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

#_______________________________________________________________________________

### Example 7: Output tables----------------------------------------------------

ui <- fluidPage(
  tableOutput("static"),
  dataTableOutput("dynamic")
)
server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
}
shinyApp(ui, server)

#_______________________________________________________________________________

### Example 8: Output plots-----------------------------------------------------

ui <- fluidPage(
  plotOutput("plot", width = "400px")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(curve(1/x,from = 0,to=10,col=2))
}
shinyApp(ui, server)

#_______________________________________________________________________________

### additional Example: Updating inputs-----------------------------------------

ui <- fluidPage(
  numericInput("min", "Minimum", 0),
  numericInput("max", "Maximum", 3),
  sliderInput("n", "n", min = 0, max = 3, value = 1)
)

server <- function(input, output, session) {
  observeEvent(input$min, {
    updateSliderInput(inputId = "n", min = input$min)
  })  
  observeEvent(input$max, {
    updateSliderInput(inputId = "n", max = input$max)
  })
}

shinyApp(ui, server)

#_______________________________________________________________________________

### additional Example: Creating UI with code-----------------------------------

ui <- fluidPage(
  textInput("label", "label"),
  selectInput("type", "type", c("slider", "numeric")),
  uiOutput("numeric")
)

server <- function(input, output, session) {
  output$numeric <- renderUI({
    if (input$type == "slider") {
      sliderInput("dynamic", input$label, value = 0, min = 0, max = 10)
    } else {
      numericInput("dynamic", input$label, value = 0, min = 0, max = 10) 
    }
  })
}
shinyApp(ui, server)

#_______________________________________________________________________________

#### Exercise 1 ####------------------------------------------------------------

#1. build a web application with the following inputs and outputs:

# A slider with inputId "carat_range" to select the range of carat 
# (0.2-5.2, initial range is 0.2-2), step is 0.2

# A select box with inputId "cut_type" to select the cut type, the vector is
# already provided for you

# A action button with inputId "display", label "Display!"

# A dynamic data table output with outputId "diamond_filtered"

library(shiny)
library(dplyr)
library(ggplot2)
cut<-c("Fair", "Good", "Very Good", "Premium", "Ideal")
ui <- fluidPage(
  
  titlePanel("manipulate the dataset diamond"),

  
)

server <- function(input, output) {

}

shinyApp(ui, server)

###########################################################
####                  Layout                           ####
###########################################################

#_______________________________________________________________________________

### Example 9: titlePanel() & SidebarLayout()-----------------------------------
# Layout the UI by placing elements in the fluidPage function
# Create a basic Shiny app with sidebar

ui <- fluidPage(
  titlePanel("Shiny"),
  sidebarLayout(
    position = "right",            #appeares by default on the left side
    sidebarPanel("really cool"),
    mainPanel("is cool")
  )
)

server <- function(input, output) {

}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 10: Grid Layout-----------------------------------------------------
# fluidRow() and column() function are used to build a layout from a grid system
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

#_______________________________________________________________________________

### Example 11: TabsetPanel()---------------------------------------------------
# to subdivide the UI into discrete sections
# Tabs are located on top by default

ui <- fluidPage(
  titlePanel("Tabsets"),
  sidebarLayout(
    sidebarPanel("panels"),
    mainPanel(
      tabsetPanel(
        tabPanel("panel 1", "one"),
        tabPanel("panel 2", "two"),
        tabPanel("panel 3", "three")
      )
    )
  )
)
server <- function(input, output) {
}

shinyApp(ui, server)


#_______________________________________________________________________________

### Example 12: navlistPanel()-----------------------------------------------
# shows tab titles vertically with a sidebar
# add headings with plain strings

ui <- fluidPage(
  navlistPanel(
    "Statistics",
    tabPanel("Description", "is the discipline that concerns the collection, 
           organization, analysis, interpretation, and presentation of data."),
    "Visualisation",
    tabPanel("Description", "the physical or imagining creation of images, 
           diagrams, or animations to communicate a message"),
    "and more Using R",
    tabPanel("Description", "is a programming language for statistical computing 
             & graphics."),
    tabPanel("Description", "is pretty cool.")
  )
)


server <- function(input, output) {
  
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 13: navbarPage()----------------------------------------------------
# creates a horizontal menu
# replaces fluidPage() & requires a title

ui <- navbarPage(
  "Shiny App",
  tabPanel("Statistics", "is the discipline that concerns the collection, 
           organization, analysis, interpretation, and presentation of data."),
  tabPanel("Visualisations", "the physical or imagining creation of images, 
           diagrams, or animations to communicate a message"),
  navbarMenu(
    "and more",
    tabPanel("Using"),
    tabPanel("R", "is a programming language for statistical computing & 
             graphics.")
    )
)


server <- function(input, output) {
  
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 14: Themes----------------------------------------------------------
# load the bslib package and change the overall look of your app

library(bslib) 

ui <- navbarPage(
  theme = bs_theme(bootswatch = "darkly"), 
    "Shiny App",
    tabPanel("Statistics", "is the discipline that concerns the collection, 
           organization, analysis, interpretation, and presentation of data."),
    tabPanel("Visualisations", "the physical or imagining creation of images, 
           diagrams, or animations to communicate a message"),
    navbarMenu(
      "and more",
      tabPanel("Using"),
      tabPanel("R", "is a programming language for statistical computing & 
             graphics.")
    )
  )

server <- function(input, output) {
  
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 15: Themes----------------------------------------------------------
# create your own own theme & view it
# install this packages if htmlwidgets are not available for your R version
install.packages("htmlwidgets", type = "binary")
install.packages("DT", type = "binary")

#load the bslib package
library(bslib)
#customize your theme
custom_theme <- bs_theme(
  bg = "lightblue", 
  fg = "yellow",
  base_font = "Maven Pro"
)

bs_theme_preview(theme = custom_theme, with_themer = FALSE)

# use your theme on an example
ui <- fluidPage(
  theme = custom_theme,
  titlePanel("Tabsets"),
  sidebarLayout(
    sidebarPanel("panels"),
    mainPanel(
      tabsetPanel(
        tabPanel("panel 1", "one"),
        tabPanel("panel 2", "two"),
        tabPanel("panel 3", "three")
      )
    )
  )
)
server <- function(input, output) {
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 16: HTML------------------------------------------------------------
# Customize your shiny app with HTML helper

ui <- fluidPage(
  h1("Header 1"),    # Heading
  br(),              # single line break
  p(strong("bold")), # p() Paragraph, strong() important text, displayed in bold
  p("hi this is",em("italic")),   # emphasized text, typically displayed in italic
  p("here is a", code("code")),   # text defined as computer code
  a(href="https://nambatu.shinyapps.io/shiny1/","cool shiny app") #create a link

)
server <- function(input, output) {
}

shinyApp(ui, server)
#_______________________________________________________________________________

#### Exercise 2 ####------------------------------------------------------------
# 2. Make a fun layout for the diamond dataset from exercise 1:

# display the slider input widget and the select box with the fluidRow() and
# column() function next to each other with width 6

# create a navlistPanel with 2 tabPanels
# every tabPanel should have a heading and one should contain the action button
# from exercise 1

# if you have time left: change the theme of the shiny app and insert some HTML 
# helpers like h1() and br() and maybe add a link

cut<-c("Fair", "Good", "Very Good", "Premium", "Ideal")

ui <- fluidPage(
  
)

server <- function(input, output) {

}

shinyApp(ui, server)

###########################################################
####                  Server                           ####
###########################################################

#_______________________________________________________________________________

### Example 17: Render function ###

ui <- fluidPage(
  numericInput("freq", label = "Frequency", value = 1),
  plotOutput("sin")
)

server <- function(input, output) {
  output$sin <- renderPlot({
    # You can code your own output in the render* function
    time <- seq(0,10, 0.01)
    plot(time, sin(time*input$freq), type = "l", ylab = "Sin")
  })
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 18: Input values ###

ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100),
)

server <- function(input, output) {
  input$count <- 10  # this will not work since the input argument is read-only
}

shinyApp(ui, server)


#_______________________________________________________________________________

### Example 19: Input values ###

ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100),
)

server <- function(input, output) {
  print(input$count)  # this will not work since the input is accessed outside of a reactive context
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 20: Reactive functions ###

ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100),
  verbatimTextOutput("reactive"),
  verbatimTextOutput("reactive2"),
  verbatimTextOutput("direct")
)

server <- function(input, output) {
  
  reactive_count <- reactive(input$count)
  output$reactive <- renderPrint(reactive_count())
  output$reactive2 <- renderPrint(reactive_count)  # reactive_count is not a fixed variable but a function
  
  output$direct <- renderPrint(input$count)
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 21: Reactive Buttons ###

ui <- fluidPage(
  numericInput("freq", label = "Frequency", value = 1),
  numericInput("amp", "Amplitude:", 1),
  submitButton("Update all input"),
  plotOutput("sin"),
)

server <- function(input, output) {
  output$sin <- renderPlot({
    t <- seq(0, 10, 0.01)
    plot(t, input$amp*sin(t*input$freq), type = "l")
  })
}

shinyApp(ui, server)

#_______________________________________________________________________________

### Example 22: Reactive Buttons ###

ui <- fluidPage(
  numericInput("freq", label = "Frequency", value = 1),
  actionButton("submit", label = "Update frequency"),
  numericInput("amp", "Amplitude:", 1),
  plotOutput("sin"),
)

server <- function(input, output) {
  
  output$sin <- renderPlot({
    t <- seq(0, 10, 0.01)
    plot(t, input$amp*sin(t*reactive_freq()), type = "l")
  })
  
  reactive_freq <- eventReactive(input$submit, {
    input$freq
  })
}

shinyApp(ui, server)


#### Exercise 3 ####------------------------------------------------------------
# Let's create some output for the diamond dataset from exercise 1:

# first filter the data according to the carat range and the cut type. Use a reactive context 
# bind the filtered data to the action button using eventReactive
# display the data in a data table. Set page length to 5

ui <- fluidPage(
  sliderInput("carat_range", "Please select the carat range", min=0.2, max=5.2, 
              value =c(0.2,2),step = 0.2),
  selectInput("cut_type", "Please select the cut type",cut,selected="Fair"),
  actionButton(inputId = "display", label = "Display!", class = "btn-success"),
  dataTableOutput("diamond_filtered")
)

server <- function(input, output) {
  
}

shinyApp(ui, server)
