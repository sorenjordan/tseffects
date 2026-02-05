test_that("gecm.to.adl translates correctly", {
 
  x.vrbl <- c("l_1_x" = 1) # lags of x
  x.d.vrbl <- c("d_x" = 0, "l_1_d_x" = 1) # lags of x

  y.vrbl <- c("l_1_y" = 1) # lags of x
  y.d.vrbl <- c("l_1_d_y" = 1) # lags of x

  expect_equal( 
	# Function output
    # Increment s.test because counter starts at s = 0
	gecm.to.adl(x.vrbl = x.vrbl, y.vrbl = y.vrbl, x.d.vrbl = x.d.vrbl, y.d.vrbl = y.d.vrbl)$x.vrbl.adl, # to get mpoly obj as character, you need to print

    # Expected output
    c("d_x" = 0, "l_1_x+l_1_d_x-d_x" = 1, "(-1)*l_1_d_x" = 2)
  ) 

  expect_equal( 
	# Function output
    # Increment s.test because counter starts at s = 0
	gecm.to.adl(x.vrbl = x.vrbl, y.vrbl = y.vrbl, x.d.vrbl = x.d.vrbl, y.d.vrbl = y.d.vrbl)$y.vrbl.adl, # to get mpoly obj as character, you need to print

    # Expected output
    c("l_1_y+l_1_d_y+1" = 1, "(-1)*l_1_d_y" = 2)
  ) 


  x.vrbl <- c("l_1_x" = 1) # lags of x
  x.d.vrbl <- c("d_x" = 0, "l_1_d_x" = 1, "l_2_d_x" = 2) # lags of x

  y.vrbl <- c("l_1_y" = 1) # lags of x
  y.d.vrbl <- c("l_1_d_y" = 1, "l_2_d_y" = 2) # lags of x

  expect_equal( 
  	# Function output
    # Increment s.test because counter starts at s = 0
	gecm.to.adl(x.vrbl = x.vrbl, y.vrbl = y.vrbl, x.d.vrbl = x.d.vrbl, y.d.vrbl = y.d.vrbl)$x.vrbl.adl, # to get mpoly obj as character, you need to print

    # Expected output
    c("d_x" = 0, "l_1_x+l_1_d_x-d_x" = 1, "(-1)*l_1_d_x+l_2_d_x" = 2, "(-1)*l_2_d_x" = 3)
  ) 

  expect_equal( 
  	# Function output
    # Increment s.test because counter starts at s = 0
	gecm.to.adl(x.vrbl = x.vrbl, y.vrbl = y.vrbl, x.d.vrbl = x.d.vrbl, y.d.vrbl = y.d.vrbl)$y.vrbl.adl, # to get mpoly obj as character, you need to print

    # Expected output
    c("l_1_y+l_1_d_y+1" = 1, "(-1)*l_1_d_y+l_2_d_y" = 2, "(-1)*l_2_d_y" = 3)
  ) 

}) 