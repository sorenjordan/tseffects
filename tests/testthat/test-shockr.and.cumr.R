test_that("shockr.and.cumr returns correct shock history translations", {

  # NULL shock.history: stops with an error
  expect_error(
    # Function output
    shockr.and.cumr(shock.history = NULL, s.limit = 5, cumulative = FALSE),

    # Expected output
    "shock.history must be specified"
  )

  # invalid string shock.history: stops with an error
  expect_error(
    # Function output
    shockr.and.cumr(shock.history = "ramp", s.limit = 5, cumulative = FALSE),

    # Expected output
    "Invalid shock.history. shock.history must be one of 'pulse' or 'step', a numeric vector for a custom shock history, or any as.numeric integer h representing the order of the GDRF"
  )

  # non-integer numeric shock.history: stops with an error
  expect_error(
    # Function output
    shockr.and.cumr(shock.history = 1.5, s.limit = 5, cumulative = FALSE),

    # Expected output
    "Invalid shock.history. shock.history must be one of 'pulse' or 'step', a numeric vector for a custom shock history, or any as.numeric integer h representing the order of the GDRF"
  )

  # custom shock history of wrong length: stops with an error
  expect_error(
    # Function output
    shockr.and.cumr(shock.history = c(1, 0, 0), s.limit = 5, cumulative = FALSE),

    # Expected output
    "Invalid shock.history. A custom shock history must be of length s.limit \\+ 1 \\(6\\). The supplied shock history has length 3"
  )

  # "pulse" maps to h.order = -1
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "pulse", s.limit = 5, cumulative = FALSE)$h.order,

    # Expected output
    -1
  )

  # "pulse" maps to h.order.plot = -1
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "pulse", s.limit = 5, cumulative = FALSE)$h.order.plot,

    # Expected output
    -1
  )

  # "impulse" maps to h.order = -1 (same as pulse)
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "impulse", s.limit = 5, cumulative = FALSE)$h.order,

    # Expected output
    -1
  )

  # "impulse" maps to h.order.plot = -1 (same as pulse)
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "impulse", s.limit = 5, cumulative = FALSE)$h.order.plot,

    # Expected output
    -1
  )

  # "step" maps to h.order = 0
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "step", s.limit = 5, cumulative = FALSE)$h.order,

    # Expected output
    0
  )

  # "step" maps to h.order.plot = 0
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "step", s.limit = 5, cumulative = FALSE)$h.order.plot,

    # Expected output
    0
  )

  # integer h maps to h.order = h
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = 2, s.limit = 5, cumulative = FALSE)$h.order,

    # Expected output
    2
  )

  # integer h maps to h.order.plot = h
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = 2, s.limit = 5, cumulative = FALSE)$h.order.plot,

    # Expected output
    2
  )

  # cumulative = TRUE with "pulse": h.order incremented by 1 (from -1 to 0)
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "pulse", s.limit = 5, cumulative = TRUE)$h.order,

    # Expected output
    0
  )

  # cumulative = TRUE with "pulse": h.order.plot unchanged at -1
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "pulse", s.limit = 5, cumulative = TRUE)$h.order.plot,

    # Expected output
    -1
  )

  # cumulative = TRUE with "step": h.order incremented by 1 (from 0 to 1)
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "step", s.limit = 5, cumulative = TRUE)$h.order,

    # Expected output
    1
  )

  # cumulative = TRUE with "step": h.order.plot unchanged at 0
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = "step", s.limit = 5, cumulative = TRUE)$h.order.plot,

    # Expected output
    0
  )

  # cumulative = TRUE with integer h: h.order incremented by 1
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = 2, s.limit = 5, cumulative = TRUE)$h.order,

    # Expected output
    3
  )

  # cumulative = TRUE with integer h: h.order.plot unchanged
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = 2, s.limit = 5, cumulative = TRUE)$h.order.plot,

    # Expected output
    2
  )

  # cumulative = TRUE with custom shock history: cumsums the vector
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = c(1, 1, 1, 0, 0, 0), s.limit = 5, cumulative = TRUE)$shock.history,

    # Expected output
    cumsum(c(1, 1, 1, 0, 0, 0))
  )

  # cumulative = FALSE with custom shock history: vector returned unchanged
  expect_equal(
    # Function output
    shockr.and.cumr(shock.history = c(1, 1, 1, 0, 0, 0), s.limit = 5, cumulative = FALSE)$shock.history,

    # Expected output
    c(1, 1, 1, 0, 0, 0)
  )

  # output is a list with three named elements: h.order.plot, h.order, shock.history
  expect_equal(
    # Function output
    names(shockr.and.cumr(shock.history = "pulse", s.limit = 5, cumulative = FALSE)),

    # Expected output
    c("h.order.plot", "h.order", "shock.history")
  )

})