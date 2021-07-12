library(ContinuousRV)

fn <- function(x) {x}

# 1.
# Returns 2
findNormalizationConstant(fn, 0, 1)

# Returns NaN
findNormalizationConstant(fn, -Inf, Inf)

# 2.
# Functia originala nu este normalizata
isPDF(fn, 0, 1)
# Functia este automat normalizata in constructorul lui CRV
isPDF(crv@fn, 0, 1)

# 4.
# Create a new CRV object
crv <- CRV(function(x) {x}, 0, 1)

# Returns 0.25
CDF(crv, 0.5)

# Plots both the PDF graph and the CDF graph
plot(crv)

# 5.
# Returns 0.666...
mean(crv)

# Returns 0.055...
variance(crv)

# Returns 1
centralMoment(crv, 0)
# Returns approx 0
centralMoment(crv, 1)
# Returns 0.055...
centralMoment(crv, 2)
# Returns -0.007407407...
centralMoment(crv, 3)
# Returns 0.007407407...
centralMoment(crv, 4)

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

# 6.
# Prepare the passed function to be used with CRVs
g <- prepareFunction(function(x) {x^2})

# Returns 0.75
mean(g(crv))
# Returns 0.0375
variance(g(crv))

# Create the simplest function to check the validity of results
X <- CRV(Vectorize(function(x) {1}), 0, 1)

# 7.
# Returns 0.1
P(X > 0.9)
# Returns 0.7
P(X < 0.7)

# Returns 0.8
P(X < 0.7 | X > 0.9)
# Returns 0.2
P(X > 0.7 & X < 0.9)

# Returns 0.53
P(X > 0.97 | X < 0.5)
# Returns 1
P(X < 0.97 | X > 0.5)

# 11.
# Create a joint PDF
pdfComun <- function(x, y) {3/8*(x+2*y)^2}

# Returns 1.625
marginalByX(pdfComun, 1, 0, 1)

# Returns 2.375
marginalByY(pdfComun, 1, 0, 1)
