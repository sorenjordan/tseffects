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

  a named vector of the x variables and corresponding lag orders of
  lower order of integration (typically levels, 0) in a GECM model

- y.vrbl:

  a named vector of the y variables and corresponding lag orders of
  lower order of integration (typically levels, 0) in a GECM model

- x.d.vrbl:

  a named vector of the x variables and corresponding lag orders of
  higher order of integration (typically first differences, 1) in a GECM
  model

- y.d.vrbl:

  a named vector of the y variables and corresponding lag orders of
  higher order of integration (typically first differences, 1) in a GECM
  model

- x.vrbl.d.x:

  the order of differencing of the x variable of lower order of
  integration (typically levels, 0) in a GECM model

- y.vrbl.d.y:

  the order of differencing of the y variable of lower order of
  integration (typically levels, 0) in a GECM model

- x.d.vrbl.d.x:

  the order of differencing of the x variable of higher order of
  integration (typically first differences, 1) in a GECM model

- y.d.vrbl.d.y:

  the order of differencing of the y variable of higher order of
  integration (typically first differences, 1) in a GECM model

- inferences.x:

  is the independent variable treated in levels or in differences?

- inferences.y:

  are the inferences for the dependent variable expected in levels or in
  differences?

- the.coef:

  the coefficient vector from the estimated GECM model

- se.type:

  the type of standard error calculated

- type:

  whether the effects are estimated in the context of a GDRF

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
