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
  inferences.y,
  type = NULL
)
```

## Arguments

- effect.type:

  a character string indicating whether to return discrete effects or
  fitted values. `discrete` returns the GDRF as a discrete effect
  estimate. `fitted` returns the GDRF as a fitted value, relative to a
  baseline value of the dependent variable. The default is `discrete`

- prediction.values:

  a named list of values for non-y variables in the model, used to
  calculate a steady-state baseline of the dependent variable when
  `effect.type = "fitted"` and `d.y = 0` and `baseline.y` is not
  supplied. Model-based uncertainty will be calculated around the
  formula for this value. If any differenced variables are included in
  the model, they should be set to 0. If multiple lags of the same
  variable are included, they should be set to the same value. Ignored
  when `d.y > 0`

- baseline.y:

  a numeric value for the user-supplied baseline value of y in levels
  (i.e. the baseline value for effects to accumulate from). Only used
  when `effect.type = "fitted"`. For `d.y = 0`, this overrides the
  steady-state calculation from `prediction.values` if provided

- baseline.y.se:

  a numeric value for the user-supplied standard error for the baseline
  value of y (to suggest uncertainty around predictions). Only used when
  `effect.type = "fitted"` and `inferences.y = "levels"`. If supplied,
  this is added in quadrature to the standard errors of the GDRF
  estimates. The default is 0: in recognition that this is
  user-constructed uncertainty. Possible values would be the square root
  of the standard deviation of y (in levels)

- shock.size:

  a numeric value for the size of the shock to x in the units of x.
  Defaults to 1 (a discrete effect similar to traditional marginal
  effects)

- d.y:

  an integer describing how many times the dependent variable was
  differenced before model estimation

- inferences.y:

  a character string specifying whether the shock to the independent
  variable is interpreted in levels or differences (of the dependent
  variable). Valid arguments include `levels` or `differences`. (For y
  variables where `d.y` is 0, this is automatically `levels`.) The
  default is `levels`

- type:

  a character string whether the effects are estimated from a GDRF model
  or the interaction model. Accepts either `GDRF` or `interact`

## Value

nothing is returned

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
