#
library(magrittr)
test_data <- list(c("abc", "abbc", "abbbc", "www.google.com", "www.google.de"),
                  c("abc", "abbbc", "aabbc", "abcde", "www.bild.de", "www.bild.com"),
                  c("a", "b", "c", "d", "e", "f", "g", "h"))


if(FALSE){

token <- rtweet::create_token("acv_twitter_app", consumer_key = "nfBg9C3m7XDV6hRS4UPDgrqHZ", consumer_secret = "NADNaMuMgEEIjzFl14PjvZp8fvNMywrsrjez9bENi5cqCeP0oA")

token

df <- rtweet::search_tweets("link", token = token, n = 5000, lang = "en")

df2 <- df %>% select(screen_name, text, keys = urls_expanded_url)




create_kv_list <- function(df, col){
  col = enquo(col)

  value_list <- df %>% pull(!!col) %>%
    unlist() %>%
    unique() %>%
    na.omit() %>%
    sort()

  key_df <- tibble::tibble(value = value_list) %>%
    dplyr::mutate(id = 1:dplyr::n()) %>%
    dplyr::select(id, value)

  key_df
}


gghilbertplot <- function(df, col){
  col = enquo(col)
  key_df <- create_kv_list(df, !!col)


}

gghilbertplot(df2, keys)


keys <- unlist(df2$keys) %>%
  unique() %>%
  na.omit() %>%
  sort()

key_df <- tibble::tibble(keys) %>%
  dplyr::mutate(id = 1:dplyr::n()) %>%
  dplyr::select(id, keys)


df3 <- df2 %>%
  unnest(cols = keys) %>%
  left_join(key_df) %>%
  na.omit()


  nmax <- max(df3$id)
  limit <- 2 ^ (round(log2(nmax)) + 1) - 1

  df4 <- df3 %>% mutate(reld = round((id / nmax) * limit))

  col <- hilbertd2xy(limit, df4$reld)
  result <- df4 %>% bind_cols(col) %>% mutate(s_start = str_to_lower(str_sub(screen_name, 1, 1)))

  frame_df <- tibble(id = 0:limit) %>% bind_cols(hilbertd2xy(limit, .$id))



  library(tidyverse)
  p <- result %>%
    ggplot2::ggplot() +
    ggplot2::aes(x = x, y = y, label = keys, color = s_start) +
    ggplot2::geom_jitter(width = 0.2, height = 0.2, alpha = 0.8) +
    #geom_label() +
    ggplot2::geom_path(data = frame_df, mapping = aes(x = x, y = y, label = id), color = c("black"), alpha = 0.1)+
    theme_minimal() +
    labs(x = "", y = "") +
    scale_color_hue() +
    guides(color = FALSE)

    plotly::ggplotly(p)
}


