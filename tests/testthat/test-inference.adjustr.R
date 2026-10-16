test_that("inference.adjustr returns correct d values for plotting and calculation", {

  # output is a list with four elements
  expect_equal(
    # Function output
    names(inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                            the.d.y = 1, the.d.x = 1)),

    # Expected output
    c("calc.d.y", "calc.d.x", "plot.d.y", "plot.d.x")
  )

  # inferences.y = "levels": calc.d.y equals the.d.y, plot.d.y equals 0
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 0)$calc.d.y,

    # Expected output
    1
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 0)$plot.d.y,

    # Expected output
    0
  )

  # inferences.y = "differences": calc.d.y equals 0, plot.d.y equals the.d.y
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "differences", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 0)$calc.d.y,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "differences", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 0)$plot.d.y,

    # Expected output
    1
  )

  # inferences.x = "levels": calc.d.x equals the.d.x, plot.d.x equals 0
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 0, the.d.x = 1)$calc.d.x,

    # Expected output
    1
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 0, the.d.x = 1)$plot.d.x,

    # Expected output
    0
  )

  # inferences.x = "differences": calc.d.x equals 0, plot.d.x equals the.d.x
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "differences",
                      the.d.y = 0, the.d.x = 1)$calc.d.x,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "differences",
                      the.d.y = 0, the.d.x = 1)$plot.d.x,

    # Expected output
    1
  )

  # both in levels: calc values equal the.d values, plot values equal 0
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 1)$calc.d.y,

    # Expected output
    1
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 1)$calc.d.x,

    # Expected output
    1
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 1)$plot.d.y,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 1, the.d.x = 1)$plot.d.x,

    # Expected output
    0
  )

  # both in differences: calc values equal 0, plot values equal the.d values
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "differences", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$calc.d.y,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "differences", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$calc.d.x,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "differences", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$plot.d.y,

    # Expected output
    1
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "differences", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$plot.d.x,

    # Expected output
    1
  )

  # d values of 0: levels inference returns 0 for both calc and plot
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 0, the.d.x = 0)$calc.d.y,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "levels",
                      the.d.y = 0, the.d.x = 0)$plot.d.y,

    # Expected output
    0
  )

  # mixed: inferences.y = "levels", inferences.x = "differences"
  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$calc.d.y,

    # Expected output
    1
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$calc.d.x,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$plot.d.y,

    # Expected output
    0
  )

  expect_equal(
    # Function output
    inference.adjustr(inferences.y = "levels", inferences.x = "differences",
                      the.d.y = 1, the.d.x = 1)$plot.d.x,

    # Expected output
    1
  )

})