# Find starting values for predicted values plots from the data in the model frame, if not supplied

Find starting values for predicted values plots from the data in the
model frame, if not supplied

## Usage

``` r
get.value(var, prediction.values, model)
```

## Arguments

- var:

  a string for var the variable to establish a prediction value for

- prediction.values:

  a named list of values for non-y variables in the model, used to
  calculate a steady-state baseline of the dependent variable when
  `effect.type = "fitted"` and `d.y = 0` and `baseline.y` is not
  supplied. Model-based uncertainty will be calculated around the
  formula for this value. If any differenced variables are included in
  the model, they should be set to 0. If multiple lags of the same
  variable are included, they should be set to the same value. Ignored
  when `d.y > 0`

- model:

  the model containing the dataframe for mean estimation if values are
  not user-supplied (and warn the user if we're taking the mean)

## Value

the numeric value of the relevant variable

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
