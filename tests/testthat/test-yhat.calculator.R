test_that("yhat.calculator produces correct formula (d.y = 0, steady-state assumed)", {
  # set up model and formulae
  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 1), shock.size = 1
  )

  expect_equal( # test whether the s = 1 period has the lagged x terms. steady state uses prediction.values
	# Function output
	result[[3]], # baseline, s = 0, s = 1
	
	# Expected output
	"((Intercept) + 0 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_x  +  l_1_y * x )"
  )
  
  step.general.levels <- general.calculator(d.x = 0, d.y = 0, h = 0,
    limit = 5, pulses = pulses.levels)

  step.result <- yhat.calculator(
    formulae = step.general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 1), shock.size = 1
  )
  
  expect_equal( # test whether the s = 1 period has the lagged x terms. steady state uses prediction.values
	# Function output
	step.result[[3]], # baseline, s = 0, s = 1
	
	# Expected output: the same with the additional x term from the s = 0 period
    "((Intercept) + 0 * x + 1 * l_1_x) / (1 - (l_1_y)) + 1 * (l_1_x  +  l_1_y * x  +  x )"
  )  
})

test_that("yhat.calculator produces correct output (d.y = 0, baseline.y supplied)", {
  # set up model and formulae
  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)
  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), limit = 5)
  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = NULL, baseline.y = 5, shock.size = 1
  )

  # output should be a list
  expect_true(is.list(result))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result), (length(general.levels$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result, is.character)))

  # each formula string should contain the baseline value
  expect_true(all(grepl("^5", result)))

  # each formula string should contain shock.size (except baseline)
  expect_true(all(grepl("1 \\*", result[-1])))
})

test_that("yhat.calculator produces correct output (d.y = 0, prediction.values supplied, no baseline.y)", {
  # set up model and formulae
  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)
  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), limit = 5)
  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = list("x" = 1, "l_1_x" = 1),
    baseline.y = NULL, shock.size = 1
  )

  # output should be a list
  expect_true(is.list(result))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result), (length(general.levels$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result, is.character)))

  # the baseline formula should contain the steady-state denominator
  # (because y.vrbl is non-null, the formula should have a division term)
  expect_true(all(grepl("1 - \\(", result)))

  # the baseline formula should contain the intercept
  expect_true(all(grepl("\\(Intercept\\)", result)))
})

test_that("yhat.calculator produces correct output (d.y = 0, FDL: no y.vrbl)", {
  # set up model and formulae (FDL: no lagged y)
  model.fdl <- lm(y ~ x + l_1_x, data = toy.ts.interaction.data)
  pulses.fdl <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = NULL, limit = 5)
  general.fdl <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.fdl)

  result <- yhat.calculator(
    formulae = general.fdl$formulae, d.y = 0,
    model = model.fdl, the.coef = coef(model.fdl),
    y.vrbl = NULL, inferences.y = "levels",
    prediction.values = list("x" = 1, "l_1_x" = 1),
    baseline.y = NULL, shock.size = 1
  )

  # output should be a list
  expect_true(is.list(result))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result), (length(general.fdl$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result, is.character)))

  # FDL: no denominator, so should NOT contain the division term
  expect_false(any(grepl("1 - \\(", result)))

  # the baseline formula should still contain the intercept
  expect_true(all(grepl("\\(Intercept\\)", result)))
})

test_that("yhat.calculator produces correct output (d.y = 0, baseline.y overrides prediction.values)", {
  # set up model and formulae
  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)
  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), limit = 5)
  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.levels)

  result.baseline <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 1),
    baseline.y = 5, shock.size = 1
  )

  result.no.baseline <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 1),
    baseline.y = NULL, shock.size = 1
  )

  # result with baseline.y should begin with the numeric value, not the formula
  expect_true(all(grepl("^5", result.baseline)))

  # result without baseline.y should contain the formula-based steady state
  expect_true(all(grepl("\\(Intercept\\)", result.no.baseline)))

  # the two results should be different
  expect_false(identical(result.baseline, result.no.baseline))
})

test_that("yhat.calculator produces correct output (d.y = 1, inferences.y = 'differences', baseline forced to 0)", {
  # set up model and formulae
  model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)
  pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_d_y" = 1), limit = 5)
  general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
    limit = 5, pulses = pulses.diffs)

  result <- yhat.calculator(
    formulae = general.diffs$formulae, d.y = 1,
    model = model.diffs, the.coef = coef(model.diffs),
    y.vrbl = c("l_1_d_y" = 1), inferences.y = "differences",
    prediction.values = NULL, baseline.y = NULL, shock.size = 1
  )

  # output should be a list
  expect_true(is.list(result))

  # output should have length equal to limit + 1+ 1 (baseline)
  expect_equal(length(result), (length(general.diffs$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result, is.character)))

  # baseline should be 0 when inferences.y = "differences"
  expect_true(all(grepl("^0", result)))
})

test_that("yhat.calculator produces correct output (d.y = 1, inferences.y = 'levels', baseline.y supplied)", {
  # set up model and formulae
  model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)
  pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_d_y" = 1), limit = 5)
  general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
    limit = 5, pulses = pulses.diffs)

  result <- yhat.calculator(
    formulae = general.diffs$formulae, d.y = 1,
    model = model.diffs, the.coef = coef(model.diffs),
    y.vrbl = c("l_1_d_y" = 1), inferences.y = "levels",
    prediction.values = list("x" = 1, "l_1_x" = 1),
    baseline.y = 5, shock.size = 2
  )

  # output should be a list
  expect_true(is.list(result))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result), (length(general.diffs$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result, is.character)))

  # baseline should be the user-supplied value
  expect_true(all(grepl("^5", result)))

  # shock.size should be reflected in the formula (except baseline)
  expect_true(all(grepl("2 \\*", result[-1])))
})

test_that("yhat.calculator shock.size is correctly reflected in output", {
  # set up model and formulae
  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)
  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), limit = 5)
  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.levels)

  result.shock1 <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = NULL, baseline.y = 5, shock.size = 1
  )

  result.shock2 <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = NULL, baseline.y = 5, shock.size = 2
  )

  # the two results should differ only in shock.size
  expect_false(identical(result.shock1, result.shock2))

  # shock.size = 1 should produce formulas with "1 *" (except baseline)
  expect_true(all(grepl("1 \\*", result.shock1[-1])))

  # shock.size = 2 should produce formulas with "2 *" (except baseline)
  expect_true(all(grepl("2 \\*", result.shock2[-1])))
})

test_that("yhat.calculator formula structure is correct across all periods", {
  # set up model and formulae
  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)
  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
    y.vrbl = c("l_1_y" = 1), limit = 5)
  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
    limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae, d.y = 0,
    model = model.levels, the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
    prediction.values = NULL, baseline.y = 5, shock.size = 1
  )

  # all formulae should share the same baseline prefix (except baseline)
  prefixes <- sapply(result[-1], function(f) substr(f, 1, 4))
  expect_true(length(unique(prefixes)) == 1)
})




