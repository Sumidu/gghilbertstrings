library(magrittr)
library(tidyverse)
library(lubridate)
library(gghilbertstrings)
library(gganimate)

read_raw <- function(){
# read dir
  file_list <- dir("debugging/152498-1055549-bundle-archive/", pattern = ".csv", full.names = T)

  # read files
  data_set <- NULL
  for(file in file_list){
    data_set <- data_set %>% bind_rows(read_csv(file))
  }
  write_rds(data_set, "debugging/flights.rds", compress = "xz")
  data_set
}

read_data <- function(){
  cat("Reading XZ compressed data file...\n")
  read_rds("debugging/flights.rds")
}

data_set <- read_data()

library(gghighlight)
library(gganimate)


data_set %>%
  mutate(day = as_date(queryTime)) %>%
  create_id_column(displayLink) %>%
  mutate(show_lbl = runif(n())) %>%
  mutate(lbl = ifelse(show_lbl > 0.95, displayLink, "")) %>%
  filter(searchTerms == "flights to amsterdam") %>%
  #filter(day == "2018-12-16") %>%
  #filter(rank %in% c(1,2,3)) %>%
  gghilbertplot(gghid, color = factor(rank), size = factor(rank), jitter = 0, alpha = 0.5, label = lbl) +
  guides(color = FALSE) +
  ggrepel::geom_label_repel(seed = 123) +
  transition_time(day) +
    enter_appear() +
    exit_disappear() -> p


plotly::ggplotly(p)

animate(p, renderer = gifski_renderer(width = 800, height = 800), res = 75, rewind = F)




library(ggplot2)
library(gganimate)


data_set %>%
  create_id_column(loc) %>%
  sample_n(1000) %>%
  gghilbertplot(gghid, color = factor(priority), jitter = 0.1, size = 0.01) +
  theme_void()
  NULL

  transition_states(states = daymod) +
  enter_fade() +
  exit_fade()
animate(p, renderer = gifski_renderer(file = "test.gif"))




