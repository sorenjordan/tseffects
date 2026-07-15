# Evaluate (and possibly plot) the General Dynamic Response Function (GDRF) for an autoregressive distributed lag (ADL) model, assuming the underlying model is in levels (`d.x` = `d.y` = 0) and the user wants a marginal effect (the untransformed GDRF). (This is just a wrapper for `GDRF.adl.plot` with simplifying assumptions)

Evaluate (and possibly plot) the General Dynamic Response Function
(GDRF) for an autoregressive distributed lag (ADL) model, assuming the
underlying model is in levels (`d.x` = `d.y` = 0) and the user wants a
marginal effect (the untransformed GDRF). (This is just a wrapper for
`GDRF.adl.plot` with simplifying assumptions)

## Usage

``` r
adl.plot(
  model = NULL,
  x.vrbl = NULL,
  y.vrbl = NULL,
  shock.history = "pulse",
  dM.level = 0.95,
  s.limit = 20,
  se.type = "const",
  return.data = FALSE,
  return.plot = TRUE,
  return.formulae = FALSE,
  ...
)
```

## Arguments

- model:

  the `lm` model containing the ADL estimates

- x.vrbl:

  a named numeric vector in which the names correspond to an independent
  variable and its lags and the numbers correspond to the specific lag
  order of each variable

- y.vrbl:

  a named numeric vector in which the names correspond to lags of the
  dependent variable and the numbers correspond to the specific lag
  order of each variable. Can be `NULL` if the model has no lagged
  dependent variables

- shock.history:

  the desired shock history. `shock.history` determines the shock
  history (h) (which can be expressed as an integer) that will be
  applied to the independent variable. -1 represents a pulse (Impulse
  Response Function). 0 represents a step (Step Response Function).
  These can also be specified via `pulse` and `step`. For others, see
  Vande Kamp, Jordan, and Rajan. The default is `pulse`

- dM.level:

  a numeric significance level of the GDRF, calculated by the delta
  method. The default is 0.95

- s.limit:

  an integer for the number of periods to determine the GDRF (beginning
  at s = 0)

- se.type:

  a string for the type of standard error to extract from the model. The
  default is `const`, but any argument to `vcovHC` from the `sandwich`
  package is accepted

- return.data:

  logical to return the raw calculated GDRFs as a list element under
  `estimates`. The default is `FALSE`

- return.plot:

  logical to return the visualized GDRFs as a list element under `plot`.
  The default is `TRUE`

- return.formulae:

  logical to return the formulae for the GDRFs as a list element under
  `formulae` (for the GDRFs) and `binomials` (for the shock history).
  The default is `FALSE`

- ...:

  other arguments to be passed to the call to plot

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r

# ADL(1,1)
# Use the toy data to run an ADL. No argument is made this is well specified; it is just expository
model.toydata <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

# Since this is in levels, we can quickly look at the adl.plot
#  Pulse effect of x
adl.plot(model = model.toydata,
  x.vrbl = c("x" = 0, "l_1_x" = 1),
  y.vrbl = c("l_1_y" = 1),
  shock.history = "pulse",
  s.limit = 20)

```
