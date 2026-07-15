test_that("gecm.plot passes arguments to GDRF.gecm.plot correctly", {

  model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)

  ####################################################################################
  # Core check: gecm.plot and the equivalent GDRF.gecm.plot call produce identical
  #  output for a pulse shock. This confirms the wrapper passes all arguments through
  ####################################################################################
  out_gecm_pulse <- gecm.plot(
    model = model,
    x.vrbl = c("l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
    y.d.vrbl = c("l_1_d_y" = 1),
    shock.history = "pulse",
    s.limit = 5,
    return.data = TRUE,
    return.plot = TRUE,
    return.formulae = TRUE
  )

  out_gdrf_pulse <- GDRF.gecm.plot(
    model = model,
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
    effect.type = "marginal",
    prediction.values = NULL,
    baseline.y = NULL,
    baseline.y.se = 0,
    shock.size = 1,
    s.limit = 5,
    return.data = TRUE,
    return.plot = TRUE,
    return.formulae = TRUE
  )

  expect_equal( # estimates match for pulse
    # Function output
    out_gecm_pulse$estimates,

    # Expected output
    out_gdrf_pulse$estimates
  )

  expect_equal( # formulae match for pulse
    # Function output
    out_gecm_pulse$formulae,

    # Expected output
    out_gdrf_pulse$formulae
  )

  expect_equal( # binomials match for pulse
    # Function output
    out_gecm_pulse$binomials,

    # Expected output
    out_gdrf_pulse$binomials
  )

  ####################################################################################
  # Same core check for a step shock
  ####################################################################################
  out_gecm_step <- gecm.plot(
    model = model,
    x.vrbl = c("l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
    y.d.vrbl = c("l_1_d_y" = 1),
    shock.history = "step",
    s.limit = 5,
    return.data = TRUE,
    return.plot = TRUE,
    return.formulae = TRUE
  )

  out_gdrf_step <- GDRF.gecm.plot(
    model = model,
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
    effect.type = "marginal",
    prediction.values = NULL,
    baseline.y = NULL,
    baseline.y.se = 0,
    shock.size = 1,
    s.limit = 5,
    return.data = TRUE,
    return.plot = TRUE,
    return.formulae = TRUE
  )

  expect_equal( # estimates match for step
    # Function output
    out_gecm_step$estimates,

    # Expected output
    out_gdrf_step$estimates
  )

  expect_equal( # formulae match for step
    # Function output
    out_gecm_step$formulae,

    # Expected output
    out_gdrf_step$formulae
  )

  expect_equal( # binomials match for step
    # Function output
    out_gecm_step$binomials,

    # Expected output
    out_gdrf_step$binomials
  )

  ####################################################################################
  # The fixed arguments gecm.plot imposes (x.vrbl.d.x = 0, y.vrbl.d.y = 0,
  #  x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1, inferences in levels, effect.type = marginal)
  #  cannot be overridden, so calling GDRF.gecm.plot with different values should NOT
  #  equal gecm.plot output
  ####################################################################################
  out_gdrf_different <- GDRF.gecm.plot(
    model = model,
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
    effect.type = "fitted",  # intentionally different
    baseline.y = 5,
    baseline.y.se = 0,
    shock.size = 1,
    s.limit = 5,
    return.data = TRUE,
    return.plot = TRUE,
    return.formulae = TRUE
  )

  expect_false( # fixed arguments are indeed fixed
    # Function output
    identical(out_gecm_pulse$estimates, out_gdrf_different$estimates)
  )

  ####################################################################################
  # s.limit is forwarded: check it changes the number of rows in estimates
  ####################################################################################
  out_s5 <- gecm.plot(
    model = model,
    x.vrbl = c("l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
    y.d.vrbl = c("l_1_d_y" = 1),
    s.limit = 5,
    return.data = TRUE
  )

  out_s10 <- gecm.plot(
    model = model,
    x.vrbl = c("l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
    y.d.vrbl = c("l_1_d_y" = 1),
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
  out_nodata <- gecm.plot(
    model = model,
    x.vrbl = c("l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
    y.d.vrbl = c("l_1_d_y" = 1),
    s.limit = 5,
    return.data = TRUE,
    return.plot = TRUE,
    return.formulae = FALSE
  )

  expect_true( # estimates not returned when return.data = TRUE
    # Function output
    "estimates" %in% names(out_nodata)
  )

  expect_false( # formulae not returned when return.formulae = FALSE
    # Function output
    "formulae" %in% names(out_nodata)
  )

  expect_true( # plot is returned when return.plot = TRUE
    # Function output
    "plot" %in% names(out_nodata)
  )

  out_noplot <- gecm.plot(
    model = model,
    x.vrbl = c("l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1),
    x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
    y.d.vrbl = c("l_1_d_y" = 1),
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


test_that("gecm.plot inherits errors from GDRF.gecm.plot for bad inputs", {

  model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)

  expect_error( # missing x.vrbl reaches GDRF.gecm.plot
    # Function output
    gecm.plot(model = model,
              y.vrbl = c("l_1_y" = 1),
              x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
              y.d.vrbl = c("l_1_d_y" = 1),
              s.limit = 5),

    # Expected output
    "Variables in shock history terms \\(x and y\\) and lagged differences"
  )

  expect_error( # x.vrbl not in model reaches GDRF.gecm.plot
    # Function output
    gecm.plot(model = model,
              x.vrbl = c("weeping angel" = 1),
              y.vrbl = c("l_1_y" = 1),
              x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
              y.d.vrbl = c("l_1_d_y" = 1),
              s.limit = 5),

    # Expected output
    "x.vrbl not present in estimated model"
  )

  expect_error( # y.vrbl not in model reaches GDRF.gecm.plot
    # Function output
    gecm.plot(model = model,
              x.vrbl = c("l_1_x" = 1),
              y.vrbl = c("androzani" = 1),
              x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
              y.d.vrbl = c("l_1_d_y" = 1),
              s.limit = 5),

    # Expected output
    "y.vrbl not present in estimated model"
  )

  expect_error( # x.d.vrbl not in model reaches GDRF.gecm.plot
    # Function output
    gecm.plot(model = model,
              x.vrbl = c("l_1_x" = 1),
              y.vrbl = c("l_1_y" = 1),
              x.d.vrbl = c("d_x" = 0, "Sontaran" = 1),
              y.d.vrbl = c("l_1_d_y" = 1),
              s.limit = 5),

    # Expected output
    "x.d.vrbl not present in estimated model"
  )

  expect_error( # y.d.vrbl not in model reaches GDRF.gecm.plot
    # Function output
    gecm.plot(model = model,
              x.vrbl = c("l_1_x" = 1),
              y.vrbl = c("l_1_y" = 1),
              x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
              y.d.vrbl = c("Rassilon" = 1),
              s.limit = 5),

    # Expected output
    "y.d.vrbl not present in estimated model"
  )

  expect_error( # invalid se.type reaches GDRF.gecm.plot
    # Function output
    gecm.plot(model = model,
              x.vrbl = c("l_1_x" = 1),
              y.vrbl = c("l_1_y" = 1),
              x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
              y.d.vrbl = c("l_1_d_y" = 1),
              se.type = "Cyberman",
              s.limit = 5),

    # Expected output
    "Invalid se.type. se.type must be an accepted"
  )

})
