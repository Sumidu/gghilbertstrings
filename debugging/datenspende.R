library(tidyverse)
library(gghilbertstrings)
library(gganimate)
library(progress)
library(glue)

# where are we
pth <- here::here("debugging","datenspende")


# get all entry names
get_terms <- function(){
  files <- dir(pth, pattern = ".*csv")
  terms <- str_match(files,"(.*)_.{2}.csv")[,2] %>% unique()
  terms
}


terms <- get_terms()


# function to write a term file in XZ compressed format
write_terms_rds <- function(term){
  options(readr.show_progress = FALSE)
  #read files
  files <- dir(pth, pattern = paste0(".*",term,".*.csv"), full.names = T)
  all_data <- NULL
  # setup progress bar
  pb <- progress_bar$new(
    format = paste("Reading", term, "[:bar] :percent eta: :eta"),
    total = length(files), clear = FALSE, width= 100)

  # read files
  for (file in files) {
    suppressMessages(
      suppressWarnings(
        file_data <- read_csv(file) %>% dplyr::rename(uuid = X1)
      )
    )

        all_data <- bind_rows(all_data, file_data)
    pb$tick()
  }

  message("Term: ", term, " has ", nrow(all_data), " entries. Compressing file ...")
  write_rds(all_data, here::here("debugging", paste0("datenspende",term, ".rds")), compress = "xz")
  message("Done.")
  options(readr.show_progress = TRUE)
}


# run only on subset?
term_selection <- terms #head(terms)
i <- 1

total <- length(term_selection)
for (term in term_selection) {
  print(glue("Running {i} of {total} {Sys.time()}"))
  write_terms_rds(term)
  i <- i + 1
}


####
#### ----------------- READ LOOP STARTS here
####

# Read again


chosen_term <- terms[1]
all_data <- NULL
for (chosen_term in terms) {
  all_data <- bind_rows(all_data,
                        read_rds(here::here("debugging", glue("datenspende{chosen_term}.rds")))
                        )
}

nrow(all_data)


# create coordinates for all possible urls and collect timing
{
  start.time <- Sys.time()
  all_data <- all_data %>%
    create_id_column(url)
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  time.taken
}

upper_limit <- max(all_data$gghid)

# find all domains that occur most frequently
top_domains <- all_data %>%
  group_by(domain) %>%
  count() %>%
  arrange(desc(n)) %>%
  head(50)

# take all urls to top domains
mean_positions <- all_data %>%
  select(domain, gghid) %>%
  right_join(top_domains) %>%
  group_by(domain) %>%  # find the average domain position
  summarize(gghid = round(mean(gghid),0))

label_positions <- mean_positions %>% bind_rows(tibble(domain = c("aaaa","zzzz"), gghid = c(1,upper_limit))) %>% create_coordinates(gghid)

label_positions %>% create_coordinates(gghid) %>%
  ggplot() +
  aes(x=x) +
  aes(y=y) +
  geom_point()


# create a list of top 2 items
generate_label_data <- function(df, col, n = 10) {
  col = rlang::enquo(col)

  id_df <-  df %>% create_id_column(!!col) %>% gghilbertstrings::create_coordinates(gghid)

  selection <- id_df %>% group_by(!!col) %>%
    count() %>% arrange(desc(n)) %>% head(n)

  id_df %>% select(!!col, gghid, reld, x, y) %>% unique() %>% right_join(selection)
}


# old appraoche
# all_urls <- read_delim(here::here("debugging", "stripped.csv"), delim = "ã", col_names = "url")
# all_urls <- all_urls %>% create_id_column(url)
# all_data <- all_data %>% left_join(all_urls) %>% create_coordinates(gghid)
# label_data <- all_data %>% filter(url %in% labels$url) %>% select(url, gghid, reld, x, y, domain) %>% unique()




names(all_data)

all_data %>%
  filter(rank < 3) %>%
  filter(search_type == "search") %>%
  filter(keyword %in% c("SPD", "CDU")) %>%
  filter(country == "DE") %>%
  filter(search_date > "2017-09-17") %>%
  create_coordinates(gghid) %>%
  ggplot() +
  aes(x = x, y = y, color = keyword, size = -rank) +
  geom_point(alpha = 0.2) +
# gghilbertplot(gghid, color = factor(cluster), size = -rank, label = domain, alpha = 0.1, jitter = 0.5) +
  ggrepel::geom_label_repel(data = label_positions,
                            mapping = aes(x = x, y = y, label = domain),
                            seed = 123, size = 2, show.legend = F, min.segment.length = 0, color = "black") +
  transition_time(search_date) +
  enter_appear() +
  exit_disappear() -> p


animate(p, renderer = gifski_renderer(), width = 1200, height = 1200, res = 150)
