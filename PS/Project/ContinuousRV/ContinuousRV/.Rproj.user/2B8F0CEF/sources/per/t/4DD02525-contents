\name{prepareFunction}
\alias{prepareFunction}

\title{
  Prepare a given function to be applied to a CRV
}
\description{
  Returns a function which takes a CRV as a parameter, and applies fn to the CRV when called.
}
\usage{
  prepareFunction(fn)
}

\arguments{
  \item{fn}{
    The function to apply
  }
}

\value{
  A function which takes a CRV as its only parameter
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {x}, 0, 1)

  # g will be a callable function
  g <- prepareFunction(function(x) {x^2})

  # Apply g to the previously defined crv
  # The returned crv's function gets normalized by the CRV constructor inside g and is now 3x^2
  crvWithGapplied <- g(crv)
}
