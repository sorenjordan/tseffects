# Evaluate and/or plot the General Dynamic Response Function (GDRF) for a GECM

Evaluate (and possibly plot) the General Dynamic Response Function
(GDRF) for a Generalized Error Correction Model (GECM), making use of
the GDRF framework (described below and in Vande Kamp, Jordan, and
Rajan)

## Usage

``` r
GDRF.gecm.plot(
  model = NULL,
  x.vrbl = NULL,
  y.vrbl = NULL,
  x.vrbl.d.x = NULL,
  y.vrbl.d.y = NULL,
  x.d.vrbl = NULL,
  y.d.vrbl = NULL,
  x.d.vrbl.d.x = NULL,
  y.d.vrbl.d.y = NULL,
  shock.history = "pulse",
  inferences.y = "levels",
  inferences.x = "levels",
  effect.type = "discrete",
  cumulative = FALSE,
  prediction.values = NULL,
  baseline.y = NULL,
  baseline.y.se = 0,
  shock.size = 1,
  dM.level = 0.95,
  s.limit = 20,
  se.type = "const",
  return.LRM = TRUE,
  return.data = FALSE,
  return.plot = TRUE,
  return.formulae = FALSE,
  ...
)
```

## Arguments

- model:

  the `lm` model containing the GECM estimates

- x.vrbl:

  a named numeric vector in which the names correspond to an independent
  variable and its lags (of the lower order of differencing, usually in
  levels d = 0) and the numbers correspond to the specific lag order of
  each variable

- y.vrbl:

  a named numeric vector in which the names correspond to lags of the
  dependent variable (of the lower order of differencing, usually in
  levels d = 0) and the numbers correspond to the specific lag order of
  each variable

- x.vrbl.d.x:

  an integer describing how many times the independent variable (of the
  lower order of differencing, usually in levels d = 0) was differenced
  before model estimation

- y.vrbl.d.y:

  an integer describing how many times the dependent variable (of the
  lower order of differencing, usually in levels d = 0) was differenced
  before model estimation

- x.d.vrbl:

  a named numeric vector in which the names correspond to an independent
  variable and its lags (of the higher order of differencing, usually in
  first differences d = 1) and the numbers correspond to the specific
  lag order of each variable

- y.d.vrbl:

  a named numeric vector in which the names correspond to lags of the
  dependent variable (of the higher order of differencing, usually in
  first differences d = 1) and the numbers correspond to the specific
  lag order of each variable

- x.d.vrbl.d.x:

  an integer describing how many times the independent variable (of the
  higher order of differencing, usually in first differences d = 1) was
  differenced before model estimation

- y.d.vrbl.d.y:

  an integer describing how many times the dependent variable (of the
  higher order of differencing, usually in first differences d = 1) was
  differenced before model estimation

- shock.history:

  either a character string, integer, or numeric vector for the desired
  shock history. `shock.history` determines the shock history (h) that
  will be applied to the independent variable. Vande Kamp, Jordan, and
  Rajan express this as the parameter h (an integer). -1 represents the
  Impulse Response Function; the equivalent string is `pulse` or
  `impulse`. 0 represents the Step Response Function; the equivalent
  string is `step`. For others, see Vande Kamp, Jordan, and Rajan.
  However, since any shock history can be decomposed into a series of
  dated Impulse Response Functions, users can also supply any numeric
  vector of the same length as s.limit + 1. The default is `pulse`

- inferences.y:

  a character string specifying whether the shock to the independent
  variable is interpreted in levels or differences (of the dependent
  variable). Valid arguments include `levels` or `differences`. (For y
  variables where `d.y` is 0, this is automatically `levels`.) The
  default is `levels`

- inferences.x:

  a character string specifying whether the shock to the independent
  variable is applied in levels or differences. Valid arguments include
  `levels` or `differences`. (For independent variables where `d.x` is
  0, this is automatically `levels`.) The default is `levels`

- effect.type:

  a character string indicating whether to return discrete effects or
  fitted values. `discrete` returns the GDRF as a discrete effect
  estimate. `fitted` returns the GDRF as a fitted value, relative to a
  baseline value of the dependent variable. The default is `discrete`

- cumulative:

  logical to return the cumulative effects or the period-specific
  effects of the given `shock.history`. For instance, to obtain the
  Cumulative Impulse Response Function, set `shock.history` to -1 and
  `cumulative = TRUE`. The default is `FALSE`

- prediction.values:

  a named list of values for non-y variables in the model, used to
  calculate a steady-state baseline of the dependent variable when
  `effect.type = "fitted"` and `y.vrbl.d.y = 0` and `baseline.y` is not
  supplied. Model-based uncertainty will be calculated around the
  formula for this value. If any differenced variables are included in
  the model, they should be set to 0. If multiple lags of the same
  variable are included, they should be set to the same value. Ignored
  when `y.vrbl.d.y > 0`

- baseline.y:

  a numeric value for the user-supplied baseline value of y in levels
  (i.e. the baseline value for effects to accumulate from). Only used
  when `effect.type = "fitted"`. For `y.vrbl.d.y = 0`, this overrides
  the steady-state calculation from `prediction.values` if provided

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

- dM.level:

  a numeric value for the significance level of the GDRF, calculated by
  the delta method. The default is 0.95

- s.limit:

  an integer for the number of periods to determine the GDRF (beginning
  at s = 0)

- se.type:

  a character string for the type of standard error to extract from the
  model. The default is `const`, but any argument to `vcovHC` from the
  `sandwich` package is accepted

- return.LRM:

  logical to return the LRM in the estimates and plots, should the LRM
  exist for that combination of `shock.history` and `cumulative`. The
  default is `TRUE`

- return.data:

  logical to return the raw calculated GDRFs as a list element under
  `estimates`. The default is `FALSE`

- return.plot:

  logical to return the visualized GDRFs as a list element under `plot`.
  The default is `TRUE`

- return.formulae:

  logical to return the formulae for the GDRFs as a list element under
  `formulae` (for the GDRFs) and `shocks` (for the shock history). The
  default is `FALSE`

- ...:

  other arguments to be passed to the call to plot

## Value

if just one of `return.data`, `return.plot`, and `return.formulae` is
`TRUE`, `GDRF.gecm.plot` will return just the requested output. If more
than one is selected (or just `return.data` is selected), it will return
a list with elements `plot` (for the plot), `estimates` (for the data),
and `formulae` and `shocks` for the GDRF formula for each period as well
as the applied shock history in integer form

## Details

Internally, GDRF.gecm.plot uses the subfunction `gecm.to.adl` to convert
the GECM coefficients to ADL coefficients before calculating the GDRF.
From there, it uses the separate subfunctions `pulse.calculator`,
`convolution.calculator`/`general.calculator`, and (possibly)
`yhat.calculator` to generate the effect estimates representing the
GDRF. The shock history is determined by `shock.history`. For more
information, see Vande Kamp, Jordan, and Rajan. We assume that the GECM
estimated is well specified, free of residual autocorrelation, balanced,
and meets other standard time-series qualities

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# GECM(1,1)
# Use the toy data to run a GECM. No argument is made this 
#  is well specified or even sensible; it is just expository
model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
test.pulse <- GDRF.gecm.plot(model = model,
                                  x.vrbl = c("l_1_x" = 1), 
                                  y.vrbl = c("l_1_y" = 1),
                                  x.vrbl.d.x = 0, 
                                  y.vrbl.d.y = 0,
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  x.d.vrbl.d.x = 1,
                                  y.d.vrbl.d.y = 1,
                                  shock.history = "pulse", 
                                  inferences.y = "levels", 
                                  inferences.x = "levels",
                                  s.limit = 10, 
                                  return.plot = TRUE, 
                                  return.formulae = TRUE)
#> Warning: return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned
names(test.pulse)
#> [1] "plot"     "formulae" "shocks"  
```
