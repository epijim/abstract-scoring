library(dplyr)
library(googlesheets4)

dat <- read_sheet(
  "https://docs.google.com/spreadsheets/d/1fZiTBwpY4b7jVOl8aMPIJUZVSn6BkNbKDnFIj9rUahQ/edit#gid=1189409547",
  sheet = "responses"
)

dat <- dat |>
  select(
    title = `What is the title of your talk?`,
    abstract = `Please provide an abstract`,
    submitted = `Timestamp`,
    types = `Which types of talk would you like to be considered for?`,
    affaliation = `What company or institution are you affiliated with?`,
    speaker = `What is the speaker's name?`,
    email = `Email Address`,
    topic = Topic
  ) |>
  mutate(
    index = row_number(),
    submitted = as.Date(submitted),
    byline = glue::glue("{speaker} ({affaliation}) wishes this abstract to be considered for {types}")
  )

saveRDS(dat,"www/data.rds")
