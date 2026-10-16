# Convert strings about the desired inferences of x/y to values of d.x/d.y; including for eventual plotting

Convert strings about the desired inferences of x/y to values of
d.x/d.y; including for eventual plotting

## Usage

``` r
inference.adjustr(inferences.y, inferences.x, the.d.y, the.d.x)
```

## Arguments

- inferences.y:

  a character string specifying whether the shock to the independent
  variable is interpreted in levels or differences (of the dependent
  variable). Valid arguments include `levels` or `differences`. (For y
  variables where `d.y` is 0, this is automatically `levels`.) The
  default is `levels`

- inferences.x:

  a character string specifying whether the shock to the independent
  variable is applied in levels or differences. Valid arguments include
  `levels` or `differences`. (For independent variables where `d.x` is
  0, this is automatically `levels`.) The default is `levels`

- the.d.y:

  the numeric order of differencing of the relevant form of y (as
  appropriate to the ADL/GECM)

- the.d.x:

  the numeric order of differencing of the relevant form of x (as
  appropriate to the ADL/GECM)

## Value

a list of the transformed orders of `d.x`/`d.y` for calcualting the GDRF
or a plotting label, as appropriate

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
