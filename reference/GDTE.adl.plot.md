# Evaluate (and possibly plot) the General Dynamic Treatment Effect (GDTE) for an autoregressive distributed lag (ADL) model

Evaluate (and possibly plot) the General Dynamic Treatment Effect (GDTE)
for an autoregressive distributed lag (ADL) model

## Usage

``` r
GDTE.adl.plot(
  model = NULL,
  x.vrbl = NULL,
  y.vrbl = NULL,
  d.x = NULL,
  d.y = NULL,
  te.type = "pte",
  inferences.y = "levels",
  inferences.x = "levels",
  dM.level = 0.95,
  s.limit = 20,
  se.type = "const",
  return.data = FALSE,
  return.plot = TRUE,
  return.formulae = FALSE,
  ...
)
```

## Arguments

- model:

  the `lm` model containing the ADL estimates

- x.vrbl:

  a named vector of the x variables and corresponding lag orders in the
  ADL model

- y.vrbl:

  a named vector of the (lagged) y variables and corresponding lag
  orders in the ADL model

- d.x:

  the order of differencing of the x variable in the ADL model

- d.y:

  the order of differencing of the y variable in the ADL model

- te.type:

  the desired treatment history. `te.type` determines the counterfactual
  series (h) that will be applied to the independent variable. -1
  represents a Pulse Treatment Effect (PTE). 0 represents a Step
  Treatment Effect (STE). These can also be specified via `pte`,
  `pulse`, `ste`, and `step`. For others, see Vande Kamp, Jordan, and
  Rajan. The default is `pte`

- inferences.y:

  does the user want resulting inferences about the dependent variable
  in levels or in differences? (For y variables where `d.y` is 0, this
  is automatically levels.) The default is `levels`

- inferences.x:

  does the user want to apply the counterfactual treatment to the
  independent variable in levels or in differences? (For x variables
  where `d.x` is 0, this is automatically levels.) The default is
  `levels`

- dM.level:

  level of significance of the GDTE, calculated by the delta method. The
  default is 0.95

- s.limit:

  an integer for the number of periods to determine the GDTE (beginning
  at s = 0)

- se.type:

  the type of standard error to extract from the ADL model. The default
  is `const`, but any argument to `vcovHC` from the `sandwich` package
  is accepted

- return.data:

  return the raw calculated GDTEs as a list element under `estimates`.
  The default is `FALSE`

- return.plot:

  return the visualized GDTEs as a list element under `plot`. The
  default is `TRUE`

- return.formulae:

  return the formulae for the GDTEs as a list element under `formulae`
  (for the GDTEs) and `binomials` (for the treatment history). The
  default is `FALSE`

- ...:

  other arguments to be passed to the call to plot

## Value

depending on `return.data`, `return.plot`, and `return.formulae`, a list
of elements relating to the GDTE

## Details

We assume that the ADL model estimated is well specified, free of
residual autocorrelation, balanced, and meets other standard time-series
qualities. Given that, to obtain causal inferences for the specified
treatment history, the user only needs a named vector of the x and y
variables, as well as the order of the differencing

## Author

Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan

## Examples

``` r
# ADL(1,1)
# Use the toy data to run an ADL. No argument is made this is well specified; it is just expository 
model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
test.pulse <- GDTE.adl.plot(model = model,
                                  x.vrbl = c("x" = 0, "l_1_x" = 1), 
                                  y.vrbl = c("l_1_y" = 1),
                                  d.x = 0, 
                                  d.y = 0,
                                  te.type = "pulse", 
                                  inferences.y = "levels", 
                                  inferences.x = "levels",
                                  s.limit = 20, 
                                  return.plot = TRUE, 
                                  return.formulae = TRUE)
names(test.pulse)
#> [1] "plot"      "formulae"  "binomials"

# Using Cavari's (2019) approval model (without interactions)
# Cavari's original model: APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + 
#     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#       MIP_MACROECONOMICS + MIP_FOREIGN + 
#     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT)

cavari.model <- lm(APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + MIP_FOREIGN +
     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT), data = approval)

# What if there was a permanent, one-unit change in the salience of foreign affairs?
cavari.step <- GDTE.adl.plot(model = cavari.model,
                                  x.vrbl = c("MIP_FOREIGN" = 0), 
                                  y.vrbl = c("APPROVE_L1" = 1),
                                  d.x = 0,
                                  d.y = 0,
                                  te.type = "ste", 
                                  inferences.y = "levels", 
                                  inferences.x = "levels",
                                  s.limit = 10, 
                                  return.plot = TRUE, 
                                  return.formulae = TRUE)
#> Warning: Variable names containing . replaced with _
```
