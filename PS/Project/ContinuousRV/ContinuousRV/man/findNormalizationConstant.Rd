\name{findNormalizationConstant}
\alias{findNormalizationConstant}

\title{
  Normalization constant finding function
}
\description{
  Finds the normalization constant of a given function.
}
\usage{
  findNormalizationConstant(fn, lower, upper)
}

\arguments{
  \item{fn}{
    Function to find the normalization constant for
  }
  \item{lower}{
    Lower bound of the function
  }
  \item{upper}{
    Upper bound of the function
  }
}
\details{
  In the case of an error, it prints out a message and returns NaN
}
\value{
  A numeric value or, in the case of an error, NaN
}

\examples{
  unnormalizedFn <- function(x) {x}

  # Returns 2
  findNormalizationConstant(unnormalizedFn, 0, 1)

  # Returns NaN
  findNormalizationConstant(unnormalizedFn, -Inf, Inf)
}
