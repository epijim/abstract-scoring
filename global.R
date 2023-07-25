

library(readr)
library(lubridate)
library(tidyr)
library(dplyr)
library(glue)
library(shiny)
library(bs4Dash)

enableBookmarking(store = "disable")

## load data
dat <- readRDS("./data.rds") #R dataset of paper info

###### Terms content

# terms_content_div <- div(
#   h1("Login"),
#   hr(),
#   textInput(
#     inputId = "login_string",
#     label = "Please provide a name or identifier to assign to your votes",
#     value = NA),
#   hr(),
#   p("By default you will be asked to review all abstracts. Optionally you can remove topics you are not interested in reviewing from the list below before logging in"),
#   p("Leave blank to test the app (blank entries will not be scored)."),
#   textOutput("filtered_data_count_text"),
#   selectInput(
#     inputId = "topics_filter", label = "",
#     choices = sort(unique(dat$topic)), selected = sort(unique(dat$topic)),
#     multiple = TRUE
#   )
# )

##########################################################################
## functions
##########################################################################

## function to rate a paper
# rate_paper <- function(choice, file_path, rv) {
#   ## is this the first time the paper is being run?
#   initializing <- choice == "initializing"
#   
#   ## are they deciding?
#   deciding <- choice == "deciding"
#   
#   ## all done?
#   validate(
#     need(nextPaper() < nrow(dat), "All done :)")
#   )
#   
#   ## index of all papers in data
#   vals <- dat %>%
#     select(index, submitted)
#   
#   if (initializing) {
#     ## grab our first paper!
#     new_ind <- vals$index[1]
#   } else {
#     ## next paper
#     val <- vals[ - which(vals$index %in% isolate(rv$user_dat$index)), ]
#     new_ind <- val$index[1]
#   }
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
#   if (initializing) {      ## create the dataframe for session
#     ## add new empty row the csv
#     rv$user_dat <- new_row
#   } else {
#     ## if this is a normal rating after initialization append a
#     ## new row to our session df
#     ## put the last review into the review slot of their data.
#     rv$user_dat[1, 5] <- choice
#     ## add a new empty row to dataframe.
#     rv$user_dat <- rbind(new_row, rv$user_dat)
#   }
#   
#   write_csv(isolate(rv$user_dat), file_path) #write the csv
#   #drop_upload(file_path, "rinpharma/2022/call4papers/", dtoken = token) #upload to dropbox too.
#   
#   # file_path2 <- file.path(tempdir(),
#   #                         paste0("user_dat_",isolate(rv$person_id), ".csv")
#   # )
#   # write_csv(data.frame(name = isolate(input$name),
#   #                      twitter = isolate(input$twitter),
#   #                      PC1 = isolate(rv$pc[1]),
#   #                      PC2 = isolate(rv$pc[2]),
#   #                      PC3 = isolate(rv$pc[3])),
#   #           file_path2)
#   #drop_upload(file_path2,"shiny/2016/papr/user_dat/", dtoken = token)
#   
#   return(new_ind)
# }