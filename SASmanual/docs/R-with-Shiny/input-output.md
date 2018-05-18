## Reactive Flow

Suppose you have a `slinderInput`in your app with the `inputId="alpha"`. The value of this input is stored in `input$alpha` so when the user moves around the slider the value of the `alpha`input is updated in th einput list. Reactivity automatically occurs when an input value is used to render an output object.

```r
library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"), 
                  selected = "critics_score"),
      
      # Set alpha level
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5)
    ),
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point(alpha = input$alpha)
  })
}

# Create the Shiny app object
shinyApp(ui = ui, server = server)
```

```r
library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(

  # Sidebar layout with a input and output definitions
  sidebarLayout(

    # Inputs
    sidebarPanel(

      # Select variable for y-axis
      selectInput(inputId = "y",
                  label = "Y-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                  selected = "audience_score"),

      # Select variable for x-axis
      selectInput(inputId = "x",
                  label = "X-axis:",
                  choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
                  selected = "critics_score")
    ),

    # Outputs
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      plotOutput(outputId = "densityplot", height = 200)
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {

  # Create scatterplot
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })

  # Create densityplot
  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) +
      geom_density()
  })

}

# Create the Shiny app object
shinyApp(ui = ui, server = server)
```

## UI Inputs

Shiny provides a wide selection of input widgets:

### **`checkboxInput`**
Add a checkbox input to specify whether the data plotted should be shown in a data table.

1. **UI**: Add an input widget that the user can interact with to check/uncheck the box
2. **UI**: Add an output defining where the data table should appear
3. **Server**: Add a reactive expression that creates the data table *if* the checkbox is checked

```r
library(shiny)
library(dplyr)
library(DT)

load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

n_total <- nrow(movies)

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Text instructions
      HTML(paste("Enter a value between 1 and", n_total)),
      
      # Numeric input for sample size
      numericInput(inputId = "n",
                   label = "Sample size:",
                   min = 1,
                   max = n_total,
                   value = 30,
                   step = 1)
      
    ),
    
    # Output: Show data table
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    req(input$n)
    movies_sample <- movies %>%
      sample_n(input$n) %>%
      select(title:studio)
    DT::datatable(data = movies_sample, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
```

![checkboxInput](../shiny-img/checkboxInput.png "checkboxInput")

!!! tip "The `req()` function"
    If you delete the numeric value from the checkbox, you will encounter an error: `Error: size is not a numeric or integer vector`. In order to avoid such errors, which users of your app could very easily encounter, we need to hold back the output from being calculated if the input is missing. The [`req` function](https://shiny.rstudio.com/reference/shiny/latest/req.html) is the simplest and best way to do this, it ensures that values are available ("truthy") before proceeding with a calculation or action. If any of the given values is not truthy, the operation is stopped by raising a "silent" exception (not logged by Shiny, nor displayed in the Shiny app's UI).

### **`selectInput`**: Multiple Selection 

The following app can be used to display movies from selected studios. There are 211 unique studios represented in this dataset, we need a better way to select than to scroll through such a long list, and we address that with the `selectize` option, which will suggest names of studios as you type them.

```r
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
all_studios <- sort(unique(movies$studio))

# UI
ui <- fluidPage(
    sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      selectInput(inputId = "studio",
                  label = "Select studio:",
                  choices = all_studios,
                  selected = "20th Century Fox",
                  multiple = TRUE,
                  selectize = TRUE)
    ),
    
    # Output(s)
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    req(input$studio)
    movies_from_selected_studios <- movies %>%
      filter(studio %in% input$studio) %>%
      select(title:studio)
    DT::datatable(data = movies_from_selected_studios, 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
```

![Selecting multiple options with selectize](../shiny-img/selectize-multiple.png "Selecting multiple options with selectize")

### **`dateRangeInput`** 

The following app is coded to show the selected movies between two given dates using `dateRangeInput`. This input will yield a vector (`input$date`) of length two, the first element is the start date and the second is the end date. 

```r
library(shiny)
library(dplyr)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

# UI
ui <- fluidPage(
    sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Explanatory text
      HTML(paste0("Movies released between the following dates will be plotted. 
                  Pick dates between ", min_date, " and ", max_date, ".")),
      
      # Break for visual separation
      br(), br(),
      
      # Date input
      dateRangeInput(inputId = "date",
                label = "Select dates:",
                start = "2013-01-01",
                end= "2014-01-01",
                startview = "year",
                min = min_date, max = max_date)
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create the plot
  output$scatterplot <- renderPlot({
    req(input$date)
    movies_selected_date <- movies %>%
      filter(thtr_rel_date >= as.POSIXct(input$date[1]) & thtr_rel_date <= as.POSIXct(input$date[2]))
    ggplot(data = movies_selected_date, aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
      geom_point()
  })
  
}
# Create a Shiny app object
shinyApp(ui = ui, server = server)
```

![dateRangeInput](../shiny-img/dateRangeInput.png "dateRangeInput")

## Rendering Functions

Shiny provides a wide selection of input widgets, each of which works with a render function:

### **`renderTable`**
Add a table beneath the plot displaying summary statistics for a new variable: `score_ratio = audience_score / critics_score`.

1. Calculate the new variable
2. **UI**: Add an input widget that the user can interact with to check boxes for selected title types
2. **UI**: Add an output defining where the summary table should appear
3. **Server**: Add a reactive expression that creates the summary table

```r

```

### **` `**

### Recap of Output/Rendering Functions

* Shiny has a variety of `render*` functions with corresponding `*Ourput` functions to create and display outputs
* `render*` functions can take on multiple arguments, the first being the expression for the desired output
* The expression in the `render*` function should be wrapped in curly braces
