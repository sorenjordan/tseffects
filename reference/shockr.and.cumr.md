# Check shock.histories and assign words describing h to integers, if applicable, and cumulative sum them, if required

Check shock.histories and assign words describing h to integers, if
applicable, and cumulative sum them, if required

## Usage

``` r
shockr.and.cumr(shock.history, s.limit, cumulative)
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

- s.limit:

  an integer for the number of periods to determine the GDRF (beginning
  at s = 0)

- cumulative:

  logical to return the cumulative effects or the period-specific
  effects of the given `shock.history`. For instance, to obtain the
  Cumulative Impulse Response Function, set `shock.history` to -1 and
  `cumulative = TRUE`. The default is `FALSE`

## Value

a list of the relevant `h.order`/`h.order.plot` (if the shock.history
was an integer) or the transformed `shock.history`

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
