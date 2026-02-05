test_that("adl.dummy.checks produces the correct warnings (GDTE type)", {

  # run a model to use for errors
  model <- lm(y ~ l_1_y + l_1_x, data = toy.ts.interaction.data)
  
  expect_error( # is.null(x.vrbl)
    # Function output
    adl.dummy.checks(x.vrbl = NULL, y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Variables in treatment effect terms \\(x and possibly y\\) must be"
  )

  expect_warning( # is.null(y.vrbl)
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "No y.vrbl in treatment effect terms implies"
  )

  expect_error( # d.x missing
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = NULL, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect terms must be specified through d.x and d.y"
  ) 

  expect_error( # d.y missing
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = NULL,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect terms must be specified through d.x and d.y"
  ) 

  expect_error( # d.x not integer
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 1.5, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect terms \\(d.x and d.y\\) must be an integer"
  ) 

  expect_error( # d.y not integer
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 1.5,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Order of differencing of variables in treatment effect terms \\(d.x and d.y\\) must be an integer"
  ) 

  expect_error( # inferences.x not supported
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "cough", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Invalid inferences.x. The counterfactual treatment"
  ) 

  expect_error( # inferences.x not supported
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "cough", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Invalid inferences.y. The counterfactual response"
  ) 

  expect_error( # inferences.x nonsensical
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "differences", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Invalid inferences.x. The counterfactual treatment for x cannot be in a higher order"
  ) 

  expect_error( # inferences.y nonsensical
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "differences", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "Invalid inferences.y. The counterfactual response for y cannot be in a higher order"
  ) 

  expect_error( # x.vrbl not numeric
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x"), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.vrbl should be a named vector"
  ) 

  expect_error( # x.vrbl not named
    # Function output
    adl.dummy.checks(x.vrbl = c(1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.vrbl should be a named vector"
  ) 

  expect_error( # y.vrbl not numeric
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y"), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.vrbl should be a named vector"
  ) 

  expect_error( # y.vrbl not named
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c(1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.vrbl should be a named vector"
  ) 

  expect_error( # se.type bad
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "cough", type = "GDTE"),

    # Expected output
    "Invalid se.type"
  ) 

  expect_error( # x.vrbl not in model
    # Function output
    adl.dummy.checks(x.vrbl = c("cough" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "x.vrbl not present"
  ) 

  expect_error( # y.vrbl not in model
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("cough" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDTE"),

    # Expected output
    "y.vrbl not present"
  ) 

})

test_that("adl.dummy.checks produces the correct warnings (GDRF type)", {

  # run a model to use for errors
  model <- lm(y ~ l_1_y + l_1_x, data = toy.ts.interaction.data)
  
  expect_error( # is.null(x.vrbl)
    # Function output
    adl.dummy.checks(x.vrbl = NULL, y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in shock history terms \\(x and possibly y\\) must be"
  )

  expect_warning( # is.null(y.vrbl)
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "No y.vrbl in shock history terms"
  )

  expect_error( # d.x missing
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = NULL, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history terms must be specified through d.x and d.y"
  ) 

  expect_error( # d.y missing
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = NULL,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history terms must be specified through d.x and d.y"
  ) 

  expect_error( # d.x not integer
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 1.5, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history terms \\(d.x and d.y\\) must be an integer"
  ) 

  expect_error( # d.y not integer
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 1.5,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in shock history terms \\(d.x and d.y\\) must be an integer"
  ) 

  expect_error( # inferences.x not supported
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "cough", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.x. The shock history"
  ) 

  expect_error( # inferences.x not supported
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "cough", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.y. The response function"
  ) 

  expect_error( # inferences.x nonsensical
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "differences", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.x. The shock history for x cannot be in a higher order"
  ) 

  expect_error( # inferences.y nonsensical
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "differences", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.y. The response function for y cannot be in a higher order"
  ) 

  expect_error( # x.vrbl not numeric
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x"), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  ) 

  expect_error( # x.vrbl not named
    # Function output
    adl.dummy.checks(x.vrbl = c(1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  ) 

  expect_error( # y.vrbl not numeric
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y"), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  ) 

  expect_error( # y.vrbl not named
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c(1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  ) 

  expect_error( # se.type bad
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "cough", type = "GDRF"),

    # Expected output
    "Invalid se.type"
  ) 

  expect_error( # x.vrbl not in model
    # Function output
    adl.dummy.checks(x.vrbl = c("cough" = 1), y.vrbl = c("l_1_y" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl not present"
  ) 

  expect_error( # y.vrbl not in model
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("cough" = 1), d.x = 0, d.y = 0,
    				inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
    				se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl not present"
  ) 

})
