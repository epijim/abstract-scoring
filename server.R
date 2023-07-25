shinyServer(function(input, output, session) {
  
  ## set up user data
  # session_id <- as.numeric(Sys.time())
  # 
  # ## variables that get updated throughout the session.
  # ## need to be wrapped in reactiveValues to make sure their updates propigate
  rv <- reactiveValues(
    index_view = 1,
    user_dat = data.frame(
      index   = 1,
      title   = NA,
      speaker    = NA,
      session = NA,
      result  = NA,
      person  = NA
    )
  )
  # 
  # ## Login
  # observeEvent(input$login_string, {
  #   rv$person_id <- isolate(input$login_string)
  # })
  # 
  # ## create temp csv that we use to track session
  # file_path <- file.path(tempdir(), paste0(round(session_id), ".csv"))
  # write_csv(isolate(rv$user_dat), file_path)
  # 
  # 
  # ## on each rating or skip send the counter sum to update level info.
  # nextPaper <- reactive({
  #   rv$counter
  # })
  # 
  # output$authenticated <- renderText({
  #   validate(
  #     need(rv$person_id != "", "App in testing mode as no name provided.")
  #   )
  #   paste("Your responses are recorded as coming from",rv$person_id)
  # })
  # 
  #   
  # ## Inputs --------------------
  #   
  # ## Decide
  # decision <- reactive({input$decide})
  # output$decision_char <- renderText({ glue(
  #   "Make decision to {decision()} this abstract"
  #   )
  # })
  # 
  # ## on the interaction with the swipe card do this stuff
  # filtered_data <- eventReactive(input$decision_confirmed, {
  #   
  #   
  #   ## get swipe results from javascript
  #   decision_made <- decision()
  #   
  #   ## all done? - looks into rv
  #   validate(
  #     need(nextPaper() < nrow(dat), "All done :)")
  #   )
  #   
  #   ## index of all papers in data
  #   vals <- dat %>%
  #     select(index, submitted)
  #            
  #   ## Check which paper is needed
  #   if (rv$counter==-1) {
  #     ## grab our first paper!
  #     new_ind <- vals$index[1]
  #   } else {
  #     ## next paper
  #     val <- vals[ - which(vals$index %in% isolate(rv$user_dat$index)), ]
  #     new_ind <- val$index[1]
  #   }
  #   
  #   ## make a new row for our session data.
  #   new_row <- data.frame(
  #     index   = new_ind,
  #     title   = dat$title[dat$index == new_ind],
  #     speaker    = dat$speaker[dat$index == new_ind],
  #     session = session_id,
  #     result  = NA,
  #     person  = isolate(rv$person_id)
  #     
  #     # running
  #   )
  #   
  #   if (rv$counter==-1) {      ## create the dataframe for session
  #     ## add new empty row the csv
  #     rv$user_dat <- new_row
  #   } else {
  #     ## if this is a normal rating after initialization append a
  #     ## new row to our session df
  #     ## put the last review into the review slot of their data.
  #     rv$user_dat[1, 5] <- decision_made
  #     ## add a new empty row to dataframe.
  #     rv$user_dat <- rbind(new_row, rv$user_dat)
  #   }
  #   
  #   # was file_path not downloads
  #   write_csv(isolate(rv$user_dat), "~/downloads/vote.csv") #write the csv
  #   
  #   ## increase counter
  #   rv$counter = rv$counter + 1
  #   
  #   ## grab info on new paper
  #   selection <- filtered_data()[new_ind, ]
  #   
  #   print(filtered_data())
  # 
  #   selection
  #   
  #   
  # })
  
  # Navigate ---------------------
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
  
  # Capture login with name ----------
  login_name <- eventReactive(input$login,{
    validate(need(
      nchar(input$login_string) > 3, "Please provide a login longer than 3 char"
    ))
    
    input$login_string
  })
  
  output$login_name <- renderText({login_name()})
  
  # Filter to required abstract ---------
  filtered_abstract <- reactive({
    validate(need(
      length(login_name()) > 0, "Please login"
    ))
    
    dat %>% filter(index == rv$index_view)
    })
  
  # Make display for abstract -----------
  
  output$abstract_text <- renderUI({
    
    
    title <- filtered_abstract()$title
    abstract <- filtered_abstract()$abstract
    HTML(paste(title, abstract, sep = '<br/>'))
    
  })
  
  # output$decision_icon <- renderText({
  #   switch(
  #     input$decide, 
  #     "reject" = "trash", 
  #     "skip" = "forward", 
  #     "include" = "thumbs up"
  #   ) |> HTML()
  #})
})


