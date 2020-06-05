


#' Function to create the Hilbert Plot
#'
#' @param df Data frame to generate plot from
#' @param idcol The column name to be used for mapping (gghid)
#' @param color The column to map to color
#' @param size The column to map to size
#' @param label The column that contains the label
#' @param alpha The amount of alpha blending for the individual points
#' @param add_curve Whether or not to add the underlying hilbert curve
#' @param curve_alpha The amount of alpha blending for the hilbert curve
#' @param curve_color The color of the hilbert curve
#' @param jitter The amount of jitter to add to prevent overplotting
#'
#' @return a ggplot object
#' @export
#'
#' @examples
#' tibble::tibble(val = 1:128, size = runif(128, 1, 5), color = rep(c(1,2,3,4),32)) %>%
#'         gghilbertplot(val, color = factor(color), size = size, add_curve = TRUE)

gghilbertplot <- function(df, idcol, color = NULL, size = NULL, label = NULL,
                          alpha = 1,
                          add_curve = FALSE, curve_alpha = 1,
                          curve_color = "black",
                          jitter = 0){
  idcol = rlang::enquo(idcol)
  color = rlang::enquo(color)
  size = rlang::enquo(size)
  label = rlang::enquo(label)


  p_col = NULL
  p_size = NULL
  p_label = NULL
  p_curve = NULL

  # calculate the limits and match ----
  nmax <- df %>% dplyr::pull(!!idcol) %>% max()
  limit <- 2 ^ (ceiling(log2(nmax)))

  # generate needed data ----
  # first use the whole space and respect r's 1 indexing
  n_data <- df %>%
    dplyr::mutate(reld = round( ( (!!idcol - 1) / nmax) * limit))
  # then generate xy coloumns from the RELative Distance
  n_col <- hilbertd2xy(limit - 1, n_data$reld)
  # rebind these columns
  result <- n_data %>% dplyr::bind_cols(n_col)


  # add hilbert curve in the background ----
  if(add_curve){
    all_points <- tibble::tibble(id = 0:(limit-1))
    all_point_h <- hilbertd2xy(limit, all_points$id)
    all_points <- all_points %>%
      dplyr::bind_cols(all_point_h)
    p_curve <- ggplot2::geom_path(data = all_points,
                                  mapping = ggplot2::aes(x = x, y = y),
                                  color = curve_color,
                                  alpha = curve_alpha,
                                  inherit.aes = FALSE)
  }


  # handle optional parameters ----
  if(!rlang::quo_is_null(color)) {
    p_col <- ggplot2::aes(color = !!color)
  }

  if(!rlang::quo_is_null(size)){
    p_size <- ggplot2::aes(size = !!size)
  }

  if(!rlang::quo_is_null(label)){
    p_label <- ggplot2::aes(label = !!label)
  }

  if(jitter > 0) {
    p_points <- ggplot2::geom_jitter(width = jitter, height = jitter, alpha = alpha)
  } else {
    p_points <- ggplot2::geom_point(alpha = alpha)
  }

  result %>%
    ggplot2::ggplot() +
    ggplot2::aes(x = x, y = y) +
    # optional aesthetics
    p_size +
    p_label +
    p_col +
    # plot the curve
    p_curve +
    # add the dots
    p_points +
    NULL
}

