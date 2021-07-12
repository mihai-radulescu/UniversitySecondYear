\name{P}
\alias{P.CRV}

\title{
  P function for continuous random variables
}
\description{
  Probability function for continuous random variables.
}
\usage{
  P(event)
}

\arguments{
  \item{event}{
    A CrvLogical vector
  }
}

\details{
  CrvLogical is a logical operation between either a CRV object and a number, or 2 CrvLogical objects
}

\value{
  A numeric value
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {1}, 0, 1)

  # Returns 0.1
  P(crv > 0.9)
  # Returns 0.7
  P(crv < 0.7)

  # Returns 0.8
  P(crv < 0.7 | crv > 0.9)
  # Returns 0.2
  P(crv > 0.7 & crv < 0.9)

  # Returns 0.53
  P(crv > 0.97 | crv < 0.5)
  # Returns 1
  P(crv < 0.97 | crv > 0.5)
}
