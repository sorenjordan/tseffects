# Evaluate and/or plot the General Dynamic Response Function (GDRF) for a GECM assumed in levels/first differences

Evaluate (and possibly plot) the General Dynamic Response Function
(GDRF) for a GECM(1,1), making use of the GDRF framework (described
below and in Vande Kamp, Jordan, and Rajan), assuming the underlying
model is in first differences (`x.vrbl.d.x` = `y.vrbl.d.y` = 0 and
`x.d.vrbl.d.x` = `y.d.vrbl.d.y` = 1), the user wants a discrete effect
(the untransformed GDRF) and inferences about y in levels to a shock
applied to x in levels, with a shock size of 1. (This is just a wrapper
for `GDRF.gecm.plot` with simplifying assumptions)

## Usage

``` r
gecm.plot(
  model = NULL,
  x.vrbl = NULL,
  y.vrbl = NULL,
  x.d.vrbl = NULL,
  y.d.vrbl = NULL,
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

  the `lm` model containing the GECM estimates

- x.vrbl:

  a named numeric vector in which the names correspond to an independent
  variable and its lags (of the lower order of differencing, in levels d
  = 0) and the numbers correspond to the specific lag order of each
  variable

- y.vrbl:

  a named numeric vector in which the names correspond to lags of the
  dependent variable (of the lower order of differencing, in levels d
  = 0) and the numbers correspond to the specific lag order of each
  variable

- x.d.vrbl:

  a named numeric vector in which the names correspond to an independent
  variable and its lags (of the higher order of differencing, in first
  differences d = 1) and the numbers correspond to the specific lag
  order of each variable

- y.d.vrbl:

  a named numeric vector in which the names correspond to lags of the
  dependent variable (of the higher order of differencing, in first
  differences d = 1) and the numbers correspond to the specific lag
  order of each variable

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
`TRUE`, `gecm.plot` will return just the requested output. If more than
one is selected (or just `return.data` is selected), it will return a
list with elements `plot` (for the plot), `estimates` (for the data),
and `formulae` and `shocks` for the GDRF formula for each period as well
as the applied shock history in integer form

## Details

We assume that the GECM model estimated is well specified, free of
residual autocorrelation, balanced, and meets other standard time-series
qualities. Given that, to obtain inferences for the specified shock
history, the user only needs a named vector of the x and y variables, as
well as the order of the differencing. Internally, the GECM to ADL
equivalences are used to calculate the GDRFs from the GECM

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# GECM(1,1). So we can use gecm.plot to quickly check dynamics
# Use the toy data to run a GECM. No argument is made this 
#  is well specified or even sensible; it is just expository
model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
test.pulse <- gecm.plot(model = model,
                                  x.vrbl = c("l_1_x" = 1), 
                                  y.vrbl = c("l_1_y" = 1),
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  shock.history = "pulse", 
                                  s.limit = 10, 
                                  return.plot = TRUE, 
                                  return.formulae = TRUE)
#> Warning: return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned
names(test.pulse)
#> [1] "plot"     "formulae" "shocks"  
```
