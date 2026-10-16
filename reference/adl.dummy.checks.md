# Do consistent dummy checks for functions that use an ADL model

Do consistent dummy checks for functions that use an ADL model

## Usage

``` r
adl.dummy.checks(
  x.vrbl,
  y.vrbl,
  z.vrbl,
  x.z.vrbl,
  d.x,
  d.y,
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
  variable and its lags and the numbers correspond to the specific lag
  order of each variable

- y.vrbl:

  a named numeric vector in which the names correspond to lags of the
  dependent variable and the numbers correspond to the specific lag
  order of each variable. Can be `NULL` if the model has no lagged
  dependent variables

- d.x:

  an integer describing how many times the independent variable was
  differenced before model estimation

- d.y:

  an integer describing how many times the dependent variable was
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

  the coefficient vector from the estimated ADL model

- se.type:

  a character string for the type of standard error to extract from the
  model. The default is `const`, but any argument to `vcovHC` from the
  `sandwich` package is accepted

- type:

  a string whether the effects are estimated from a GDRF model or the
  interaction model. Accepts either `GDRF` or `interact`

## Value

nothing is returned

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
