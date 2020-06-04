#' Function to create keys from a character list
#'
#' @param df the dataframe that is used
#' @param col the column name in NSE format
#'
#' @return a dataframe with an additional gghid column
#' @export
#'
#' @examples
create_id_column <- function(df, col){
  col = enquo(col)

  value_list <- df %>% pull(!!col) %>%
    unlist() %>%
    unique() %>%
    na.omit() %>%
    sort()

  key_df <- tibble::tibble(value = value_list) %>%
    dplyr::mutate(gghid = 1:dplyr::n()) %>%
    dplyr::select(gghid, value)

  bys = set_names("value", quo_name(col))

  df %>% left_join(key_df, by = bys)
}
