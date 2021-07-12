\name{isPDF}
\alias{isPDF}

\title{
  PDF checking function
}
\description{
  Checks if a given function meets the criteria required for being a probability density function.
}
\usage{
  isPDF(fn, lower, upper)
}

\arguments{
  \item{fn}{
    Function to check
  }
  \item{lower}{
    Lower bound of the function
  }
  \item{upper}{
    Upper bound of the function
  }
}

\value{
  A boolean value
}

\examples{
  nonPdfFn <- function(x) {x}

  # Returns FALSE
  isPDF(nonPdfFn, 0, 1)

  pdfFn <- function(x) {2 * x}

  # Returns TRUE
  isPDF(pdfFn, 0, 1)
}
