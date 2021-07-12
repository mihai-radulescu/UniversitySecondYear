\name{CRV}
\alias{CRV}

\title{
  Make a continuous random variable based on a function and a domain
}
\description{
  Creates a continuous random variable based on a function and a domain.
}
\usage{
  CRV(fn, lower, upper)
}

\arguments{
  \item{fn}{
    Function on which the variable will be based
  }
  \item{lower}{
    Lower bound of the function
  }
  \item{upper}{
    Upper bound of the function
  }
}
\details{
  The given function gets automatically normalized, by using findNormalizationConstant.
  The original function is still accessible inside the originalFn slot.
}
\value{
  Continuous random variable as a CRV object
}

\examples{
  # Create a new CRV object
  crv <- CRV(function(x) {x}, 0, 1)
}
