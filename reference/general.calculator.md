# Generate the generalized (im)pulse formulae for a dynamic linear model

Generate the generalized (im)pulse effect formulae for an autoregressive
distributed lag (ADL) model, given pulse effects and shock history. Take
the period-specific impulse response functions (presumably pulses from
pulse.calculator or convolution.calculator) and generalize them
according to a shock history h and order of differencing of the
independent and/or dependent variable

## Usage

``` r
general.calculator(d.x, d.y, h, limit, pulses)
```

## Arguments

- d.x:

  an integer determining the order of differencing of the x variable
  before a shock is applied when parametrized as an ADL model.
  (Generally, this is the same x variable used in `pulse.calculator`)

- d.y:

  an integer determining the order of differencing of the y variable
  when parametrized as an ADL model. (Generally, this is the same y
  variable used in `pulse.calculator`)

- h:

  an integer determining the shock history applied to the independent
  variable in levels. -1 represents the Impulse Response Function. 0
  represents a Step Response Function. For others, see Vande Kamp,
  Jordan, and Rajan

- limit:

  an integer for the number of periods (s) to determine the generalized
  effect (beginning at 0)

- pulses:

  a list comprising the formulae for Impulse Response Functions,
  typically generated using `pulse.calculator`

## Value

a list with two elements: `limit` + 1 `mpoly` formulae containing the
generalized effect formula (for calculating the GDRF) in each period
(under `formulae`) as well as the actual shock history (under `shocks`)

## Details

`general.calculator` does no calculation. It generates a list of `mpoly`
formulae that contain variable names that represent the generalized
effect in each period. The expectation is that these will be evaluated
using coefficients from an object containing an ADL model with
corresponding variables. Note: avoid passing characters not allowed by
`mpoly`

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# ADL(1,1)
x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
y.lags <- c("l_1_y" = 1)
s <- 5
pulse.effects <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
# Assume that both x and y are in levels and we want a pulse shock history
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
#> $shocks
#> $shocks[[1]]
#> [1] 1
#> 
#> $shocks[[2]]
#> [1] 1 0
#> 
#> $shocks[[3]]
#> [1] 1 0 0
#> 
#> $shocks[[4]]
#> [1] 1 0 0 0
#> 
#> $shocks[[5]]
#> [1] 1 0 0 0 0
#> 
#> $shocks[[6]]
#> [1] 1 0 0 0 0 0
#> 
#> 
# Apply a step shock response function
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
#> $shocks
#> $shocks[[1]]
#> [1] 1
#> 
#> $shocks[[2]]
#> [1] 1 1
#> 
#> $shocks[[3]]
#> [1] 1 1 1
#> 
#> $shocks[[4]]
#> [1] 1 1 1 1
#> 
#> $shocks[[5]]
#> [1] 1 1 1 1 1
#> 
#> $shocks[[6]]
#> [1] 1 1 1 1 1 1
#> 
#> 
```
