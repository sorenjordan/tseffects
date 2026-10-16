test_that("adl.dummy.checks produces the correct errors and warnings (GDRF type)", {

  # run a model to use for tests
  model <- lm(y ~ l_1_y + l_1_x, data = toy.ts.interaction.data)

  # is.null(x.vrbl)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = NULL, y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Variables in GDRF terms \\(x and possibly y\\) must be"
  )

  # is.null(y.vrbl) warns
  expect_warning(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "No y.vrbl in GDRF terms implies"
  )

  # x.vrbl not numeric (unnamed character vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x"), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  # x.vrbl not named (unnamed numeric vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c(1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl should be a named vector"
  )

  # y.vrbl not numeric (unnamed character vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y"), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  )

  # y.vrbl not named (unnamed numeric vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c(1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl should be a named vector"
  )

  # se.type not valid
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "cough", type = "GDRF"),

    # Expected output
    "Invalid se.type"
  )

  # x.vrbl not in model
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("cough" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "x.vrbl not present"
  )

  # y.vrbl not in model
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("cough" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "y.vrbl not present"
  )

  # d.x missing
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = NULL, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF terms must be specified through d.x and d.y"
  )

  # d.y missing with y.vrbl supplied
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = NULL, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF terms must be specified through d.x and d.y"
  )

  # d.y missing with no y.vrbl (suppressing the y.vrbl = NULL warning)
  suppressWarnings(expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = NULL, z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = NULL, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Even if there is no y.vrbl in GDRF"
  ))

  # d.x not integer
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 1.5, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF terms \\(d.x and d.y\\) must be an integer"
  )

  # d.y not integer
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 1.5, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Order of differencing of variables in GDRF terms \\(d.x and d.y\\) must be an integer"
  )

  # inferences.x not a valid string
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "cough", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.x. The shock.history"
  )

  # inferences.y not a valid string
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "cough",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.y. The response function"
  )

  # inferences.x = "differences" nonsensical when d.x = 0
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "differences", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.x. The shock.history for x cannot be in a higher order"
  )

  # inferences.y = "differences" nonsensical when d.y = 0
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "differences",
      the.coef = coef(model), se.type = "const", type = "GDRF"),

    # Expected output
    "Invalid inferences.y. The response function for y cannot be in a higher order"
  )

  # valid inputs with d.x = 0 produce no error
  expect_no_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 0, inferences.x = "levels", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF")
  )

  # inferences.x = "differences" is valid when d.x = 1
  expect_no_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 1, d.y = 0, inferences.x = "differences", inferences.y = "levels",
      the.coef = coef(model), se.type = "const", type = "GDRF")
  )

  # inferences.y = "differences" is valid when d.y = 1
  expect_no_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("l_1_x" = 1), y.vrbl = c("l_1_d_y" = 1), z.vrbl = NULL, x.z.vrbl = NULL,
      d.x = 0, d.y = 1, inferences.x = "levels", inferences.y = "differences",
      the.coef = coef(lm(d_y ~ l_1_d_y + l_1_x, data = toy.ts.interaction.data)),
      se.type = "const", type = "GDRF")
  )

})

test_that("adl.dummy.checks produces the correct errors and warnings (interact type)", {

  # run a model to use for tests
  model <- lm(y ~ l_1_y + x + l_1_x + z + l_1_z + x_z + z_l_1_x + x_l_1_z + l_1_x_l_1_z,
    data = toy.ts.interaction.data)

  # is.null(z.vrbl)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = NULL, x.z.vrbl = c("x_z" = 0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "Variables in interaction term \\(x, z, and x.z\\) must be specified"
  )

  # is.null(x.z.vrbl)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("z" = 0), x.z.vrbl = NULL,
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "Variables in interaction term \\(x, z, and x.z\\) must be specified"
  )

  # z.vrbl not numeric (unnamed character vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("z"), x.z.vrbl = c("x_z" = 0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "z.vrbl should be a named vector"
  )

  # z.vrbl not named (unnamed numeric vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c(0), x.z.vrbl = c("x_z" = 0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "z.vrbl should be a named vector"
  )

  # x.z.vrbl not numeric (unnamed character vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("z" = 0), x.z.vrbl = c("x_z"),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "x.z.vrbl should be a named vector"
  )

  # x.z.vrbl not named (unnamed numeric vector)
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("z" = 0), x.z.vrbl = c(0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "x.z.vrbl should be a named vector"
  )

  # z.vrbl not in model
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("cough" = 0), x.z.vrbl = c("x_z" = 0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "z.vrbl not present"
  )

  # x.z.vrbl not in model
  expect_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("z" = 0), x.z.vrbl = c("cough" = 0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact"),

    # Expected output
    "x.z.vrbl not present"
  )

  # valid inputs produce no error
  expect_no_error(
    # Function output
    adl.dummy.checks(x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
      z.vrbl = c("z" = 0), x.z.vrbl = c("x_z" = 0),
      d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL,
      the.coef = coef(model), se.type = "const", type = "interact")
  )

})