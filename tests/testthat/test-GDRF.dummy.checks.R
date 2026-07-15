test_that("GDRF.dummy.checks produces the correct warnings and errors", {

  # effect.type invalid
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "cough", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = NULL, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Invalid effect.type. effect.type must be one of marginal or fitted"
  )

  # effect.type = "marginal" with prediction.values supplied
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "marginal", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = NULL, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Do not supply prediction.values when effect.type = 'marginal'"
  )

  # effect.type = "marginal" with baseline.y supplied
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "marginal", prediction.values = NULL, baseline.y = 5,
      baseline.y.se = NULL, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Do not supply baseline.y when effect.type = 'marginal'"
  )

  # effect.type = "marginal" with baseline.y.se supplied
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "marginal", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 1, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Do not supply baseline.y.se when effect.type = 'marginal'"
  )

  # effect.type = "marginal" with shock.size != 0 (i.e. != 1 default, a non-default value)
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "marginal", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = NULL, shock.size = 2, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Do not supply shock.size when effect.type = 'marginal'"
  )

  # effect.type = "fitted", prediction.values not a list
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = c(x = 1), baseline.y = NULL,
      baseline.y.se = NULL, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "If using prediction.values, it must be a list"
  )

  # effect.type = "fitted", baseline.y not numeric
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = "cough",
      baseline.y.se = NULL, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "If providing a baseline.y, it must be numeric"
  )

  # effect.type = "fitted", baseline.y length > 1
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = c(1, 2),
      baseline.y.se = NULL, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Only provide a single baseline.y value"
  )

  # effect.type = "fitted", baseline.y.se not numeric
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 2,
      baseline.y.se = "cough", shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "If providing a baseline.y.se, it must be numeric"
  )

  # effect.type = "fitted", baseline.y.se length > 1
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 2,
      baseline.y.se = c(1, 2), shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Only provide a single baseline.y.se value"
  )

  # effect.type = "fitted", shock.size not numeric
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 2,
      baseline.y.se = 0, shock.size = "cough", d.y = 0, inferences.y = "levels"),
    # Expected output
    "shock.size must be numeric"
  )

  # effect.type = "fitted", d.y = 0, both baseline.y and prediction.values supplied
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "Both baseline.y and prediction.values supplied; baseline.y takes precedence and prediction.values will be ignored"
  )

  # effect.type = "fitted", d.y = 0, no baseline.y (using prediction.values)
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels"),
    # Expected output
    "If any differenced variables are included in the model, ensure they are set to 0 in prediction.values"
  )

  # effect.type = "fitted", d.y = 1, prediction.values supplied (should warn, not error)
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = 0,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "levels"),
    # Expected output
    "prediction.values is ignored when d.y > 0"
  )

  # effect.type = "fitted", d.y = 1, inferences.y = "differences", non-zero baseline.y
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "differences"),
    # Expected output
    "Assuming anything other than baseline.y = 0 when inferences.y = 'differences' suggests the model is unstable"
  )

  # effect.type = "fitted", d.y = 1, inferences.y = "differences", shock.size = 1 (redundant with marginal)
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 0,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "differences"),
    # Expected output
    "effect.type = 'fitted' with inferences.y = 'differences' and shock.size = 1 is identical to effect.type = 'marginal'"
  )

})