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
    radioButtons("sort_direction", "Sort Direction:",
                 choices = c("Highest to Lowest" = "desc",
                             "Lowest to Highest" = "asc"),
                 selected = "desc"),
    actionButton("sort_btn", "Sort by Ratings", class = "btn-primary")
  ),

  card(
    card_header("Interactive Table"),
    div(style = "padding: 15px;",
        DTOutput("table", width = "100%")
    )
  )
