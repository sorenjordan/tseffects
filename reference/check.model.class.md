# Check and classify the model object passed to tseffects functions

Check and classify the model object passed to tseffects functions

## Usage

``` r
check.model.class(model)
```

## Arguments

- model:

  a fitted model object

## Value

a named list with the following elements:

- model.class:

  character, the primary class of the model

- supported:

  logical, `TRUE` if the class is in the tested list

- is.panel:

  logical, `TRUE` if the model is a panel/TSCS model

- is.glm:

  logical, `TRUE` if the model has a non-identity link function

- link.fn:

  character, the link function family (e.g. `"identity"`, `"logit"`,
  `"log"`). `"identity"` for non-GLM models

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
