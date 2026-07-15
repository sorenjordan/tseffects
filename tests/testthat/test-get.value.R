test_that("get.value returns correct values", {
  model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  expect_equal( # user-supplied value is returned directly
    # Function output
    get.value(var = "x", prediction.values = list("x" = 5), model = model),

    # Expected output
    5
  )

  expect_equal( # user-supplied value of 0 is returned (not treated as missing)
    # Function output
    get.value(var = "x", prediction.values = list("x" = 0), model = model),

    # Expected output
    0
  )

  expect_warning( # variable not in prediction.values: mean used and warning issued
    # Function output
    get.value(var = "x", prediction.values = list(), model = model),

    # Expected output
    "x not in prediction.values; mean of series used"
  )

  expect_equal( # variable not in prediction.values: correct mean returned
    # Function output
    suppressWarnings(get.value(var = "x", prediction.values = list(), model = model)),

    # Expected output
    mean(model.frame(model)[["x"]], na.rm = TRUE)
  )

  expect_warning( # NA in prediction.values: mean used and warning issued
    # Function output
    get.value(var = "x", prediction.values = list("x" = NA), model = model),

    # Expected output
    "x not in prediction.values; mean of series used"
  )

  expect_equal( # NA in prediction.values: correct mean returned
    # Function output
    suppressWarnings(get.value(var = "x", prediction.values = list("x" = NA), model = model)),

    # Expected output
    mean(model.frame(model)[["x"]], na.rm = TRUE)
  )

  expect_equal( # correct mean returned for a different variable
    # Function output
    suppressWarnings(get.value(var = "l_1_x", prediction.values = list(), model = model)),

    # Expected output
    mean(model.frame(model)[["l_1_x"]], na.rm = TRUE)
  )

  expect_equal( # user-supplied value takes precedence over model mean
    # Function output
    get.value(var = "x", prediction.values = list("x" = 99), model = model),

    # Expected output
    99
  )
})