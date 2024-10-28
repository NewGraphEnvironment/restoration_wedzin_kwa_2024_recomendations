library(shiny)
library(bslib)
library(DT)

# Sample data
initial_data <- data.frame(
  Item = c("Apple", "Banana", "Orange", "Pear"),
  Price = c(1.99, 0.99, 1.49, 2.49),
  UserRating = rep(NA, 4),  # Column for user inputs
  stringsAsFactors = FALSE
)

ui <- page_sidebar(
  theme = bs_theme(),
  title = "Table with User Inputs",
  sidebar = card(
    actionButton("sort_btn", "Sort by UserRating", class = "btn-primary")
  ),

  card(
    card_header("Interactive Table"),
    div(style = "padding: 15px;",
        DTOutput("table", width = "100%")
    )
  )
)

server <- function(input, output, session) {
  # Reactive value to store the current state of the data
  rv <- reactiveVal(initial_data)

  # Create the interactive table
  output$table <- renderDT({
    datatable(
      rv(),
      selection = 'none',
      editable = list(
        target = "cell",
        disable = list(columns = c(0, 1))  # Make only UserRating column editable
      ),
      options = list(
        pageLength = 10,
        dom = 't',  # Show only the table without other controls
        ordering = FALSE  # Disable default sorting
      )
    )
  }, server = FALSE)  # Use client-side processing

  # Handle cell edits
  observeEvent(input$table_cell_edit, {
    info <- input$table_cell_edit
    current_data <- rv()
    current_data[info$row, info$col] <- as.numeric(info$value)
    rv(current_data)
  })

  # Handle sort button click - now always sorts ascending
  observeEvent(input$sort_btn, {
    current_data <- rv()
    # Only sort if there are valid ratings
    if (!all(is.na(current_data$UserRating))) {
      sorted_data <- current_data[order(current_data$UserRating), ]  # ascending order
      rv(sorted_data)
    }
  })
}

shinyApp(ui, server)
