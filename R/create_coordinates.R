

#' Function to create coordinates for a Hilbert Curve
#' This functions adds three columns to a data frame: reld, x, y
#'
#' @param df the dataframe to use
#' @param idcol the column to use for mapping
#'
#' @return a data frame with three additional columns
#' @export
#'
#' @examples
#' mtcars %>% tibble::rownames_to_column() %>% create_id_column(rowname) %>% create_coordinates(gghid)
create_coordinates <- function(df, idcol) {
  idcol <- rlang::enquo(idcol)

  max_value <- df %>% dplyr::pull(!!idcol) %>% max()
  limit <- 4 ^ (ceiling(log(max_value, 4)))

  n_data <- df %>%
    dplyr::mutate(reld = round(((!!idcol - 1) / max_value) * limit))

  # then generate xy coloumns from the RELative Distance
  n_col <- hilbertd2xy(limit - 1, n_data$reld)
  # rebind these columns
  result <- n_data %>% dplyr::bind_cols(n_col)

  result
}
