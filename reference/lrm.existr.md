# Handle LRM existence check

Handle LRM existence check

## Usage

``` r
lrm.existr(
  shock.history,
  h.order,
  cumulative,
  calc.d.x,
  calc.d.y,
  effect.type,
  return.LRM
)
```

## Arguments

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

- h.order:

  the converted integer shock history order (from the shock.history
  conversion step), if it exists

- cumulative:

  logical for whether the user wants cumulative effects

- calc.d.x:

  the numeric order of differencing of x used in calculation (after
  inferences.x adjustment)

- calc.d.y:

  the numeric order of differencing of y used in calculation (after
  inferences.y adjustment)

- effect.type:

  a character string indicating whether to return discrete effects or
  fitted values. `discrete` returns the GDRF as a discrete effect
  estimate. `fitted` returns the GDRF as a fitted value, relative to a
  baseline value of the dependent variable. The default is `discrete`

- return.LRM:

  logical for whether the user wants the LRM returned

## Value

logical for whether a LRM exists to calculate

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
