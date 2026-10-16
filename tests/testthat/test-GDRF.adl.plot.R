# Models used throughout
# model.adl: y in levels, ADL(1,1) -- for discrete/fitted tests
# model.diffs: d_y as DV, ADL(1,1) -- for d.y > 0 tests
# model.i2: d_2_y as DV, ADL(1,1) in second differences -- for d.x/d.y > 1 tests

test_that("GDRF.adl.plot errors and warnings are issued correctly", {  
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  model.diffs <- lm(d_y ~ l_1_d_y + x + l_1_x, data = toy.ts.interaction.data)
  model.i2 <- lm(d_2_y ~ l_1_d_2_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = NULL,
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = 1, d.y = 2,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),
                   
    # Expected output
    "Variables in GDRF terms \\(x and possibly y\\) must be specified through x.vrbl and"
  ) 
  
  expect_warning( # no y.vrbl
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = NULL,
                  d.x = 1, d.y = 2,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),
                   
    # Expected output
    "No y.vrbl in GDRF terms implies a static or finite dynamics model: are you sure you want this?"
  )
  
  expect_error( # no d.x
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = NULL, d.y = 2,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF terms must be specified"
  )
  
  expect_error( # d.y not supplied, y.vrbl present
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = 1, d.y = NULL,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF terms must be specified"
  )
  
  expect_error( # d.x must be integer
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = 1.5, d.y = 2,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF terms \\(d.x"
  )
  
  expect_error( # d.y must be integer
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = 1, d.y = 2.7,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF terms \\(d.x"
  )
    
  expect_error( # invalid inference type specified - y
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = 1, d.y = 2,
                  shock.history = "pulse",
                  inferences.y = "the doctor", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid inferences.y. The response function for y" 
  )

  expect_error( # invalid inference type specified - x
    # Function output
    GDRF.adl.plot(model = model.i2,
                  x.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                  y.vrbl = c("l_1_d_2_y" = 1),
                  d.x = 1, d.y = 2,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "the Rani",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid inferences.x. The shock.history" 
  )
  
  expect_error( # inference type mismatch: d.y/inferences differences
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "The response function for y cannot be in" 
  )
  
  expect_error( # inference type mismatch: d.x/inferences differences
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "differences",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "The shock.history for x cannot be in a higher" 
  )
  
  expect_error( # x vrbl not named vector
    # Function output
    GDRF.adl.plot(model = model.adl, 
                   x.vrbl = c(0,1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl vector has no values
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c(0, 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "x.vrbl should be a named vector"
  )

  expect_error( # x.vrbl not a named numeric vector (names but no values)
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x", "l_1_x"),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "x.vrbl should be a named vector"
  )
 
  expect_error( # y vrbl not named vector
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c(1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl values not given
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y"),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "y.vrbl should be a named vector"
  )

  expect_error( # invalid se.type
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  se.type = "woof",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid se.type."
  )

  expect_error( # x vrbl not in the model
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("Time Lord" = 0, "Time Lady" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # y.vrbl not in the model
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("Time Tot" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "y.vrbl not present in estimated model" 
  )

  expect_error( # no shock.history
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = NULL,
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "shock.history must be specified" 
  )
  
  expect_error( # shock.history is not accepted input
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "the Master",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid shock.history. shock.history must be one of" 
  )
  
  expect_error( # shock.history is non-integer numeric
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = 2.5,
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid shock.history"
  )

  expect_error( # invalid effect.type
    # Function output	  
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "cough",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid effect.type. effect.type must be one of"
  )

  # The below are all with the fitted option
  
  expect_error( # discrete + prediction.values
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  prediction.values = list("x" = 1, "l_1_x" = 1),
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Do not supply prediction.values when effect.type = 'discrete'"
  )

  expect_error( # discrete + baseline.y
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  baseline.y = 5,
                  s.limit = 5,
                  return.plot = FALSE, return.data = TRUE),
                  
    # Expected output
    "Do not supply baseline.y when effect.type = 'discrete'"
  )

  expect_error( # discrete + baseline.y.se
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  baseline.y.se = 1,
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Do not supply baseline.y.se when effect.type = 'discrete'"
  )
  
  expect_error( # fitted + prediction.values not a list
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = c("x" = 1, "l_1_x" = 1),
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "If using prediction.values, it must be a list"
  )

  expect_error( # fitted + baseline.y not numeric
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = "cough",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "If providing a baseline.y, it must be numeric"
  )

  expect_error( # fitted + baseline.y length > 1
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = c(1, 2),
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Only provide a single baseline.y value"
  )

  expect_error( # fitted + baseline.y.se not numeric
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  baseline.y.se = "cough",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "If providing a baseline.y.se, it must be numeric"
  )

  expect_error( # fitted + baseline.y.se length > 1
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  baseline.y.se = c(1, 2),
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Only provide a single baseline.y.se value"
  )

  expect_error( # fitted + shock.size not numeric
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  shock.size = "cough",
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "shock.size must be numeric"
  )

  expect_error( # fitted + shock.size length > 1
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  shock.size = c(1, 2),
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "shock.size should be a single value"
  )

  expect_error( # fitted + d.y = 1 + inferences.y = levels + no baseline.y
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0, d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = NULL,
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "You must provide either a baseline.y value"
  )

  expect_error( # fitted + d.y = 0 + no baseline.y and no prediction.values
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = NULL,
                  prediction.values = NULL,
                  s.limit = 5, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "You must provide either a baseline.y value or prediction.values"
  )

  expect_error( # return nothing
    # Function output
    suppressWarnings(GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  s.limit = 5,
                  return.plot = FALSE, return.formulae = FALSE, return.data = FALSE)),

    # Expected output
    "Return at least one of the plot, the data, or the formulae"
  )

})


test_that("GDRF.adl.plot effect.type combination warnings are issued correctly", {
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  model.diffs <- lm(d_y ~ l_1_d_y + x + l_1_x, data = toy.ts.interaction.data)

  expect_warning( # fitted + d.y = 0 + both baseline.y and prediction.values
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = 5,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Both baseline.y and prediction.values supplied; baseline.y takes precedence and prediction.values will be ignored"
  )

  expect_warning( # fitted + d.y = 0 + prediction.values only (differenced variable reminder)
    # Function output
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = NULL,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "If any differenced variables are included in the model, ensure they are set to 0 in prediction.values"
  )

  expect_warning( # fitted + d.y = 1 + prediction.values (ignored)
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0, d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = 5,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "prediction.values is ignored when d.y > 0"
  )

  expect_warning( # fitted + d.y = 1 + inferences.y = differences + non-zero baseline.y
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0, d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Assuming anything other than baseline.y = 0 when inferences.y = 'differences' suggests the model is unstable"
  )

  expect_warning( # fitted + d.y = 1 + inferences.y = differences + shock.size = 1 (redundant)
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0, d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 0,
                  shock.size = 1,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "effect.type = 'fitted' with inferences.y = 'differences' and shock.size = 1 is identical to effect.type = 'discrete'"
  )

  expect_error( # fitted + d.y = 1 + inferences.y = levels + no baseline.y
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0,
                  d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = NULL,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

    # Expected output
    "You must provide either a baseline.y value"
  )

  expect_warning( # LRM decay warning: pulse, cumulative = FALSE, d.x = 1, d.y = 0
    # (h+1) - d.x + d.y = (-1+1) - 1 + 0 = -1 < 0: decays
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 1, d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "differences", inferences.x = "differences",
                  cumulative = FALSE,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned"
  )

  expect_warning( # LRM diverge warning: step, cumulative = TRUE, d.x = 0, d.y = 1
    # (h+1) - d.x + d.y = (0+1) - 0 + 1 = 2 > 0: diverges
    # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0, d.y = 1,
                  shock.history = "step",
                  inferences.y = "levels", inferences.x = "levels",
                  cumulative = TRUE,
                  s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "return.LRM = TRUE but the effects diverge to \\+/-infinity as s -> infinity. No LRM is returned"
  )

  expect_warning( # mpoly . replacement warning
    {
      toy.ts.interaction.data$d.x <- toy.ts.interaction.data$d_x
      model.dot <- lm(d_2_y ~ l_1_d_2_y + d.x + l_1_d_x, data = toy.ts.interaction.data)

      # Function output
      GDRF.adl.plot(model = model.dot,
                    x.vrbl = c("d.x" = 0, "l_1_d_x" = 1),
                    y.vrbl = c("l_1_d_2_y" = 1),
                    d.x = 0, d.y = 0,
                    shock.history = "pulse",
                    inferences.y = "levels", inferences.x = "levels",
                    s.limit = 3, return.plot = FALSE, return.data = TRUE)
    },

    # Expected output
    "Variable names containing . replaced with _"
  )
  
})

test_that("GDRF.adl.plot output structure is correct (discrete, no LRM)", {

  # pulse + cumulative = FALSE + d.x = 0, d.y = 0:
  # h = -1, -1 - 0 + 0 = -1 < 0: no LRM (warns about decay)
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5

  result <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  s.limit = the.s,
                  return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)
  )

  expect_equal( # output names when all three returned
    # Function output
    names(result),

    # Expected output
    c("plot", "estimates", "formulae", "shocks")
  )

  expect_equal( # estimates has correct number of rows: s.limit + 1, no LRM
    # Function output
    nrow(result$estimates),

    # Expected output
    the.s + 1
  )

  expect_equal( # estimates has correct column names
    # Function output
    names(result$estimates),

    # Expected output
    c("Period", "GDRF", "SE", "Lower", "Upper")
  )

  expect_equal( # formulae has correct number of elements: s.limit + 1, no LRM
    # Function output
    length(result$formulae),

    # Expected output
    the.s + 1
  )

  expect_equal( # formulae names go from s = 0 to s = s.limit
    # Function output
    names(result$formulae),

    # Expected output
    paste0("s = ", 0:the.s)
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})


test_that("GDRF.adl.plot output structure is correct (discrete, with LRM)", {

  # step + cumulative = FALSE + d.x = 0, d.y = 0:
  # h = 0, 0 - 0 + 0 = 0: LRM exists
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5

  result <- GDRF.adl.plot(model = model.adl,
                           x.vrbl = c("x" = 0, "l_1_x" = 1),
                           y.vrbl = c("l_1_y" = 1),
                           d.x = 0, d.y = 0,
                           shock.history = "step",
                           inferences.y = "levels", inferences.x = "levels",
                           effect.type = "discrete",
                           s.limit = the.s,
                           return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # estimates has correct number of rows: s.limit + 1 + 1 LRM
    # Function output
    nrow(result$estimates),

    # Expected output
    the.s + 1 + 1
  )

  expect_true( # LRM row is present in estimates
    # Function output
    "LRM" %in% result$estimates$Period
  )

  expect_true( # LRM formula is present in formulae
    # Function output
    "LRM" %in% names(result$formulae)
  )

  expect_equal( # LRM formula has correct structure: shock.size * (numerator) / (1 - denominator)
    # Function output
    result$formulae[["LRM"]],

    # Expected output
    "(1 * (x+l_1_x))/(1-(l_1_y))"
  )

})


test_that("GDRF.adl.plot output structure is correct (discrete, cumulative + LRM)", {

  # pulse + cumulative = TRUE + d.x = 0, d.y = 0:
  # (h+1) - d.x + d.y = (-1+1) - 0 + 0 = 0: LRM exists
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5

  result <- GDRF.adl.plot(model = model.adl,
                           x.vrbl = c("x" = 0, "l_1_x" = 1),
                           y.vrbl = c("l_1_y" = 1),
                           d.x = 0, d.y = 0,
                           shock.history = "pulse",
                           inferences.y = "levels", inferences.x = "levels",
                           effect.type = "discrete",
                           cumulative = TRUE,
                           s.limit = the.s,
                           return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # estimates has correct number of rows: s.limit + 1 + 1 LRM
    # Function output
    nrow(result$estimates),

    # Expected output
    the.s + 1 + 1
  )

  expect_true( # LRM row is present in estimates
    # Function output
    "LRM" %in% result$estimates$Period
  )

  expect_true( # LRM formula present in formulae
    # Function output
    "LRM" %in% names(result$formulae)
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})


test_that("GDRF.adl.plot output structure is correct (fitted, baseline.y, no LRM)", {

  # fitted + step + d.y = 0 + baseline.y: LRM suppressed for fitted
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5

  result <- GDRF.adl.plot(model = model.adl,
                           x.vrbl = c("x" = 0, "l_1_x" = 1),
                           y.vrbl = c("l_1_y" = 1),
                           d.x = 0, d.y = 0,
                           shock.history = "step",
                           inferences.y = "levels", inferences.x = "levels",
                           effect.type = "fitted",
                           baseline.y = 5,
                           shock.size = 1,
                           s.limit = the.s,
                           return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # estimates has correct number of rows: baseline + s.limit + 1, no LRM
    # Function output
    nrow(result$estimates),

    # Expected output
    1 + the.s + 1
  )

  expect_false( # LRM row is NOT present in estimates for fitted
    # Function output
    "LRM" %in% result$estimates$Period
  )

  expect_false( # LRM formula is NOT present in formulae for fitted
    # Function output
    "LRM" %in% names(result$formulae)
  )

  expect_true( # baseline row is present in estimates
    # Function output
    "baseline" %in% result$estimates$Period
  )

  expect_true( # baseline formula is present in formulae
    # Function output
    "baseline" %in% names(result$formulae)
  )

  expect_equal( # formulae names: baseline + s = 0 to s = s.limit
    # Function output
    names(result$formulae),

    # Expected output
    c("baseline", paste0("s = ", 0:the.s))
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})

test_that("GDRF.adl.plot output structure is correct (fitted, prediction.values)", {

  # fitted + pulse + d.y = 0 + prediction.values steady state
  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5

  result <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = NULL,
                  shock.size = 1,
                  s.limit = the.s,
                  return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)
  )

  expect_equal( # estimates has correct number of rows: baseline + s.limit + 1
    # Function output
    nrow(result$estimates),

    # Expected output
    1 + the.s + 1
  )

  expect_true( # baseline row is present in estimates
    # Function output
    "baseline" %in% result$estimates$Period
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})

test_that("GDRF.adl.plot output structure is correct (custom shock history)", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5
  custom.shocks <- c(1, 1, 1, 0, 0, 1)

  result <- GDRF.adl.plot(model = model.adl,
                           x.vrbl = c("x" = 0, "l_1_x" = 1),
                           y.vrbl = c("l_1_y" = 1),
                           d.x = 0, d.y = 0,
                           shock.history = custom.shocks,
                           inferences.y = "levels", inferences.x = "levels",
                           effect.type = "discrete",
                           s.limit = the.s,
                           return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # estimates has correct number of rows: s.limit + 1, no LRM for non-cumulative custom
    # Function output
    nrow(result$estimates),

    # Expected output
    the.s + 1
  )

  expect_false( # LRM is not present for non-cumulative custom shock history
    # Function output
    "LRM" %in% result$estimates$Period
  )

  expect_equal( # formulae has correct number of elements
    # Function output
    length(result$formulae),

    # Expected output
    the.s + 1
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})

test_that("GDRF.adl.plot output structure is correct (custom shock history, cumulative)", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  the.s <- 5
  custom.shocks <- c(1, 1, 1, 0, 0, 1)

  # custom + cumulative = TRUE: warns about LRM condition but returns TRUE
  result <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = custom.shocks,
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  cumulative = TRUE,
                  s.limit = the.s,
                  return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)
  )

  expect_equal( # estimates has correct number of rows: s.limit + 1 + 1 LRM
    # Function output
    nrow(result$estimates),

    # Expected output
    the.s + 1 + 1
  )

  expect_true( # LRM row is present for cumulative custom shock history
    # Function output
    "LRM" %in% result$estimates$Period
  )

})

test_that("GDRF.adl.plot return options work correctly", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # all three returned
  result.all <- GDRF.adl.plot(model = model.adl,
                               x.vrbl = c("x" = 0, "l_1_x" = 1),
                               y.vrbl = c("l_1_y" = 1),
                               d.x = 0, d.y = 0,
                               shock.history = "step",
                               inferences.y = "levels", inferences.x = "levels",
                               s.limit = 3,
                               return.plot = TRUE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # all three returned: names are plot, estimates, formulae, shocks
    # Function output
    names(result.all),

    # Expected output
    c("plot", "estimates", "formulae", "shocks")
  )

  # plot only
  result.plot <- GDRF.adl.plot(model = model.adl,
                                x.vrbl = c("x" = 0, "l_1_x" = 1),
                                y.vrbl = c("l_1_y" = 1),
                                d.x = 0, d.y = 0,
                                shock.history = "step",
                                inferences.y = "levels", inferences.x = "levels",
                                s.limit = 3,
                                return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  expect_true( # plot only: returns ggplot directly, not a list
    # Function output
    inherits(result.plot, "ggplot")
  )

  # data only
  result.data <- GDRF.adl.plot(model = model.adl,
                                x.vrbl = c("x" = 0, "l_1_x" = 1),
                                y.vrbl = c("l_1_y" = 1),
                                d.x = 0, d.y = 0,
                                shock.history = "step",
                                inferences.y = "levels", inferences.x = "levels",
                                s.limit = 3,
                                return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  expect_true( # data only: returns data frame directly
    # Function output
    is.data.frame(result.data)
  )

  # formulae only
  result.formulae <- GDRF.adl.plot(model = model.adl,
                                    x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1),
                                    d.x = 0, d.y = 0,
                                    shock.history = "step",
                                    inferences.y = "levels", inferences.x = "levels",
                                    s.limit = 3,
                                    return.plot = FALSE, return.formulae = TRUE, return.data = FALSE)

  expect_equal( # formulae only: names are formulae and shocks
    # Function output
    names(result.formulae),

    # Expected output
    c("formulae", "shocks")
  )

  # plot + data, no formulae
  result.plotdata <- GDRF.adl.plot(model = model.adl,
                                    x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1),
                                    d.x = 0, d.y = 0,
                                    shock.history = "step",
                                    inferences.y = "levels", inferences.x = "levels",
                                    s.limit = 3,
                                    return.plot = TRUE, return.formulae = FALSE, return.data = TRUE)

  expect_equal( # plot + data: names are plot and estimates
    # Function output
    names(result.plotdata),

    # Expected output
    c("plot", "estimates")
  )

  # plot + formulae, no data
  result.plotformulae <- GDRF.adl.plot(model = model.adl,
                                        x.vrbl = c("x" = 0, "l_1_x" = 1),
                                        y.vrbl = c("l_1_y" = 1),
                                        d.x = 0, d.y = 0,
                                        shock.history = "step",
                                        inferences.y = "levels", inferences.x = "levels",
                                        s.limit = 3,
                                        return.plot = TRUE, return.formulae = TRUE, return.data = FALSE)

  expect_equal( # plot + formulae: names are plot, formulae, shocks
    # Function output
    names(result.plotformulae),

    # Expected output
    c("plot", "formulae", "shocks")
  )

  # data + formulae, no plot
  result.dataformulae <- GDRF.adl.plot(model = model.adl,
                                        x.vrbl = c("x" = 0, "l_1_x" = 1),
                                        y.vrbl = c("l_1_y" = 1),
                                        d.x = 0, d.y = 0,
                                        shock.history = "step",
                                        inferences.y = "levels", inferences.x = "levels",
                                        s.limit = 3,
                                        return.plot = FALSE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # data + formulae: names are estimates, formulae, shocks
    # Function output
    names(result.dataformulae),

    # Expected output
    c("estimates", "formulae", "shocks")
  )

})

test_that("GDRF.adl.plot fitted value output is correct (d.y = 0, baseline.y supplied)", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.discrete <- suppressWarnings(GDRF.adl.plot(model = model,
                                   x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   d.x = 0,
                                   d.y = 0,
                                   shock.history = "pulse",
                                   inferences.y = "levels",
                                   inferences.x = "levels",
                                   effect.type = "discrete",
                                   s.limit = 3,
                                   return.plot = TRUE,
                                   return.formulae = TRUE,
                                   return.data = TRUE))

  result.fitted <- GDRF.adl.plot(model = model,
                                 x.vrbl = c("x" = 0, "l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 d.x = 0,
                                 d.y = 0,
                                 shock.history = "pulse",
                                 inferences.y = "levels",
                                 inferences.x = "levels",
                                 effect.type = "fitted",
                                 baseline.y = 5,
                                 shock.size = 1,
                                 s.limit = 3,
                                 return.plot = TRUE,
                                 return.formulae = TRUE,
                                 return.data = TRUE)

  # fitted values should differ from discrete effects
  expect_false(identical(result.discrete$estimates$GDRF, result.fitted$estimates$GDRF))

  # fitted values should be offset from discrete effects by approximately baseline.y, ignoring the baseline
  expect_equal(
    result.fitted$estimates$GDRF[-1] - result.discrete$estimates$GDRF,
    rep(5, nrow(result.discrete$estimates)),
    tolerance = 1e-6
  )

  # SE should be the same for fitted and discrete when baseline.y.se = 0, ignoring the baseline
  expect_equal(
    result.fitted$estimates$SE[-1],
    result.discrete$estimates$SE,
    tolerance = 1e-6
  )
})

test_that("GDRF.adl.plot shock.size scales fitted values correctly", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.size1 <- GDRF.adl.plot(model = model,
                                x.vrbl = c("x" = 0, "l_1_x" = 1),
                                y.vrbl = c("l_1_y" = 1),
                                d.x = 0,
                                d.y = 0,
                                shock.history = "pulse",
                                inferences.y = "levels",
                                inferences.x = "levels",
                                effect.type = "fitted",
                                baseline.y = 0,
                                shock.size = 1,
                                s.limit = 3,
                                return.plot = FALSE,
                                return.formulae = FALSE,
                                return.data = TRUE)

  result.size2 <- GDRF.adl.plot(model = model,
                                x.vrbl = c("x" = 0, "l_1_x" = 1),
                                y.vrbl = c("l_1_y" = 1),
                                d.x = 0,
                                d.y = 0,
                                shock.history = "pulse",
                                inferences.y = "levels",
                                inferences.x = "levels",
                                effect.type = "fitted",
                                baseline.y = 0,
                                shock.size = 2,
                                s.limit = 3,
                                return.plot = FALSE,
                                return.formulae = FALSE,
                                return.data = TRUE)

  # with baseline.y = 0, shock.size = 2 should double the GDRF relative to shock.size = 1, ignoring the baseline
  expect_equal(
    result.size2$GDRF[-1],
    result.size1$GDRF[-1] * 2,
    tolerance = 1e-6
  )
})

test_that("GDRF.adl.plot fitted values are offset from discrete effects by baseline.y", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.discrete <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  shock.size = 1,
                  s.limit = 5,
                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)
  )

  result.fitted <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  shock.size = 1,
                  s.limit = 5,
                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)
  )

  expect_equal( # fitted GDRF minus discrete GDRF equals baseline.y for all non-baseline rows
    # Function output: skip the baseline row (row 1) of fitted
    result.fitted$GDRF[-1] - result.discrete$GDRF,

    # Expected output
    rep(5, nrow(result.discrete)),
    tolerance = 1e-6
  )

  expect_equal( # SE is identical for fitted and discrete when baseline.y.se = 0
    # Function output: skip the baseline row (row 1) of fitted
    result.fitted$SE[-1],

    # Expected output
    result.discrete$SE,
    tolerance = 1e-6
  )

})

test_that("GDRF.adl.plot baseline.y.se is added in quadrature correctly", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.nose <- GDRF.adl.plot(model = model.adl,
                                x.vrbl = c("x" = 0, "l_1_x" = 1),
                                y.vrbl = c("l_1_y" = 1),
                                d.x = 0, d.y = 0,
                                shock.history = "step",
                                inferences.y = "levels", inferences.x = "levels",
                                effect.type = "fitted",
                                baseline.y = 5,
                                baseline.y.se = 0,
                                shock.size = 1,
                                s.limit = 5,
                                return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  result.withse <- GDRF.adl.plot(model = model.adl,
                                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                                  y.vrbl = c("l_1_y" = 1),
                                  d.x = 0, d.y = 0,
                                  shock.history = "step",
                                  inferences.y = "levels", inferences.x = "levels",
                                  effect.type = "fitted",
                                  baseline.y = 5,
                                  baseline.y.se = 2,
                                  shock.size = 1,
                                  s.limit = 5,
                                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  expect_equal( # SE with baseline.y.se = 2 equals sqrt(SE^2 + 2^2)
    # Function output
    result.withse$SE,

    # Expected output
    sqrt(result.nose$SE^2 + 2^2),
    tolerance = 1e-6
  )

  expect_false( # Lower CIs differ when baseline.y.se is added
    # Function output
    identical(result.nose$Lower, result.withse$Lower)
  )

  expect_false( # Upper CIs differ when baseline.y.se is added
    # Function output
    identical(result.nose$Upper, result.withse$Upper)
  )

})




test_that("GDRF.adl.plot LRM is suppressed for effect.type = fitted", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.discrete <- GDRF.adl.plot(model = model,
                                   x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   d.x = 0,
                                   d.y = 0,
                                   shock.history = "step",
                                   inferences.y = "levels",
                                   inferences.x = "levels",
                                   effect.type = "discrete",
                                   s.limit = 3,
                                   return.plot = TRUE,
                                   return.formulae = TRUE,
                                   return.data = TRUE)

  result.fitted <- GDRF.adl.plot(model = model,
                                 x.vrbl = c("x" = 0, "l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 d.x = 0,
                                 d.y = 0,
                                 shock.history = "step",
                                 inferences.y = "levels",
                                 inferences.x = "levels",
                                 effect.type = "fitted",
                                 baseline.y = 5,
                                 shock.size = 1,
                                 s.limit = 3,
                                 return.plot = TRUE,
                                 return.formulae = TRUE,
                                 return.data = TRUE)

  expect_true( # discrete effect with step should include LRM
    # Function output
    "LRM" %in% names(result.discrete$formulae)
  )

  expect_false( # fitted value with step should suppress LRM
    # Function output
    "LRM" %in% names(result.fitted$formulae)
  )

  expect_equal( # fitted value output should have s.limit + 1 rows (no LRM row) + 1 baseline
    # Function output
    nrow(result.fitted$estimates),
    # Expected output
    3 + 1 + 1
  )
})

test_that("mpoly formulae are correct (x and lag x only)", { 
  model <- lm(d_y ~ x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings({GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               # y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)})
  
  model_test_step <- suppressWarnings({GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               # y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)})

  expect_equal( # test whether formula matches for s = 3 (pulse)})
    # Function output    
    model_test_pulse$formulae[['s = 1']],

    # Expected output
    "l_1_d_x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 1']],
    
    # Expected output
    "l_1_d_x  +  x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "1 * (x+l_1_d_x)"
  )

})

test_that("GDRF.adl.plot LRM formula is correct (step, no y.vrbl)", {

  # FDL: no lagged y, step, d.x = 0, d.y = 0: LRM = shock.size * (x + l_1_x)
  model.fdl <- suppressWarnings(lm(y ~ x + l_1_x, data = toy.ts.interaction.data))

  result <- suppressWarnings(
    GDRF.adl.plot(model = model.fdl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = NULL,
                  d.x = 0, d.y = 0,
                  shock.history = "step",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  shock.size = 1,
                  s.limit = 5,
                  return.plot = FALSE, return.formulae = TRUE, return.data = TRUE)
  )

  expect_equal( # LRM formula for FDL: no denominator
    # Function output
    result$formulae[["LRM"]],

    # Expected output
    "1 * (x+l_1_x)"
  )

})


test_that("GDRF.adl.plot LRM formula is correct (step, with y.vrbl, shock.size = 2)", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result <- GDRF.adl.plot(model = model.adl,
                           x.vrbl = c("x" = 0, "l_1_x" = 1),
                           y.vrbl = c("l_1_y" = 1),
                           d.x = 0, d.y = 0,
                           shock.history = "step",
                           inferences.y = "levels", inferences.x = "levels",
                           effect.type = "discrete",
                           shock.size = 2,
                           s.limit = 5,
                           return.plot = FALSE, return.formulae = TRUE, return.data = TRUE)

  expect_equal( # LRM formula with y.vrbl and shock.size = 2
    # Function output
    result$formulae[["LRM"]],

    # Expected output
    "(2 * (x+l_1_x))/(1-(l_1_y))"
  )

})

test_that("mpoly formulae are correct (d.x = 0; d.y = 0)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(1 * (x+l_1_d_x))/(1-(l_1_d_y))"
  )
 
})


test_that("mpoly formulae are correct (d.x = 0; d.y = 1)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), y inferences in differences, x inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  )  

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(1 * (x+l_1_d_x))/(1-(l_1_d_y))"
  )

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  2 * l_1_d_y * l_1_d_x  +  2 * l_1_d_y**2 * x  +  3 * l_1_d_x  +  3 * l_1_d_y * x  +  4 * x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 2, 3, 4)
  )

  expect_equal( # test whether formula matches for LRM (step) - doesn't exist as it is undefined
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    NULL
  )

})

test_that("mpoly formulae are correct (d.x = 1; d.y = 0)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), y inferences in levels, x inferences in differences, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(1 * (x+l_1_d_x))/(1-(l_1_d_y))"
  )

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  -  l_1_d_y * l_1_d_x  -  l_1_d_y**2 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, -1, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 0, 0, 0)
  ) 
  
  expect_equal( # test whether formula matches for LRM (step) - undefined
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    NULL
  )
  
})


test_that("mpoly formulae are correct (d.x = 1; d.y = 1)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), y inferences in differences, x inferences in differences, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "differences", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(1 * (x+l_1_d_x))/(1-(l_1_d_y))"
  )
  
  ####################################################################################
  # ADL(1,1), y inferences in differences, x inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  -  l_1_d_y * l_1_d_x  -  l_1_d_y**2 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, -1, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 0, 0, 0)
  ) 

  expect_equal( # test whether formula matches for LRM (step) - undefined combination
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    NULL
  )
  
  ####################################################################################
  # ADL(1,1), y inferences in levels, x inferences in differences, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  2 * l_1_d_y * l_1_d_x  +  2 * l_1_d_y**2 * x  +  3 * l_1_d_x  +  3 * l_1_d_y * x  +  4 * x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 2, 3, 4)
  ) 

  expect_equal( # test whether formula matches for LRM (step) - undefined
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    NULL
  )
  
  ####################################################################################
  # ADL(1,1), y inferences in levels, x inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  model_test_step <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE))
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$shocks[[4]], # to get mpoly obj as character, you need to print
    
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether formula matches for s = 3 (step) 
    # Function output   
    model_test_step$formulae[['s = 3']],
    
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )
  
  expect_equal( # test whether the binomials are as expected for s = 3 (step)
    # Function output
    # position = 4 because counter starts at s = 0 
    model_test_step$shocks[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  )

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(1 * (x+l_1_d_x))/(1-(l_1_d_y))"
  )

})

test_that("Fitted values evaluated are correct (d.x = 0; d.y = 0)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse_pred <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,                               	
                               shock.history = "pulse", 
                               inferences.y = "levels", inferences.x = "levels", 
                               effect.type = "fitted", prediction.values = list("x" = 1, "l_1_d_x" = 1), shock.size = 2,
                               s.limit = 3, 
                               return.plot = FALSE,
                               return.formulae = TRUE, return.data = TRUE))
  
  expect_equal( # baseline should just be the plain steady-state
    # Function output
    model_test_pulse_pred$estimates$GDRF[model_test_pulse_pred$estimates$Period == "baseline"],

    # Expected output:
    unname((coef(model)["(Intercept)"] + 
    	coef(model)["x"] * 1 + 
    	coef(model)["l_1_d_x"] * 1)/(1 - coef(model)["l_1_d_y"])),
    tolerance = 1e-6
  )

  expect_equal( # period 0 is the initial (scaled) shock
    # Function output
    model_test_pulse_pred$estimates$GDRF[model_test_pulse_pred$estimates$Period == "0"],

    # Expected output:
    unname((coef(model)["(Intercept)"] + 
    	coef(model)["x"] * 1 + 
    	coef(model)["l_1_d_x"] * 1)/(1 - coef(model)["l_1_d_y"]) +
    		coef(model)["x"]*2
    	),
    tolerance = 1e-6
  )

  expect_equal( # period 1 is the scaled shock + deteriorating old one
    # Function output
    model_test_pulse_pred$estimates$GDRF[model_test_pulse_pred$estimates$Period == "1"],

    # Expected output:
    unname((coef(model)["(Intercept)"] + 
    	coef(model)["x"] * 1 + 
    	coef(model)["l_1_d_x"] * 1)/(1 - coef(model)["l_1_d_y"]) +
    		coef(model)["x"]*2*coef(model)["l_1_d_y"] +
    		coef(model)["l_1_d_x"]*2
    	),
    tolerance = 1e-6
  )

  model_test_pulse_means <- suppressWarnings(GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,                               	
                               shock.history = "pulse", 
                               inferences.y = "levels", inferences.x = "levels", 
                               effect.type = "fitted", prediction.values = list("x" = 1), shock.size = 2,
                               s.limit = 3, 
                               return.plot = FALSE,
                               return.formulae = TRUE, return.data = TRUE))
  
  expect_equal( # baseline should just be the plain steady-state
    # Function output
    model_test_pulse_means$estimates$GDRF[model_test_pulse_means$estimates$Period == "baseline"],

    # Expected output:
    unname((coef(model)["(Intercept)"] + 
    	coef(model)["x"] * 1 + 
    	coef(model)["l_1_d_x"] * mean(toy.ts.interaction.data$l_1_d_x, na.rm = TRUE))/(1 - coef(model)["l_1_d_y"])),
    tolerance = 1e-6
  )

  expect_equal( # period 0 is the initial (scaled) shock
    # Function output
    model_test_pulse_means$estimates$GDRF[model_test_pulse_means$estimates$Period == "0"],

    # Expected output:
    unname((coef(model)["(Intercept)"] + 
    	coef(model)["x"] * 1 + 
    	coef(model)["l_1_d_x"] * mean(toy.ts.interaction.data$l_1_d_x, na.rm = TRUE))/(1 - coef(model)["l_1_d_y"]) +
    		coef(model)["x"]*2
    	),
    tolerance = 1e-6
  )

  expect_equal( # period 1 is the scaled shock + deteriorating old one
    # Function output
    model_test_pulse_means$estimates$GDRF[model_test_pulse_means$estimates$Period == "1"],

    # Expected output:
    unname((coef(model)["(Intercept)"] + 
    	coef(model)["x"] * 1 + 
    	coef(model)["l_1_d_x"] * mean(toy.ts.interaction.data$l_1_d_x, na.rm = TRUE))/(1 - coef(model)["l_1_d_y"]) +
    		coef(model)["x"]*2*coef(model)["l_1_d_y"] +
    		coef(model)["l_1_d_x"]*2
    	),
    tolerance = 1e-6
  ) 
  
})

test_that("Correct dimensions of output", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  # Three periods
  the.s <- 3
  model_test <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = the.s, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)

  expect_equal( # test if the number of binomials is correct
    # Function output
    length(model_test$shocks),
    
    # Expected output
    # account for s = 0
    the.s + 1
  )
  
  expect_equal( # test if the number of formulae is correct
    # Function output
    length(model_test$formulae),
    
    # Expected output
    # account for s = 0 and the LRM
    the.s + 1 + 1
  )  
  
  expect_equal( # test the dimensions of the estimates
    # Function output
    dim(model_test$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0 + 1 for LRM), 5 columns (Period, GDTE, SE, Lower, Upper)
    c(the.s + 1 + 1, 5),  
  )

  expect_equal( # test the names of the estimates
    # Function output
    names(model_test$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDTE, SE, Lower, Upper)
    c("Period", "GDRF", "SE", "Lower", "Upper"),  
  )
})


test_that("Function returns objects correctly (including errors)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  expect_error( # No plot, estimates, formulae 
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_y" = 1),
                   d.x = 2, 
                   d.y = 2,
                   shock.history = "step", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 3, 
                   return.plot = FALSE, 
                   return.formulae = FALSE,
                   return.data = FALSE),
                   
    # Expected error
    "Return at least one of the plot, the data"
  )
  
  model_test_allthree <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 3, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)

  expect_true( # are all three objects returned?
    # Function output
    all(c("plot", "estimates", "formulae") %in% names(model_test_allthree))
  )

  model_test_justplot <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 3, 
                                return.plot = TRUE, 
                                return.formulae = FALSE,
                                return.data = FALSE)

  expect_false( # is formulae or estimates returned?
    # Function output
    all(c("estimates", "formulae") %in% names(model_test_justplot))
  )

  model_test_noplot <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 3, 
                                return.plot = FALSE, 
                                return.formulae = TRUE,
                                return.data = TRUE)

  expect_false( # is plot returned?
    # Function output
    all(c("plot") %in% names(model_test_noplot))
  )

  model_test_noformulae <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 3, 
                                return.plot = TRUE, 
                                return.formulae = FALSE,
                                return.data = TRUE)

  expect_false( # is formulae returned?
    all(c("formulae") %in% names(model_test_noformulae))
  )

  model_test_nodata <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 3, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = FALSE)

  expect_false( # is data returned?
    all(c("estimates") %in% names(model_test_nodata))
  )

  model_test_justdata <- GDRF.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                y.vrbl = c("l_1_d_y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 3, 
                                return.plot = FALSE, 
                                return.formulae = FALSE,
                                return.data = TRUE)

  expect_false( # is data returned?
    all(c("plot", "formulae") %in% names(model_test_justdata))
  )
})

test_that("GDRF.adl.plot y-axis labels are correct", {

  model.adl   <- lm(y ~ l_1_y + x + l_1_x,     data = toy.ts.interaction.data)
  model.diffs <- lm(d_y ~ l_1_d_y + x + l_1_x, data = toy.ts.interaction.data)

  # discrete, pulse, cumulative = FALSE: GDRF[(s.limit, -1, plot.d.y, plot.d.x)]
  result.disc.pulse <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  cumulative = FALSE,
                  s.limit = 5,
                  return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)
  )

  expect_true( # y-axis label contains GDRF
    # Function output
    grepl("GDRF", deparse(result.disc.pulse$labels$y))
  )

  expect_false( # y-axis label does not contain Cumulative for non-cumulative
    # Function output
    grepl("Cumulative", deparse(result.disc.pulse$labels$y))
  )

  # discrete, pulse, cumulative = TRUE: Cumulative GDRF
  result.disc.pulse.cum <- GDRF.adl.plot(model = model.adl,
                                          x.vrbl = c("x" = 0, "l_1_x" = 1),
                                          y.vrbl = c("l_1_y" = 1),
                                          d.x = 0, d.y = 0,
                                          shock.history = "pulse",
                                          inferences.y = "levels", inferences.x = "levels",
                                          effect.type = "discrete",
                                          cumulative = TRUE,
                                          s.limit = 5,
                                          return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  expect_true( # y-axis label contains Cumulative for cumulative
    # Function output
    grepl("Cumulative", deparse(result.disc.pulse.cum$labels$y))
  )

  # discrete, custom shock history, cumulative = FALSE: generic label
  result.disc.custom <- GDRF.adl.plot(model = model.adl,
                                       x.vrbl = c("x" = 0, "l_1_x" = 1),
                                       y.vrbl = c("l_1_y" = 1),
                                       d.x = 0, d.y = 0,
                                       shock.history = c(1, 1, 1, 0, 0, 1),
                                       inferences.y = "levels", inferences.x = "levels",
                                       effect.type = "discrete",
                                       cumulative = FALSE,
                                       s.limit = 5,
                                       return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  expect_true( # custom shock history produces generic label
    # Function output
    grepl("Discrete Effect of Shock History", deparse(result.disc.custom$labels$y))
  )

  # discrete, custom shock history, cumulative = TRUE: cumulative generic label
  result.disc.custom.cum <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = c(1, 1, 1, 0, 0, 1),
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  cumulative = TRUE,
                  s.limit = 5,
                  return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)
  )

  expect_true( # custom + cumulative produces cumulative generic label
    # Function output
    grepl("Cumulative Discrete Effect of Shock History", deparse(result.disc.custom.cum$labels$y))
  )

  # fitted, step, cumulative = FALSE: Fitted Values label
  result.fitted.step <- GDRF.adl.plot(model = model.adl,
                                       x.vrbl = c("x" = 0, "l_1_x" = 1),
                                       y.vrbl = c("l_1_y" = 1),
                                       d.x = 0, d.y = 0,
                                       shock.history = "step",
                                       inferences.y = "levels", inferences.x = "levels",
                                       effect.type = "fitted",
                                       baseline.y = 5,
                                       shock.size = 1,
                                       cumulative = FALSE,
                                       s.limit = 5,
                                       return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  expect_true( # fitted label contains Fitted Values
    # Function output
    grepl("Fitted Values", deparse(result.fitted.step$labels$y))
  )

  expect_false( # fitted non-cumulative label does not contain Cumulative
    # Function output
    grepl("Cumulative", deparse(result.fitted.step$labels$y))
  )

  # fitted, custom shock, cumulative = TRUE: cumulative fitted generic label
  result.fitted.custom.cum <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = c(1, 1, 1, 0, 0, 1),
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  shock.size = 1,
                  cumulative = TRUE,
                  s.limit = 5,
                  return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)
  )

  expect_true( # fitted + custom + cumulative produces cumulative fitted generic label
    # Function output
    grepl("Cumulative Fitted Values of Shock History", deparse(result.fitted.custom.cum$labels$y))
  )

})


test_that("GDRF.adl.plot x-axis label is correct", {

  model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result <- suppressWarnings(
    GDRF.adl.plot(model = model.adl,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0, d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels", inferences.x = "levels",
                  effect.type = "discrete",
                  s.limit = 5,
                  return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)
  )

  expect_true( # x-axis label contains expected text
    # Function output
    grepl("Number of Periods Since Initial Shock", result$labels$x)
  )

})




















# test_that("GDRF.adl.plot plot object is correct", {

  # skip_if_not_installed("vdiffr")

  # model.adl <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # p <- GDRF.adl.plot(model = model.adl,
                     # x.vrbl = c("x" = 0, "l_1_x" = 1),
                     # y.vrbl = c("l_1_y" = 1),
                     # d.x = 0, d.y = 0,
                     # shock.history = "pulse",
                     # inferences.y = "levels", inferences.x = "levels",
                     # effect.type = "discrete",
                     # s.limit = 5,
                     # return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  # expect_no_error( # plot builds without error
    # # Function output
    # print(p)
  # )

  # vdiffr::expect_doppelganger( # plot matches snapshot
    # # Snapshot name
    # "gdrf-adl-pulse-discrete",

    # # Function output
    # p
  # )

  # p.lrm <- GDRF.adl.plot(model = model.adl,
                          # x.vrbl = c("x" = 0, "l_1_x" = 1),
                          # y.vrbl = c("l_1_y" = 1),
                          # d.x = 0, d.y = 0,
                          # shock.history = "step",
                          # inferences.y = "levels", inferences.x = "levels",
                          # effect.type = "discrete",
                          # s.limit = 5,
                          # return.plot = TRUE, return.formulae =                           FALSE, return.data = FALSE)

  # expect_no_error( # plot with LRM builds without error
    # # Function output
    # print(p.lrm)
  # )

  # vdiffr::expect_doppelganger( # plot with LRM matches snapshot
    # # Snapshot name
    # "gdrf-adl-step-discrete-lrm",

    # # Function output
    # p.lrm
  # )

  # p.fitted <- GDRF.adl.plot(model = model.adl,
                             # x.vrbl = c("x" = 0, "l_1_x" = 1),
                             # y.vrbl = c("l_1_y" = 1),
                             # d.x = 0, d.y = 0,
                             # shock.history = "step",
                             # inferences.y = "levels", inferences.x = "levels",
                             # effect.type = "fitted",
                             # baseline.y = 5,
                             # shock.size = 1,
                             # s.limit = 5,
                             # return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  # expect_no_error( # fitted plot builds without error
    # # Function output
    # print(p.fitted)
  # )

  # vdiffr::expect_doppelganger( # fitted plot matches snapshot
    # # Snapshot name
    # "gdrf-adl-step-fitted-baseline5",

    # # Function output
    # p.fitted
  # )

# })




# # test_that("Correct Plot: GDRF.adl.plot", {
  # local_edition(3)
  # model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)
  
  # p <- GDRF.adl.plot(model = model, 
                                   # x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                   # y.vrbl = c("l_1_d_y" = 1),
                                   # d.x = 0, 
                                   # d.y = 0,
                                   # shock.history = "pulse", 
                                   # inferences.y = "levels", 
                                   # inferences.x = "levels",
                                   # s.limit = 3, 
                                   # return.plot = TRUE,
                                   # return.formulae = FALSE)
  # expect_no_error(p) # Check for errors during plot generation
  # vdiffr::expect_doppelganger("gdrfadlpulse", p) # Test the plot
# })

