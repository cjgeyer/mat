\name{useblas}
\alias{matvecmult}
\alias{matmatmult}
\title{Matrix Multiplication}
\description{
  Multiply matrices and vectors.
}
\usage{
    matvecmult(a, x)
    matmatmult(a, b)
}
\arguments{
  \item{a}{a matrix.}
  \item{b}{another matrix such that \code{ncol(a) == nrow(b)}.}
  \item{x}{a vector of dimension \code{ncol(a)}.}
}
\value{
  Either \code{a \%*\% cbind(x)} or \code{a \%*\% b} as the case may be.
}
\examples{
a <- matrix(1:12, 3, 4)
b <- matrix(1:20, 4, 5)
x <- 1:4
matvecmult(a, x)
matmatmult(a, b)
}
\keyword{misc}
