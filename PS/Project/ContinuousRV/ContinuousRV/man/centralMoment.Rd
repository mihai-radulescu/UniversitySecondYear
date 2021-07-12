\name{centralMoment}
\alias{centralMoment}

\title{
  Central moment of a CRV
}
\description{
  Calculates the central moment of of a specified rank for a given CRV.
}
\usage{
  centralMoment(crv, rank)
}

\arguments{
  \item{crv}{
    A CRV object
  }
  \item{rank}{
    An integer value
  }
}

\details{
  In the case where the mean of the CRV doesn't exist, it prints a message and returns NaN.
}

\value{
  A numeric value, or, in the case of an error, NaN
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {x}, 0, 1)

  # Returns 1
  centralMoment(crv, 0)

  # Returns 0 - due to approximation errors, it returns a value very close to 0
  centralMoment(crv, 1)

  # Returns 0.055...
  centralMoment(crv, 2)

  # Returns -0.007407407...
  centralMoment(crv, 3)

  # Returns 0.007407407...
  centralMoment(crv, 4)
}
