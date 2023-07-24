enableBookmarking(store = "disable")

## load data
dat <- readRDS("./data.rds") #R dataset of paper info

library(readr)
library(lubridate)
library(tidyr)
library(dplyr)
library(glue)
library(shiny)
library(bs4Dash)