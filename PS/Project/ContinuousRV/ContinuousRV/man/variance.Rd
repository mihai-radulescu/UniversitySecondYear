\name{variance}
\alias{variance}

\title{
  Variance of a CRV
}
\description{
  Calculates the variance for a given CRV.
}
\usage{
  variance(crv)
}

\arguments{
  \item{crv}{
    A CRV object
  }
}

\details{
  variance(x) is synonymous with centralMoment(x, 2)
}

\value{
  A numeric value
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {x}, 0, 1)

  # Returns 0.055...
  variance(crv)
}
