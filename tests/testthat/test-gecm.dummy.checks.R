test_that("gecm.dummy.checks produces the correct warnings (GDTE type)", {

  # run a model to use for errors
  model <- lm(y ~ l_1_y + l_1_x + d_x + l_1_d_y, data = toy.ts.interaction.data)
  
  expect_error( # x.vrbl NULL 
    # Function output
    gecm.dummy.checks(x.vrbl = NULL, y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Variables in treatment effect terms \\(x and y\\)"
  )

  expect_error( # y.vrbl NULL 
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Variables in treatment effect terms \\(x and y\\)"
  )

  expect_error( # x.d.vrbl NULL 
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = NULL, y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Variables in treatment effect terms \\(x and y\\)"
  )

  # Do not require a y.d.vrbl since the GECM can be the reparam. ADL(1, 1)
  # expect_error( # y.d.vrbl NULL 
    # # Function output
    # gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = NULL,
    				# x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				# inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				# se.type = "const", type = "GDTE"),

    # # Expected output
    # "Variables in treatment effect terms \\(x and y\\)"
  # )

  expect_error( # x.vrbl.d.x missing
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = NULL, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect terms"
  )

  expect_error( # y.vrbl.d.y missing
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = NULL, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect terms"
  )

  expect_error( # x.d.vrbl.d.x missing
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in lagged differences in treatment effect must"
  )

  expect_error( # y.d.vrbl.d.y missing (& y.d.vrbl defined)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in lagged differences in treatment effect must"
  )

  expect_error( # y.d.vrbl.d.y missing (& y.d.vrbl not defined)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = NULL,
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Even if variables in lagged differences in"
  )

  expect_error( # x.vrbl.d.x not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 1.5, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an integer"
  )

  expect_error( # y.vrbl.d.y not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 1.5, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an integer"
  )

  expect_error( # x.d.vrbl.d.x not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1.5, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in lagged differences in treatment effect term \\(x.d.vrbl.d.x"
  )

  expect_error( # y.d.vrbl.d.y not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1.5,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in lagged differences in treatment effect term \\(y.d.vrbl.d.y"
  )

  expect_error( # x.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c(1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  expect_error( # x.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x"), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  expect_error( # y.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c(1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.vrbl should be a named vector"
  )

  expect_error( # y.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y"), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x.d.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c(0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.d.vrbl should be a named vector"
  )

  expect_error( # x.d.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x"), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.d.vrbl should be a named vector"
  )

  expect_error( # y.d.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c(1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.d.vrbl should be a named vector"
  )

  expect_error( # y.d.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y"),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.d.vrbl should be a named vector"
  )

  expect_error( # x ordering off
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 2, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, the variable in differences should be one order of differencing"
  )

  expect_error( # y ordering off
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 2,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, the variable in differences should be one order of differencing"
  )

  expect_error( # multiple lags (x)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1, "l_2_x" = 2), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # multiple lags (y)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1, "l_2_y" = 2), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # not first lag (x)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 2), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # not first lag (y)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 2), y.vrbl = c("l_1_y" = 2), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # inferences.x not in levels
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "differences", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, inferences regarding the counterfactual treatment of x"
  )

  expect_error( # inferences.y not in levels
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "differences", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "In a GECM, inferences regarding the counterfactual treatment of x"
  )
    
  expect_error( # se.type
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "cough", type = "GDTE"),

    # Expected output
    "Invalid se.type"
  )

  expect_error( # x.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("cough" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.vrbl not present in estimated model"
  )

  expect_error( # y.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("cough" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.vrbl not present in estimated model"
  )

  expect_error( # x.d.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("cough" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.d.vrbl not present in estimated model"
  )

  expect_error( # y.d.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("cough" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.d.vrbl not present in estimated model"
  )

})
    

test_that("gecm.dummy.checks produces the correct warnings (GDRF type)", {

  # run a model to use for errors
  model <- lm(y ~ l_1_y + l_1_x + d_x + l_1_d_y, data = toy.ts.interaction.data)
  
  expect_error( # x.vrbl NULL 
    # Function output
    gecm.dummy.checks(x.vrbl = NULL, y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in shock history terms \\(x and y\\)"
  )

  expect_error( # y.vrbl NULL 
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in shock history terms \\(x and y\\)"
  )

  expect_error( # x.d.vrbl NULL 
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = NULL, y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in shock history terms \\(x and y\\)"
  )

  # Do not require a y.d.vrbl since the GECM can be the reparam. ADL(1, 1)
  # expect_error( # y.d.vrbl NULL 
    # # Function output
    # gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = NULL,
    				# x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				# inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				# se.type = "const", type = "GDRF"),

    # # Expected output
    # "Variables in shock history terms \\(x and y\\)"
  # )

  expect_error( # x.vrbl.d.x missing
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = NULL, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history terms"
  )

  expect_error( # y.vrbl.d.y missing
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = NULL, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history terms"
  )

  expect_error( # x.d.vrbl.d.x missing
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history must"
  )

  expect_error( # y.d.vrbl.d.y missing (& y.d.vrbl defined)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history must"
  )

  expect_error( # y.d.vrbl.d.y missing (& y.d.vrbl not defined)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = NULL,
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Even if variables in lagged differences in"
  )










  expect_error( # x.vrbl.d.x not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 1.5, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an integer"
  )

  expect_error( # y.vrbl.d.y not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 1.5, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an integer"
  )

  expect_error( # x.d.vrbl.d.x not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1.5, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history term \\(x.d.vrbl.d.x"
  )

  expect_error( # y.d.vrbl.d.y not integer
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1.5,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in shock history term \\(y.d.vrbl.d.y"
  )

  expect_error( # x.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c(1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  expect_error( # x.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x"), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  expect_error( # y.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c(1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  )

  expect_error( # y.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y"), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x.d.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c(0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.d.vrbl should be a named vector"
  )

  expect_error( # x.d.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x"), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.d.vrbl should be a named vector"
  )

  expect_error( # y.d.vrbl unnamed
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c(1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.d.vrbl should be a named vector"
  )

  expect_error( # y.d.vrbl not numeric
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y"),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.d.vrbl should be a named vector"
  )

  expect_error( # x ordering off
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 2, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, the variable in differences should be one order of differencing"
  )

  expect_error( # y ordering off
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 2,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, the variable in differences should be one order of differencing"
  )

  expect_error( # multiple lags (x)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1, "l_2_x" = 2), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # multiple lags (y)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1, "l_2_y" = 2), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # not first lag (x)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 2), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # not first lag (y)
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 2), y.vrbl = c("l_1_y" = 2), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  expect_error( # inferences.x not in levels
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "differences", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, inferences regarding the shock history of x"
  )

  expect_error( # inferences.y not in levels
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "differences", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, inferences regarding the shock history of x"
  )
    
  expect_error( # se.type
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "cough", type = "GDRF"),

    # Expected output
    "Invalid se.type"
  )

  expect_error( # x.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("cough" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl not present in estimated model"
  )

  expect_error( # y.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("cough" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl not present in estimated model"
  )

  expect_error( # x.d.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("cough" = 0), y.d.vrbl = c("l_1_d_y" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.d.vrbl not present in estimated model"
  )

  expect_error( # y.d.vrbl not in model
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("cough" = 1),
    				x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.d.vrbl not present in estimated model"
  )

})
    



