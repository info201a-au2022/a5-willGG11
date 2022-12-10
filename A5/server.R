#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

data <- read.csv("data/owid-co2-data.csv")
new_data <- data %>% group_by(year) %>% mutate(co_meaner = mean(consumption_co2, na.rm = TRUE), mean_per_capita = mean(co2_per_capita, na.rm = TRUE),
                                               mean_per_gdp = mean(co2_per_gdp, na.rm = TRUE))


the_data <- new_data %>% select('co2_per_gdp', 'co_meaner', 'co2_per_capita', 'year', 'country','mean_per_capita',
                                "mean_per_gdp") %>% 
  filter(is.na(co2_per_gdp) == FALSE) %>% 
  filter(is.na(co_meaner) == FALSE)

data_test <- data %>% filter(year == 2021)


server <- function(input, output) {
  year_filter <- data %>% filter(year == 2021)
  output$var_one <- renderText ({
    max_gdp <-  year_filter %>% filter(co2_per_capita == max(co2_per_capita, na.rm=TRUE)) %>% pull(country)
    min_gdp <-  year_filter %>% filter(co2_per_capita == min(co2_per_capita, na.rm=TRUE)) %>% pull(country)
    paste("The country with highest Co2 emission per capita is ", max_gdp, ".", "The country with lowest Co2 emission per capita is ", min_gdp, ".")
  })
  output$var_two <- renderText ({
    consumption <- year_filter %>% summarise(co_mean = mean(consumption_co2, na.rm=TRUE)) %>% pull(co_mean)
    paste("The average consumption of Co2 in all contries/ region is ", consumption, "million tonnes.")
    
  })
  output$var_three <- renderText ({
    max_per <-  year_filter %>% filter(co2_per_gdp == max(co2_per_gdp, na.rm=TRUE)) %>% pull(country)
    min_per <-  year_filter %>% filter(co2_per_gdp == min(co2_per_gdp, na.rm=TRUE)) %>% pull(country)
    paste("The country with highest Co2 emission per gdp is ", max_per, ".", "The country with lowest Co2 emission per gdpis ", min_per, ".")
    
  })
  
  output$plot_chart <- renderPlot ({
    year_data <- the_data %>% filter(year %in% input$year_slider[1]:input$year_slider[2])
    if(input$fil == 'co2_per_gdp') {
      ggplot(year_data, aes(x = year, y = mean_per_gdp)) + geom_line() + ggtitle("Average Co2 consumed by making each additional gdp of all regions in givin years") + 
        ylab('co2 consumption') + xlab("year")

    } else if (input$fil == 'co2_per_capita') {
      ggplot(year_data, aes(x = year, y = mean_per_capita )) + geom_line() +
        ggtitle("Average Co2 consumed per capta of all regions in givin years") + 
        ylab('co2 consumption') + xlab("year")
    } else if (input$fil == 'co_meaner') {
      ggplot(year_data, aes(x = year, y = co_meaner)) + geom_line()  +  ggtitle("Average year total Co2 consumption of all regions in givin years") +
        ylab('co2 consumption') + xlab("year") 

    }
    
    })
  output$plot_info <- renderText ({
    if(input$fil == 'co2_per_gdp') {
      "Observing the graph, we can find that co2 consumption for each additional bust before 1995 then dramatically decreases from 2000 - 2018,
      It is reasonable to speculate the energy saving policy and technology were largely invented and adpoted after 1995"
    } else if (input$fil == 'co2_per_capita') {
      "Observing the graph, we can find that mean co2 consumption per capita similarly bust before 1995 then dramatically decreases from 2000 - 2018,
      However, the data fluctuates even though there is a declining tendency overall.
      It is reasonable to speculate the energy saving policy and technology were largely invented and adpoted after 1995
      And flucuation may caused by  climate articles like Paris Agreement and Political stands"
    } else if (input$fil == 'co_meaner') {
      "Average year total consumption of All regions is keeping increasing and the inclination is increasing, which means the growth of co2 consumption 
      is acclerating year by year, speculation is the more globalization and the swift development of developing countries "

      
    }
    
  })

}

