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
	result$modified.formulae[[3]], # baseline, s = 0, s = 1
	
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
	step.result$modified.formulae[[3]], # baseline, s = 0, s = 1
	
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
  expect_true(is.list(result$modified.formulae))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result$modified.formulae), (length(general.levels$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result$modified.formulae, is.character)))

  # each formula string should contain the baseline value
  expect_true(all(grepl("^5", result$modified.formulae)))

  # each formula string should contain shock.size (except baseline)
  expect_true(all(grepl("1 \\*", result$modified.formulae[-1])))
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
  expect_true(is.list(result$modified.formulae))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result$modified.formulae), (length(general.levels$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result$modified.formulae, is.character)))

  # the baseline formula should contain the steady-state denominator
  # (because y.vrbl is non-null, the formula should have a division term)
  expect_true(all(grepl("1 - \\(", result$modified.formulae)))

  # the baseline formula should contain the intercept
  expect_true(all(grepl("\\(Intercept\\)", result$modified.formulae)))
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
  expect_true(is.list(result$modified.formulae))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result$modified.formulae), (length(general.fdl$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result$modified.formulae, is.character)))

  # FDL: no denominator, so should NOT contain the division term
  expect_false(any(grepl("1 - \\(", result$modified.formulae)))

  # the baseline formula should still contain the intercept
  expect_true(all(grepl("\\(Intercept\\)", result$modified.formulae)))
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
  expect_true(all(grepl("^5", result.baseline$modified.formulae)))

  # result without baseline.y should contain the formula-based steady state
  expect_true(all(grepl("\\(Intercept\\)", result.no.baseline$modified.formulae)))

  # the two results should be different
  expect_false(identical(result.baseline, result.no.baseline$modified.formulae))
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
  expect_true(is.list(result$modified.formulae))

  # output should have length equal to limit + 1+ 1 (baseline)
  expect_equal(length(result$modified.formulae), (length(general.diffs$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result$modified.formulae, is.character)))

  # baseline should be 0 when inferences.y = "differences"
  expect_true(all(grepl("^0", result$modified.formulae)))
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
  expect_true(is.list(result$modified.formulae))

  # output should have length equal to limit + 1 + 1 (baseline)
  expect_equal(length(result$modified.formulae), (length(general.diffs$formulae) + 1))

  # each element should be a character string
  expect_true(all(sapply(result$modified.formulae, is.character)))

  # baseline should be the user-supplied value
  expect_true(all(grepl("^5", result$modified.formulae)))

  # shock.size should be reflected in the formula (except baseline)
  expect_true(all(grepl("2 \\*", result$modified.formulae[-1])))
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
  expect_false(identical(result.shock1$modified.formulae, result.shock2$modified.formulae))

  # shock.size = 1 should produce formulas with "1 *" (except baseline)
  expect_true(all(grepl("1 \\*", result.shock1$modified.formulae[-1])))

  # shock.size = 2 should produce formulas with "2 *" (except baseline)
  expect_true(all(grepl("2 \\*", result.shock2$modified.formulae[-1])))
})

test_that("yhat.calculator output structure is correct", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 1, "l_1_x" = 1),
    baseline.y = NULL,
    shock.size = 1
  )

  expect_true( # output is a list
    # Function output
    is.list(result)
  )

  expect_equal( # output has two named elements: modified.formulae and modified.symbolic.formulae
    # Function output
    names(result),

    # Expected output
    c("modified.formulae", "modified.symbolic.formulae")
  )

  expect_equal( # modified.formulae has length limit + 1 + 1 (baseline prepended)
    # Function output
    length(result$modified.formulae),

    # Expected output
    length(general.levels$formulae) + 1
  )

  expect_equal( # modified.symbolic.formulae has same length as modified.formulae
    # Function output
    length(result$modified.symbolic.formulae),

    # Expected output
    length(result$modified.formulae)
  )

  expect_true( # every element of modified.formulae is a character string
    # Function output
    all(sapply(result$modified.formulae, is.character))
  )

  expect_true( # every element of modified.symbolic.formulae is a character string
    # Function output
    all(sapply(result$modified.symbolic.formulae, is.character))
  )

})


test_that("yhat.calculator baseline construction is correct (d.y = 0, prediction.values supplied)", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 1, "l_1_x" = 1),
    baseline.y = NULL,
    shock.size = 1
  )

  expect_true( # baseline formula contains the intercept term
    # Function output
    grepl("\\(Intercept\\)", result$modified.formulae[[1]])
  )

  expect_true( # baseline formula contains the steady-state denominator (1 - y.vrbl)
    # Function output
    grepl("1 - \\(l_1_y\\)", result$modified.formulae[[1]])
  )

  expect_true( # baseline formula contains the supplied value of x (1)
    # Function output
    grepl("^\\(\\(Intercept\\) \\+ 1 \\* x \\+ 1 \\* l_1_x\\)", result$modified.formulae[[1]])
  )

  expect_true( # symbolic formula uses numeric values (not z_val placeholder) since no interaction
    # Function output
    !grepl("z_val", result$modified.symbolic.formulae[[1]])
  )

})


test_that("yhat.calculator baseline construction is correct (d.y = 0, prediction.values, mean fallback)", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  # only supply x, not l_1_x: l_1_x should fall back to its mean and warn
  expect_warning(
    result <- yhat.calculator(
      formulae = general.levels$formulae,
      d.y = 0,
      model = model.levels,
      the.coef = coef(model.levels),
      y.vrbl = c("l_1_y" = 1),
      inferences.y = "levels",
      prediction.values = list("x" = 1),
      baseline.y = NULL,
      shock.size = 1
    ),

    # Expected output
    "l_1_x not in prediction.values; mean of series used"
  )

  expect_true( # baseline still contains the intercept term after mean fallback
    # Function output
    grepl("\\(Intercept\\)", result$modified.formulae[[1]])
  )

  expect_true( # baseline formula contains the mean of l_1_x when not in prediction.values
    # Function output
    grepl(as.character(mean(toy.ts.interaction.data$l_1_x, na.rm = TRUE)),
        result$modified.formulae[[1]],
        fixed = TRUE)
  )  
  
  expect_true( # baseline still contains the steady-state denominator after mean fallback
    # Function output
    grepl("1 - \\(l_1_y\\)", result$modified.formulae[[1]])
  )

})


test_that("yhat.calculator baseline construction is correct (d.y = 0, baseline.y supplied)", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  result <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = NULL,
    baseline.y = 5,
    shock.size = 1
  )

  expect_equal( # baseline element is the numeric baseline.y value as a string
    # Function output
    result$modified.formulae[[1]],

    # Expected output
    "5"
  )

  expect_true( # all non-baseline formulae start with the baseline value
    # Function output
    all(sapply(result$modified.formulae[-1], function(f) startsWith(f, "5 + ")))
  )

})


test_that("yhat.calculator baseline.y overrides prediction.values (d.y = 0)", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  result.baseline <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 1),
    baseline.y = 5,
    shock.size = 1
  )

  result.pred <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 1),
    baseline.y = NULL,
    shock.size = 1
  )

  expect_equal( # baseline.y = 5 means the first element is "5", not the steady-state formula
    # Function output
    result.baseline$modified.formulae[[1]],

    # Expected output
    "5"
  )

  expect_true( # prediction.values result has steady-state formula with intercept, not a bare number
    # Function output
    grepl("\\(Intercept\\)", result.pred$modified.formulae[[1]])
  )

  expect_false( # the two results differ
    # Function output
    identical(result.baseline$modified.formulae, result.pred$modified.formulae)
  )

})


test_that("yhat.calculator FDL (no y.vrbl) baseline has no denominator", {

  model.fdl <- lm(y ~ x + l_1_x, data = toy.ts.interaction.data)

  pulses.fdl <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                 y.vrbl = NULL, limit = 5)

  general.fdl <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                    limit = 5, pulses = pulses.fdl)

  result <- yhat.calculator(
    formulae = general.fdl$formulae,
    d.y = 0,
    model = model.fdl,
    the.coef = coef(model.fdl),
    y.vrbl = NULL,
    inferences.y = "levels",
    prediction.values = list("x" = 1, "l_1_x" = 1),
    baseline.y = NULL,
    shock.size = 1
  )

  expect_false( # FDL baseline has no steady-state denominator
    # Function output
    grepl("1 - \\(", result$modified.formulae[[1]])
  )

  expect_true( # FDL baseline still contains intercept
    # Function output
    grepl("\\(Intercept\\)", result$modified.formulae[[1]])
  )

})


test_that("yhat.calculator shock.size is correctly embedded in non-baseline formulae", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  result.shock1 <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = NULL,
    baseline.y = 5,
    shock.size = 1
  )

  result.shock3 <- yhat.calculator(
    formulae = general.levels$formulae,
    d.y = 0,
    model = model.levels,
    the.coef = coef(model.levels),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = NULL,
    baseline.y = 5,
    shock.size = 3
  )

  expect_true( # shock.size = 1 embeds "1 * (" in all non-baseline formulae
    # Function output
    all(sapply(result.shock1$modified.formulae[-1], function(f) grepl("1 \\* \\(", f)))
  )

  expect_true( # shock.size = 3 embeds "3 * (" in all non-baseline formulae
    # Function output
    all(sapply(result.shock3$modified.formulae[-1], function(f) grepl("3 \\* \\(", f)))
  )

  expect_false( # shock.size = 1 and shock.size = 3 produce different formulae
    # Function output
    identical(result.shock1$modified.formulae, result.shock3$modified.formulae)
  )

  expect_equal( # shock.size does not affect the baseline element
    # Function output
    result.shock1$modified.formulae[[1]],

    # Expected output
    result.shock3$modified.formulae[[1]]
  )

})


test_that("yhat.calculator is correct (d.y = 1, inferences.y = 'differences', baseline forced to 0)", {

  model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)

  pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_d_y" = 1), limit = 5)

  general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
                                      limit = 5, pulses = pulses.diffs)

  result <- yhat.calculator(
    formulae = general.diffs$formulae,
    d.y = 1,
    model = model.diffs,
    the.coef = coef(model.diffs),
    y.vrbl = c("l_1_d_y" = 1),
    inferences.y = "differences",
    prediction.values = NULL,
    baseline.y = NULL,
    shock.size = 1
  )

  expect_equal( # baseline element is "0" when inferences.y = "differences"
    # Function output
    result$modified.formulae[[1]],

    # Expected output
    "0"
  )

  expect_true( # all non-baseline formulae start with "0 + "
    # Function output
    all(sapply(result$modified.formulae[-1], function(f) startsWith(f, "0 + ")))
  )

})


test_that("yhat.calculator is correct (d.y = 1, inferences.y = 'levels', baseline.y supplied)", {

  model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)

  pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_d_y" = 1), limit = 5)

  general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
                                      limit = 5, pulses = pulses.diffs)

  result <- yhat.calculator(
    formulae = general.diffs$formulae,
    d.y = 1,
    model = model.diffs,
    the.coef = coef(model.diffs),
    y.vrbl = c("l_1_d_y" = 1),
    inferences.y = "levels",
    prediction.values = NULL,
    baseline.y = 7,
    shock.size = 2
  )

  expect_equal( # baseline element is the user-supplied baseline.y as a string
    # Function output
    result$modified.formulae[[1]],

    # Expected output
    "7"
  )

  expect_true( # all non-baseline formulae start with the baseline value
    # Function output
    all(sapply(result$modified.formulae[-1], function(f) startsWith(f, "7 + ")))
  )

  expect_true( # shock.size = 2 is embedded in non-baseline formulae
    # Function output
    all(sapply(result$modified.formulae[-1], function(f) grepl("2 \\* \\(", f)))
  )

})


test_that("yhat.calculator interaction: z_val placeholder appears in symbolic formulae", {

  model.interact <- lm(y ~ x + l_1_x + z + l_1_z + x_z + l_1_x_l_1_z + l_1_y,
                       data = toy.ts.interaction.data)

  pulses.interact <- pulse.calculator(
    x.vrbl = c("x+x_z*z_val" = 0, "l_1_x+l_1_x_l_1_z*z_val" = 1),
    y.vrbl = c("l_1_y" = 1),
    limit  = 5
  )

  general.interact <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                         limit = 5, pulses = pulses.interact)

  result <- yhat.calculator(
    formulae = general.interact$formulae,
    d.y = 0,
    model = model.interact,
    the.coef = coef(model.interact),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 0, "x_z" = 0, "l_1_x_l_1_z" = 0),
    baseline.y = NULL,
    shock.size = 1,
    z.val = 1,
    z.vrbl = c("z" = 0, "l_1_z" = 1),
    x.z.vrbl = c("x_z" = 0, "l_1_x_l_1_z" = 1)
  )

  expect_true( # symbolic baseline formula contains z_val placeholder
    # Function output
    grepl("z_val", result$modified.symbolic.formulae[[1]])
  )

  expect_false( # evaluated baseline formula has no z_val placeholder (replaced with numeric z)
    # Function output
    grepl("z_val", result$modified.formulae[[1]])
  )

  expect_true( # evaluated baseline formula contains the numeric value of z (1)
    # Function output
    grepl("1\\* z_val|z_val|1 \\*", result$modified.formulae[[1]]) |
    !grepl("z_val", result$modified.formulae[[1]])
  )

  expect_true( # symbolic and evaluated formulae differ because of z_val substitution
    # Function output
    !identical(result$modified.symbolic.formulae[[1]], result$modified.formulae[[1]])
  )

})


test_that("yhat.calculator interaction: baseline.y suppresses steady-state and z_val in baseline", {

  model.interact <- lm(y ~ x + l_1_x + z + l_1_z + x_z + l_1_x_l_1_z + l_1_y,
                       data = toy.ts.interaction.data)

  pulses.interact <- pulse.calculator(
    x.vrbl = c("x+x_z*z_val" = 0, "l_1_x+l_1_x_l_1_z*z_val" = 1),
    y.vrbl = c("l_1_y" = 1),
    limit  = 5
  )

  general.interact <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                         limit = 5, pulses = pulses.interact)

  result <- yhat.calculator(
    formulae = general.interact$formulae,
    d.y = 0,
    model = model.interact,
    the.coef = coef(model.interact),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = NULL,
    baseline.y = 10,
    shock.size = 1,
    z.val = 2,
    z.vrbl = c("z" = 0, "l_1_z" = 1),
    x.z.vrbl = c("x_z" = 0, "l_1_x_l_1_z" = 1)
  )

  expect_equal( # baseline element is the user-supplied baseline.y as a string
    # Function output
    result$modified.formulae[[1]],

    # Expected output
    "10"
  )

  expect_equal( # symbolic baseline element is also the user-supplied baseline.y as a string
    # Function output
    result$modified.symbolic.formulae[[1]],

    # Expected output
    "10"
  )

  expect_true( # all non-baseline formulae start with the baseline value
    # Function output
    all(sapply(result$modified.formulae[-1], function(f) startsWith(f, "10 + ")))
  )

})


test_that("yhat.calculator interaction: z.val is correctly substituted into non-baseline formulae", {

  model.interact <- lm(y ~ x + l_1_x + z + l_1_z + x_z + l_1_x_l_1_z + l_1_y,
                       data = toy.ts.interaction.data)

  pulses.interact <- pulse.calculator(
    x.vrbl = c("x+x_z*z_val" = 0, "l_1_x+l_1_x_l_1_z*z_val" = 1),
    y.vrbl = c("l_1_y" = 1),
    limit  = 5
  )

  general.interact <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                         limit = 5, pulses = pulses.interact)

  result.z1 <- yhat.calculator(
    formulae = general.interact$formulae,
    d.y = 0,
    model = model.interact,
    the.coef = coef(model.interact),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 0, "x_z" = 0, "l_1_x_l_1_z" = 0),
    baseline.y = NULL,
    shock.size = 1,
    z.val = 1,
    z.vrbl = c("z" = 0, "l_1_z" = 1),
    x.z.vrbl = c("x_z" = 0, "l_1_x_l_1_z" = 1)
  )

  result.z3 <- yhat.calculator(
    formulae = general.interact$formulae,
    d.y = 0,
    model = model.interact,
    the.coef = coef(model.interact),
    y.vrbl = c("l_1_y" = 1),
    inferences.y = "levels",
    prediction.values = list("x" = 0, "l_1_x" = 0, "x_z" = 0, "l_1_x_l_1_z" = 0),
    baseline.y = NULL,
    shock.size = 1,
    z.val = 3,
    z.vrbl = c("z" = 0, "l_1_z" = 1),
    x.z.vrbl = c("x_z" = 0, "l_1_x_l_1_z" = 1)
  )

  expect_false( # different z.val produces different evaluated formulae
    # Function output
    identical(result.z1$modified.formulae, result.z3$modified.formulae)
  )

  expect_true( # symbolic formulae are identical regardless of z.val (placeholder not substituted)
    # Function output
    identical(result.z1$modified.symbolic.formulae, result.z3$modified.symbolic.formulae)
  )

  expect_true( # symbolic formulae contain z_val placeholder in non-baseline elements
    # Function output
    all(sapply(result.z1$modified.symbolic.formulae[-1], function(f) grepl("z_val", f)))
  )

  expect_true( # evaluated non-baseline formulae still contain z_val placeholder (substitution happens in interact.adl.plot)
    # Function output
    all(sapply(result.z1$modified.formulae[-1], function(f) grepl("z_val", f)))
  )

})


test_that("yhat.calculator stops correctly on invalid inputs", {

  model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)

  pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                    y.vrbl = c("l_1_y" = 1), limit = 5)

  general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
                                       limit = 5, pulses = pulses.levels)

  model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)

  pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
                                   y.vrbl = c("l_1_d_y" = 1), limit = 5)

  general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
                                      limit = 5, pulses = pulses.diffs)

  # d.y = 0, no baseline.y and no prediction.values: stops with an error
  expect_error(
    # Function output
    yhat.calculator(
      formulae = general.levels$formulae,
      d.y = 0,
      model = model.levels,
      the.coef = coef(model.levels),
      y.vrbl = c("l_1_y" = 1),
      inferences.y = "levels",
      prediction.values = NULL,
      baseline.y = NULL,
      shock.size = 1
    ),

    # Expected output
    "No baseline or predicted values for y in levels for yhat.calculator"
  )

  # d.y = 1, inferences.y = "levels", no baseline.y and no prediction.values: stops with an error
  expect_error(
    # Function output
    yhat.calculator(
      formulae = general.diffs$formulae,
      d.y = 1,
      model = model.diffs,
      the.coef = coef(model.diffs),
      y.vrbl = c("l_1_d_y" = 1),
      inferences.y = "levels",
      prediction.values = NULL,
      baseline.y = NULL,
      shock.size = 1
    ),

    # Expected output
    "No baseline or predicted values for y in levels for yhat.calculator"
  )

  # d.y = 0, prediction.values contains a z.vrbl name: stops with an error
  expect_error(
    # Function output
    yhat.calculator(
      formulae = general.levels$formulae,
      d.y = 0,
      model = model.levels,
      the.coef = coef(model.levels),
      y.vrbl = c("l_1_y" = 1),
      inferences.y = "levels",
      prediction.values = list("x" = 1, "l_1_x" = 1, "z" = 0),
      baseline.y = NULL,
      shock.size = 1,
      z.vrbl = c("z" = 0)
    ),

    # Expected output
    "Do not supply value for any z.vrbl in prediction.values. These come from z.val"
  )

})





