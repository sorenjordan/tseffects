test_that("pulse.calculator generates correct equations (ADL)", {

  ####################################################################################
  # ADL (1,0) testing if PTE matches for s = 3 in formula sheet
  ####################################################################################
  x.lags <- c("x" = 0, "l_1_x" = 1, "l_2_x" = 2, "l_3_x" = 3) # lags of x
  y.lags <- NULL
  s <- 5 # limit 
  s.test <- 3 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags,
                 y.vrbl = y.lags, 
                 limit = s)
  
  expect_equal( # test whether formula matches for s = 3
	# Function output
    # Increment s.test because counter starts at s = 0
	print(pte.test[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    'l_3_x'
  )   
  
  expect_equal( # test if length of returned formulae is correct for limit = 5
	# Function output    
    length(pte.test), # counter goes from s = 0 to s = 5
    
    # Expected output
    s+1
  )  
  
  ####################################################################################
  # ADL (1,1) testing if PTE matches for s = 3 in formula sheet
  ####################################################################################
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  s <- 5 # limit 
  s.test <- 3 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags,
                 y.vrbl = y.lags, 
                 limit = s)
  
  expect_equal( # test whether formula matches for s = 3
	# Function output
    # Increment s.test because counter starts at s = 0
	print(pte.test[[s.test+1]]), # to get mpoly obj as character, you need to print

    # Expected output
    'l_1_y^2 l_1_x  +  l_1_y^3 x'
  )   
  
  expect_equal( # test if length of returned formulae is correct for limit = 5
	# Function output    
    length(pte.test), # counter goes from s = 0 to s = 5
    
    # Expected output
    s+1
  )  
  
 
  ####################################################################################
  # ADL (2,1) with non-consecutive lags of y testing if PTE matches for s = 5 in formula sheet
  ####################################################################################
  x.lags <- c("l_1_x" = 1) # lags of x
  y.lags <- c("l_2_y" = 2)
  s <- 5 # limit 
  s.test <- 5 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags,
                 y.vrbl = y.lags, 
                 limit = s)
  
  expect_equal( # test whether formula matches, s = 5
	# Function output
    # Increment s.test because counter starts at s = 0
    print(pte.test[[s.test+1]]), # to get mpoly obj as character, you need to print
    
    # Expected output
    'l_2_y^2 l_1_x'
  )   

  expect_equal( # test if length of returned formulae is correct for ADL(1,1), limit = 5
	# Function output
    length(pte.test), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  )
  
  x.lags <- c("x" = 0, "l_2_x" = 2) # lags of x
  y.lags <- c("l_1_y" = 1)
  s <- 5 # limit 
  s.test <- 3 # period to test
  
  pte.test <- pulse.calculator(x.vrbl = x.lags,
                 y.vrbl = y.lags, 
                 limit = s)
  
  expect_equal( # test whether formula matches, s = 5
	# Function output
    # Increment s.test because counter starts at s = 0
    print(pte.test[[s.test+1]]), # to get mpoly obj as character, you need to print
    
    # Expected output
    'l_1_y l_2_x  +  l_1_y^3 x'
  )   

  expect_equal( # test if length of returned formulae is correct for ADL(1,1), limit = 5
	# Function output
    length(pte.test), # counter goes from s = 0 to s = 5

    # Expected output
    s+1
  ) 
  
})



test_that("pulse.calculator generates correct equations (GECM)", {
		
    ####################################################################################
	#  GECM(1,1) in first differences
    ####################################################################################
	x.lags <- c("l_x" = 1)
	y.lags <- c("l_y" = 1)
	x.vrbl.d.x <- 0
	y.vrbl.d.y <- 0
	x.d.lags <- c("d_x" = 0, "l_1_d_x" = 1)
	y.d.lags <- c("l_1_d_y" = 1)
	x.d.vrbl.d.x <- 1
	y.d.vrbl.d.y <- 1
	s <- 2 # limit h = 2 because GECMs are stupid complicated
	
	# Straight from the GECM code: make the lags into a list, accounting for differences in the periods
	x.vrbl.helper <- 1:max(x.lags)
	for(i in 1:max(x.lags)) {
		if(i %in% x.lags) {
			names(x.vrbl.helper)[i] <- names(x.lags)[which(x.lags == i)]
		} else {
			names(x.vrbl.helper)[i] <- 0
		}
	}
	y.vrbl.helper <- 1:max(y.lags)
	for(i in 1:max(y.lags)) {
		if(i %in% y.lags) {
			names(y.vrbl.helper)[i] <- names(y.lags)[which(y.lags == i)]
		} else {
			names(y.vrbl.helper)[i] <- 0
		}
	}
	# Now, do the same thing with the lagged differences (x.d.vrbl and y.d.vrbl)
	# Reconstruct the ADL equivalents from the GECM. First, make helper versions of x.vrbl and y.vrbl that aren't 
	#  missing any lags (i.e. if they're non-consecutive, it fills their name with 0). 
	#  x.d.vrbl can begin at 0
	x.d.vrbl.helper <- 0:max(x.d.lags)
	for(i in 0:max(x.d.lags)) {
		if(i %in% x.d.lags) {
			# adjust position by 1: because it starts at 0
			names(x.d.vrbl.helper)[(i+1)] <- names(x.d.lags)[which(x.d.lags == i)]
		} else {
			# adjust position by 1: because it starts at 0
			names(x.d.vrbl.helper)[(i+1)] <- 0
		}
	}
	y.d.vrbl.helper <- 1:max(y.d.lags)
	for(i in 1:max(y.d.lags)) {
		if(i %in% y.d.lags) {
			names(y.d.vrbl.helper)[i] <- names(y.d.lags)[which(y.d.lags == i)]
		} else {
			names(y.d.vrbl.helper)[i] <- 0
		}
	}

	# Now turn the GECM parameters into the ADL parameters
	#  Notice the ADL order is one order higher than the GECM order
	x.vrbl.adl <- 0:(max(x.d.vrbl.helper)+1)
	# For all of the below, q is defined in terms of the ADL side
	for(q in 0:max(x.vrbl.adl)) {
		# 0 and 1 are one-off formulae
		if(q == 0) {
			# \beta_0 for the ADL is \beta_0 in the GECM (x.d.vrbl.helper at 0)
			names(x.vrbl.adl)[which(x.vrbl.adl == 0)] <- names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 0)]
		} else if(q == 1) {
			# \beta_1 for the ADL is \theta_1 (x.vrbl.helper at 1) + \beta_1 in the GECM (x.d.vrbl.helper at 1) - \beta_0 in the GECM (x.d.vrbl.helper at 0)
			names(x.vrbl.adl)[which(x.vrbl.adl == 1)] <- paste0(names(x.vrbl.helper)[which(x.vrbl.helper == 1)], "+", 
														names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 1)], "-", 
														names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 0)])
		} else if(q == max(x.vrbl.adl)) {
			# \beta_q for the ADL is -\beta_{q-1} in the GECM
			names(x.vrbl.adl)[which(x.vrbl.adl == max(x.vrbl.adl))] <- paste0("(-1)*", names(x.d.vrbl.helper)[which(x.d.vrbl.helper == (q-1))])
		} else {
			# all other \beta_j for the ADL is -\beta_{j-1} in the GECM + \beta_j in the GECM
			names(x.vrbl.adl)[which(x.vrbl.adl == q)] <- paste0("(-1)*", names(x.d.vrbl.helper)[which(x.d.vrbl.helper == (q-1))], "+", 
														names(x.d.vrbl.helper)[which(x.d.vrbl.helper == q)])
		}
	}
	# y will start at 1
	#  Notice the ADL order is one order higher than the GECM order
	y.vrbl.adl <- 1:(max(y.d.vrbl.helper)+1)
	# For all of the below, p is defined in terms of the ADL side
	for(p in 1:max(y.vrbl.adl)) {
		# 0 is one-off formula
		if(p == 1) {
			# \alpha_1 for the ADL is \theta_0 (y.vrbl.helper at 1) + \alpha_1 in the GECM (y.d.vrbl.helper at 1) + 1
			names(y.vrbl.adl)[which(y.vrbl.adl == 1)] <- paste0(names(y.vrbl.helper)[which(y.vrbl.helper == 1)], "+",
														names(y.d.vrbl.helper)[which(y.d.vrbl.helper == 1)], "+1")
		} else if(p == max(y.vrbl.adl)) {
			# \alpha_p for the ADL is -\alpha_{p-1}
			names(y.vrbl.adl)[which(y.vrbl.adl == max(y.vrbl.adl))] <- paste0("(-1)*", names(y.d.vrbl.helper)[which(y.d.vrbl.helper == (p-1))])
		} else {
			# all other \alpha_j for the ADL is -\alpha_{j-1} in the GECM + \alpha_j in the GECM
			names(y.vrbl.adl)[which(y.vrbl.adl == p)] <- paste0("(-1)*", names(y.d.vrbl.helper)[which(y.d.vrbl.helper == (p-1))], "+", 
														names(y.d.vrbl.helper)[which(y.d.vrbl.helper == p)])
		}
	}
	
	# calculate the ptes
	pte.test <- pulse.calculator(x.vrbl = x.vrbl.adl,
                 y.vrbl = y.vrbl.adl, 
                 limit = s)
	
	
	expect_equal( # test whether formula matches for GECM(1,1), s = 2
 	  # Function output
  	  # Increment h because counter starts at s = 0
      print(pte.test[[s+1]]), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  'l_y l_x  +  l_1_d_x l_y  +  l_y^2 d_x  +  2 l_y d_x l_1_d_y  +  l_x l_1_d_y  +  l_1_d_x l_1_d_y  +  d_x l_1_d_y^2  +  l_x  +  l_y d_x'
  )   
}) 
