\name{uselapack}
\alias{matinv}
\alias{matdet}
\alias{matsolve}
\alias{matsmash}
\title{Matrix Operations}
\description{
  Matrix Inverse, Determinant, Solution of Linear Equations.
}
\usage{
    matinv(a)
    matdet(a)
    matsolve(a, b)
    matsmash(a, x, fortran = FALSE)
}
\arguments{
  \item{a}{a square positive definite matrix.}
  \item{b}{a matrix having the same number of rows as \code{a}.}
  \item{x}{a vector of dimension \code{ncol(a)}.}
  \item{fortran}{If \code{FALSE} (the default use C code to call Lapack
      code (which is trickier), otherwise use Fortran code.}
}
\details{
  The reason for the requirement of positive definiteness is that we
  use Cholesky decomposition of \code{a}.

  This whole package is just an illustration of how to call LAPACK from
  C that is called by R.  LAPACK has many factorizations but we just
  illustrate one (if you get one, the rest are easy).

  If you know Fortran, it is much easier to write your algorithm in
  Fortran since Lapack and BLAS are also written in Fortran.
  So we have one illustration of this.
}
\value{
  Either \code{solve(a)} or \code{det(a)} or \code{solve(a, b)} or
  \code{rbind(x) \%*\% solve(a) \%*\% cbind(x)} as the case may be.
}
\examples{
n <- 20
p <- 5
x <- matrix(rnorm(n * p), nrow = n)
a <- t(x) \%*\% x
matinv(a)
matdet(a)
b <- rnorm(p)
matsolve(a, b)
matsmash(a, b)
}
\keyword{misc}
