test_that("GDRF.dummy.checks produces the correct warnings and errors", {

  # effect.type invalid
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "cough", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Invalid effect.type. effect.type must be one of 'discrete' or 'fitted'"
  )

  # shock.size not numeric
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 0, shock.size = "cough", d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "shock.size must be numeric"
  )

  # shock.size length > 1
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 0, shock.size = c(1, 2), d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "shock.size should be a single value"
  )

  # effect.type = "discrete" with prediction.values supplied
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Do not supply prediction.values when effect.type = 'discrete'"
  )

  # effect.type = "discrete" with baseline.y supplied and non-zero
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = NULL, baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Do not supply baseline.y when effect.type = 'discrete'"
  )

  # effect.type = "discrete" with baseline.y.se supplied and non-zero
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 1, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Do not supply baseline.y.se when effect.type = 'discrete'"
  )

  # effect.type = "fitted", both prediction.values and baseline.y are NULL
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "You must provide either a baseline.y value or prediction.values"
  )

  # effect.type = "fitted", prediction.values not a list
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = c(x = 1), baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "If using prediction.values, it must be a list"
  )

  # effect.type = "fitted", prediction.values supplied with non-zero baseline.y.se
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = 1, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "If using prediction.values, do not change baseline.y.se from 0"
  )

  # effect.type = "fitted", baseline.y not numeric
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = "cough",
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "If providing a baseline.y, it must be numeric"
  )

  # effect.type = "fitted", baseline.y length > 1
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = c(1, 2),
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Only provide a single baseline.y value"
  )

  # effect.type = "fitted", baseline.y.se not numeric
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 2,
      baseline.y.se = "cough", shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "If providing a baseline.y.se, it must be numeric"
  )

  # effect.type = "fitted", baseline.y.se length > 1 (requires prediction.values = NULL per code check)
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 2,
      baseline.y.se = c(1, 2), shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Only provide a single baseline.y.se value"
  )

  # effect.type = "fitted", d.y = 1, inferences.y = "levels", no baseline.y
  expect_error(
    # Function output
    suppressWarnings(GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "levels", type = "GDRF")),

    # Expected output
    "There is no baseline for y if effect.type = 'fitted' if d.y > 0"
  )

  # effect.type = "fitted", d.y = 0, both baseline.y and prediction.values supplied
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "Both baseline.y and prediction.values supplied; baseline.y takes precedence and prediction.values will be ignored"
  )

  # effect.type = "fitted", d.y = 0, prediction.values only (warns about differenced variables)
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "If any differenced variables are included in the model, ensure they are set to 0 in prediction.values"
  )

  # effect.type = "fitted", d.y = 1, prediction.values supplied (warns, not errors)
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = list(x = 1), baseline.y = 0,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "levels", type = "GDRF"),

    # Expected output
    "prediction.values is ignored when d.y > 0"
  )

  # effect.type = "fitted", d.y = 1, inferences.y = "differences", non-zero baseline.y
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "differences", type = "GDRF"),

    # Expected output
    "Assuming anything other than baseline.y = 0 when inferences.y = 'differences' suggests the model is unstable"
  )

  # effect.type = "fitted", d.y = 1, inferences.y = "differences", shock.size = 1 (identical to discrete)
  expect_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 0,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "differences", type = "GDRF"),

    # Expected output
    "effect.type = 'fitted' with inferences.y = 'differences' and shock.size = 1 is identical to effect.type = 'discrete'"
  )

  # type = "interact" produces "dynamic conditional effect" in error message, not "GDRF"
  expect_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = list(x = 1), baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "interact"),

    # Expected output
    "dynamic conditional effect"
  )

  # effect.type = "discrete", baseline.y = 0 does not error (0 is the expected no-op value)
  expect_no_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = NULL, baseline.y = 0,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF")
  )

  # effect.type = "discrete", baseline.y.se = 0 does not error (0 is the expected no-op value)
  expect_no_error(
    # Function output
    GDRF.dummy.checks(effect.type = "discrete", prediction.values = NULL, baseline.y = NULL,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF")
  )

  # valid fitted call with baseline.y and d.y = 0 does not error or warn
  expect_no_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 0, inferences.y = "levels", type = "GDRF")
  )

  # valid fitted call with baseline.y and d.y = 1, inferences.y = "levels" does not error or warn
  expect_no_warning(
    # Function output
    GDRF.dummy.checks(effect.type = "fitted", prediction.values = NULL, baseline.y = 5,
      baseline.y.se = 0, shock.size = 1, d.y = 1, inferences.y = "levels", type = "GDRF")
  )

})