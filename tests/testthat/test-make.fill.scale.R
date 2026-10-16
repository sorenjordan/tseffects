test_that("make.fill.scale returns correct ggplot2 scale object", {

  # output is a ggproto object (a ggplot2 scale)
  expect_true(
    # Function output
    inherits(make.fill.scale(pal = "Blue-Red", Effect = c(-1, 0, 1)), "Scale")
  )

  # output is specifically a ScaleContinuous object
  expect_true(
    # Function output
    inherits(make.fill.scale(pal = "Blue-Red", Effect = c(-1, 0, 1)), "ScaleContinuous")
  )

  # output is a fill scale (aesthetics slot contains "fill")
  expect_true(
    # Function output
    "fill" %in% make.fill.scale(pal = "Blue-Red", Effect = c(-1, 0, 1))$aesthetics
  )

  # limits include 0 when all effects are positive: range(c(0, c(1,2,3))) = c(0, 3)
  expect_equal(
    # Function output
    make.fill.scale(pal = "Blue-Red", Effect = c(1, 2, 3))$limits,

    # Expected output
    c(0, 3)
  )

  # limits include 0 when all effects are negative: range(c(0, c(-3,-2,-1))) = c(-3, 0)
  expect_equal(
    # Function output
    make.fill.scale(pal = "Blue-Red", Effect = c(-3, -2, -1))$limits,

    # Expected output
    c(-3, 0)
  )

  # limits span full range when effects cross 0: range(c(0, c(-2,0,3))) = c(-2, 3)
  expect_equal(
    # Function output
    make.fill.scale(pal = "Blue-Red", Effect = c(-2, 0, 3))$limits,

    # Expected output
    c(-2, 3)
  )

  # limits when all effects are 0: range collapses to c(0, 0)
  expect_equal(
    # Function output
    make.fill.scale(pal = "Blue-Red", Effect = c(0, 0, 0))$limits,

    # Expected output
    c(0, 0)
  )

  # NA values in Effect are ignored in range calculation: range(c(0, c(-1,NA,3)), na.rm=TRUE) = c(-1, 3)
  expect_equal(
    # Function output
    make.fill.scale(pal = "Blue-Red", Effect = c(-1, NA, 3))$limits,

    # Expected output
    c(-1, 3)
  )

  # alternate palette "Grays" produces a valid Scale object
  expect_true(
    # Function output
    inherits(make.fill.scale(pal = "Grays", Effect = c(-1, 0, 1)), "Scale")
  )

  # alternate palette "Tropic" produces a valid Scale object
  expect_true(
    # Function output
    inherits(make.fill.scale(pal = "Tropic", Effect = c(-1, 0, 1)), "Scale")
  )

  # scale produced by "Blue-Red" and "Grays" differ: limits class structure are the same
  expect_true(
    # Function output
    identical(
      make.fill.scale(pal = "Blue-Red", Effect = c(-1, 0, 1))$limits,
      make.fill.scale(pal = "Grays",    Effect = c(-1, 0, 1))$limits
    ) &&
    identical(
      class(make.fill.scale(pal = "Blue-Red", Effect = c(-1, 0, 1))),
      class(make.fill.scale(pal = "Grays",    Effect = c(-1, 0, 1)))
    )
  )

  # different Effect ranges produce different limits
  expect_false(
    # Function output
    identical(
      make.fill.scale(pal = "Blue-Red", Effect = c(-1, 0, 1))$limits,
      make.fill.scale(pal = "Blue-Red", Effect = c(-5, 0, 5))$limits
    )
  )

})