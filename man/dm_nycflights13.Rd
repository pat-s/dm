% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nycflights13.R
\name{dm_nycflights13}
\alias{dm_nycflights13}
\title{Creates a dm object for the \pkg{nycflights13} data}
\usage{
dm_nycflights13(cycle = FALSE, color = TRUE, subset = TRUE)
}
\arguments{
\item{cycle}{Boolean.
If \code{FALSE} (default), only one foreign key relation
(from \code{flights$origin} to \code{airports$faa}) between the \code{flights} table and the \code{airports} table is
established.
If \code{TRUE}, a \code{dm} object with a double reference
between those tables will be produced.}

\item{color}{Boolean, if \code{TRUE} (default), the resulting \code{dm} object will have
colors assigned to different tables for visualization with \code{dm_draw()}.}

\item{subset}{Boolean, if \code{TRUE} (default), the \code{flights} table is reduced to flights with column \code{day} equal to 10.}
}
\value{
A \code{dm} object consisting of {nycflights13} tables, complete with primary and foreign keys and optionally colored.
}
\description{
Creates an example \code{\link{dm}} object from the tables in \pkg{nycflights13},
along with the references.
See \link[nycflights13:flights]{nycflights13::flights} for a description of the data.
As described in \link[nycflights13:planes]{nycflights13::planes}, the relationship
between the \code{flights} table and the \code{planes} tables is "weak", it does not satisfy
data integrity constraints.
}
\examples{
if (rlang::is_installed("nycflights13")) {
  dm_nycflights13() \%>\%
    dm_draw()
}
}
