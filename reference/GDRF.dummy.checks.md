# Do consistent dummy checks for GDRF functions that might take fitted values

Do consistent dummy checks for GDRF functions that might take fitted
values

## Usage

``` r
GDRF.dummy.checks(
  effect.type,
  prediction.values,
  baseline.y,
  baseline.y.se,
  shock.size,
  d.y,
  inferences.y
)
```

## Arguments

- effect.type:

  whether to return marginal effects or fitted values. `marginal`
  returns the GDRF as a marginal effect. `fitted` returns the GDRF as a
  fitted value, relative to a baseline value of y. The default is
  `marginal`

- prediction.values:

  a named list of values for non-y variables in the model, used to
  calculate a steady-state baseline when `effect.type = "fitted"` and
  `d.y = 0` and `baseline.y` is not supplied. This allows for the
  calculation of model-based uncertainty. If any differenced variables
  are included in the model, they should be set to 0. Ignored when
  `d.y > 0`

- baseline.y:

  a user-supplied baseline value of y in levels. For `d.y = 0`, this
  overrides the steady-state calculation from `prediction.values` if
  provided. For `d.y > 0` with `inferences.y = "levels"`, this is
  required (otherwise it is just marginal effects). Only used when
  `effect.type = "fitted"`

- baseline.y.se:

  a user-supplied standard error for the baseline value of y (to suggest
  uncertainty around predictions). If supplied, this is added in
  quadrature to the standard errors of the GDRF estimates. Only used
  when `effect.type = "fitted"` and `inferences.y = "levels"`. The
  default is 0: in recognition that this is user-constructed
  uncertainty. Possible values would be the square root of the standard
  deviation of y (in levels)

- shock.size:

  the size of the shock to x in the units of x. Only used when
  `effect.type = "fitted"`; marginal effects are not scaled. Defaults to
  1 (a marginal effect)

- d.y:

  the order of differencing of the y variable in the ADL model

- inferences.y:

  does the user want resulting inferences about the dependent variable
  in levels or in differences? (For y variables where `d.y` is 0, this
  is automatically levels.) The default is `levels`

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
