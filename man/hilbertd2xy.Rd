% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hilbertd2xy.R
\name{hilbertd2xy}
\alias{hilbertd2xy}
\title{Hilbert conversion, distance to coordinates}
\usage{
hilbertd2xy(n, d)
}
\arguments{
\item{n}{Size (must be a 2^k value, such as 4,8,16,32)}

\item{d}{A vector of values to be converted to coordinates (starts with 0)}
}
\value{
Tibble with columns x and y
}
\description{
Hilbert conversion, distance to coordinates
}
\examples{
hilbertd2xy(64,31)
}
