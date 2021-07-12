\name{initialMoment}
\alias{initialMoment}

\title{
  Initial moment of a CRV
}
\description{
  Calculates the initial moment of of a specified rank for a given CRV.
}
\usage{
  initialMoment(crv, rank)
}

\arguments{
  \item{crv}{
    A CRV object
  }
  \item{rank}{
    An integer value
  }
}

\value{
  A numeric value
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {x}, 0, 1)

  # Returns 1
  initialMoment(crv, 0)

  # Returns 0.666...
  initialMoment(crv, 1)

  # Returns 0.5
  initialMoment(crv, 2)

  # Returns 0.4
  initialMoment(crv, 3)

  # Returns 0.333...
  initialMoment(crv, 4)
}
