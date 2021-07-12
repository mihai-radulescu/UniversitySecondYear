\name{mean}
\alias{mean.CRV}

\title{
  Mean of a CRV
}
\description{
  Calculates the mean of a given CRV.
}
\usage{
  mean(crv)
}

\arguments{
  \item{crv}{
    A CRV object
  }
}

\value{
  A numeric value, or, in the case of an error, NaN
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {x}, 0, 1)

  # Returns 0.666...
  mean(crv)
}
