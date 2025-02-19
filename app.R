library(shiny)
library(bslib)
library(DT)
# library(readr)


# looks like the export from zotero is now breaking our xciter::xct_keys_to_inline_table_col function. not sure why - added last
# citation by hand.... Need to look into it
# httr::GET(
#   url = "https://raw.githubusercontent.com/NewGraphEnvironment/new_graphiti/main/assets/NewGraphEnvironment.bib",
#   httr::write_disk("references.bib", overwrite = TRUE)
# )


# # use the csv vs the tribble
# data_raw <- readr::read_csv(
#
#   "recommendations_raw.csv"
# )
#
# data_clean <- xciter::xct_keys_to_inline_table_col(
#   data_raw,
#   col_format = "Details")
#
# # temporary hack to avoid use of ngr in webassembly.  burn out a csv object then just read it in for shiny live
# data_clean |>
#   readr::write_csv(
#     file = 'recommendations.csv'
#   )

data_clean <- readr::read_csv('recommendations.csv')


ui <- page_fluid(
  theme = bs_theme(),
  title = "Priority Rating Tool",

  card(
    card_header(
      div(style = "display: flex; justify-content: space-between; align-items: center;",
          span("Interactive Priority Table"),
          actionButton("sort_btn", "Sort by Priority Rating", class = "btn-sm btn-primary")
      )
    ),
    div(style = "padding: 15px;",
        p("Click in the USERINPUT column to add your priority ratings (any positive number - could be a $$DOLLAR amount)"),
        DTOutput("table", width = "100%"),
        # Add a div for showing validation messages
        div(id = "validation_message", style = "color: red; margin-top: 10px;")
    )
  )
)

server <- function(input, output, session) {
  rv <- reactiveVal(data_clean)

  output$table <- renderDT({
    datatable(
      rv(),
      selection = 'none',
      rownames = FALSE,
      escape = FALSE,
      editable = list(
        target = "cell",
        disable = list(columns = c(1, 2))
      ),
      options = list(
        pageLength = 15,
        dom = 't',
        ordering = FALSE,
        initComplete = JS("function(settings, json) {
          $(this.api().table().container()).css({'font-size': '12px'});
        }"),
        columnDefs = list(
          list(
            targets = 0,
            createdCell = JS("function(td, cellData, rowData, row, col) {
              $(td).css('background-color', '#f0f8ff');
              $(td).css('cursor', 'pointer');
              $(td).css('font-weight', 'bold');
              if(cellData === null || cellData === '' || cellData === 'NA') {
                $(td).html('Click to rate!');
                $(td).css('color', '#666');
                $(td).css('font-style', 'italic');
              }
            }")
          )
        )
      )
    ) %>%
      formatStyle(
        'Details',
        backgroundColor = 'white',
        color = 'black'
      )
  }, server = FALSE)

  # Handle cell edits with improved validation feedback
  observeEvent(input$table_cell_edit, {
    info <- input$table_cell_edit
    current_data <- rv()

    # Convert input to numeric and validate
    new_value <- suppressWarnings(as.numeric(info$value))

    if (is.na(new_value)) {
      # Show error for non-numeric input
      runjs("document.getElementById('validation_message').innerHTML = 'Please enter a valid number.'")
    } else if (new_value <= 0) {
      # Show error for negative or zero input
      runjs("document.getElementById('validation_message').innerHTML = 'Please enter a positive number.'")
    } else {
      # Valid input: update data and clear message
      current_data$USERINPUT[info$row] <- new_value
      rv(current_data)
      runjs("document.getElementById('validation_message').innerHTML = ''")
    }
  })

  observeEvent(input$sort_btn, {
    current_data <- rv()
    idx <- order(is.na(current_data$USERINPUT), current_data$USERINPUT)
    sorted_data <- current_data[idx, ]
    rv(sorted_data)
  })
}

shinyApp(ui, server)
