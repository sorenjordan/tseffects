# Translate the coefficients from the General Error Correction Model (GECM) to the autoregressive distributed lag (ADL) model

Translate the coefficients from the General Error Correction Model
(GECM) to the autoregressive distributed lag (ADL) model

## Usage

``` r
gecm.to.adl(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl)
```

## Arguments

- x.vrbl:

  a named vector of the x variables (of the lower level of differencing,
  usually in levels d = 0) and corresponding lag orders in the GECM
  model

- y.vrbl:

  a named vector of the (lagged) y variables (of the lower level of
  differencing, usually in levels d = 0) and corresponding lag orders in
  the GECM model

- x.d.vrbl:

  a named vector of the x variables (of the higher level of
  differencing, usually first differences d = 1) and corresponding lag
  orders in the GECM model

- y.d.vrbl:

  a named vector of the y variables (of the higher level of
  differencing, usually first differences d = 1) and corresponding lag
  orders in the GECM model

## Value

a list of named vectors of translated ADL coefficients for the x and y
variables of interest

## Details

`gecm.to.adl` utilizes the mathematical equivalence between the GECM and
ADL models to translate the coefficients from one to the other. This
way, we can apply a single function using the ADL math to calculate
effects

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# GECM(1,1)
the.x.vrbl <- c("l_1_x" = 1) 
the.y.vrbl <- c("l_1_y" = 1) 
the.x.d.vrbl <- c("d_x" = 0, "l_1_d_x" = 1) 
the.y.d.vrbl <- c("l_1_d_y" = 1) 
adl.coef <- gecm.to.adl(x.vrbl = the.x.vrbl, y.vrbl = the.y.vrbl, 
      x.d.vrbl = the.x.d.vrbl, y.d.vrbl = the.y.d.vrbl)
adl.coef$x.vrbl.adl
#>               d_x l_1_x+l_1_d_x-d_x      (-1)*l_1_d_x 
#>                 0                 1                 2 
adl.coef$y.vrbl.adl
#> l_1_y+l_1_d_y+1    (-1)*l_1_d_y 
#>               1               2 
```
