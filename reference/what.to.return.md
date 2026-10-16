# Consistently return the correct objects after a GDRF ADL/GECM

Consistently return the correct objects after a GDRF ADL/GECM

## Usage

``` r
what.to.return(
  return.plot,
  return.formulae,
  return.data,
  plot.out,
  dat.out,
  the.final.formulae
)
```

## Arguments

- return.plot:

  logical to return the visualized GDRFs as a list element under `plot`.
  The default is `TRUE`

- return.formulae:

  logical to return the formulae for the GDRFs as a list element under
  `formulae` (for the GDRFs) and `shocks` (for the shock history). The
  default is `FALSE`

- return.data:

  logical to return the raw calculated GDRFs as a list element under
  `estimates`. The default is `FALSE`

- plot.out:

  the created plot from the GDRF ADL/GECM

- dat.out:

  the created data from the GDRF ADL/GECM

- the.final.formulae:

  the created formulae from the GDRF ADL/GECM

## Value

a list of the requested objects

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
