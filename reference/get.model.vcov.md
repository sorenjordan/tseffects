# Extract a variance-covariance matrix from a fitted model object (dispatches to `insight::get_varcov()` when possible)

Extract a variance-covariance matrix from a fitted model object
(dispatches to
[`insight::get_varcov()`](https://easystats.github.io/insight/reference/get_varcov.html)
when possible)

## Usage

``` r
get.model.vcov(model, model.info, se.type = "const", vcov. = NULL)

# S3 method for class 'dynardl'
get.model.vcov(model, model.info = NULL, se.type = "const", vcov. = NULL)

# Default S3 method
get.model.vcov(model, model.info = NULL, se.type = "const", vcov. = NULL)
```

## Arguments

- model:

  a fitted model object

- model.info:

  a named list as returned by `check.model.class`

- se.type:

  a character string for the type of standard error to extract from the
  model; must be accepted by
  [`insight::get_varcov()`](https://easystats.github.io/insight/reference/get_varcov.html).
  This includes arguments to `vcovHC` from the `sandwich` package (for
  instance: `HC0` is White's heteroskedasticity-consistent robust
  standard errors). Default is classic standard errors

- vcov.:

  an optional pre-computed variance-covariance matrix to use directly,
  if evaluating effects from a model not supported by
  `insight::get_vcov()`

## Value

a named numeric matrix of variances and covariances, with row and column
names matching the coefficient names of the model

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
