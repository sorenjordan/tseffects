# Extract the model frame from a fitted model object (dispatches to `insight::get_data()` when possible)

Extract the model frame from a fitted model object (dispatches to
[`insight::get_data()`](https://easystats.github.io/insight/reference/get_data.html)
when possible)

## Usage

``` r
get.model.data(model, model.info = NULL, data. = NULL)

# S3 method for class 'dynardl'
get.model.data(model, model.info = NULL, data. = NULL)

# Default S3 method
get.model.data(model, model.info = NULL, data. = NULL)
```

## Arguments

- model:

  a fitted model object

- model.info:

  a named list as returned by `check.model.class`

- data.:

  an optional data frame to use directly, if evaluating effects from a
  model not supported by
  [`insight::get_modelmatrix()`](https://easystats.github.io/insight/reference/get_modelmatrix.html)
  If `NULL`, `check.model.class` is called internally

## Value

a data frame containing the data used to fit the model, with named
columns matching the variable names of the model

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
