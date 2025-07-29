test_that("GDTE generates correct equations (pulse treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  h <- 5
  h.test <- 3 # period to test
  
  pte.test <- pte.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = h)
  
  ####################################################################################
  # ADL(1,1), both variables in levels, pulse, testing if GDTE matches for h = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0
  n <- -1 # -1 - 0 + 0 = pulse 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print

    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1 
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  

  ####################################################################################
  # ADL(1,1), differenced x, levels y, pulse, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 0
  n <- -1 # -1 - 1 + 0 = transient 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  -  l_1_y * l_1_x  -  l_1_y**2 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, -1, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
 

  ####################################################################################
  # ADL(1,1), levels x, differenced y, pulse, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 0
  d.y <- 1
  n <- -1 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
 
 
  ####################################################################################
  # ADL(1,1), differenced x, differenced y, pulse, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 1
  n <- -1 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
}) 


test_that("GDTE generates correct equations (step treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  h <- 5
  h.test <- 3 # period to test
  
  pte.test <- pte.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = h)
 
  ####################################################################################
  # ADL(1,1), both variables in levels, step, testing if GDTE matches for h = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0
  n <- 0 # -1 - 0 + 0 = pulse 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1 
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )   
 

  ####################################################################################
  # ADL(1,1), differenced x, levels y, step, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 0
  n <- 0 # -1 - 1 + 0 = transient 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )   
 
 
  ####################################################################################
  # ADL(1,1), levels x, differenced y, step, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 0
  d.y <- 1
  n <- 0 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )   
 
 
  ####################################################################################
  # ADL(1,1), differenced x, differenced y, step, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 1
  n <- 0 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
}) 


test_that("GDTE generates correct equations (trend treatments)", {
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  h <- 5
  h.test <- 3 # period to test
  
  pte.test <- pte.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = h) 
  ####################################################################################
  # ADL(1,1), both variables in levels, trend, testing if GDTE matches for h = 3
  ####################################################################################
  d.x <- 0
  d.y <- 0
  n <- 1 # -1 - 0 + 0 = pulse 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print

    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1 
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
 

  ####################################################################################
  # ADL(1,1), differenced x, levels y, trend, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 0
  n <- 1 # -1 - 1 + 0 = transient 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  


  ####################################################################################
  # ADL(1,1), levels x, differenced y, trend, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 0
  d.y <- 1
  n <- 1 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  3 * l_1_y * l_1_x  +  3 * l_1_y**2 * x  +  6 * l_1_x  +  6 * l_1_y * x  +  10 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 3, 6, 10)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  


  ####################################################################################
  # ADL(1,1), differenced x, differenced y, trend, testing if GDTE matches for h = 3
  ####################################################################################  
  d.x <- 1
  d.y <- 1
  n <- 1 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( # test whether formula matches for h = 3
    # Function output    
    # Increment h.test because counter starts at h = 0
    print(gdte.test$formulae[[h.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x "
  )   
  
  expect_equal( # test whether the binomials are as expected for h = 3
    # Function output
    # Increment h.test because counter starts at h = 0
    gdte.test$binomials[[h.test+1]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0

    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal( # test whether the correct number of formulae have been produced
    # Function output
    length(gdte.test$formulae), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
  expect_equal( # test whether the correct number of binomials have been produced
    # Function output
    length(gdte.test$binomials), # counter goes from h = 0 to h=5

    # Expected output
    h+1
  )  
  
})