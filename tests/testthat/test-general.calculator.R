test_that("general.calculator generates correct equations (pulse treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
  
  ####################################################################################
  # ADL(1,1), both variables in levels, pulse, testing if GDTE matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0
  h <- -1 # -1 - 0 + 0 = pulse 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print

    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1 
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  

  ####################################################################################
  # ADL(1,1), differenced x, levels y, pulse, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 0
  h <- -1 # -1 - 1 + 0 = transient 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  -  l_1_y * l_1_x  -  l_1_y**2 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, -1, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
 

  ####################################################################################
  # ADL(1,1), levels x, differenced y, pulse, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 0
  d.y <- 1
  h <- -1 # -1 - 0 + 1 = step 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
 
 
  ####################################################################################
  # ADL(1,1), differenced x, differenced y, pulse, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 1
  h <- -1 # -1 - 0 + 1 = step 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
}) 


test_that("general.calculator generates correct equations (step treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
 
  ####################################################################################
  # ADL(1,1), both variables in levels, step, testing if GDTE matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0
  h <- 0 # -1 - 0 + 0 = pulse 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s=5

    # Expected output
    s+1 
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s=5

    # Expected output
    s+1
  )   
 

  ####################################################################################
  # ADL(1,1), differenced x, levels y, step, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 0
  h <- 0 # -1 - 1 + 0 = transient 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )   
 
 
  ####################################################################################
  # ADL(1,1), levels x, differenced y, step, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 0
  d.y <- 1
  h <- 0 # -1 - 0 + 1 = step 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )   
 
 
  ####################################################################################
  # ADL(1,1), differenced x, differenced y, step, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 1
  h <- 0 # -1 - 0 + 1 = step 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
}) 


test_that("general.calculator generates correct equations (trend treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  s <- 5
  s.test <- 3 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s) 
  ####################################################################################
  # ADL(1,1), both variables in levels, trend, testing if GDTE matches for s = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0
  h <- 1 # -1 - 0 + 0 = pulse 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print

    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1 
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
 

  ####################################################################################
  # ADL(1,1), differenced x, levels y, trend, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 0
  h <- 1 # -1 - 1 + 0 = transient 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  


  ####################################################################################
  # ADL(1,1), levels x, differenced y, trend, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 0
  d.y <- 1
  h <- 1 # -1 - 0 + 1 = step 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  3 * l_1_y * l_1_x  +  3 * l_1_y**2 * x  +  6 * l_1_x  +  6 * l_1_y * x  +  10 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 3, 6, 10)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  


  ####################################################################################
  # ADL(1,1), differenced x, differenced y, trend, testing if GDTE matches for s = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 1
  h <- 1 # -1 - 0 + 1 = step 
  
  gdte.test <- general.calculator(d.x = d.x, d.y = d.y, h = h, limit = s, pulses = pte.test)
  
  expect_equal( # test whether formula matches for s = 3
    # Function output    
    # Increment s.test because counter starts at s = 0
    print(gdte.test$formulae[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for s = 3
    # Function output
    # Increment s.test because counter starts at s = 0
    gdte.test$binomials[[s.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at s = 0

    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )  
  
})