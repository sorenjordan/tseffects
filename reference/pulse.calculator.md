# Generate pulse effect formulae for a given autoregressive distributed lag (ADL) model

Generate pulse effect formulae for a given autoregressive distributed
lag (ADL) model

## Usage

``` r
pulse.calculator(x.vrbl, y.vrbl = NULL, limit)
```

## Arguments

- x.vrbl:

  a named vector of the x variables and corresponding lag orders in an
  ADL model

- y.vrbl:

  a named vector of the (lagged) y variables and corresponding lag
  orders in an ADL model

- limit:

  an integer for the number of periods (s) to determine the pulse effect
  (beginning at 0)

## Value

a list of limit + 1 `mpoly` formulae containing the pulse effect formula
in each period

## Details

`pulse.calculator` does no calculation. It generates a list of `mpoly`
formulae that contain variable names that represent the pulse effect in
each period. The expectation is that these will be evaluated using
coefficients from an object containing an ADL model with corresponding
variables. Note: `mpoly` does not allow variable names with a .;
variables passed to `pulse.calculator` should not include this character

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# ADL(1,1)
x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
y.lags <- c("l_1_y" = 1)
s <- 5
pulses <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
pulses
#> [[1]]
#> x 
#> 
#> [[2]]
#> l_1_x  +  l_1_y x 
#> 
#> [[3]]
#> l_1_y l_1_x  +  l_1_y^2 x 
#> 
#> [[4]]
#> l_1_y^2 l_1_x  +  l_1_y^3 x 
#> 
#> [[5]]
#> l_1_y^3 l_1_x  +  l_1_y^4 x 
#> 
#> [[6]]
#> l_1_y^4 l_1_x  +  l_1_y^5 x 
#> 
# Will also handle finite dynamics
x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
finite.pulses <- pulse.calculator(x.vrbl = x.lags, limit = s)
```
