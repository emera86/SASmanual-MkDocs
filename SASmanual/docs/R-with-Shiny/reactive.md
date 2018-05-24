## Reactive Elements

There are three kinds of objects in reactive programming:

* **Reactive Sources**: user input that comes through a browser interface, typically.
* **Reactive Endpoints**: something that appears in the user's browser window, such as a plot or a table of values. A reactive source can be connected to multiple endpoints, and vice versa.
* **Reactive Conductors**: reactive component between a source and an endpoint. It can be a dependetn (child) and have dependents (parent) while **sources can only be parents** and **endpoints can only be children**

We can create a reactive data set using the **`reactive()`** function which creates a **cached expression** that knows it is out of date when input changes as in the following example:

```r
# Create a subset fo data filtering

movies_subset <- reactive({
  req(input$selected_type)
  filter(movies, title_type %in% input$selected_type)
})
```

Before we do any calculations that depends on a predefined input, we check its availability with the `req()` function and we surround the expression with curly braces.

When you refer to a reactive data set you need to use parentheses after its name, that is, a cached expression, meaning that it only rerun when its inputs change.

```r
mainPanel(
(...)
# Print number of obs plotted
uiOutput(outputID = "n"),
(...)
)

(...)
# Create scatterplot

output$scatterplot <- renderPlot({
  ggplot(data = movies_subset(),
    aes_string(x = input$x, y = input$y)) + geom_point()
})

# Server - Print number of movies selected

output$n <- renderUI({
  HTML(paste0("The plot displays the relationship between the <br>
              audience and critics' scores of <br>",
              nrow(movies_subset()),
              " <b>", input$selected_type, "</b> movies."))
})
(...)
```

!!! tip
    The obvious choice for creating a text output would be `renderText` but if you want to get a little fancier including some HTML to use some text decoration, like bolding and line breaks in the text output, we need a rendering function that generates HTML, which is `renderUI`.

