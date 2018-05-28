Shiny comes with a list of functions saved under tags that allow us to access HTML tags and use them to add static (as opposed to reactive) content to our apps. The tags objects in Shiny is a list of a 110 simple functions for constructing HMTL documents. Each of the elements in this list is a function that maps to an HTML tag.

```r
tags$b("This is my first app")
<b>This is my first app</b>
```

The most common used tags are wrapped in their own functions and you can use them without the `tags$` list. These are functions like `a()` for anchor text, `br()` for line break, `code()` for displaying code in monospace form and the heading functions (`h1()`, `h2()`, etc.).

The following app does a bunch of things: allows users to customize the plot, subsets and samples the data, and reports simple summary statistics and displays the data table. HTML tags are used to add headers and visual separators to make it a bit more clear, at a first glance, what's happening in the app.

```r
library(shiny)
library(ggplot2)
library(stringr)
library(dplyr)
library(DT)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      h3("Plotting"),      # Third level header: Plotting
      
      # Select variable for y-axis 
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis 
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title Type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      hr(),      # Horizontal line for visual separation
      
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Set point size
      sliderInput(inputId = "size", 
                  label = "Size:", 
                  min = 0, max = 5, 
                  value = 2),
      
      # Enter text for plot title
      textInput(inputId = "plot_title", 
                label = "Plot title", 
                placeholder = "Enter text to be used as plot title"),
      
      hr(),      # Horizontal line for visual separation
      
      h3("Sampling and subsetting"),      # Third level header: Sampling and subsetting
      
      # Select which types of movies to plot
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choices = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film"),
      
      # Select sample size
      numericInput(inputId = "n_samp", 
                   label = "Sample size:", 
                   min = 1, max = nrow(movies), 
                   value = 50),
      
      hr(),      # Horizontal line for visual separation
      
      # Show data table
      checkboxInput(inputId = "show_data",
                    label = "Show data table",
                    value = TRUE)
      
    ),
    
    # Output:
    mainPanel(
      
      # Show scatterplot
      h3("Scatterplot"),          # Third level header: Scatterplot
      plotOutput(outputId = "scatterplot"),
      br(),          # Single line break for a little bit of visual separation
      
      # Print number of obs plotted
      h4(uiOutput(outputId = "n")),    # Fourth level header
      br(), br(),    # Two line breaks for a little bit of visual separation
      
      # Show data table
      h3("Data table"),          # Third level header: Data table
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output, session) {
  
  # Create a subset of data filtering for selected title types
  movies_subset <- reactive({
    req(input$selected_type) # ensure availablity of value before proceeding
    filter(movies, title_type %in% input$selected_type)
  })
  
  # Update the maximum allowed n_samp for selected type movies
  observe({
    updateNumericInput(session, 
                       inputId = "n_samp",
                       value = min(50, nrow(movies_subset())),
                       max = nrow(movies_subset())
    )
  })
  
  # Create new df that is n_samp obs from selected type movies
  movies_sample <- reactive({ 
    req(input$n_samp) # ensure availablity of value before proceeding
    sample_n(movies_subset(), input$n_samp)
  })
  
  # Create scatterplot object the plotOutput function is expecting 
  output$scatterplot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y,
                                              color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) +
      labs(x = toTitleCase(str_replace_all(input$x, "_", " ")),
           y = toTitleCase(str_replace_all(input$y, "_", " ")),
           color = toTitleCase(str_replace_all(input$z, "_", " ")),
           title = toTitleCase(input$plot_title))
  })
  
  # Print number of movies plotted 
  output$n <- renderUI({
    types <- movies_sample()$title_type %>% 
      factor(levels = input$selected_type) 
    counts <- table(types)
    
    HTML(paste("There are", counts, input$selected_type, "movies in this dataset. <br>"))
  })
  
  # Print data table if checked
  output$moviestable <- DT::renderDataTable(
    if(input$show_data){
      DT::datatable(data = movies_sample()[, 1:7], 
                    options = list(pageLength = 10), 
                    rownames = FALSE)
    }
  )
  
  }

# Create Shiny app object
shinyApp(ui = ui, server = server)
```
