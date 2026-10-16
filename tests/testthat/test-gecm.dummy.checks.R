test_that("gecm.dummy.checks produces the correct errors (GDRF type)", {

  # run a model to use for tests
  model <- lm(y ~ l_1_y + l_1_x + d_x + l_1_d_y, data = toy.ts.interaction.data)

  # x.vrbl NULL
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = NULL, y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in GDRF terms \\(x and y\\)"
  )

  # y.vrbl NULL
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in GDRF terms \\(x and y\\)"
  )

  # x.d.vrbl NULL
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = NULL, y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in GDRF terms \\(x and y\\)"
  )

  # x.vrbl.d.x missing
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = NULL, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF terms"
  )

  # y.vrbl.d.y missing
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = NULL, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF terms"
  )

  # x.d.vrbl.d.x missing
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF must"
  )

  # y.d.vrbl.d.y missing with y.d.vrbl defined
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF must"
  )

  # y.d.vrbl.d.y missing with y.d.vrbl not defined
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = NULL,
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = NULL,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Even if variables in lagged differences in"
  )

  # x.vrbl.d.x not integer
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 1.5, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an integer"
  )

  # y.vrbl.d.y not integer
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 1.5, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an integer"
  )

  # x.d.vrbl.d.x not integer
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1.5, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF term \\(x.d.vrbl.d.x"
  )

  # y.d.vrbl.d.y not integer
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1.5,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in lagged differences in GDRF term \\(y.d.vrbl.d.y"
  )

  # x.vrbl unnamed
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c(1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  # x.vrbl not numeric
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x"), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  # y.vrbl unnamed
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c(1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  )

  # y.vrbl not numeric
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y"), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  )

  # x.d.vrbl unnamed
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c(0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "x.d.vrbl should be a named vector"
  )

  # x.d.vrbl not numeric
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x"), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "x.d.vrbl should be a named vector"
  )

  # y.d.vrbl unnamed
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c(1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "y.d.vrbl should be a named vector"
  )

  # y.d.vrbl not numeric
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y"),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "y.d.vrbl should be a named vector"
  )

  # x differencing ordering off (distance > 1)
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 2, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, the variable in differences should be one order of differencing"
  )

  # y differencing ordering off (distance > 1)
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 2,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, the variable in differences should be one order of differencing"
  )

  # multiple lags in x.vrbl
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1, "l_2_x" = 2), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  # multiple lags in y.vrbl
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1, "l_2_y" = 2), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  # x.vrbl not at lag 1
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 2), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  # y.vrbl not at lag 1
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 2), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, include only the first lag of the variable"
  )

  # inferences.x not levels
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "differences", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, inferences regarding the GDRF of x"
  )

  # inferences.y not levels
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "differences", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "In a GECM, inferences regarding the GDRF of x"
  )

  # se.type not valid
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "cough", type = "GDRF"),

    # Expected output
    "Invalid se.type"
  )

  # x.vrbl not in model
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("cough" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl not present in estimated model"
  )

  # y.vrbl not in model
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("cough" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl not present in estimated model"
  )

  # x.d.vrbl not in model
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("cough" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "x.d.vrbl not present in estimated model"
  )

  # y.d.vrbl not in model
  expect_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("cough" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF"),

    # Expected output
    "y.d.vrbl not present in estimated model"
  )

  # valid inputs produce no error
  expect_no_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = c("l_1_d_y" = 1),
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF")
  )

  # valid inputs with no y.d.vrbl produce no error
  expect_no_error(
    # Function output
    gecm.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), x.d.vrbl = c("d_x" = 0), y.d.vrbl = NULL,
      x.vrbl.d.x = 0, y.vrbl.d.y = 0, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
      inferences.x = "levels", inferences.y = "levels", the.coef = coef(model),
      se.type = "const", type = "GDRF")
  )

})