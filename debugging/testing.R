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


# Remove the leading www
data_set <- data_set %>% mutate(displayLink = str_remove(displayLink, "www."))

# create a list of top 2 items
generate_label_data <- function(df, col, n = 10) {
  col = rlang::enquo(col)

  id_df <-  df %>% create_id_column(!!col) %>% create_coordinates(gghid)

  selection <- id_df %>% group_by(!!col) %>%
    count() %>% arrange(desc(n)) %>% head(n)

  id_df %>% select(!!col, gghid, reld, x, y) %>% unique() %>% right_join(selection)
}

labeldata <- data_set %>% generate_label_data(displayLink, 20)

data_set %>%
  mutate(day = as_date(queryTime)) %>%
  create_id_column(displayLink) %>%
  filter(searchTerms %in% c("flights to amsterdam", "flights to frankfurt am main")) %>%
  gghilbertplot(gghid, color = factor(searchTerms), size = factor(rank), label = displayLink,
                jitter = 0.5, alpha = 0.3,
                add_curve = TRUE, curve_alpha = 0.1) +
  ggrepel::geom_label_repel(data = labeldata,
                            mapping = aes(x = x, y = y, label = displayLink),
                            seed = 123, size = 2, show.legend = F, min.segment.length = 0, color = "black") +
  theme_void() +
  guides(color = guide_legend(override.aes = aes(label = "", size = 5, alpha = 1))) +
  guides(size = FALSE) +
  labs(color = "Search Terms", size = "Rank") +
  transition_time(day) +
  enter_appear() +
  exit_disappear() -> p



transition_time(day) +
    enter_appear() +
    exit_disappear() -> p


plotly::ggplotly(p)

animate(p, renderer = gifski_renderer(width = 1200, height = 1200), res = 150, rewind = F)




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




