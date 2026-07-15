# Transform the GDRF formulae to fitted value formulae

Transform the GDRF formulae to fitted value formulae

## Usage

``` r
yhat.calculator(
  formulae,
  d.y,
  model,
  the.coef,
  y.vrbl = NULL,
  inferences.y = NULL,
  prediction.values = NULL,
  baseline.y = NULL,
  shock.size = 1
)
```

## Arguments

- formulae:

  the list of formulae from `general.calculator`

- d.y:

  an integer for the order of differencing of the y variable in the ADL
  model

- model:

  the `lm` model containing the model estimates

- the.coef:

  the coefficient vector from the estimated model

- y.vrbl:

  a named vector of the (lagged) y variables and corresponding lag
  orders in the ADL model

- inferences.y:

  whether the inferences for the dependent variable are in levels or
  differences. Must be one of `levels` or `differences`

- prediction.values:

  a named list of values for non-y variables in the model, used to
  calculate a steady-state baseline when `d.y = 0` and `baseline.y` is
  not supplied. If any differenced variables are included in the model,
  they should be set to 0. Ignored when `d.y > 0`

- baseline.y:

  a user-supplied baseline value of y in levels. For `d.y = 0`, this
  overrides the steady-state calculation from `prediction.values`. For
  `d.y > 0` with `inferences.y = "levels"`, this is required. Optional
  uncertainty around this baseline can be supplied through
  `baseline.y.se` in the calling function

- shock.size:

  the size of the shock to x in the units of x. Defaults to 1 (the
  marginal effect)

## Value

a list of `limit` + 1 formula strings containing the fitted value
formula in each period, for evaluation by `deltaMethod` in the calling
function

## Details

`yhat.calculator` does no calculation. It transforms the formulae from
`general.calculator` into fitted value formulae by prepending a baseline
value of y. For `d.y = 0`, the baseline is either a user-supplied value
or a model-implied steady-state prediction, the latter of which
incorporates model-based uncertainty. For `d.y > 0`, the baseline must
be user-supplied through `baseline.y`, as the model in differences
contains no information about the level of y. Optional uncertainty
around a user-supplied baseline can be added through `baseline.y.se`, it
is added as a post-processing step in the calling function

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# ADL model with y in levels
model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

# set up formulae
pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
  y.vrbl = c("l_1_y" = 1), limit = 5)
general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
  limit = 5, pulses = pulses.levels)

# I(0) y: steady state from means (warns about differenced variables)
#  Note this would mean different values for x and l_1_x, which might be undesirable
yhat.calculator(formulae = general.levels$formulae, d.y = 0,
  model = model.levels, the.coef = coef(model.levels),
  y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
  prediction.values = NULL, baseline.y = 0, shock.size = 1)
#> [[1]]
#> [1] "0"
#> 
#> [[2]]
#> [1] "0 + 1 * (x )"
#> 
#> [[3]]
#> [1] "0 + 1 * (l_1_x  +  l_1_y * x )"
#> 
#> [[4]]
#> [1] "0 + 1 * (l_1_y * l_1_x  +  l_1_y**2 * x )"
#> 
#> [[5]]
#> [1] "0 + 1 * (l_1_y**2 * l_1_x  +  l_1_y**3 * x )"
#> 
#> [[6]]
#> [1] "0 + 1 * (l_1_y**3 * l_1_x  +  l_1_y**4 * x )"
#> 
#> [[7]]
#> [1] "0 + 1 * (l_1_y**4 * l_1_x  +  l_1_y**5 * x )"
#> 

# I(0) y: steady state from supplied prediction.values (same values for both x/l_1_x)
yhat.calculator(formulae = general.levels$formulae, d.y = 0,
  model = model.levels, the.coef = coef(model.levels),
  y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
  prediction.values = list("x" = 1, "l_1_x" = 1),
  baseline.y = NULL, shock.size = 1)
#> [[1]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y))"
#> 
#> [[2]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (x )"
#> 
#> [[3]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_x  +  l_1_y * x )"
#> 
#> [[4]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_y * l_1_x  +  l_1_y**2 * x )"
#> 
#> [[5]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_y**2 * l_1_x  +  l_1_y**3 * x )"
#> 
#> [[6]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_y**3 * l_1_x  +  l_1_y**4 * x )"
#> 
#> [[7]]
#> [1] "((Intercept) + 1 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_y**4 * l_1_x  +  l_1_y**5 * x )"
#> 

# I(0) y: user-supplied baseline.y overrides prediction.values
yhat.calculator(formulae = general.levels$formulae, d.y = 0,
  model = model.levels, the.coef = coef(model.levels),
  y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
  prediction.values = list("x" = 0, "l_1_x" = 1),
  baseline.y = 5, shock.size = 1)
#> [[1]]
#> [1] "5"
#> 
#> [[2]]
#> [1] "5 + 1 * (x )"
#> 
#> [[3]]
#> [1] "5 + 1 * (l_1_x  +  l_1_y * x )"
#> 
#> [[4]]
#> [1] "5 + 1 * (l_1_y * l_1_x  +  l_1_y**2 * x )"
#> 
#> [[5]]
#> [1] "5 + 1 * (l_1_y**2 * l_1_x  +  l_1_y**3 * x )"
#> 
#> [[6]]
#> [1] "5 + 1 * (l_1_y**3 * l_1_x  +  l_1_y**4 * x )"
#> 
#> [[7]]
#> [1] "5 + 1 * (l_1_y**4 * l_1_x  +  l_1_y**5 * x )"
#> 

# ADL model with differenced y
model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)

# set up formulae
pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
  y.vrbl = c("l_1_d_y" = 1), limit = 5)
general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
  limit = 5, pulses = pulses.diffs)

if (FALSE) { # \dontrun{
# inferences in differences, baseline.y != 0. warn that this makes no sense (implies the
#  model is always changing) and change baseline.y to 0
yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
  model = model.diffs, the.coef = coef(model.diffs),
  y.vrbl = c("l_1_y" = 1), inferences.y = "differences",
  baseline.y = 3, shock.size = 1)
  
# inferences in differences, shock size of 1: identical to marginal effect (warns)
yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
  model = model.diffs, the.coef = coef(model.diffs),
  y.vrbl = c("l_1_y" = 1), inferences.y = "differences",
  baseline.y = NULL, shock.size = 1)

# inferences in differences, shock size of 2: scales the marginal effect
#  Since we're asking for inferences.y in differences, the baseline will automatically be 0
yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
  model = model.diffs, the.coef = coef(model.diffs),
  y.vrbl = c("l_1_y" = 1), inferences.y = "differences",
  baseline.y = NULL, shock.size = 2)

# inferences in levels with no baseline.y: stops with an error
yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
  model = model.diffs, the.coef = coef(model.diffs),
  y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
  baseline.y = NULL, shock.size = 2)

# inferences in levels with prediction.values but no baseline.y: warns and stops
yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
  model = model.diffs, the.coef = coef(model.diffs),
  y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
  prediction.values = list("x" = 1, "l_1_x" = 1),
  baseline.y = NULL, shock.size = 2)
} # }

# inferences in levels with a supplied baseline
yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
  model = model.diffs, the.coef = coef(model.diffs),
  y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
  prediction.values = list("x" = 1, "l_1_x" = 1),
  baseline.y = 5, shock.size = 2)
#> [[1]]
#> [1] "5"
#> 
#> [[2]]
#> [1] "5 + 2 * (x )"
#> 
#> [[3]]
#> [1] "5 + 2 * (l_1_x  +  l_1_d_y * x  +  x )"
#> 
#> [[4]]
#> [1] "5 + 2 * (l_1_d_y * l_1_x  +  l_1_d_y**2 * x  +  l_1_x  +  l_1_d_y * x  +  x )"
#> 
#> [[5]]
#> [1] "5 + 2 * (l_1_d_y**2 * l_1_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_x  +  l_1_d_y**2 * x  +  l_1_x  +  l_1_d_y * x  +  x )"
#> 
#> [[6]]
#> [1] "5 + 2 * (l_1_d_y**3 * l_1_x  +  l_1_d_y**4 * x  +  l_1_d_y**2 * l_1_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_x  +  l_1_d_y**2 * x  +  l_1_x  +  l_1_d_y * x  +  x )"
#> 
#> [[7]]
#> [1] "5 + 2 * (l_1_d_y**4 * l_1_x  +  l_1_d_y**5 * x  +  l_1_d_y**3 * l_1_x  +  l_1_d_y**4 * x  +  l_1_d_y**2 * l_1_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_x  +  l_1_d_y**2 * x  +  l_1_x  +  l_1_d_y * x  +  x )"
#> 
```
