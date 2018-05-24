## Reactive Elements

There are three kinds of objects in reactive programming:

* **Reactive Sources**: user input that comes through a browser interface, typically.
* **Reactive Endpoints**: something that appears in the user's browser window, such as a plot or a table of values. A reactive source can be connected to multiple endpoints, and vice versa.
* **Reactive Conductors**: reactive component between a source and an endpoint. It can be a dependetn (child) and have dependents (parent) while **sources can only be parents** and **endpoints can only be children**

We can create a reactive data set using the **`reactive()`** function which creates a **cached expression** that knows it is out of date when input changes. Remember to check the availability of the predefined input with the `req()` function before doing any calculations that depends on it and surround the expression with curly braces. When you refer to a reactive data set you need to use parentheses after its name, that is, a cached expression, meaning that it only rerun when its inputs change.

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

