test_that("GDRF.gecm.plot errors and warnings are issued correctly", {  
  
  # run a model to use for errors
  model <- lm(d_2_y ~ l_1_d_2_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function output
    GDRF.gecm.plot(model = model, 
                    # x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in shock history terms \\(x and y\\) and lagged differences"
  ) 
  
  expect_error( # no y.vrbl
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    #y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in shock history terms \\(x and y\\) and lagged differences"
  )
  
  expect_error( # no x.d.vrbl
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    # x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in shock history terms \\(x and y\\) and lagged differences"
  ) 
  
  expect_error( # no y.d.vrbl
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    # y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in shock history terms \\(x and y\\) and lagged differences"
  )

  expect_error( # no x.vrbl.d.x
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    # x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history terms"  
  ) 
  
  expect_error( # no y.vrbl.d.y
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    #y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history terms"  
  )
  
  expect_error( # no x.d.vrbl.d.x
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    # x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history must"    
  ) 
  
  expect_error( # no y.d.vrbl.d.y
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    # y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history must"    
  )

  expect_error( # x.vrbl.d.x must be integer
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0.753654, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history term \\(x.vrbl.d.x and y.vrbl.d.y\\)"  
  )
  
  expect_error( # y.vrbl.d.y must be integer
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 74.645,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in shock history term \\(x.vrbl.d.x and y.vrbl.d.y\\)"  
  )
    
  expect_error( # x.d.vrbl.d.x must be integer
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1.24, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history term \\(x.d.vrbl.d.x"  
  )
  
  expect_error( # y.d.vrbl.d.y must be integer
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 3.14,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history term \\(x.d.vrbl.d.x"  
  )

  expect_error( # x vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c(1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x"), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c(1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
 
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y"),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x.d.vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c(0, 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x", "l_1_d_x"), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c(1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y"),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl.d.order-x.vrbl.d.order: difference of ordering exceeds 1
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 3, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # y.d.vrbl.d.order-y.vrbl.d.order: difference of ordering exceeds 1
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 9,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # does GECM include more than first lag of x?
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1, "l_2_x" = 2), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
    
  expect_error( # does GECM include more than first lag of y?
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1, "l_2_y" = 2),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # does GECM include more than first lag of x?
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 2), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # does GECM include more than first lag of y?
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 2),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # invalid inferences.x
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "differences", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, inferences regarding the shock history of x"
  )

  expect_error( # invalid inferences.y
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "differences",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, inferences regarding the shock history of x"
  )

  expect_error( # invalid se.type
    # Function output
      GDRF.gecm.plot(model = model, 
                      x.vrbl = c("l_x" = 1), 
                      y.vrbl = c("l_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      shock.history = "ste", 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      s.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE,
                      se.type = "Cyberman"),
      
      # Expected error
      "Invalid se.type. se.type must be an accepted" 
  )
  
  expect_error( # x.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("weeping angel" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # x.d.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("l_1_d_2_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "Sontaran" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "x.d.vrbl not present in estimated model" 
  )
  
  expect_error( # y.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("androzani" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "y.vrbl not present in estimated model"
  )
  
  expect_error( # y.d.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("l_1_d_2_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("Rassilon" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "y.d.vrbl not present in estimated model" 
  )
  
  expect_error( # shock.history is invalid word
    # Function output
      GDRF.gecm.plot(model = model, 
                      x.vrbl = c("l_1_d_x" = 1), 
                      y.vrbl = c("l_1_d_2_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_2_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      shock.history = "Daleks", 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      s.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      
      # Expected error
      "Invalid shock.history. shock.history must be one of pulse or step"
  )

  expect_error( # shock.history is not integer
    # Function output
      GDRF.gecm.plot(model = model, 
                      x.vrbl = c("l_1_d_x" = 1), 
                      y.vrbl = c("l_1_d_2_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_2_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      shock.history = 3.5, 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      s.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      
      # Expected error
      "Invalid shock.history. shock.history must be one of pulse or step"
  )
  
})

test_that("Warning for . issued correctly", {
  
  toy.ts.interaction.data$d.x <- toy.ts.interaction.data$d_x
  
  model_warning <- lm(d_2_y ~ l_1_d_2_y + d.x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_warning( # Changing _ to . 
    # Function
    GDRF.gecm.plot(model = model_warning, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("l_1_d_2_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_2_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    shock.history = "step", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    s.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected warning
    "Variable names containing . replaced with \\_"
  )
})


test_that("mpoly formulae are correct (GECM(1,1))", { 
  
  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)

  ####################################################################################
  # GECM(1,1), both inferences in levels, pulse and step
  ####################################################################################
  the.s <- 2
  
  model_test_pte <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "pulse", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = the.s, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)
  
  model_test_ste <- GDRF.gecm.plot(model = model, 
                                    x.vrbl = c("l_1_x" = 1), 
                                    y.vrbl = c("l_1_y" = 1),
                                    x.vrbl.d.x = 0, 
                                    y.vrbl.d.y = 0,
                                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                    y.d.vrbl = c("l_1_d_y" = 1),
                                    x.d.vrbl.d.x = 1, 
                                    y.d.vrbl.d.y = 1,
                                    shock.history = "step", 
                                    inferences.y = "levels", 
                                    inferences.x = "levels",
                                    s.limit = the.s, 
                                    return.plot = TRUE, 
                                    return.formulae = TRUE,
                                    return.data = TRUE)

  expect_equal( # test whether formula matches for s = 2 (pulse)
    # Function output    
    model_test_pte$formulae[['s = 2']],
    
    # Expected output
    "l_1_y * l_1_x  +  l_1_y * l_1_d_x  +  l_1_y**2 * d_x  +  2 * l_1_y * d_x * l_1_d_y  +  l_1_x * l_1_d_y  +  l_1_d_x * l_1_d_y  +  d_x * l_1_d_y**2  +  l_1_x  +  l_1_y * d_x "
  )   
  
  expect_equal( # test whether formula matches for s = 2 (step)
    # Function output    
    model_test_ste$formulae[['s = 2']],

    # Expected output
    "l_1_y * l_1_x  +  l_1_y * l_1_d_x  +  l_1_y**2 * d_x  +  2 * l_1_y * d_x * l_1_d_y  +  l_1_x * l_1_d_y  +  l_1_d_x * l_1_d_y  +  d_x * l_1_d_y**2  +  2 * l_1_x  +  2 * l_1_y * d_x  +  l_1_d_x  +  d_x * l_1_d_y  +  d_x "
  )
})


test_that("Correct dimensions of output", { 
  
  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)

  ####################################################################################
  # GECM(1,1), both inferences in levels, pulse and step
  ####################################################################################
  the.s <- 2
  
  model_test_pte <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "pulse", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = the.s, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)

  model_test_ste <- GDRF.gecm.plot(model = model, 
                                    x.vrbl = c("l_1_x" = 1), 
                                    y.vrbl = c("l_1_y" = 1),
                                    x.vrbl.d.x = 0, 
                                    y.vrbl.d.y = 0,
                                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                    y.d.vrbl = c("l_1_d_y" = 1),
                                    x.d.vrbl.d.x = 1, 
                                    y.d.vrbl.d.y = 1,
                                    shock.history = "step", 
                                    inferences.y = "levels", 
                                    inferences.x = "levels",
                                    s.limit = the.s, 
                                    return.plot = TRUE, 
                                    return.formulae = TRUE,
                                    return.data = TRUE)
  
  expect_equal( # test the names of the estimates (pulse)
    # Function output
    names(model_test_pte$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDRF, SE, Lower, Upper)
    c("Period", "GDRF", "SE", "Lower", "Upper"),  
  )  
  
  expect_equal( # test the names of the estimates (step)
    # Function output
    names(model_test_ste$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDRF, SE, Lower, Upper)
    c("Period", "GDRF", "SE", "Lower", "Upper"),  
  )  

  expect_equal( # test the dimensions of the estimates (pulse)
    # Function output
    dim(model_test_pte$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDRF, SE, Lower, Upper)
    c(the.s + 1, 5),  
  )

  expect_equal( # test the dimensions of the estimates (step)
    # Function output
    dim(model_test_ste$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0 + 1 for LRM), 5 columns (Period, GDRF, SE, Lower, Upper)
    c(the.s + 1 + 1, 5),  
  )
})


test_that("Function returns objects correctly (including errors)", { 

  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)

  expect_error( # are all three objects returned?
    model_test_allthree <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2, 
                                return.plot = FALSE, 
                                return.formulae = FALSE,
                                return.data = FALSE),

    # Function output
    "Return at least one of the plot, the data"
  )  
	  
  model_test_allthree <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)

  expect_true( # are all three objects returned?
    # Function output
    all(c("plot", "estimates", "formulae") %in% names(model_test_allthree))
  )  


  model_test_justplot <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2,
                                return.formulae = FALSE, 
                                return.plot = TRUE,
                                return.data = FALSE)

  expect_false( # is formulae or estimates returned?
    # Function output
    all(c("estimates", "formulae") %in% names(model_test_justplot))
  )
    
  model_test_noplot <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2,
                                return.plot = FALSE, 
                                return.data = TRUE,
                                return.formulae = TRUE)

  expect_false( # is plot returned?
    # Function output
    all(c("plot") %in% names(model_test_noplot))
  )

  model_test_noformulae <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2,
                                return.formulae = FALSE, 
                                return.plot = TRUE,
                                return.data = TRUE)

  expect_false( # is formulae returned?
    all(c("formulae") %in% names(model_test_noformulae))
  )

  model_test_nodata <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2, 
                                return.formulae = TRUE, 
                                return.plot = TRUE,
                                return.data = FALSE)

  expect_false( # is data returned?
    all(c("estimates") %in% names(model_test_nodata))
  )
    
  model_test_justdata <- GDRF.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                shock.history = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                s.limit = 2, 
                                return.formulae = FALSE, 
                                return.plot = FALSE,
                                return.data = TRUE)

  expect_false( # is data returned?
    all(c("plot", "formulae") %in% names(model_test_justdata))
  )
})

test_that("Correct Plot: GDRF.gecm.plot", {
  local_edition(3)
  	
  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)
  one <- GDRF.gecm.plot(model = model, 
                       x.vrbl = c("l_1_x" = 1), 
                       y.vrbl = c("l_1_y" = 1),
                       x.vrbl.d.x = 0, 
                       y.vrbl.d.y = 0,
                       x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                       y.d.vrbl = c("l_1_d_y" = 1),
                       x.d.vrbl.d.x = 1, 
                       y.d.vrbl.d.y = 1,
                       shock.history = "pulse", 
                       inferences.y = "levels", 
                       inferences.x = "levels",
                       s.limit = 2,  
                       return.formulae = FALSE, 
                       return.plot =  TRUE,
                       return.data = FALSE)
  expect_no_error(one) 
  expect_doppelganger("gdrfgecmpulse", one)
  expect_snapshot("gdrfgecmpulse")
  
  two <- GDRF.gecm.plot(model = model, 
                       x.vrbl = c("l_1_x" = 1), 
                       y.vrbl = c("l_1_y" = 1),
                       x.vrbl.d.x = 0, 
                       y.vrbl.d.y = 0,
                       x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                       y.d.vrbl = c("l_1_d_y" = 1),
                       x.d.vrbl.d.x = 1, 
                       y.d.vrbl.d.y = 1,
                       shock.history = "step", 
                       inferences.y = "levels", 
                       inferences.x = "levels",
                       s.limit = 2,  
                       return.formulae = FALSE, 
                       return.plot =  TRUE,
                       return.data = FALSE)
  expect_no_error(two) 
  expect_doppelganger("gdrfgecmstep", two)
  expect_snapshot("gdrfgecmstep")
})