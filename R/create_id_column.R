#' Function to create keys from a character list
#'
#' @param df the dataframe that is used
#' @param col the column name in NSE format
#'
#' @return a dataframe with an additional gghid column
#' @export
#'
#' @examples
#' mtcars %>% tibble::rownames_to_column() %>% create_id_column(rowname)
create_id_column <- function(df, col){
  col = rlang::enquo(col)

  value_list <- df %>% dplyr::pull(!!col) %>%
    unlist() %>%
    unique() %>%
    stats::na.omit() %>%
    sort()

  key_df <- tibble::tibble(value = value_list) %>%
    dplyr::mutate(gghid = 1:dplyr::n()) %>%
    dplyr::select(gghid, value)

  bys = rlang::set_names("value", rlang::quo_name(col))

  df %>% dplyr::left_join(key_df, by = bys)
}
