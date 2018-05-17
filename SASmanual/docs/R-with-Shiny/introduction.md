## What is Shiny?

[Shiny](https://shiny.rstudio.com/) is an R package that makes it easy to build interactive web apps straight from R. You can host standalone apps on a webpage or embed them in R Markdown documents or build dashboards. You can also extend your Shiny apps with CSS themes, htmlwidgets, and JavaScript actions.

Every Shiny app has a webpage that the user visits, and behind this webpage there is a computer that serves this webpage by running R.

* When running your app locally, the computer serving your app is your own computer.
* When your app is deployed, the computer serving your app is a web server.

## General Tips

* Always run the entire script, not just up to the point where you're developing code
* Sometimes the best way to see what's wrong it is to run the app and review the error
* Watch out for commas!

## Anatomy of a Shiny App

1. We start by **loading any necessary packages** one of which is necessarily Shiny (we also **load the data** before the ui and server definitions so that it can be used in both)
2. Then we lay out the **user interface** with the UI object that controls the appearance of our app 
3. We define the **server function** that contains instructions needed to build the app
4. We end each Shiny app script with a call to the **`shinyApp()`** function that puts these two components together to create the Shiny app object

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

## Loading Data

The first step in the following example is to load the libraries and data to be used.

```r
library(shiny)
library(ggplot2)
load(url("http://s3.amazonaws.com/assets.datacamp.com/production/course_4850/datasets/movies.Rdata"))
```

## User Interface

The user interface, that we'll refer to as the UI going forward, defines and lays out the inputs of your app where users can make their selections. It also lays out the outputs.

1. At the outermost layer of out UI definition we begin with the **`fluidPage`** function. This function creates a fluid page layout consisting of **rows and columns**. Rows make sure that elements in them appear on the same line and columns within these rows define how much horizontal space each element should occupy. Fluid pages scale their components in realtime to fill all available browser width, which means the app developer don't need to worry about defininf relative widths for individual app components. 
2. We **define the layout** of our app. Shiny includes a number of options for laying out the components of an application. The **default layout is a layout with a sidebar** that you can define with the **`sidebarLayout`** function. Under the hood, Shiny implements layout features available in Bootstrap 2, which is a popular HTML/CSS framework, so no prior experience with Bootstrap is necessary. 
3. We define out **sidebar panel** that will contain the input controls in the following example. There are two dropdown menus created with the **`selectInput`** function.
4. The final component of our UI is the **`mainPanel`**. In the example, the main panel contains only one component, a plot output.

```r
# Define UI for application that plots features of movies
ui <- fluidPage(
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics score" = "critics_score", 
                              "Audience score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics score" = "critics_score", 
                              "Audience score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA rating" = "mpaa_rating", 
                              "Critics rating" = "critics_rating", 
                              "Audience rating" = "audience_rating"), 
                  selected = "mpaa_rating")
    ),
    
    # Output
    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)
```

!!! summary "Check these websites"
    To learn more about various layouts check the [Application Layout Guide](https://shiny.rstudio.com/articles/layout-guide.html).

## Server Function

The server function calculates outputs and performs any other calculations needed for the outputs.

At the outermost layer we define our **server function** which takes two arguments: **an input and an output**. Both of these are named lists. The server function accesses inputs selected by the user to perform computations and specifies how outputs laid out in the UI should be updated. The server function can take on one more argument, **session**, which is an environment that can be used to access information and functionality relating to the session.

In the following example of server function has only one output, a plot, so it contains the logic necessary to build this plot. The **`renderPlot`** function specifies how the plot output should be updated through some **ggplot2** code. The definition of the variables comes from the input list that is built in the UI.

```r
# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create the scatterplot object the plotOutput function is expecting
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y,
                                     color = input$z)) +
      geom_point()
  })
}
```

There are three rules of building server functions:

1. Always save objects to display to the named output list, in other words, something of the form `output$plot-to-display`
2. Build objects to display with one of the render functions (`render*()`), like we built our plot with **`renderPlor`**
3. Use input values from the named input list, with `output$plot-to-display`

Just like various inputs, Shiny also provides a wide selection of output types, each of which works with a render function. 

| `render*()` function | `*Output()` function            |
|----------------------|---------------------------------|
| `renderDataTable()`  | `dataTableOutput()`             |
| `renderImage()`      | `imageOutput()`                 |
| `renderPlot()`       | `plotOutput()`                  |
| `renderPrint()`      | `verbatimTextOutput()`          |
| `renderTable()`      | `tableOutput()`                 |
| `renderText()`       | `textOutput()`                  |
| `renderUI()`         | `uiOutput()` or `htmlOutput()`  |

!!! tip
    It's easy to build interactive applications with Shiny, but to get the most out of it, you'll need to understand the **reactive programming** scheme used by Shiny: it automatically updates outputs, such as plots, when inputs that go into them change.

## Building the Shiny app object

The last component of each Shiny app is a call to the application named **`shinyApp`** function, which puts the UI and the server pieces together to create a Shiny app object.

```r
# Create a Shiny app object
shinyApp(ui = ui, server = server)
```
