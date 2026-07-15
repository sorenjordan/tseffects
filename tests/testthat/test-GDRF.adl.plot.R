test_that("GDRF.adl.plot errors and warnings are issued correctly", {  
  # run a model to use for errors
  model <- lm(d_2_y ~ l_1_d_2_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function output
    GDRF.adl.plot(model = model, 
                   #x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
                   
    # Expected output
    "Variables in shock history terms \\(x and possibly y\\) must be specified through x.vrbl and"
  ) 
  
  expect_warning( # no y.vrbl
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   # y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
                   
    # Expected output
    "No y.vrbl in shock history terms implies a static or finite dynamics model: are you sure you want this?"
  )
  
  expect_error( # no d.x
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   # d.x = 1, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history terms must be specified"
  )
  
  expect_error( # no d.y
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1, 
                   # d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history terms must be specified"
  )
  
  expect_error( # d.x must be integer
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1.82, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history terms \\(d.x"
  )
  
  expect_error( # d.y must be integer
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1, 
                   d.y = 2.89,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history terms \\(d.x"
  )
    
  expect_error( # invalid inference type specified - y
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "the doctor", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Invalid inferences.y. The response function for y" 
  )

  expect_error( # invalid inference type specified - x
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "the Rani",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Invalid inferences.x. The shock history" 
  )
  
  expect_error( # inference type mismatch: d.y/inferences differences
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "The response function for y cannot be in" 
  )
  
  expect_error( # inference type mismatch: d.x/inferences differences
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "differences",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "The shock history for x cannot be in a higher" 
  )
  
  expect_error( # x vrbl not named vector
    # Function output
    GDRF.adl.plot(model = model, 
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
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x", "l_1_d_x"),
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
 
  expect_error( # y vrbl not named vector
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c(1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl values not given
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y"),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "y.vrbl should be a named vector"
  )

  expect_error( # invalid se.type
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("Time Lord" = 0, "Time Lady" = 1),
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pte", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   se.type = "woof",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Invalid se.type."
  )

  expect_error( # x vrbl not in the model
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("Time Lord" = 0, "Time Lady" = 1),
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pte", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # y.vrbl not in the model
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("Time Tot" = 1),
                   d.x = 1, 
                   d.y = 2,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "y.vrbl not present in estimated model" 
  )

  expect_error( # no shock.history
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = NULL, 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Shock history type must be specified" 
  )
  
  expect_error( # shock.history is not accepted input
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "the Master", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Invalid shock.history. shock.history must be one of pulse or step" 
  )
  
  expect_error( # shock.history is not accepted input
    # Function output
    GDRF.adl.plot(model = model, 
                   x.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = 2.5, 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected output
    "Invalid shock.history. shock.history must be one of pulse or step" 
  )  

  # The below are all new with the fitted option
  model.fitted <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  expect_error( # invalid effect.type
      # Function output	  
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "cough",
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

    # Expected output
    "Invalid effect.type. effect.type must be one of marginal or fitted"
  )

  expect_error( # marginal + prediction.values
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "marginal",
                  prediction.values = list("x" = 1, "l_1_x" = 1),
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Do not supply prediction.values when effect.type = 'marginal'"
  )

  expect_error( # marginal + baseline.y
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "marginal",
                  baseline.y = 5,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Do not supply baseline.y when effect.type = 'marginal'"
  )

  expect_error( # marginal + baseline.y.se
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "marginal",
                  baseline.y.se = 1,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Do not supply baseline.y.se when effect.type = 'marginal'"
  )

  expect_error( # marginal + shock.size
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "marginal",
                  shock.size = 2,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Do not supply shock.size when effect.type = 'marginal'"
  )

  expect_error( # fitted + prediction.values not a list
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = c("x" = 1, "l_1_x" = 1),
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "If using prediction.values, it must be a list"
  )

  expect_error( # fitted + baseline.y not numeric
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = "cough",
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "If providing a baseline.y, it must be numeric"
  )

  expect_error( # fitted + baseline.y length > 1
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = c(1, 2),
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Only provide a single baseline.y value"
  )

  expect_error( # fitted + baseline.y.se not numeric
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 2,
                  baseline.y.se = "cough",
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output                 
    "If providing a baseline.y.se, it must be numeric"
  )

  expect_error( # fitted + baseline.y.se length > 1
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 2,
                  baseline.y.se = c(1, 2),
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Only provide a single baseline.y.se value"
  )

  expect_error( # fitted + shock.size not numeric
      # Function output
    GDRF.adl.plot(model = model.fitted,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  shock.size = "cough",
                  baseline.y = 0,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "shock.size must be numeric"
  )
})


test_that("GDRF.adl.plot effect.type combination warnings are issued correctly", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
  model.diffs <- lm(d_y ~ l_1_d_y + x + l_1_x, data = toy.ts.interaction.data)

  expect_warning( # fitted + d.y = 0 + both baseline.y and prediction.values
      # Function output
    GDRF.adl.plot(model = model,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = 5,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Both baseline.y and prediction.values supplied; baseline.y takes precedence and prediction.values will be ignored"
  )

  expect_warning( # fitted + d.y = 0 + prediction.values only (differenced variable reminder)
  # Function output
    GDRF.adl.plot(model = model,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_y" = 1),
                  d.x = 0,
                  d.y = 0,
                  shock.history = "pulse",
                  inferences.y = "levels",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = NULL,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "If any differenced variables are included in the model, ensure they are set to 0 in prediction.values"
  )

  expect_warning( # fitted + d.y = 1 + prediction.values (ignored)
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
                  prediction.values = list("x" = 0, "l_1_x" = 0),
                  baseline.y = 5,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "prediction.values is ignored when d.y > 0"
  )

  expect_warning( # fitted + d.y = 1 + inferences.y = differences + non-zero baseline.y
      # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0,
                  d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "differences",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  baseline.y = 5,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE),

			      # Expected output
    "Assuming anything other than baseline.y = 0 when inferences.y = 'differences' suggests the model is unstable"
  )

  expect_warning( # fitted + d.y = 1 + inferences.y = differences + shock.size = 1 (redundant)
  # Function output
    GDRF.adl.plot(model = model.diffs,
                  x.vrbl = c("x" = 0, "l_1_x" = 1),
                  y.vrbl = c("l_1_d_y" = 1),
                  d.x = 0,
                  d.y = 1,
                  shock.history = "pulse",
                  inferences.y = "differences",
                  inferences.x = "levels",
                  effect.type = "fitted",
                  shock.size = 1,
                  s.limit = 3,
                  return.plot = TRUE,
                  return.formulae = TRUE,
					baseline.y = 0),
			      # Expected output
    "effect.type = 'fitted' with inferences.y = 'differences' and shock.size = 1 is identical to effect.type = 'marginal'"
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
})

test_that("GDRF.adl.plot fitted value output is correct (d.y = 0, baseline.y supplied)", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.marginal <- GDRF.adl.plot(model = model,
                                   x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   d.x = 0,
                                   d.y = 0,
                                   shock.history = "pulse",
                                   inferences.y = "levels",
                                   inferences.x = "levels",
                                   effect.type = "marginal",
                                   s.limit = 3,
                                   return.plot = TRUE,
                                   return.formulae = TRUE,
                                   return.data = TRUE)

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

  # fitted values should differ from marginal effects
  expect_false(identical(result.marginal$estimates$GDRF, result.fitted$estimates$GDRF))

  # fitted values should be offset from marginal effects by approximately baseline.y, ignoring the baseline
  expect_equal(
    result.fitted$estimates$GDRF[-1] - result.marginal$estimates$GDRF,
    rep(5, nrow(result.marginal$estimates)),
    tolerance = 1e-6
  )

  # SE should be the same for fitted and marginal when baseline.y.se = 0, ignoring the baseline
  expect_equal(
    result.fitted$estimates$SE[-1],
    result.marginal$estimates$SE,
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

test_that("GDRF.adl.plot baseline.y.se is added in quadrature correctly", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.nose <- GDRF.adl.plot(model = model,
                               x.vrbl = c("x" = 0, "l_1_x" = 1),
                               y.vrbl = c("l_1_y" = 1),
                               d.x = 0,
                               d.y = 0,
                               shock.history = "pulse",
                               inferences.y = "levels",
                               inferences.x = "levels",
                               effect.type = "fitted",
                               baseline.y = 5,
                               baseline.y.se = 0,
                               shock.size = 1,
                               s.limit = 3,
                               return.plot = FALSE,
                               return.formulae = FALSE,
                               return.data = TRUE)

  result.withse <- GDRF.adl.plot(model = model,
                                 x.vrbl = c("x" = 0, "l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 d.x = 0,
                                 d.y = 0,
                                 shock.history = "pulse",
                                 inferences.y = "levels",
                                 inferences.x = "levels",
                                 effect.type = "fitted",
                                 baseline.y = 5,
                                 baseline.y.se = 2,
                                 shock.size = 1,
                                 s.limit = 3,
                                 return.plot = FALSE,
                                 return.formulae = FALSE,
                                 return.data = TRUE)

  expect_equal( # SE with baseline.y.se should equal sqrt(SE^2 + baseline.y.se^2)
    # Function output
    result.withse$SE,
	
    # Expected output
    sqrt(result.nose$SE^2 + 2^2),
    tolerance = 1e-6
  )

  expect_false( # CIs should differ when baseline.y.se is added
    # Function output
    identical(result.nose$Lower, result.withse$Lower)
  )
})

test_that("GDRF.adl.plot LRM is suppressed for effect.type = fitted", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  result.marginal <- GDRF.adl.plot(model = model,
                                   x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   d.x = 0,
                                   d.y = 0,
                                   shock.history = "step",
                                   inferences.y = "levels",
                                   inferences.x = "levels",
                                   effect.type = "marginal",
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

  expect_true( # marginal effect with step should include LRM
    # Function output
    "LRM" %in% names(result.marginal$formulae)
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


test_that("Warning for . issued correctly", {
  
  toy.ts.interaction.data$d.x <- toy.ts.interaction.data$d_x
  
  
  model_warning <- lm(d_2_y ~ l_1_d_2_y + d.x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_warning( # Changing _ to . 
    # Function output
    GDRF.adl.plot(model = model_warning, 
                   x.vrbl = c("d.x" = 0, "l_1_d_x" = 1), 
                   y.vrbl = c("l_1_d_2_y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   shock.history = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   s.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),

    # Expected warning
    "Variable names containing . replaced with \\_"
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
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(x+l_1_d_x)"
  )

})




test_that("mpoly formulae are correct (d.x = 0; d.y = 0)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
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
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(x+l_1_d_x)/(1-(l_1_d_y))"
  )
 
})


test_that("mpoly formulae are correct (d.x = 0; d.y = 1)", { 
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # ADL(1,1), y inferences in differences, x inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "differences", 
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
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  )  

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(x+l_1_d_x)/(1-(l_1_d_y))"
  )

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 0, 
                               d.y = 1,
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
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
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
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
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
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(x+l_1_d_x)/(1-(l_1_d_y))"
  )

  ####################################################################################
  # ADL(1,1), both inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
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
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  -  l_1_d_y * l_1_d_x  -  l_1_d_y**2 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
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
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "differences", 
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
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  ) 

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(x+l_1_d_x)/(1-(l_1_d_y))"
  )
  
  ####################################################################################
  # ADL(1,1), y inferences in differences, x inferences in levels, pulse and step
  ####################################################################################  
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "step", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  expect_equal( # test whether formula matches for s = 3 (pulse)
    # Function output    
    model_test_pulse$formulae[['s = 3']],

    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  -  l_1_d_y * l_1_d_x  -  l_1_d_y**2 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
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
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
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
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3 (pulse)
    # Function output   
    # position = 4 because counter starts at s = 0 
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
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
  model_test_pulse <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               shock.history = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               s.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- GDRF.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                               y.vrbl = c("l_1_d_y" = 1),
                               d.x = 1, 
                               d.y = 1,
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
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    
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
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
  
    # Expected output
    c(1, 1, 1, 1)
  )

  expect_equal( # test whether formula matches for LRM (step) 
    # Function output   
    model_test_step$formulae[["LRM"]],
    
    # Expected output
    "(x+l_1_d_x)/(1-(l_1_d_y))"
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
    length(model_test$binomials),
    
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

test_that("Correct Plot: GDRF.adl.plot", {
  local_edition(3)
  model <- lm(d_y ~ l_1_d_y + x + l_1_d_x, data = toy.ts.interaction.data)
  
  p <- GDRF.adl.plot(model = model, 
                                   x.vrbl = c("x" = 0, "l_1_d_x" = 1), 
                                   y.vrbl = c("l_1_d_y" = 1),
                                   d.x = 0, 
                                   d.y = 0,
                                   shock.history = "pulse", 
                                   inferences.y = "levels", 
                                   inferences.x = "levels",
                                   s.limit = 3, 
                                   return.plot = TRUE,
                                   return.formulae = FALSE)
  expect_no_error(p) # Check for errors during plot generation
  # expect_doppelganger("gdrfadlpulse", p) # Test the plot
  # expect_snapshot("gdrfadlpulse")
})

