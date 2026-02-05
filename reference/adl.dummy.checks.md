# Do consistent dummy checks for functions (GDTE/GDRF) that use an ADL model

Do consistent dummy checks for functions (GDTE/GDRF) that use an ADL
model

## Usage

``` r
adl.dummy.checks(
  x.vrbl,
  y.vrbl,
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

  a named vector of the x variables and corresponding lag orders in an
  ADL model

- y.vrbl:

  a named vector of the y variables and corresponding lag orders in an
  ADL model

- d.x:

  the order of differencing of the x variable in the ADL model

- d.y:

  the order of differencing of the y variable in the ADL model

- inferences.x:

  is the independent variable treated in levels or in differences?

- inferences.y:

  are the inferences for the dependent variable expected in levels or in
  differences?

- the.coef:

  the coefficient vector from the estimated ADL model

- se.type:

  the type of standard error calculated

- type:

  whether the effects are estimated in the context of a GDTE/GDRF

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
