
# tseffects: Robust Dynamic (Causal) Inferences from Single-Equation Time Series Models (with Interactions)

<!-- badges: start -->
[![Version](https://www.r-pkg.org/badges/version/tseffects?color=black)](https://cran.r-project.org/package=tseffects)
[![CRAN checks](https://badges.cranchecks.info/summary/tseffects.svg)](https://cran.r-project.org/web/checks/check_results_tseffects.html)
[![codecov](https://codecov.io/github/sorenjordan/tseffects/graph/badge.svg?token=SD7T7UUCCP)](https://codecov.io/github/sorenjordan/tseffects)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/tseffects)](https://cran.r-project.org/package=tseffects)
<!-- badges: end -->

<a href="https://github.com/sorenjordan/tseffects/"><img src="tree/main/reference/figures/hex.png" align="right" width="150" height="150" alt="tseffects website" /></a>

Autoregressive distributed lag (A[R]DL) models (and their reparameterized equivalent, the Generalized Error-Correction Model [GECM]) are the workhorse models in uncovering dynamic inferences. ADL models are simple to estimate; this is what makes them attractive. Once these models are estimated, what is less clear is how to uncover a rich set of dynamic inferences from these models. We provide tools for recovering those inferences in three forms: causal inferences from ADL models, traditional time series quantities of interest (short- and long-run effects), and dynamic conditional relationships.

## Installation

```tseffects``` is available on CRAN. To install the stable version released to CRAN, install as normal:

```
install.packages("tseffects")
library(tseffects)
```

## Usage: causal inferences

Drawing causal inferences from ADL and GECM models is easy. From an ADL(1,1), just specify the independent and dependent variables, as well as the treatment history desired.

```
# ADL(1,1)
# Use the toy data to run an ADL. No argument is made this is well specified; it is just expository
model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
test.pulse <- ts.ci.adl.plot(model = model,
x.vrbl = c("x" = 0, "l_1_x" = 1),
y.vrbl = c("l_1_y" = 1),
d.x = 0,
d.y = 0,
te.type = "pulse",
inferences.y = "levels",
inferences.x = "levels",
h.limit = 20,
return.plot = TRUE,
return.formulae = TRUE
return.data = TRUE
)
```



<!-- ## Citation

To cite ```tseffects``` in publications and working papers, please use:

Mehlhaff, Isaac D. *Mass Polarization across Time and Space*. New York: Cambridge University Press (2025).

For BibTeX users:

```
@book{Mehlhaffbook,
  title = {Mass {{Polarization}} across {{Time}} and {{Space}}},
  author = {Mehlhaff, Isaac D.},
  year = {2025},
  publisher = {{Cambridge University Press}},
  location = {{New York}},
  doi = {https://doi.org/10.1017/9781009350662}
}
```
-->