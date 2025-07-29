test_that("Errors are issued correctly", {  
  
  # run a model to use for errors
  model <- lm(d_2_y ~ l_1_d_2_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function output
    ts.ci.gecm.plot(model = model, 
                    # x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in treatment effects term \\(x and y\\) and lagged differences"
  ) 
  
  expect_error( # no y.vrbl
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    #y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in treatment effects term \\(x and y\\) and lagged differences"
  )
  
  expect_error( # no x.d.vrbl
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    # x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Variables in treatment effects term \\(x and y\\) and lagged differences"
  ) 
  
  expect_error( # no y.d.vrbl
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    # y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "lagged differences must be specified through x.vrbl, y.vrbl, x.d.vrbl, and y.d.vrbl for a GECM"
  )

  expect_error( # no x.vrbl.d.x
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    # x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in treatment effects term"  
  ) 
  
  expect_error( # no y.vrbl.d.y
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    #y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in treatment effects term"  
  )
  
  expect_error( # no x.d.vrbl.d.x
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    # x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences \\(x and y\\) must be specified through x.d.vrbl.d.x"
  ) 
  
  expect_error( # no y.d.vrbl.d.y
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    # y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences \\(x and y\\) must be specified through x.d.vrbl.d.x"
  )
  
  expect_error( # x.d.vrbl.d.x must be integer
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1.24, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences \\(x.d.vrbl.d.x and y.d.vrbl.d.y\\) must be an integer"  
  )
  
  expect_error( # y.d.vrbl.d.y must be integer
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 3.14,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences \\(x.d.vrbl.d.x and y.d.vrbl.d.y\\) must be an integer"
  )
  
  expect_error( # x.vrbl.d.x must be integer
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0.753654, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in treatment effects term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an"  
  )
  
  expect_error( # y.vrbl.d.y must be integer
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 74.645,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "Order of differencing of variables in treatment effects term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an"  
  )
  
  expect_error( # x vrbl not named vector
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c(1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected output
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl vector has no values
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x"), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl not named vector
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c(1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
 
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl vector has no values
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y"),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x.d.vrbl not named vector
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c(0, 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl vrbl vector has no values
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x", "l_1_d_x"), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl not named vector
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c(1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl vrbl vector has no values
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y"),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl.d.order-x.vrbl.d.order: difference of ordering exceeds 1
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 3, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # y.d.vrbl.d.order-y.vrbl.d.order: difference of ordering exceeds 1
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 9,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),

    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # does GECM include more than first lag of y?
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 1), 
                    y.vrbl = c("l_y" = 2),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # does GECM include more than first lag of x?
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 9), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # does GECM include more than first lag of x?
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 0, "d_x" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # does GECM include more than first lag of y?
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_x" = 0), 
                    y.vrbl = c("l_y" = 1, "l_1_d_y" = 2),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )

 expect_error( # te.type is accepted input
    # Function output
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l_x" = 1), 
                      y.vrbl = c("l_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "Daleks", 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      
      # Expected error
      "Invalid te.type. te.type must be one of pte \\(pulse\\) or ste \\(step\\)"
  )
    
  expect_error( # are inferences for y requested in levels?
    # Function output
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l_x" = 1), 
                      y.vrbl = c("l_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "ste", 
                      inferences.y = "New Jersey", 
                      inferences.x = "levels",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
     
      # Expected error
      "In a GECM, causal inferences regarding the treatment effect of x on y are automatically recovered in" 
  )
  
  expect_error( # are inferences for y requested in levels?
    # Function output
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l_x" = 1), 
                      y.vrbl = c("l_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "ste", 
                      inferences.y = "levels", 
                      inferences.x = "Pennsylvania",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      
      # Expected error
      "In a GECM, causal inferences regarding the treatment effect of x on y are automatically recovered in"
  )
  
  expect_error( # invalid se.type
    # Function output
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l_x" = 1), 
                      y.vrbl = c("l_y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                      y.d.vrbl = c("l_1_d_y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "ste", 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE,
                      se.type = "Cyberman"),
      
      # Expected error
      "Invalid se.type. se.type must be an accepted" 
  )
  
  expect_error( # x.vrbl not in model
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("weeping angel" = 1), 
                    y.vrbl = c("l_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # x.d.vrbl not in model
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("l_1_d_2_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "Sontaran" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "x.d.vrbl not present in estimated model" 
  )
  
  expect_error( # y.vrbl not in model
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("androzani" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "y.vrbl not present in estimated model"
  )
  
  expect_error( # y.d.vrbl not in model
    # Function output
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("l_1_d_2_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("Rassilon" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    
    # Expected error
    "y.d.vrbl not present in estimated model" 
  )
})


test_that("Warning for . issued correctly", {
  
  toy.ts.interaction.data$d.x <- toy.ts.interaction.data$d_x
  
  model_warning <- lm(d_2_y ~ l_1_d_2_y + d.x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_warning( # Changing _ to . 
    # Function
    ts.ci.gecm.plot(model = model_warning, 
                    x.vrbl = c("l_1_d_x" = 1), 
                    y.vrbl = c("l_1_d_2_y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l_1_d_x" = 1), 
                    y.d.vrbl = c("l_1_d_2_y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
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
  the.h <- 2
  
  model_test_pte <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "pte", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = the.h, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)
  
  model_test_ste <- ts.ci.gecm.plot(model = model, 
                                    x.vrbl = c("l_1_x" = 1), 
                                    y.vrbl = c("l_1_y" = 1),
                                    x.vrbl.d.x = 0, 
                                    y.vrbl.d.y = 0,
                                    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                    y.d.vrbl = c("l_1_d_y" = 1),
                                    x.d.vrbl.d.x = 1, 
                                    y.d.vrbl.d.y = 1,
                                    te.type = "ste", 
                                    inferences.y = "levels", 
                                    inferences.x = "levels",
                                    h.limit = the.h, 
                                    return.plot = TRUE, 
                                    return.formulae = TRUE,
                                    return.data = TRUE)
  
  
  
  expect_equal( # test whether formula matches for h = 2 (pulse)
    # Function output    
    model_test_pte$formulae[['h = 2']],
    
    # Expected output
    "l_1_y * l_1_x  +  l_1_y * l_1_d_x  +  l_1_y**2 * d_x  +  2 * l_1_y * d_x * l_1_d_y  +  l_1_x * l_1_d_y  +  l_1_d_x * l_1_d_y  +  d_x * l_1_d_y**2  +  l_1_x  +  l_1_y * d_x "
  )   
  
  expect_equal( # test whether formula matches for h = 2 (step)
    # Function output    
    model_test_ste$formulae[['h = 2']],

    # Expected output
    "l_1_y * l_1_x  +  l_1_y * l_1_d_x  +  l_1_y**2 * d_x  +  2 * l_1_y * d_x * l_1_d_y  +  l_1_x * l_1_d_y  +  l_1_d_x * l_1_d_y  +  d_x * l_1_d_y**2  +  2 * l_1_x  +  2 * l_1_y * d_x  +  l_1_d_x  +  d_x * l_1_d_y  +  d_x "
  )
  
  expect_equal( # test the names of the estimates (pulse)
    # Function output
    names(model_test_pte$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDTE, SE, Lower, Upper)
    c("Period", "GDTE", "SE", "Lower", "Upper"),  
  )  
  
  expect_equal( # test the names of the estimates (step)
    # Function output
    names(model_test_ste$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDTE, SE, Lower, Upper)
    c("Period", "GDTE", "SE", "Lower", "Upper"),  
  )  

  expect_equal( # test the dimensions of the estimates (pulse)
    # Function output
    dim(model_test_pte$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDTE, SE, Lower, Upper)
    c(the.h + 1, 5),  
  )

  expect_equal( # test the dimensions of the estimates (step)
    # Function output
    dim(model_test_ste$estimates),  

    # Expected output
    # rows is periods (limit + 1 for 0), 5 columns (Period, GDTE, SE, Lower, Upper)
    c(the.h + 1, 5),  
  )
})


test_that("Function returns objects correctly (including errors)", { 

  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)
	  
  #### Final Tests 
  model_test_allthree <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)

  expect_true( # are all three objects returned?
    # Function output
    all(c("plot", "estimates", "formulae") %in% names(model_test_allthree))
  )  
  
  model_test_noformulae <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2,
                                return.formulae = FALSE, 
                                return.plot = TRUE,
                                return.data = TRUE)

  expect_false( # is formulae returned?
    all(c("formulae") %in% names(model_test_noformulae))
  )

  model_test_justplot <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2,
                                return.formulae = FALSE, 
                                return.plot = TRUE,
                                return.data = FALSE)

  expect_false( # is formulae or estimates returned?
    # Function output
    all(c("estimates", "formulae") %in% names(model_test_justplot))
  )
    
  model_test_noplot <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2,
                                return.plot = FALSE, 
                                return.data = TRUE,
                                return.formulae = TRUE)

  expect_false( # is plot returned?
    # Function output
    all(c("plot") %in% names(model_test_noplot))
  )
    
  model_test_nodata <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.formulae = TRUE, 
                                return.plot = TRUE,
                                return.data = FALSE)

  expect_false( # is data returned?
    all(c("estimates") %in% names(model_test_nodata))
  )
    
  model_test_justdata <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l_1_x" = 1), 
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.formulae = FALSE, 
                                return.plot = FALSE,
                                return.data = TRUE)

  expect_false( # is data returned?
    all(c("plot", "formulae") %in% names(model_test_justdata))
  )
})

test_that("Correct Plots", {
  local_edition(3)
  	
  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)
  p <- ts.ci.gecm.plot(model = model, 
                       x.vrbl = c("l_1_x" = 1), 
                       y.vrbl = c("l_1_y" = 1),
                       x.vrbl.d.x = 0, 
                       y.vrbl.d.y = 0,
                       x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                       y.d.vrbl = c("l_1_d_y" = 1),
                       x.d.vrbl.d.x = 1, 
                       y.d.vrbl.d.y = 1,
                       te.type = "pte", 
                       inferences.y = "levels", 
                       inferences.x = "levels",
                       h.limit = 2,  
                       return.formulae = FALSE, 
                       return.plot =  TRUE,
                       return.data = FALSE)
  expect_no_error(p) 
  expect_doppelganger("p", p)
  expect_snapshot("p")
  
  q <- ts.ci.gecm.plot(model = model, 
                       x.vrbl = c("l_1_x" = 1), 
                       y.vrbl = c("l_1_y" = 1),
                       x.vrbl.d.x = 0, 
                       y.vrbl.d.y = 0,
                       x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                       y.d.vrbl = c("l_1_d_y" = 1),
                       x.d.vrbl.d.x = 1, 
                       y.d.vrbl.d.y = 1,
                       te.type = "ste", 
                       inferences.y = "levels", 
                       inferences.x = "levels",
                       h.limit = 2,  
                       return.formulae = FALSE, 
                       return.plot =  TRUE,
                       return.data = FALSE)
  expect_no_error(q) 
  expect_doppelganger("q", q)
  expect_snapshot("q")
})