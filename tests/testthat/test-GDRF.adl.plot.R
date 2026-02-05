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
  expect_doppelganger("gdrfadlpulse", p) # Test the plot
  expect_snapshot("gdrfadlpulse")
})

