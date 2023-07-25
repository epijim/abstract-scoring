shinyServer(function(input, output, session) {
  
  prior_votes <- read_sheet(
    gsheet,sheet = "votes"
  )
  
  dat <- read_sheet(
    gsheet,sheet = "responses_cleaned"
  )
  
  rv <- reactiveValues(
    index_view = 1,
    session_votes = data.frame(
      index = NA, vote = NA, timestamp = NA
    )
  )

# Navigate -------------------------------------------------------------------
  observeEvent(input$previous_abstract,{
    if (rv$index_view == 1){
      new_index <- max(dat$index)
    } else {
      new_index <- rv$index_view - 1
    }
    
    rv$index_view <- new_index
  })
  
  observeEvent(input$next_abstract,{
    if (rv$index_view == max(dat$index)){
      new_index <- 1
    } else {
      new_index <- rv$index_view + 1
    }
    
    rv$index_view <- new_index
  })
  
# Capture login with name ----------------------------------------------------
  login_name <- eventReactive(input$login,{
    validate(need(
      nchar(input$login_string) > 3, "Please provide a login longer than 3 char"
    ))
    
    hide(id = "login")
    hide(id = "login_string")
    
    input$login_string
  })
  
  output$login_name <- renderText({login_name()})
  
# Filter to required abstract ---------------------------------------------------
  filtered_abstract <- reactive({
    validate(need(
      nchar(login_name()) > 0, "Please login"
    ))
    
    dat %>% filter(index == rv$index_view)
    })
  
# Make display for abstract -----------------------------------------------------
  
  output$abstract_text <- renderUI({
    
    
    title <- filtered_abstract()$title
    abstract <- filtered_abstract()$abstract
    affaliation <- filtered_abstract()$affaliation
    #HTML(paste(title, abstract, sep = '<br/>'))
    HTML(glue(
      "
      <h3>{title}</h3> 
      <p>{abstract}</p>
      <p>Author is affiliated with {affaliation} (Author names are blinded to minimise bias)</p>
      "
    ))
    
  })
  
# Save abstract vote ---------------------------------------------------------
  
  # Create vote as tibble
  abstract_vote <- eventReactive(input$submit_rating, {
    
    validate(need(
      nchar(login_name()) > 0, "Please login"
    ))
    
    # save votes in session
    new_data <- data.frame(
      index = rv$index_view,
      vote = input$decide,
      timestamp = Sys.time()
    )
    
    rv$session_votes <- rbind(rv$session_votes, new_data)
    
    # make output
    tibble(
      index = rv$index_view,
      title = filtered_abstract()$title,
      user = login_name(),
      vote = input$decide,
      notes = input$abstract_notes,
      timestamp = Sys.time()
    )
  })
  
  # Total voted
  filtered_votes <- reactive({

    
    filtered_votes <- prior_votes %>% 
      filter(user == login_name()) %>%
      mutate(timestamp = as.numeric(timestamp)) %>%
      select(index,vote,timestamp) %>%
      bind_rows(rv$session_votes) 
  })
  
  output$vote_tally <- renderText({
    indexes <- filtered_votes() %>% pull(index) %>% na.omit()
    distinct <- n_distinct(indexes) 
    
    glue(
      "{distinct} / {n_distinct(dat$index)} abstracts"
    )
     
  })
  
  
  # Latest vote for this abstract
  last_vote <- reactive({
    
    filtered_to_this_abstract <- filtered_votes() %>%
      filter(index == rv$index_view)
    
    if (nrow(filtered_to_this_abstract) == 0) {
      last_vote <- "This abstract has not been rated"
    } else {
      last_vote <- filtered_to_this_abstract %>% arrange(desc(timestamp)) %>% slice(1) %>%
        mutate(
          last_vote  = glue(
            'You have voted to {vote} this abstract'
            )
        ) %>% pull(last_vote)
    }
    
    if (nchar(login_name()) == 0){
      last_vote <- "Login using the sidebar"
    }
    
    last_vote
  })
  
  output$abstract_text_latest <- renderText({
    last_vote()
  })
  
  # Save vote to gsheet
  observeEvent(abstract_vote(), {
    sheet_append(
      gsheet,
      data = abstract_vote(),
      sheet = "votes"
    )
  })
  
})


