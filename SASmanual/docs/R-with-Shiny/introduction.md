## General tips

* Always run the entire script, not just up to the point where you're developing code
* Sometimes the best way to see what's wrong it is to run the app and review the error
* Watch out for commas!

## Anatomy of a Shiny app

1. We start by **loading any necessary packages** one of which is necessarily Shiny (we also **load the data** before the ui and server definitions so that it can be used in both)
2. Then we lay out the **user interface** with the UI object that controls the appearance of our app
3. We define the **server function** that contains instructions needed to build the app
4. We end each Shiny app script with a call to the **shinyApp()** function that puts these two components together to create the Shiny app object

```r
library(shiny)
load(url("http://your-data"))

# Define UI for application
ui <- fluidPage()

# Define server function
server <- function(input, output) {}

# Create a Shiny app object
shinyApp(ui = ui, server = server)
```
