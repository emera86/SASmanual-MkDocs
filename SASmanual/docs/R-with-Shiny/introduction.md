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
                  selected = "mpaa_rating"),
    
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
