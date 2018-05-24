## Reactive Elements

There are three kinds of objects in reactive programming:

* **Reactive Sources**: user input that comes through a browser interface, typically.
* **Reactive Endpoints**: something that appears in the user's browser window, such as a plot or a table of values. A reactive source can be connected to multiple endpoints, and vice versa.
* **Reactive Conductors**: reactive component between a source and an endpoint. It can be a dependetn (child) and have dependents (parent) while **sources can only be parents** and **endpoints can only be children**

![Reactive element types](../shiny-img/reactive-elements-types.PNG "Reactive element types")

We can create a reactive data set using the **`reactive()`** function which creates a **cached expression** that knows it is out of date when input changes. Remember to check the availability of the predefined input with the **`req()`** function before doing any calculations that depends on it and surround the expression with curly braces. When you refer to a reactive data set you need to use parentheses after its name, that is, a cached expression, meaning that it only rerun when its inputs change.

```r
library(shiny)
library(dplyr)
library(readr)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
      # Select filetype
      radioButtons(inputId = "filetype",
                   label = "Select filetype:",
                   choices = c("csv", "tsv"),
                   selected = "csv"),
      
      # Select variables to download
      checkboxGroupInput(inputId = "selected_var",
                         label = "Select variables:",
                         choices = names(movies),
                         selected = c("title"))
      
    ),
    
    # Output(s)
    mainPanel(
      DT::dataTableOutput(outputId = "moviestable"),
      downloadButton("download_data", "Download data")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create reactive data frame
  movies_selected <- reactive({
    req(input$selected_var)
    movies %>% select(input$selected_var)
  })
  
  # Create data table
  output$moviestable <- DT::renderDataTable({
    req(input$selected_var)
    DT::datatable(data = movies_selected(), 
                  options = list(pageLength = 10), 
                  rownames = FALSE)
  })
  
  # Download file
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("movies.", input$filetype)
    },
    content = function(file) { 
      if(input$filetype == "csv"){ 
        write_csv(movies_selected(), file) 
      }
      if(input$filetype == "tsv"){ 
        write_tsv(movies_selected(), file) 
      }
    }
  )
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
```

!!! tip
    The obvious choice for creating a text output would be `renderText` but if you want to get a little fancier including some HTML to use some text decoration, like bolding and line breaks in the text output, we need a rendering function that generates HTML, which is `renderUI`.
    
![reactive-data-set](../shiny-img/reactive-data-set.png "Reactive data set")

## Why Using Reactives?

By using a reactive expression for the subsetted data frame, we were able to get away with subsetting once and then using the result twice.

In general, reactive conductors let you not repeat yourself (i.e. avoid copy-and-paste code) and decompose large, complex calculations into smaller pieces to make them more understandable. This benefits are similar to decomposing a large complex R script into a series of small functions that build on each other.

### Functions vs Reactives

Each time you call a function, R will revaluate it. However, reactive expressions are lazy, they only get executed when their input changes. This means that even if you call a reactive expression multiple times, it only re-executes when its input(s) change(s).

Using many reactive expressions in your app can create a complicated dependency structure. The **`reactlog`** is a graphical representation of this dependency structure, and it also gives you very detailed information about what's happening under the hood as Shiny evaluates your application. To view the **`reactlog`**:

* In a fresh R session and run `options(shiny.reactlog = TRUE)` 
* Then, launch your app as you normally would
* In the app, pres **Ctrl+F3**

```r
library(shiny)
library(ggplot2)
library(dplyr)
library(tools)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Application title
  titlePanel("Movie browser"),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs(s)
    sidebarPanel(
      
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
      
      # Enter text for plot title
      textInput(inputId = "plot_title", 
                label = "Plot title", 
                placeholder = "Enter text for plot title"),
      
      # Select which types of movies to plot
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choices = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film")
      
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      textOutput(outputId = "description")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create a subset of data filtering for selected title types
  movies_subset <- reactive({
    req(input$selected_type)
    filter(movies, title_type %in% input$selected_type)
  })
  
  # Convert plot_title toTitleCase
  pretty_plot_title <- reactive({
    toTitleCase(input$plot_title)
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies_subset(), 
           aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point() +
      labs(title = pretty_plot_title())
  })
  
  # Create descriptive text
  output$description <- renderText({
    paste0("The plot above titled '", pretty_plot_title(), "' visualizes the relationship between ", input$x, " and ", input$y, ", conditional on ", input$z, ".")
  })
  
}

# Create the Shiny app object
shinyApp(ui = ui, server = server)
```

![Reactive Elements](../shiny-img/reactive-elements.PNG "Reactive Elements")

```r
library(shiny)
library(ggplot2)
library(dplyr)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))

# UI
ui <- fluidPage(
  sidebarLayout(
    
    # Input(s)
    sidebarPanel(
      
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
      
      # Select which types of movies to plot
      checkboxGroupInput(inputId = "selected_type",
                         label = "Select movie type(s):",
                         choices = c("Documentary", "Feature Film", "TV Movie"),
                         selected = "Feature Film"),
      
      # Select sample size
      numericInput(inputId = "n_samp", 
                   label = "Sample size:", 
                   min = 1, max = nrow(movies), 
                   value = 3)
    ),
    
    # Output(s)
    mainPanel(
      plotOutput(outputId = "scatterplot"),
      uiOutput(outputId = "n")
    )
  )
)

# Server
server <- function(input, output) {
  
  # Create a subset of data filtering for selected title types
  movies_subset <- reactive({
    req(input$selected_type)
    filter(movies, title_type %in% input$selected_type)
  })
  
  # Create new df that is n_samp obs from selected type movies
  movies_sample <- reactive({ 
    req(input$n_samp)
    sample_n(movies_subset(), input$n_samp)
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point()
  })
  
  # Print number of movies plotted
  output$n <- renderUI({
    types <- movies_sample()$title_type %>% 
      factor(levels = input$selected_type) 
    counts <- table(types)
    HTML(paste("There are", counts, input$selected_type, "movies plotted in the plot above. <br>"))
  })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
```

![Reactive Elements](../shiny-img/reactive-elements2.PNG "Reactive Elements")

## Reactives and observers

Here we discuss implementations of the three different types of reactive objects. As we go through the different implementations, it's recommended to think back to where they appear on the reactive flow chart.

![Reactive Flow](../shiny-img/reactive-flow.PNG "Reactive Flow")

* **Implementation of Reactive Sources**: An implementation of reactive sources is **`reactiveValues()`**. One example of this is user inputs. The input object is a reactive value that looks like a list and contains many individual reactive values that are set by input from the web browser.
* **Implementation of Reactive**: The implementation of reactive conductors is a **`reactive()`** expression that you can create with the reactive function. An example is the reactive data frame subsets created in the previous example. 
    * Reactive expressions can access reactive values or other reactive expressions and they return a value. 
    * They are useful for caching the results of any procedure that happens in response to user input.
* **Implementation of Reactive**: The implementation of reactive endpoints is **`observe()`**. For example, an output object is a reactive observer. Actually, under the hood, a render function returns a reactive expression, and when you assing this reactive expression to an output value, Shiny automatically creates an observer that uses the reactive expression. 
    * Observers can access reactive sources and reactive expressions, but they don't return a value.
    * Instead they are used for their side effects, which typically involves sending data to the web browser.

### Reactives vs Observers

* Similarities: they both store expressions that can be executed
* Differences:
    * Reactive expressions return values, but observers don't
    * Observers (and endpoints in general) eagerly respond to changes in their dependences, but reactive expressions (and conductors in general) do not
    * Reactive expressions must not have side effects, while observers are only useful for their side effects
* Most importantly:
    * The **`reactive()`** function is used when calculating values, without side effects
    * The **`observe()`** function is used to perform actions, with side effects
    * Do not use an **`observe()`** function when calculating a value, and especially don't use **`reactive()`** for performing actions with side effects
    
|---------------|--------------|--------------|
|               | **`reactive()`** | **`observe()`** |
| **Purpose** | Calculations | Actions |
| **Side effects** | Forbidden | Allowed |
