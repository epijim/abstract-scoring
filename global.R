library(readr)
library(lubridate)
library(tidyr)
library(dplyr)
library(glue)
library(shiny)
library(fresh)
library(bs4Dash)
library(googlesheets4)

enableBookmarking(store = "disable")

options(gargle_oauth_cache = ".secrets")
#gs4_auth()
gs4_auth(cache = ".secrets", email = Sys.getenv("email"))

## Data store 

library(googlesheets4)

gsheet <- gs4_get(Sys.getenv("google_sheet_id"))

