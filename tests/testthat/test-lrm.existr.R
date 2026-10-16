test_that("lrm.existr returns correct existence flags", {

  # lrm.existr only returns TRUE/FALSE, so this is easy!

  # return.LRM = FALSE: always returns FALSE regardless of other arguments
  expect_false(
    # Function output
    lrm.existr(shock.history = "pulse", h.order = -1, cumulative = TRUE,
               calc.d.x = 0, calc.d.y = 1, effect.type = "discrete", return.LRM = FALSE)
  )

  # effect.type = "fitted": always returns FALSE regardless of other arguments
  expect_false(
    # Function output
    lrm.existr(shock.history = "pulse", h.order = 0, cumulative = TRUE,
               calc.d.x = 0, calc.d.y = 0, effect.type = "fitted", return.LRM = TRUE)
  )

  # cumulative = FALSE, non-custom shock history: LRM condition evaluated on raw h.order, not incremented
  # pulse (h = -1), d.x = 0, d.y = 0 -> -1 - 0 + 0 = -1 < 0: decays, warns, returns FALSE
  expect_warning(
    # Function output
    lrm.existr(shock.history = "pulse", h.order = -1, cumulative = FALSE,
               calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE),

    # Expected output
    "return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned"
  )

  expect_false(
    # Function output
    suppressWarnings(
      lrm.existr(shock.history = "pulse", h.order = -1, cumulative = FALSE,
                 calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
    )
  )

  # cumulative = FALSE, non-custom shock history, LRM condition met: step (h = 0), d.x = 0, d.y = 0
  # 0 - 0 + 0 = 0: returns TRUE
  expect_true(
    # Function output
    lrm.existr(shock.history = "step", h.order = 0, cumulative = FALSE,
               calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
  )

  # LRM condition met (cumulative, h+1 - d.x + d.y = 0): pulse (h = -1), d.x = 0, d.y = 1
  expect_true(
    # Function output
    lrm.existr(shock.history = "pulse", h.order = -1, cumulative = TRUE,
               calc.d.x = 1, calc.d.y = 1, effect.type = "discrete", return.LRM = TRUE)
  )

  # LRM condition met (cumulative): step (h = 0), d.x = 0, d.y = 0
  # (0+1) - 0 + 0 = 1 > 0: diverges. Use step, d.x = 1, d.y = 0: (0+1) - 1 + 0 = 0: TRUE
  expect_true(
    # Function output
    lrm.existr(shock.history = "step", h.order = 0, cumulative = TRUE,
               calc.d.x = 1, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
  )

  # LRM condition met (cumulative): h = 1, d.x = 1, d.y = 0
  # (1+1) - 1 + 0 = 1 > 0: diverges. Use h = 1, d.x = 2, d.y = 0: (1+1) - 2 + 0 = 0: TRUE
  expect_true(
    # Function output
    lrm.existr(shock.history = 1, h.order = 1, cumulative = TRUE,
               calc.d.x = 2, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
  )

  # LRM condition not met: effects decay to 0 (cumulative, (h+1) - d.x + d.y < 0)
  # pulse (h = -1), d.x = 0, d.y = 0: ((-1)+1) - 0 + 0 = 0... not decay
  # pulse (h = -1), d.x = 1, d.y = 0: ((-1)+1) - 1 + 0 = -1 < 0: decay
  expect_warning(
    # Function output
    lrm.existr(shock.history = "pulse", h.order = -1, cumulative = TRUE,
               calc.d.x = 1, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE),

    # Expected output
    "return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned"
  )

  expect_false(
    # Function output
    suppressWarnings(
      lrm.existr(shock.history = "pulse", h.order = -1, cumulative = TRUE,
                 calc.d.x = 1, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
    )
  )

  # LRM condition not met: effects diverge (cumulative, (h+1) - d.x + d.y > 0)
  # step (h = 0), d.x = 0, d.y = 1: (0+1) - 0 + 1 = 2 > 0: diverges
  expect_warning(
    # Function output
    lrm.existr(shock.history = "step", h.order = 0, cumulative = TRUE,
               calc.d.x = 0, calc.d.y = 1, effect.type = "discrete", return.LRM = TRUE),

    # Expected output
    "return.LRM = TRUE but the effects diverge to \\+/-infinity as s -> infinity. No LRM is returned"
  )

  expect_false(
    # Function output
    suppressWarnings(
      lrm.existr(shock.history = "step", h.order = 0, cumulative = TRUE,
                 calc.d.x = 0, calc.d.y = 1, effect.type = "discrete", return.LRM = TRUE)
    )
  )

  # custom shock history + cumulative = TRUE: warns about LRM condition and returns TRUE
  expect_warning(
    # Function output
    lrm.existr(shock.history = c(1, 0, 0, 0, 0, 0), h.order = -1, cumulative = TRUE,
               calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE),

    # Expected output
    "The LRM condition \\(h - d.x \\+ d.y = 0\\) holds for integer h but is not guaranteed to hold for a custom shock history. Interpret the LRM with caution"
  )

  # custom shock history + cumulative = TRUE: warns about LRM condition and returns TRUE (including weird histories)
  expect_warning(
    # Function output
    lrm.existr(shock.history = c(1, 6, 42, 0, 0, 0), h.order = -1, cumulative = TRUE,
               calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE),

    # Expected output
    "The LRM condition \\(h - d.x \\+ d.y = 0\\) holds for integer h but is not guaranteed to hold for a custom shock history. Interpret the LRM with caution"
  )
  
  expect_true(
    # Function output
    suppressWarnings(
      lrm.existr(shock.history = c(1, 0, 0, 0, 0, 0), h.order = -1, cumulative = TRUE,
                 calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
    )
  )

  # custom shock history + cumulative = FALSE: returns FALSE (no LRM for non-cumulative custom)
  expect_false(
    # Function output
    lrm.existr(shock.history = c(1, 0, 0, 0, 0, 0), h.order = -1, cumulative = FALSE,
               calc.d.x = 0, calc.d.y = 0, effect.type = "discrete", return.LRM = TRUE)
  )

})