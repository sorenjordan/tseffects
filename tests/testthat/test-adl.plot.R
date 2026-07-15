test_that("adl.plot passes arguments to GDRF.adl.plot correctly", {

  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  ####################################################################################
  # Core check: adl.plot and the equivalent GDRF.adl.plot call produce identical
  #  output for a pulse shock. This confirms the wrapper passes all arguments through
  ####################################################################################
  
  out_adl_pulse <- adl.plot(
    model = model, x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), shock.history = "pulse", s.limit = 5,
	return.data = TRUE, return.plot = TRUE, return.formulae = TRUE)

  out_gdrf_pulse <- GDRF.adl.plot(
    model = model,
    x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
    d.x = 0, d.y = 0, shock.history = "pulse",
    inferences.y = "levels", inferences.x = "levels", effect.type = "marginal",
    prediction.values = NULL, baseline.y = NULL,
    baseline.y.se = 0, shock.size = 1, s.limit = 5,
    return.data = TRUE, return.plot = TRUE, return.formulae = TRUE
  )

  expect_equal( # estimates match for pulse
    # Function output
    out_adl_pulse$estimates,

    # Expected output
    out_gdrf_pulse$estimates
  )

  expect_equal( # formulae match for pulse
    # Function output
    out_adl_pulse$formulae,

    # Expected output
    out_gdrf_pulse$formulae
  )

  expect_equal( # binomials match for pulse
    # Function output
    out_adl_pulse$binomials,

    # Expected output
    out_gdrf_pulse$binomials
  )

  ####################################################################################
  # Same core check for a step shock
  ####################################################################################
  out_adl_step <- adl.plot(
    model = model, x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), shock.history = "step", s.limit = 5,
	return.data = TRUE, return.plot = TRUE, return.formulae = TRUE)

  out_gdrf_step <- GDRF.adl.plot(
    model = model,
    x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
    d.x = 0, d.y = 0, shock.history = "step",
    inferences.y = "levels", inferences.x = "levels", effect.type = "marginal",
    prediction.values = NULL, baseline.y = NULL,
    baseline.y.se = 0, shock.size = 1, s.limit = 5,
    return.data = TRUE, return.plot = TRUE, return.formulae = TRUE
  )

  expect_equal( # estimates match for step
    # Function output
    out_adl_step$estimates,

    # Expected output
    out_gdrf_step$estimates
  )

  expect_equal( # formulae match for step
    # Function output
    out_adl_step$formulae,

    # Expected output
    out_gdrf_step$formulae
  )

  expect_equal( # binomials match for step
    # Function output
    out_adl_step$binomials,

    # Expected output
    out_gdrf_step$binomials
  )

  ####################################################################################
  # The fixed arguments adl.plot imposes (d.x = 0, d.y = 0, inferences in levels,
  #  effect.type = marginal) cannot be overridden, so calling GDRF.adl.plot with
  #  different values should NOT equal adl.plot output
  ####################################################################################
  out_gdrf_different <- GDRF.adl.plot(
    model = model,
    x.vrbl = c("x" = 0, "l_1_x" = 1), y.vrbl = c("l_1_y" = 1),
    d.x = 1, d.y = 1, shock.history = "step",
    inferences.y = "levels", inferences.x = "levels", effect.type = "marginal",
    prediction.values = NULL, baseline.y = NULL,
    baseline.y.se = 0, shock.size = 1, s.limit = 5,
    return.data = TRUE, return.plot = TRUE, return.formulae = TRUE
  )

  expect_false( # fixed arguments are indeed fixed
    # Function output
    identical(out_adl_pulse$estimates, out_gdrf_different$estimates)
  )

  ####################################################################################
  # s.limit is forwarded: check it changes the number of rows in estimates
  ####################################################################################
  out_s5 <- adl.plot(
    model = model,
    x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    s.limit = 5,
    return.data = TRUE
  )

  out_s10 <- adl.plot(
    model = model,
    x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl  = c("l_1_y" = 1),
    s.limit = 10,
    return.data = TRUE
  )

  expect_equal( # s.limit = 5 produces 6 rows (s = 0 ... 5)
    # Function output
    nrow(out_s5$estimates),

    # Expected output
    5 + 1
  )

  expect_equal( # s.limit = 10 produces 11 rows (s = 0 ... 10)
    # Function output
    nrow(out_s10$estimates),

    # Expected output
    10 + 1
  )

  ####################################################################################
  # return.* flags are forwarded correctly
  ####################################################################################
  out_nodata <- adl.plot(
    model = model,
    x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    s.limit = 5,
    return.data = FALSE,
    return.plot = TRUE,
    return.formulae = FALSE
  )

  expect_false( # estimates not returned when return.data = FALSE
    # Function output
    "estimates" %in% names(out_nodata)
  )

  expect_false( # formulae not returned when return.formulae = FALSE
    # Function output
    "formulae" %in% names(out_nodata)
  )

  expect_false( # plot is returned when return.plot = TRUE AND something else is returned, but it is unnamed otherwise
    # Function output
    "plot" %in% names(out_nodata)
  )

  out_noplot <- adl.plot(
	model = model,
	x.vrbl = c("x" = 0, "l_1_x" = 1),
	y.vrbl = c("l_1_y" = 1),
	s.limit = 5,
	return.data = TRUE,
	return.plot = FALSE,
	return.formulae = TRUE
  )

  expect_true( # estimates returned when return.data = TRUE
    # Function output
    "estimates" %in% names(out_noplot)
  )

  expect_true( # formulae returned when return.formulae = TRUE
    # Function output
    "formulae" %in% names(out_noplot)
  )

  expect_false( # plot not returned when return.plot = FALSE
    # Function output
    "plot" %in% names(out_noplot)
  )

})


test_that("adl.plot inherits errors from GDRF.adl.plot for bad inputs", {

  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  expect_error( # missing x.vrbl reaches GDRF.adl.plot
    # Function output
    adl.plot(model  = model,
		y.vrbl = c("l_1_y" = 1),
		s.limit = 5),

    # Expected output
    "Variables in .* must be specified through x.vrbl"
  )

  expect_error( # x.vrbl not in model reaches GDRF.adl.plot
    # Function output
    adl.plot(model  = model,
		x.vrbl = c("not_a_variable" = 0, "also_not" = 1),
		y.vrbl = c("l_1_y" = 1),
		s.limit = 5),

    # Expected output
    "x.vrbl not present in estimated model"
  )

  expect_error( # y.vrbl not in model reaches GDRF.adl.plot
    # Function output
    adl.plot(model  = model,
		x.vrbl = c("x" = 0, "l_1_x" = 1),
		y.vrbl = c("not_a_variable" = 1),
		s.limit = 5),

    # Expected output
    "y.vrbl not present in estimated model"
  )

  expect_error( # invalid se.type reaches GDRF.adl.plot
    # Function output
    adl.plot(model   = model,
		x.vrbl  = c("x" = 0, "l_1_x" = 1),
		y.vrbl  = c("l_1_y" = 1),
		se.type = "woof",
		s.limit = 5),

    # Expected output
    "Invalid se.type."
  )

})
