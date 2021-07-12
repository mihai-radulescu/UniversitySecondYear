# 1.
setGeneric(
  "findNormalizationConstant",
  function(fn, lower, upper) {
    standardGeneric("findNormalizationConstant")
  }
)

setMethod("findNormalizationConstant", signature = c("function", "numeric", "numeric"), definition = function(fn, lower, upper) {
  tryCatch(
    {
      int <- integrate(fn, lower, upper)$value

      if (int == 0) {
        message("Nu exista constanta de normalizare")
        return(NaN)
      }

      return(1 / int)
    },
    error=function(cond) {
      message("Nu exista constanta de normalizare")
      return(NaN)
    }
  )
})

# 3.
setClass("CRV", representation(
  fn = "function",
  domain = "list",
  originalFn = "function"
))

CRV <- function(fn, lower, upper) {
  normalizationValue <- findNormalizationConstant(fn, lower, upper)

  new(
    "CRV",
    fn = function(x) {normalizationValue * fn(x)},
    originalFn = fn,
    domain = list(
      lower = lower,
      upper = upper,
      seq = function(step = 0.001) {seq(lower, upper, step)}
    )
  )
}

setClassUnion("CrvLogicalComparand", c("CRV", "numeric"))

setClass("CrvLogical", representation(
  comp1 = "CrvLogicalComparand",
  operand = "character",
  comp2 = "CrvLogicalComparand",
  value = "numeric"
))

setClassUnion("CrvLogicalComparand", c("CRV", "CrvLogical", "numeric"))

CrvLogical <- function(comp1, operand, comp2) {
  value <- 0

  if (class(comp1) == "CRV" && class(comp2) == "numeric") {
    if(operand == "<") {
      value <- CDF(comp1, comp2)
    } else if(operand == ">") {
      value <- 1 - CDF(comp1, comp2)
    }
  } else if (class(comp1) == "CrvLogical" && class(comp2) == "CrvLogical") {
    if (operand == "&") {
      value <- (comp1@value + comp2@value) - 1
      if (value < 0) {
        value <- 0
      }
    } else if (operand == "|") {
      value <- comp1@value + comp2@value
      if (value > 1) {
        value <- 1
      }
    }
  }

  new(
    "CrvLogical",
    comp1 = comp1,
    operand = operand,
    comp2 = comp2,
    value = value
  )
}

# 2.
setGeneric(
  "isPDF",
  function(fn, lower, upper) {
    standardGeneric("isPDF")
  }
)

setMethod("isPDF", signature = c("function"), definition = function(fn, lower, upper) {
  # verificam daca funtia este mereu pozitiva pe domeniul dat, verificand valoarea minima cu optimize. Daca este, atunci verificam daca integrala este 1. Daca da, atunci functia data este PDF.
  ifelse(optimize(fn, interval=c(lower, upper)) < 0, return(FALSE), return(integrate(fn, lower, upper)$value == 1))
})

# 4.
setGeneric(
  "CDF",
  function(crv, x) {
    standardGeneric("CDF")
  }
)

setMethod("CDF", signature = c("CRV", "numeric"), definition = function(crv, x) {
  integrate(crv@fn, crv@domain$lower, x)$value
})

setMethod("plot", signature = c("CRV"), definition = function(x) {
  # Aplicam PDF-ul variabilei pe domeniul ei si apelam plot-ul nativ
  P <- lapply(x@domain$seq(0.001), x@fn)
  plot(x@domain$seq(0.001), P)

  # Aplicam CDF-ul variabilei pe domeniul ei si apelam plot-ul nativ
  P <- lapply(x@domain$seq(0.001), CDF, crv = x)
  plot(x@domain$seq(0.001), P)
})

# 5.
# Daca nu exista mean pentru o anumita repartitie, atunci nu pot exista momente centrele (i.e. Cauchy distribution) -- try catch pt integrala de la mean?
setMethod("mean", signature = c("CRV"), definition = function(x) {
  tryCatch(
    {
      return(integrate(function(x_) {x_ * x@fn(x_)}, x@domain$lower, x@domain$upper)$value)
    },
    error=function(cond) {
      message("Nu exista medie pentru varibila data")
      return(NaN)
    }
  )
})

setGeneric(
  "centralMoment",
  function(crv, rank) {
    standardGeneric("centralMoment")
  }
)

setMethod("centralMoment", signature = c("CRV", "numeric"), definition = function(crv, rank) {
  m <- mean(crv)

  if (is.nan(m)) {
    message(c("Nu exista moment central de ordinul ", rank))
    return(NaN)
  }

  integrate(function(x) {(x - m) ** rank * crv@fn(x)}, crv@domain$lower, crv@domain$upper)$value
})

setGeneric(
  "initialMoment",
  function(crv, rank) {
    standardGeneric("initialMoment")
  }
)

setMethod("initialMoment", signature = c("CRV", "numeric"), definition = function(crv, rank) {
  integrate(function(x) {x ** rank * crv@fn(x)}, crv@domain$lower, crv@domain$upper)$value
})

setGeneric(
  "variance",
  function(crv) {
    standardGeneric("variance")
  }
)

setMethod("variance", signature = c("CRV"), definition = function(crv) {
  centralMoment(crv, 2)
})

# 6.
prepareFunction <- function(fn) {
  function(crv) {
    CRV((function(x) {fn(crv@fn(x))}), crv@domain$lower, crv@domain$upper)
  }
}

# 7.
setMethod("<", signature = c("CRV", "numeric"), definition = function(e1, e2) {
  CrvLogical(e1, "<", e2)
})

setMethod(">", signature = c("CRV", "numeric"), definition = function(e1, e2) {
  CrvLogical(e1, ">", e2)
})

setMethod("==", signature = c("CRV", "numeric"), definition = function(e1, e2) {
  CrvLogical(e1, "==", e2)
})

setGeneric(
  "P",
  function(event) {
    standardGeneric("P")
  }
)

setMethod("P", signature = c("CrvLogical"), definition = function(event) {
  event@value
})

setMethod("&", signature = c("CrvLogical", "CrvLogical"), definition = function(e1, e2) {
  CrvLogical(e1, "&", e2)
})

setMethod("|", signature = c("CrvLogical", "CrvLogical"), definition = function(e1, e2) {
  CrvLogical(e1, "|", e2)
})

# 8.
# Apelat cu functia help(numeRepartitie)

# 11.
marginalByX <- function(fn, x, lower, upper) {integrate(fn, lower, upper, x = x)$value}
marginalByY <- function(fn, y, lower, upper) {integrate(fn, lower, upper, y = y)$value}

