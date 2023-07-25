dashboardPage(
  dashboardHeader(title = "Voting app"),
  dashboardSidebar(
    textInput(
      inputId = "login_string",
      label = "Please provide a unique identifier for your scoring",
      value = NA
      ),
    actionButton("login", "Login"),
    hr(),
    p("Your votes are being recorded as:"),
    textOutput("login_name")
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(
        title = "Abstract",
        htmlOutput("abstract_text")
        ),
      
      box(
        title = "Score abstract",
        radioButtons(
          "decide",
          label = p("Rating for this abstract"),
          choices = list(
            "Include this abstract" = "include",
            "Skip scoring this abstract" = "skip",
            "Reject this abstract" = "reject"),
          selected = "reject"),
          textInput(
            "abstract_notes",
            label = "Notes",
            value = "",
            placeholder = "optional"
          ),
        actionButton(
          "submit_rating",
          label = "Submit rating",
          icon = icon("floppy-disk")
        )
      #   #hr(),
      #   #textOutput("decision_char"),
      #   hr(),
      #   appButton(
      #     inputId = "decision_confirmed",
      #     label = textOutput("decision_char"), 
      #     icon = icon("check-to-slot"), 
      #     color = "warning"
      #     #dashboardBadge(textOutput("decision_char"), color = "primary")
      ),
      box(
        title = "Current rating for this abstract",
        p("placeholder")
      ),
      box(
        title = "Navigate abstracts",
        actionButton("previous_abstract", "Previous", icon = icon("arrow-left")),
        actionButton("next_abstract", "Next", icon = icon("arrow-right"))
      )
    )
  )
)