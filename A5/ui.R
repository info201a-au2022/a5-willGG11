
library(shiny)
library(bslib)

data <- read.csv("data/owid-co2-data.csv")



Introduction_tab <- tabPanel(
  "Introduction",
  hr(),
  fluidPage(
    h3("background info"),
    hr(),
    p("Climate change not only reflects the problem of balance between man and nature, but also shows the problem of balance between different societies, such as uneven distribution of resources, different environmental standards and different economic levels between developing and developed countries."),
    p("Three variables are carefully examined and analyzed in this study to support research on climate change.
The variables are as follows:"),
    em("co2_per_capita"),
    p("	Annual total production-based emissions of carbon dioxide (CO₂), excluding land-use change, measured in tonnes per person"),
    em("co2_per_gdp"),
    p("Annual total production-based emissions of carbon dioxide (CO₂), excluding land-use change, measured in kilograms per dollar of GDP (2011 international-$)."),
    em("consumption_co2"),
    p("	Annual consumption-based emissions of carbon dioxide (CO₂), measured in million tonnes."),
    hr(),
    h3("Variable information"),
    hr(),
    h5("Value generated"),
    h6("The countries with highest and lowest co2_per_capita"),
    strong("The reason to generate this variable is for examining if the biggeer country in size would result
      in lower co2_per_capita, example: China and India"),
    textOutput(outputId = "var_one"),
    h6("The average co2 consumption"),
    strong("The reason to generate this variable is for examining if countries with high accumlative gdp would result
      in higher co2 consumption , example: US,China, India"),
    textOutput(outputId = "var_two"),
    h6("The countries with highest and lowest co2_per_gdp"),
    strong("The reason to generate this variable is for examining if countries with advanced technology would result
      in higher co2_per_gdp, example: US and European countries"),
    textOutput(outputId = "var_three"),
    

  )
)
Interactive_tab <- tabPanel(
  "Interactive visualization",
  fluidPage(
    titlePanel("Interactive visualization of Co2 stats"),
    HTML("Create co2 analysis by different years and conditions selected."),
    br(),
    hr(),
    
    sidebarLayout(

      selectInput(inputId = "fil", label = "select the variables to visualize below:",
                  choices = c("co2_per_gdp", "co2_per_capita", "co_meaner"),
                  selected = "co2_per_gdp"
      ), 
        
      sliderInput(
        inputId = "year_slider", 
        label = "Select Year Range", 
        min = 1990, 
        max = 2018,
        value = c(1990, 2018),
        round = TRUE
      )


  ),

      mainPanel(
        plotOutput(outputId = "plot_chart"),
        textOutput(outputId = "plot_info")
      )

    )
    
  )



ui <- navbarPage (
    theme = "theme.css",
                 titlePanel("Co2 and greenhouse emission report"),
                 
                  Introduction_tab,
                  Interactive_tab
)
