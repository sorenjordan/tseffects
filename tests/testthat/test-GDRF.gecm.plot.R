# Models used throughout
# model.gecm: standard GECM(1,1) with d_y as DV, levels and differences of x and y

test_that("GDRF.gecm.plot errors and warnings are issued correctly", {  
  
  # run a model to use for errors
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = NULL,
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Variables in GDRF terms \\(x and y\\) and lagged differences"
  ) 

  expect_error( # no y.vrbl
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = NULL,
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Variables in GDRF terms \\(x and y\\) and lagged differences"
  )
  
  expect_error( # no x.d.vrbl
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = NULL,
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Variables in GDRF terms \\(x and y\\) and lagged differences"
  ) 

  expect_error( # no x.vrbl.d.x
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = NULL, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF terms"  
  ) 
  
  expect_error( # no y.vrbl.d.y
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = NULL,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF terms"  
  )
  
  expect_error( # no x.d.vrbl.d.x
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF must"    
  ) 
  
  expect_error( # y.d.vrbl supplied but y.d.vrbl.d.y missing
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF must be specified through y.d.vrbl.d.y"
  )

  expect_error( # x.vrbl.d.x must be integer
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0.5, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF term \\(x.vrbl.d.x and y.vrbl.d.y\\)"  
  )
  
  expect_error( # y.vrbl.d.y must be integer
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0.7,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in GDRF term \\(x.vrbl.d.x and y.vrbl.d.y\\)"  
  )
    
  expect_error( # x.d.vrbl.d.x must be integer
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1.3, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF term \\(x.d.vrbl.d.x"  
  )
  
  expect_error( # y.d.vrbl.d.y must be integer
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 3.14,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF term \\(y.d.vrbl.d.y"  
  )

  expect_error( # x vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c(1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x"),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c(1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
 
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y"),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x.d.vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c(0, 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x", "l_1_d_x"),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl not named vector
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c(1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl vrbl vector has no values
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y"),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl.d.order-x.vrbl.d.order: difference of ordering exceeds 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 3, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # y.d.vrbl.d.order-y.vrbl.d.order: difference of ordering exceeds 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 9,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # does GECM include more than first lag of x?
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1, "l_2_x" = 2),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
    
  expect_error( # does GECM include more than first lag of y?
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1, "l_2_y" = 2),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # x.vrbl has lag order != 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 2),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # y.vrbl has lag order != 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 2),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # invalid inferences.y
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "differences", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "In a GECM, inferences regarding the GDRF of x"
  )

  expect_error( # invalid inferences.x
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "differences",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "In a GECM, inferences regarding the GDRF of x"
  )

  expect_error( # invalid se.type
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   se.type = "Cyberman",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

      # Expected error
      "Invalid se.type. se.type must be an accepted" 
  )
  
  expect_error( # x.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("weeping angel" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # x.d.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "Sontaran" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "x.d.vrbl not present in estimated model" 
  )
  
  expect_error( # y.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("androzani" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "y.vrbl not present in estimated model"
  )
  
  expect_error( # y.d.vrbl not in model
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("Rassilon" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
    # Expected error
    "y.d.vrbl not present in estimated model" 
  )
  
  expect_error( # shock.history is invalid word
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "Daleks",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
      
    # Expected error
    "Invalid shock.history. shock.history must be one of 'pulse' or 'step'"
  )

  expect_error( # shock.history = NULL
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = NULL,
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected error
    "shock.history must be specified"
  )

  expect_error( # shock.history is not integer
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = 3.5,
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

      
    # Expected error
    "Invalid shock.history. shock.history must be one of 'pulse' or 'step'"
  )

  expect_error( # prediction.values not supported for GECM
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   prediction.values = list("l_1_x" = 1),
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
	# Expected output
    "prediction.values not suppported for GECM"
  )

  expect_error( # invalid effect.type
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "cough",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
   
    # Expected output
    "Invalid effect.type. effect.type must be one of 'discrete' or 'fitted'"
  )

  expect_error( # discrete + baseline.y supplied
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "discrete", baseline.y = 5,
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
	# Expected output
    "Do not supply baseline.y when effect.type = 'discrete'"
  )

  expect_error( # discrete + baseline.y.se supplied
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "discrete",
                   baseline.y.se = 1,
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
    
	# Expected output
    "Do not supply baseline.y.se when effect.type = 'discrete'"
  )

  expect_error( # fitted + baseline.y not numeric
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = "cough",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
  
    # Expected output
    "If providing a baseline.y, it must be numeric"
  )

  expect_error( # fitted + baseline.y length > 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = c(1, 2),
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
   
    # Expected output
    "Only provide a single baseline.y value"
  )

  expect_error( # fitted + baseline.y.se not numeric
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = 5,
                   baseline.y.se = "cough",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
   
    # Expected output
    "If providing a baseline.y.se, it must be numeric"
  )

  expect_error( # fitted + baseline.y.se length > 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = 5,
                   baseline.y.se = c(1, 2),
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
  
    # Expected output
    "Only provide a single baseline.y.se value"
  )

  expect_error( # fitted + shock.size not numeric
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = 5,
                   shock.size = "cough",
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),
   
    # Expected output
    "shock.size must be numeric"
  )

  expect_error( # fitted + y.d.vrbl.d.y = 1 + inferences.y = levels + no baseline.y
    # Function output
    GDRF.gecm.plot(model = model.gecm,
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
                   effect.type = "fitted",
                   baseline.y = NULL,
                   s.limit = 5,
                   return.plot = TRUE,
                   return.formulae = TRUE),
   
    # Expected output
    "You must provide either a baseline.y"
  )

  expect_error( # fitted + shock.size length > 1
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = 5,
                   shock.size = c(1, 2),
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "shock.size should be a single value"
  )

  expect_error( # fitted + y.vrbl.d.y = 0 + no baseline.y and no prediction.values
    # Function output
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = NULL,
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    # Expected output
    "You must provide either a baseline.y value"
  )

  expect_error( # return nothing
   # Function output
   suppressWarnings(GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   s.limit = 3,
                   return.plot = FALSE, return.formulae = FALSE, return.data = FALSE)),

    # Expected output
    "Return at least one of the plot, the data, or the formulae"
  )

})

test_that("GDRF.gecm.plot warnings are issued correctly", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  expect_warning( # LRM decay warning: pulse, cumulative = TRUE
    # (h+1) - d.x + d.y = (-1+1) - 0 + 0 = 0: actually LRM exists for pulse+cumulative
    # use a combination that decays: pulse cumulative=FALSE, non-zero d implies no LRM
    # For GECM the LRM is always the step (h=0): pulse non-cumulative gives -1-0+0 = -1 < 0
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   cumulative = FALSE,
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    "return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned"
  )

  expect_warning( # LRM diverge warning: step + cumulative = TRUE
    # (h+1) - d.x + d.y = (0+1) - 0 + 0 = 1 > 0: diverges
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "step",
                   inferences.y = "levels", inferences.x = "levels",
                   cumulative = TRUE,
                   s.limit = 3, return.plot = FALSE, return.data = TRUE),

    "return.LRM = TRUE but the effects diverge to \\+/-infinity as s -> infinity. No LRM is returned"
  )

  expect_warning( # mpoly . replacement warning
    {
      toy.ts.interaction.data$d.x <- toy.ts.interaction.data$d_x
      model.dot <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d.x + l_1_d_x,
                      data = toy.ts.interaction.data)
      GDRF.gecm.plot(model = model.dot,
                     x.vrbl = c("l_1_x" = 1),
                     y.vrbl = c("l_1_y" = 1),
                     x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                     x.d.vrbl = c("d.x" = 0, "l_1_d_x" = 1),
                     y.d.vrbl = c("l_1_d_y" = 1),
                     x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                     shock.history = "step",
                     inferences.y = "levels", inferences.x = "levels",
                     s.limit = 3, return.plot = FALSE, return.data = TRUE)
    },

    "Variable names containing . replaced with _"
  )

})

test_that("GDRF.gecm.plot output structure is correct (discrete, no LRM)", {

  # pulse + cumulative = FALSE: h = -1, -1 - 0 + 0 = -1 < 0: no LRM (warns decay)
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  the.s <- 5

  result <- suppressWarnings(
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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


test_that("GDRF.gecm.plot output structure is correct (discrete, with LRM)", {

  # step + cumulative = FALSE: h = 0, 0 - 0 + 0 = 0: LRM exists
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  the.s <- 5

  result <- GDRF.gecm.plot(model = model.gecm,
                            x.vrbl = c("l_1_x" = 1),
                            y.vrbl = c("l_1_y" = 1),
                            x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                            x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                            y.d.vrbl = c("l_1_d_y" = 1),
                            x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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

  expect_equal( # LRM formula has correct structure for GECM: shock.size * (-1) * x.vrbl / y.vrbl
    # Function output
    result$formulae[["LRM"]],

    # Expected output
    "(1* (-1) * (l_1_x))/(l_1_y)"
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})


test_that("GDRF.gecm.plot output structure is correct (discrete, cumulative + LRM)", {

  # pulse + cumulative = TRUE: (h+1) - d.x + d.y = (-1+1) - 0 + 0 = 0: LRM exists
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  the.s <- 5

  result <- GDRF.gecm.plot(model = model.gecm,
                            x.vrbl = c("l_1_x" = 1),
                            y.vrbl = c("l_1_y" = 1),
                            x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                            x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                            y.d.vrbl = c("l_1_d_y" = 1),
                            x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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

  expect_true( # LRM formula is present in formulae
    # Function output
    "LRM" %in% names(result$formulae)
  )

  expect_true( # plot is a ggplot object
    # Function output
    inherits(result$plot, "ggplot")
  )

})


test_that("GDRF.gecm.plot output structure is correct (fitted, baseline.y, no LRM)", {

  # fitted + step + baseline.y: LRM suppressed for fitted
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  the.s <- 5

  result <- GDRF.gecm.plot(model = model.gecm,
                            x.vrbl = c("l_1_x" = 1),
                            y.vrbl = c("l_1_y" = 1),
                            x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                            x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                            y.d.vrbl = c("l_1_d_y" = 1),
                            x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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


test_that("GDRF.gecm.plot output structure is correct (custom shock history)", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  the.s <- 5
  custom.shocks <- c(1, 1, 1, 0, 0, 1)

  result <- GDRF.gecm.plot(model = model.gecm,
                            x.vrbl = c("l_1_x" = 1),
                            y.vrbl = c("l_1_y" = 1),
                            x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                            x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                            y.d.vrbl = c("l_1_d_y" = 1),
                            x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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


test_that("GDRF.gecm.plot output structure is correct (custom shock history, cumulative)", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  the.s <- 5
  custom.shocks <- c(1, 1, 1, 0, 0, 1)

  # custom + cumulative = TRUE: warns about LRM condition but returns TRUE
  result <- suppressWarnings(
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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


test_that("GDRF.gecm.plot shock.size scales discrete effects correctly", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result.size1 <- GDRF.gecm.plot(model = model.gecm,
                                  x.vrbl = c("l_1_x" = 1),
                                  y.vrbl = c("l_1_y" = 1),
                                  x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                  shock.history = "step",
                                  inferences.y = "levels", inferences.x = "levels",
                                  effect.type = "discrete",
                                  shock.size = 1,
                                  s.limit = 5,
                                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  result.size2  <- GDRF.gecm.plot(model = model.gecm,
                                  x.vrbl = c("l_1_x" = 1),
                                  y.vrbl = c("l_1_y" = 1),
                                  x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                  shock.history = "step",
                                  inferences.y = "levels", inferences.x = "levels",
                                  effect.type = "discrete",
                                  shock.size = 2,
                                  s.limit = 5,
                                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  expect_equal( # shock.size = 2 doubles all GDRF estimates relative to shock.size = 1
    # Function output (exclude LRM row which has different scaling)
    result.size2$GDRF[result.size2$Period != "LRM"],

    # Expected output
    result.size1$GDRF[result.size1$Period != "LRM"] * 2,
    tolerance = 1e-6
  )

  expect_equal( # shock.size = 2 doubles all SE estimates relative to shock.size = 1
    # Function output (exclude LRM row)
    result.size2$SE[result.size2$Period != "LRM"],

    # Expected output
    result.size1$SE[result.size1$Period != "LRM"] * 2,
    tolerance = 1e-6
  )

})


test_that("GDRF.gecm.plot shock.size scales fitted values correctly (baseline.y = 0)", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result.size1 <- GDRF.gecm.plot(model = model.gecm,
                                  x.vrbl = c("l_1_x" = 1),
                                  y.vrbl = c("l_1_y" = 1),
                                  x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                  shock.history = "pulse",
                                  inferences.y = "levels", inferences.x = "levels",
                                  effect.type = "fitted",
                                  baseline.y = 0,
                                  shock.size = 1,
                                  s.limit = 5,
                                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  result.size2 <- GDRF.gecm.plot(model = model.gecm,
                                  x.vrbl = c("l_1_x" = 1),
                                  y.vrbl = c("l_1_y" = 1),
                                  x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                  shock.history = "pulse",
                                  inferences.y = "levels", inferences.x = "levels",
                                  effect.type = "fitted",
                                  baseline.y = 0,
                                  shock.size = 2,
                                  s.limit = 5,
                                  return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  expect_equal( # with baseline.y = 0, shock.size = 2 doubles GDRF relative to shock.size = 1
    # Function output: skip the baseline row (row 1)
    result.size2$GDRF[-1],

    # Expected output
    result.size1$GDRF[-1] * 2,
    tolerance = 1e-6
  )

})


test_that("GDRF.gecm.plot fitted values are offset from discrete effects by baseline.y", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result.discrete <- suppressWarnings(
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "discrete",
                   shock.size = 1,
                   s.limit = 5,
                   return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)
  )

  result.fitted <- suppressWarnings(
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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


test_that("GDRF.gecm.plot baseline.y.se is added in quadrature correctly", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result.nose <- GDRF.gecm.plot(model = model.gecm,
                                 x.vrbl = c("l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                 x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                 y.d.vrbl = c("l_1_d_y" = 1),
                                 x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                 shock.history = "step",
                                 inferences.y = "levels", inferences.x = "levels",
                                 effect.type = "fitted",
                                 baseline.y = 5,
                                 baseline.y.se = 0,
                                 shock.size = 1,
                                 s.limit = 5,
                                 return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  result.withse <- GDRF.gecm.plot(model = model.gecm,
                                   x.vrbl = c("l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                   y.d.vrbl = c("l_1_d_y" = 1),
                                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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


test_that("GDRF.gecm.plot LRM is suppressed for effect.type = fitted", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result.discrete <- GDRF.gecm.plot(model = model.gecm,
                                     x.vrbl = c("l_1_x" = 1),
                                     y.vrbl = c("l_1_y" = 1),
                                     x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                     x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                     y.d.vrbl = c("l_1_d_y" = 1),
                                     x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                     shock.history = "step",
                                     inferences.y = "levels", inferences.x = "levels",
                                     effect.type = "discrete",
                                     s.limit = 5,
                                     return.plot = FALSE, return.formulae = TRUE, return.data = TRUE)

  result.fitted <- GDRF.gecm.plot(model = model.gecm,
                                   x.vrbl = c("l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                   y.d.vrbl = c("l_1_d_y" = 1),
                                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                   shock.history = "step",
                                   inferences.y = "levels", inferences.x = "levels",
                                   effect.type = "fitted",
                                   baseline.y = 5,
                                   shock.size = 1,
                                   s.limit = 5,
                                   return.plot = FALSE, return.formulae = TRUE, return.data = TRUE)

  expect_true( # discrete + step has LRM in formulae
    # Function output
    "LRM" %in% names(result.discrete$formulae)
  )

  expect_true( # discrete + step has LRM row in estimates
    # Function output
    "LRM" %in% result.discrete$estimates$Period
  )

  expect_false( # fitted suppresses LRM in formulae
    # Function output
    "LRM" %in% names(result.fitted$formulae)
  )

  expect_false( # fitted suppresses LRM row in estimates
    # Function output
    "LRM" %in% result.fitted$estimates$Period
  )

})



test_that("GDRF.gecm.plot return options work correctly", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  # all three returned
  result.all <- GDRF.gecm.plot(model = model.gecm,
                                x.vrbl = c("l_1_x" = 1),
                                y.vrbl = c("l_1_y" = 1),
                                x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                y.d.vrbl = c("l_1_d_y" = 1),
                                x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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
  result.plot <- GDRF.gecm.plot(model = model.gecm,
                                 x.vrbl = c("l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                 x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                 y.d.vrbl = c("l_1_d_y" = 1),
                                 x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                 shock.history = "step",
                                 inferences.y = "levels", inferences.x = "levels",
                                 s.limit = 3,
                                 return.plot = TRUE, return.formulae = FALSE, return.data = FALSE)

  expect_true( # plot only: returns ggplot directly, not a list
    # Function output
    inherits(result.plot, "ggplot")
  )

  # data only
  result.data <- GDRF.gecm.plot(model = model.gecm,
                                 x.vrbl = c("l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                 x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                 y.d.vrbl = c("l_1_d_y" = 1),
                                 x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                 shock.history = "step",
                                 inferences.y = "levels", inferences.x = "levels",
                                 s.limit = 3,
                                 return.plot = FALSE, return.formulae = FALSE, return.data = TRUE)

  expect_true( # data only: returns data frame directly
    # Function output
    is.data.frame(result.data)
  )

  # formulae only
  result.formulae <- GDRF.gecm.plot(model = model.gecm,
                                     x.vrbl = c("l_1_x" = 1),
                                     y.vrbl = c("l_1_y" = 1),
                                     x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                     x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                     y.d.vrbl = c("l_1_d_y" = 1),
                                     x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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
  result.plotdata <- GDRF.gecm.plot(model = model.gecm,
                                     x.vrbl = c("l_1_x" = 1),
                                     y.vrbl = c("l_1_y" = 1),
                                     x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                     x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                     y.d.vrbl = c("l_1_d_y" = 1),
                                     x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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
  result.plotformulae <- GDRF.gecm.plot(model = model.gecm,
                                         x.vrbl = c("l_1_x" = 1),
                                         y.vrbl = c("l_1_y" = 1),
                                         x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                         x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                         y.d.vrbl = c("l_1_d_y" = 1),
                                         x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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
  result.dataformulae <- GDRF.gecm.plot(model = model.gecm,
                                         x.vrbl = c("l_1_x" = 1),
                                         y.vrbl = c("l_1_y" = 1),
                                         x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                         x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                         y.d.vrbl = c("l_1_d_y" = 1),
                                         x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
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

test_that("GDRF.gecm.plot LRM formula is correct (step, shock.size = 1)", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result <- GDRF.gecm.plot(model = model.gecm,
                            x.vrbl = c("l_1_x" = 1),
                            y.vrbl = c("l_1_y" = 1),
                            x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                            x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                            y.d.vrbl = c("l_1_d_y" = 1),
                            x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                            shock.history = "step",
                            inferences.y = "levels", inferences.x = "levels",
                            effect.type = "discrete",
                            shock.size = 1,
                            s.limit = 5,
                            return.plot = FALSE, return.formulae = TRUE, return.data = FALSE)

  expect_equal( # LRM formula for GECM: (shock.size * (-1) * x.vrbl) / (y.vrbl)
    # Function output
    result$formulae[["LRM"]],

    # Expected output
    "(1* (-1) * (l_1_x))/(l_1_y)"
  )

})


test_that("GDRF.gecm.plot LRM formula is correct (step, shock.size = 2)", {

  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  result <- GDRF.gecm.plot(model = model.gecm,
                            x.vrbl = c("l_1_x" = 1),
                            y.vrbl = c("l_1_y" = 1),
                            x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                            x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                            y.d.vrbl = c("l_1_d_y" = 1),
                            x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                            shock.history = "step",
                            inferences.y = "levels", inferences.x = "levels",
                            effect.type = "discrete",
                            shock.size = 2,
                            s.limit = 5,
                            return.plot = FALSE, return.formulae = TRUE, return.data = FALSE)

  expect_equal( # LRM formula with shock.size = 2
    # Function output
    result$formulae[["LRM"]],

    # Expected output
    "(2* (-1) * (l_1_x))/(l_1_y)"
  )

})

test_that("GDRF.gecm.plot shocks element reflects shock.history correctly", {
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)
  # pulse
  result.pulse <- suppressWarnings(GDRF.gecm.plot(model = model.gecm,
                                  x.vrbl = c("l_1_x" = 1),
                                  y.vrbl = c("l_1_y" = 1),
                                  x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                  x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                  y.d.vrbl = c("l_1_d_y" = 1),
                                  x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                  shock.history = "pulse",
                                  inferences.y = "levels", inferences.x = "levels",
                                  effect.type = "discrete",
                                  cumulative = FALSE,
                                  s.limit = 5,
                                  return.plot = FALSE, return.formulae = TRUE, return.data = FALSE))
  expect_equal( # pulse shocks: 1 followed by zeros
    # Function output
    result.pulse$shocks[["s = 5"]],
    # Expected output
    c(1, 0, 0, 0, 0, 0)
  )
  # step
  result.step <- GDRF.gecm.plot(model = model.gecm,
                                 x.vrbl = c("l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                 x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                 y.d.vrbl = c("l_1_d_y" = 1),
                                 x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                 shock.history = "step",
                                 inferences.y = "levels", inferences.x = "levels",
                                 effect.type = "discrete",
                                 s.limit = 5,
                                 return.plot = FALSE, return.formulae = TRUE, return.data = FALSE)
  expect_equal( # step shocks: all ones
    # Function output
    result.step$shocks[["s = 5"]],
    # Expected output
    c(1, 1, 1, 1, 1, 1)
  )
  # custom
  custom.shocks <- c(1, 1, 1, 0, 0, 1)
  result.custom <- GDRF.gecm.plot(model = model.gecm,
                                   x.vrbl = c("l_1_x" = 1),
                                   y.vrbl = c("l_1_y" = 1),
                                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                   y.d.vrbl = c("l_1_d_y" = 1),
                                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                   shock.history = custom.shocks,
                                   inferences.y = "levels", inferences.x = "levels",
                                   effect.type = "discrete",
                                   s.limit = 5,
                                   return.plot = FALSE, return.formulae = TRUE, return.data = FALSE)
  expect_equal( # custom shocks are stored as supplied
    # Function output
    result.custom$shocks[["s = 5"]],
    # Expected output
    custom.shocks
  )
})

test_that("mpoly formulae are correct (GECM(1,1))", { 
  
  model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)

  ####################################################################################
  # GECM(1,1), both inferences in levels, pulse and step
  ####################################################################################
  the.s <- 2
  
  model_test_pte <- suppressWarnings(GDRF.gecm.plot(model = model, 
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
                                return.data = TRUE))
  
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
  
  model_test_pte <- suppressWarnings(GDRF.gecm.plot(model = model, 
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
                                return.data = TRUE))

  model_test_ste <- suppressWarnings(GDRF.gecm.plot(model = model, 
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
                                    return.data = TRUE))
  
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


test_that("Fitted values evaluated are correct (GECM, x.vrbl.d.x = 0, y.vrbl.d.y = 0)", {
  model.gecm <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x,
                   data = toy.ts.interaction.data)

  # gecm.to.adl reparameterization:
  # The GECM d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x converts to ADL as:
  # phi_1 = 1 + b_y + b_dy   (coefficient on l_1_y in ADL)
  # phi_2 = -b_dy             (coefficient on l_2_y in ADL)
  # om_0  = b_dx              (coefficient on x at lag 0 in ADL)
  # om_1  = b_x - b_dx + b_ldx (coefficient on x at lag 1 in ADL)
  # om_2  = -b_ldx            (coefficient on x at lag 2 in ADL)
  b_y   <- unname(coef(model.gecm)["l_1_y"])
  b_x   <- unname(coef(model.gecm)["l_1_x"])
  b_dy  <- unname(coef(model.gecm)["l_1_d_y"])
  b_dx  <- unname(coef(model.gecm)["d_x"])
  b_ldx <- unname(coef(model.gecm)["l_1_d_x"])
  b_int <- unname(coef(model.gecm)["(Intercept)"])

  phi_1 <- 1 + b_y + b_dy
  phi_2 <- -b_dy
  om_0  <- b_dx
  om_1  <- b_x - b_dx + b_ldx
  om_2  <- -b_ldx

  ####################################################################################
  # step shock + fitted + baseline.y = 5, shock.size = 1
  # step: shock[s] = 1 for all s
  # GDRF recurrence (fitted, inferences in levels):
  #   G(0) = baseline.y + om_0 * shock[0]
  #   G(s) = baseline.y + phi_1*(G(s-1) - baseline.y) + phi_2*(G(s-2) - baseline.y)
  #          + om_0*shock[s] + om_1*shock[s-1] + om_2*shock[s-2]
  # which in terms of discrete effects D(s) = G(s) - baseline.y:
  #   D(0) = om_0 * 1
  #   D(1) = phi_1*D(0) + om_0*1 + om_1*1
  #   D(2) = phi_1*D(1) + phi_2*D(0) + om_0*1 + om_1*1 + om_2*1
  ####################################################################################
  result.step <- GDRF.gecm.plot(model = model.gecm,
                                 x.vrbl = c("l_1_x" = 1),
                                 y.vrbl = c("l_1_y" = 1),
                                 x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                                 x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                                 y.d.vrbl = c("l_1_d_y" = 1),
                                 x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                                 shock.history = "step",
                                 inferences.y = "levels", inferences.x = "levels",
                                 effect.type = "fitted",
                                 baseline.y = 5,
                                 shock.size = 1,
                                 s.limit = 3,
                                 return.plot = FALSE, return.formulae = FALSE,
                                 return.data = TRUE)

  expect_equal( # baseline is exactly baseline.y
    # Function output
    result.step$GDRF[result.step$Period == "baseline"],
    # Expected output
    5,
    tolerance = 1e-6
  )
  expect_equal( # s = 0: baseline.y + om_0 * shock[0]
    # Function output
    result.step$GDRF[result.step$Period == "0"],
    # Expected output
    5 + om_0 * 1,
    tolerance = 1e-6
  )
  expect_equal( # s = 1: baseline.y + phi_1*D(0) + om_0*shock[1] + om_1*shock[0]
    # Function output
    result.step$GDRF[result.step$Period == "1"],
    # Expected output
    5 + phi_1 * (om_0 * 1) + om_0 * 1 + om_1 * 1,
    tolerance = 1e-6
  )
  expect_equal( # s = 2: baseline.y + phi_1*D(1) + phi_2*D(0) + om_0*shock[2] + om_1*shock[1] + om_2*shock[0]
    # Function output
    result.step$GDRF[result.step$Period == "2"],
    # Expected output
    5 + phi_1 * (phi_1 * (om_0 * 1) + om_0 * 1 + om_1 * 1) +
        phi_2 * (om_0 * 1) +
        om_0 * 1 + om_1 * 1 + om_2 * 1,
    tolerance = 1e-6
  )

  ####################################################################################
  # pulse shock + fitted + baseline.y = 5, shock.size = 1
  # pulse: shock[0] = 1, shock[s] = 0 for s > 0
  # D(0) = om_0 * 1
  # D(1) = phi_1*D(0) + om_0*0 + om_1*1
  # D(2) = phi_1*D(1) + phi_2*D(0) + om_0*0 + om_1*0 + om_2*1
  ####################################################################################
  result.pulse <- suppressWarnings(
    GDRF.gecm.plot(model = model.gecm,
                   x.vrbl = c("l_1_x" = 1),
                   y.vrbl = c("l_1_y" = 1),
                   x.vrbl.d.x = 0, y.vrbl.d.y = 0,
                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
                   y.d.vrbl = c("l_1_d_y" = 1),
                   x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
                   shock.history = "pulse",
                   inferences.y = "levels", inferences.x = "levels",
                   effect.type = "fitted",
                   baseline.y = 5,
                   shock.size = 1,
                   s.limit = 3,
                   return.plot = FALSE, return.formulae = FALSE,
                   return.data = TRUE)
  )

  expect_equal( # baseline is exactly baseline.y
    # Function output
    result.pulse$GDRF[result.pulse$Period == "baseline"],
    # Expected output
    5,
    tolerance = 1e-6
  )
  expect_equal( # s = 0: baseline.y + om_0 * shock[0]
    # Function output
    result.pulse$GDRF[result.pulse$Period == "0"],
    # Expected output
    5 + om_0 * 1,
    tolerance = 1e-6
  )
  expect_equal( # s = 1: baseline.y + phi_1*D(0) + om_0*shock[1] + om_1*shock[0]
    #           pulse: shock[1] = 0, shock[0] = 1
    # Function output
    result.pulse$GDRF[result.pulse$Period == "1"],
    # Expected output
    5 + phi_1 * (om_0 * 1) + om_0 * 0 + om_1 * 1,
    tolerance = 1e-6
  )
  expect_equal( # s = 2: baseline.y + phi_1*D(1) + phi_2*D(0) + om_0*shock[2] + om_1*shock[1] + om_2*shock[0]
    #           pulse: shock[2] = 0, shock[1] = 0, shock[0] = 1
    # Function output
    result.pulse$GDRF[result.pulse$Period == "2"],
    # Expected output
    5 + phi_1 * (phi_1 * (om_0 * 1) + om_0 * 0 + om_1 * 1) +
        phi_2 * (om_0 * 1) +
        om_0 * 0 + om_1 * 0 + om_2 * 1,
    tolerance = 1e-6
  )
})























# test_that("Correct Plot: GDRF.gecm.plot", {
  # local_edition(3)
  	
  # model <- lm(d_y ~ l_1_x + l_1_y + d_x + l_1_d_x + l_1_d_y, data = toy.ts.interaction.data)
  # one <- GDRF.gecm.plot(model = model, 
                       # x.vrbl = c("l_1_x" = 1), 
                       # y.vrbl = c("l_1_y" = 1),
                       # x.vrbl.d.x = 0, 
                       # y.vrbl.d.y = 0,
                       # x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                       # y.d.vrbl = c("l_1_d_y" = 1),
                       # x.d.vrbl.d.x = 1, 
                       # y.d.vrbl.d.y = 1,
                       # shock.history = "step", 
                       # inferences.y = "levels", 
                       # inferences.x = "levels",
                       # s.limit = 2,  
                       # return.formulae = FALSE, 
                       # return.plot =  TRUE,
                       # return.data = FALSE)
  # expect_no_error(one) 
  # # expect_doppelganger("gdrfgecmpulse", one)
  # # expect_snapshot("gdrfgecmpulse")
  
  # p <- GDRF.gecm.plot(model = model, 
                       # x.vrbl = c("l_1_x" = 1), 
                       # y.vrbl = c("l_1_y" = 1),
                       # x.vrbl.d.x = 0, 
                       # y.vrbl.d.y = 0,
                       # x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1), 
                       # y.d.vrbl = c("l_1_d_y" = 1),
                       # x.d.vrbl.d.x = 1, 
                       # y.d.vrbl.d.y = 1,
                       # shock.history = "pulse", 
                       # inferences.y = "levels", 
                       # inferences.x = "levels",
                       # s.limit = 2,  
                       # return.formulae = FALSE, 
                       # return.plot =  TRUE,
                       # return.data = FALSE)
  # expect_no_error(p)
  # vdiffr::expect_doppelganger("gdrfgecmpulse", p) # Test the plot  
  # # expect_doppelganger("gdrfgecmstep", two)
  # # expect_snapshot("gdrfgecmstep")
# })