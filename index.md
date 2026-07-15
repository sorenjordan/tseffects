# tseffects: Dynamic Inferences from Time Series (with Interactions)

Autoregressive distributed lag (A\[R\]DL) models (and their
reparameterized equivalent, the Generalized Error-Correction Model
\[GECM\]) are the workhorse models in uncovering dynamic inferences. ADL
models are simple to estimate; this is what makes them attractive. Once
these models are estimated, what is less clear is how to uncover a rich
set of dynamic inferences from these models. We provide tools for
recovering those inferences. These tools apply to traditional
time-series quantities of interest and are built from the Impulse
Response Function and Step Response Function (sometimes described as a
pulse effect or a cumulative effect). They also allow for a variety of
shock histories to be applied to the independent variable (beyond just a
one-time, one-unit increase) as well as the recovery of inferences in
levels for shocks applied to (in)dependent variables in differences
(what we call the Generalized Dynamic Response Function). These effects
are also available for the general conditional dynamic model advocated
by Warner, Vande Kamp, and Jordan (2026 <doi:10.1017/psrm.2026.10087>).
We also provide the formulae for these effects.

Two ultra-simple examples are shown below: see the vignette and manual
for many, many more!

## Installation

`tseffects` is available on CRAN. To install the stable version released
to CRAN, install as normal:

    install.packages("tseffects")
    library(tseffects)

## Usage: effects in levels

Drawing inferences from ADL and GECM models is easy. From an ADL(1,1),
just specify the independent and dependent variables, as well as the
treatment history desired.

    # ADL(1,1)
    # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository
    model.toydata <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

    GDRF.adl.plot(model = model.toydata,
    x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    d.x = 0,
    d.y = 0,
    shock.history = "pulse",
    inferences.y = "levels",
    inferences.x = "levels",
    s.limit = 20)

## Usage: conditional relationships

If we want to interpret the same style of effects from an interactive
model, we just specify the interaction and its terms.

    # ADL(1,1)
    # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository
    model.toydata <- lm(y ~ l_1_y + x + l_1_x + z + l_1_z +
    x_z + l_1_x_z +
    x_l_1_z + l_1_x_l_1_z, data = toy.ts.interaction.data)

    interact.adl.plot(model = model.toydata, x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = c("z" = 0, "l_1_z" = 1),
    x.z.vrbl = c("x_z" = 0, "l_1_x_z" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
    z.vals = -2:2,
    effect.type = "impulse", plot.type = "lines", line.options = "z.lines",
    s.limit = 20)
