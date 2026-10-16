test_that("convolution.calculator generates correct equations (pulse treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1)
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3

  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
  
  # pulse shock in levels: one-time impulse
  pulse.shocks <- c(1, 0, 0, 0, 0, 0)

  ####################################################################################
  # ADL(1,1), both variables in levels, pulse, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = pulse.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,0,0,0)
    c(1, 0, 0, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, levels y, pulse, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = pulse.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  -  l_1_y * l_1_x  -  l_1_y**2 * x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,0,0,0) = c(1,-1,0,0)
    c(1, -1, 0, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), levels x, differenced y, pulse, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = pulse.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "x  +  l_1_x  +  x * l_1_y  +  l_1_x * l_1_y  +  x * l_1_y**2  +  l_1_x * l_1_y**2  +  x * l_1_y**3 "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,0,0,0)
    c(1, 0, 0, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, differenced y, pulse, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = pulse.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_x * l_1_y**2  +  l_1_y**3 * x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,0,0,0) = c(1,-1,0,0)
    c(1, -1, 0, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )
})

test_that("convolution.calculator generates correct equations (step treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1)
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3

  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)

  # step shock in levels: permanent one-unit increase
  step.shocks <- c(1, 1, 1, 1, 1, 1)

  ####################################################################################
  # ADL(1,1), both variables in levels, step, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = step.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,1,1,1)
    c(1, 1, 1, 1)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, levels y, step, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = step.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,1,1,1) = c(1,0,0,0)
    c(1, 0, 0, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), levels x, differenced y, step, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = step.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "4 * x  +  3 * l_1_x  +  3 * x * l_1_y  +  2 * l_1_x * l_1_y  +  2 * x * l_1_y**2  +  l_1_x * l_1_y**2  +  x * l_1_y**3 "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,1,1,1)
    c(1, 1, 1, 1)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, differenced y, step, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = step.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "x  +  l_1_x  +  x * l_1_y  +  l_1_x * l_1_y  +  x * l_1_y**2  +  l_1_x * l_1_y**2  +  x * l_1_y**3 "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,1,1,1) = c(1,0,0,0)
    c(1, 0, 0, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )
})

test_that("convolution.calculator generates correct equations (trend treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1)
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3

  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)

  # trend shock in levels: natural numbers
  trend.shocks <- c(1, 2, 3, 4, 5, 6)

  ####################################################################################
  # ADL(1,1), both variables in levels, trend, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = trend.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,2,3,4)
    c(1, 2, 3, 4)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, levels y, trend, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = trend.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,2,3,4) = c(1,1,1,1)
    c(1, 1, 1, 1)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), levels x, differenced y, trend, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 1
  
  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = trend.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "10 * x  +  6 * l_1_x  +  6 * x * l_1_y  +  3 * l_1_x * l_1_y  +  3 * x * l_1_y**2  +  l_1_x * l_1_y**2  +  x * l_1_y**3 "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,2,3,4)
    c(1, 2, 3, 4)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, differenced y, trend, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = trend.shocks, pulses = pte.test)

  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(conv.test$formulae[[s.test+1]]),
    # Expected output
    "4 * x  +  3 * l_1_x  +  3 * x * l_1_y  +  2 * l_1_x * l_1_y  +  2 * x * l_1_y**2  +  l_1_x * l_1_y**2  +  x * l_1_y**3 "
  )

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,2,3,4) = c(1,1,1,1)
    c(1, 1, 1, 1)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )
})

test_that("convolution.calculator generates correct equations (arbitrary/bespoke treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1)
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3

  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)

  # arbitrary shock: not a standard h-order sequence
  # e.g. an interrupted trend: grows then drops to zero then jumps
  arb.shocks <- c(1, 2, 3, 0, 0, 4)

  ####################################################################################
  # ADL(1,1), both variables in levels, arbitrary shock, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = arb.shocks, pulses = pte.test)

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,2,3,0)
    c(1, 2, 3, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, levels y, arbitrary shock, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 0

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = arb.shocks, pulses = pte.test)

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,2,3,0) = c(1,1,1,-3)
    c(1, 1, 1, -3)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), levels x, differenced y, arbitrary shock, testing if matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = arb.shocks, pulses = pte.test)

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 0: no translation, shocks stay c(1,2,3,0)
    c(1, 2, 3, 0)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  ####################################################################################
  # ADL(1,1), differenced x, differenced y, arbitrary shock, testing if matches for s = 3
  ####################################################################################
  d.x <- 1
  d.y <- 1

  conv.test <- convolution.calculator(d.x = d.x, d.y = d.y, shocks = arb.shocks, pulses = pte.test)

  expect_equal( # test whether shocks are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    conv.test$shocks[[s.test+1]],
    # Expected output
    # d.x = 1: diff() of c(1,2,3,0) = c(1,1,1,-3)
    c(1, 1, 1, -3)
  )

  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(conv.test$formulae), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )

  expect_equal( # test whether the correct number of shock lists have been produced
    # Function output
    length(conv.test$shocks), # counter goes from s = 0 to s = 5
    # Expected output
    s+1
  )
})

test_that("convolution.calculator matches general.calculator for standard shock histories", {
  # This is the key cross-validation test: convolution.calculator with the
  # appropriate shock vector in levels should always match general.calculator
  # with the corresponding h
  x.lags <- c("x" = 0, "l_1_x" = 1)
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3

  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)

  pulse.shocks <- c(1, 0, 0, 0, 0, 0)
  step.shocks  <- c(1, 1, 1, 1, 1, 1)
  trend.shocks <- c(1, 2, 3, 4, 5, 6)

  for(d.x in 0:1) {
    for(d.y in 0) { # mpoly reorders d.y so we need to just do levels.

      # h = -1 should match pulse shocks
      expect_equal( # test whether convolution matches general for pulse
        # Function output
        # Increment s.test because counter starts at s = 0
        convolution.calculator(d.x=d.x, d.y=d.y, shocks=pulse.shocks, pulses=pte.test)$formulae[[s.test+1]],
        # Expected output
        # general.calculator with h = -1 is the reference
        general.calculator(d.x=d.x, d.y=d.y, h=-1, limit=s, pulses=pte.test)$formulae[[s.test+1]],
        info = paste0("pulse: d.x=", d.x, ", d.y=", d.y)
      )

      # h = 0 should match step shocks
      expect_equal( # test whether convolution matches general for step
        # Function output
        # Increment s.test because counter starts at s = 0
        convolution.calculator(d.x=d.x, d.y=d.y, shocks=step.shocks, pulses=pte.test)$formulae[[s.test+1]],
        # Expected output
        # general.calculator with h = 0 is the reference
        general.calculator(d.x=d.x, d.y=d.y, h=0, limit=s, pulses=pte.test)$formulae[[s.test+1]],
        info = paste0("step: d.x=", d.x, ", d.y=", d.y)
      )

      # h = 1 should match trend shocks
      expect_equal( # test whether convolution matches general for trend
        # Function output
        # Increment s.test because counter starts at s = 0
        convolution.calculator(d.x=d.x, d.y=d.y, shocks=trend.shocks, pulses=pte.test)$formulae[[s.test+1]],
        # Expected output
        # general.calculator with h = 1 is the reference
        general.calculator(d.x=d.x, d.y=d.y, h=1, limit=s, pulses=pte.test)$formulae[[s.test+1]],
        info = paste0("trend: d.x=", d.x, ", d.y=", d.y)
      )
    }
  }
})