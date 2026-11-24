# Extract a named coefficient vector from a fitted model object (dispatches to `insight:: get_parameters()` when possible)

Extract a named coefficient vector from a fitted model object
(dispatches to
[`insight:: get_parameters()`](https://easystats.github.io/insight/reference/get_parameters.html)
when possible)

## Usage

``` r
get.model.coef(model, model.info = NULL, coef. = NULL)

# S3 method for class 'dynardl'
get.model.coef(model, model.info = NULL, coef. = NULL)

# Default S3 method
get.model.coef(model, model.info = NULL, coef. = NULL)
```

## Arguments

- model:

  a fitted model object

- model.info:

  a named list as returned by `check.model.class`

- coef.:

  an optional named numeric vector of coefficients to use directly, if
  evaluating effects from a model not supported by
  [`insight::get_parameters()`](https://easystats.github.io/insight/reference/get_parameters.html)

## Value

a named numeric vector of model coefficients, with names matching the
parameter names of the model as they appear in the model formula

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
