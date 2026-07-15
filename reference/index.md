# Package index

## All functions

- [`GDRF.adl.plot()`](https://sorenjordan.github.io/tseffects/reference/GDRF.adl.plot.md)
  : Evaluate (and possibly plot) the General Dynamic Response Function
  (GDRF) for an autoregressive distributed lag (ADL) model

- [`GDRF.gecm.plot()`](https://sorenjordan.github.io/tseffects/reference/GDRF.gecm.plot.md)
  : Evaluate (and possibly plot) the General Dynamic Response Function
  (GDRF) for a Generalized Error Correction Model (GECM)

- [`adl.plot()`](https://sorenjordan.github.io/tseffects/reference/adl.plot.md)
  :

  Evaluate (and possibly plot) the General Dynamic Response Function
  (GDRF) for an autoregressive distributed lag (ADL) model, assuming the
  underlying model is in levels (`d.x` = `d.y` = 0) and the user wants a
  marginal effect (the untransformed GDRF). (This is just a wrapper for
  `GDRF.adl.plot` with simplifying assumptions)

- [`approval`](https://sorenjordan.github.io/tseffects/reference/approval.md)
  : Data on US Presidential Approval

- [`gecm.plot()`](https://sorenjordan.github.io/tseffects/reference/gecm.plot.md)
  :

  Evaluate (and possibly plot) the General Dynamic Response Function
  (GDRF) for a GECM(1,1) model, assuming the underlying model is in
  first differences (`x.vrbl.d.x` = `y.vrbl.d.y` = 0 and `x.d.vrbl.d.x`
  = `y.d.vrbl.d.y` = 1) and the user wants a marginal effect (the
  untransformed GDRF) and inferences about y in levels to a treatment
  applied to x in levels. (This is just a wrapper for `GDRF.gecm.plot`
  with simplifying assumptions)

- [`gecm.to.adl()`](https://sorenjordan.github.io/tseffects/reference/gecm.to.adl.md)
  : Translate the coefficients from the General Error Correction Model
  (GECM) to the autoregressive distributed lag (ADL) model

- [`general.calculator()`](https://sorenjordan.github.io/tseffects/reference/general.calculator.md)
  : Generate the generalized effect formulae for an autoregressive
  distributed lag (ADL) model, given pulse effects and shock history

- [`interact.adl.plot()`](https://sorenjordan.github.io/tseffects/reference/interact.adl.plot.md)
  :

  Plot the interaction in a single-equation time series model estimated
  via `lm`.

- [`pulse.calculator()`](https://sorenjordan.github.io/tseffects/reference/pulse.calculator.md)
  : Generate pulse effect formulae for a given autoregressive
  distributed lag (ADL) model

- [`toy.ts.interaction.data`](https://sorenjordan.github.io/tseffects/reference/toy.ts.interaction.data.md)
  : Simulated interactive time series data

- [`yhat.calculator()`](https://sorenjordan.github.io/tseffects/reference/yhat.calculator.md)
  : Transform the GDRF formulae to fitted value formulae
