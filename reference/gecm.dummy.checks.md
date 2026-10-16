# Do consistent dummy checks for functions that use a GECM model

Do consistent dummy checks for functions that use a GECM model

## Usage

``` r
gecm.dummy.checks(
  x.vrbl,
  y.vrbl,
  x.d.vrbl,
  y.d.vrbl,
  x.vrbl.d.x,
  y.vrbl.d.y,
  x.d.vrbl.d.x,
  y.d.vrbl.d.y,
  inferences.x,
  inferences.y,
  the.coef,
  se.type,
  type = NULL
)
```

## Arguments

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

- x.vrbl.d.x:

  an integer describing how many times the independent variable (of the
  lower order of differencing, usually in levels d = 0) was differenced
  before model estimation

- y.vrbl.d.y:

  an integer describing how many times the dependent variable (of the
  lower order of differencing, usually in levels d = 0) was differenced
  before model estimation

- x.d.vrbl.d.x:

  an integer describing how many times the independent variable (of the
  higher order of differencing, usually in first differences d = 1) was
  differenced before model estimation

- y.d.vrbl.d.y:

  an integer describing how many times the dependent variable (of the
  higher order of differencing, usually in first differences d = 1) was
  differenced before model estimation

- inferences.x:

  a character string specifying whether the shock to the independent
  variable is applied in levels or differences. Valid arguments include
  `levels` or `differences`. (For independent variables where `d.x` is
  0, this is automatically `levels`.) The default is `levels`

- inferences.y:

  a character string specifying whether the shock to the independent
  variable is interpreted in levels or differences (of the dependent
  variable). Valid arguments include `levels` or `differences`. (For y
  variables where `d.y` is 0, this is automatically `levels`.) The
  default is `levels`

- the.coef:

  the coefficient vector from the estimated GECM model

- se.type:

  a character string for the type of standard error to extract from the
  model. The default is `const`, but any argument to `vcovHC` from the
  `sandwich` package is accepted

- type:

  a string whether the effects are estimated from a GDRF model or the
  interaction model. For now, just `GDRF`. But we will eventually
  develop `interact.gecm.plot`

## Value

nothing is returned

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
