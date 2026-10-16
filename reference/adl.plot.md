# Evaluate and/or plot the General Dynamic Response Function (GDRF) for an ADL assumed in levels

Evaluate (and possibly plot) the General Dynamic Response Function
(GDRF) for an autoregressive distributed lag (ADL) model, making use of
the GDRF framework (described below and in Vande Kamp, Jordan, and
Rajan), assuming the underlying model is in levels (`d.x` = `d.y` = 0)
and the user wants a discrete effect (the untransformed GDRF) with a
shock size of 1. (This is just a wrapper for `GDRF.adl.plot` with
simplifying assumptions)

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
`TRUE`, `adl.plot` will return just the requested output. If more than
one is selected (or just `return.data` is selected), it will return a
list with elements `plot` (for the plot), `estimates` (for the data),
and `formulae` and `shocks` for the GDRF formula for each period as well
as the applied shock history in integer form

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
#> Warning: return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned

```
