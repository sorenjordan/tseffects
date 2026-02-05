# Generate the generalized effect formulae for an autoregressive distributed lag (ADL) model, given pulse effects and shock/treatment history

Generate the generalized effect formulae for an autoregressive
distributed lag (ADL) model, given pulse effects and shock/treatment
history

## Usage

``` r
general.calculator(d.x, d.y, h, limit, pulses)
```

## Arguments

- d.x:

  the order of differencing of the x variable in the ADL model.
  (Generally, this is the same x variable used in `pulse.calculator`)

- d.y:

  the order of differencing of the y variable in the ADL model.
  (Generally, this is the same y variable used in `pulse.calculator`)

- h:

  an integer for the shock/treatment history. `h` determines the
  counterfactual series that will be applied to the independent
  variable. -1 represents a pulse. 0 represents a step. For others, see
  Vande Kamp, Jordan, and Rajan

- limit:

  an integer for the number of periods (s) to determine the generalized
  effect (beginning at 0)

- pulses:

  a list of pulse effect formulae used to construct the generalized
  effect formulae. We expect this will be provided by `pulse.calculator`

## Value

a list of `limit` + 1 `mpoly` formulae containing the generalized effect
formula in each period

## Details

`general.calculator` does no calculation. It generates a list of `mpoly`
formulae that contain variable names that represent the generalized
effect in each period. The expectation is that these will be evaluated
using coefficients from an object containing an ADL model with
corresponding variables. Note: `mpoly` does not allow variable names
with a .; variables passed to `general.calculator` should not include
this character

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# ADL(1,1)
x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
y.lags <- c("l_1_y" = 1)
s <- 5
pulse.effects <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
# Assume that both x and y are in levels and we want a pulse treatment
general.pulse.effects <- general.calculator(d.x = 0, d.y = 0, 
              h = -1, limit = s, pulses = pulse.effects)
general.pulse.effects
#> $formulae
#> $formulae[[1]]
#> [1] "x "
#> 
#> $formulae[[2]]
#> [1] "l_1_x  +  l_1_y * x "
#> 
#> $formulae[[3]]
#> [1] "l_1_y * l_1_x  +  l_1_y**2 * x "
#> 
#> $formulae[[4]]
#> [1] "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
#> 
#> $formulae[[5]]
#> [1] "l_1_y**3 * l_1_x  +  l_1_y**4 * x "
#> 
#> $formulae[[6]]
#> [1] "l_1_y**4 * l_1_x  +  l_1_y**5 * x "
#> 
#> 
#> $binomials
#> $binomials[[1]]
#> [1] 1
#> 
#> $binomials[[2]]
#> [1] 1 0
#> 
#> $binomials[[3]]
#> [1] 1 0 0
#> 
#> $binomials[[4]]
#> [1] 1 0 0 0
#> 
#> $binomials[[5]]
#> [1] 1 0 0 0 0
#> 
#> $binomials[[6]]
#> [1] 1 0 0 0 0 0
#> 
#> 
# Apply a step treatment
general.step.effects <- general.calculator(d.x = 0, d.y = 0, 
              h = 0, limit = s, pulses = pulse.effects)
general.step.effects
#> $formulae
#> $formulae[[1]]
#> [1] "x "
#> 
#> $formulae[[2]]
#> [1] "l_1_x  +  l_1_y * x  +  x "
#> 
#> $formulae[[3]]
#> [1] "l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
#> 
#> $formulae[[4]]
#> [1] "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
#> 
#> $formulae[[5]]
#> [1] "l_1_y**3 * l_1_x  +  l_1_y**4 * x  +  l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
#> 
#> $formulae[[6]]
#> [1] "l_1_y**4 * l_1_x  +  l_1_y**5 * x  +  l_1_y**3 * l_1_x  +  l_1_y**4 * x  +  l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
#> 
#> 
#> $binomials
#> $binomials[[1]]
#> [1] 1
#> 
#> $binomials[[2]]
#> [1] 1 1
#> 
#> $binomials[[3]]
#> [1] 1 1 1
#> 
#> $binomials[[4]]
#> [1] 1 1 1 1
#> 
#> $binomials[[5]]
#> [1] 1 1 1 1 1
#> 
#> $binomials[[6]]
#> [1] 1 1 1 1 1 1
#> 
#> 
```
