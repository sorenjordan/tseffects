test_that("mpoly.subber subs symbols correctly", {

  dat <- data.frame(y = rnorm(25), 
  					x.1 = rnorm(25)
  					)
  dat$"d(x, 1)" <- rnorm(25)
  					
  model <- lm(y ~ x.1 + `d(x, 1)`, data = dat)

  x.vrbl <- c("x.1" = 1, "`d(x, 1)`" = 2)
  y.vrbl <- c("y" = 0)
  x.d.vrbl <- c("x   1" = 1)
  y.d.vrbl <- c("B()()B" = 1)
  the.coef <- coef(model)
  the.vcov <- vcov(model)
   
  mpoly.subber(env = environment())

  expect_equal( # test x.vrbl
 	  # Function output
      names(x.vrbl), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  c("x_1", "`d_x__1_`")
  )   

  expect_equal( # test y.vrbl
 	  # Function output
      names(y.vrbl), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  c("y")
  )   

  expect_equal( # test x.d.vrbl
 	  # Function output
      names(x.d.vrbl), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  'x___1'
  )
  
  expect_equal( # test y.d.vrbl
 	  # Function output
      names(y.d.vrbl), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  'B____B'
  )
  
  expect_equal( # test the.coef
 	  # Function output
      names(the.coef), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  c("(Intercept)", "x_1", "`d_x__1_`")
  )  
  
  expect_equal( # test the.vcov
 	  # Function output
      rownames(the.vcov), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  c("(Intercept)", "x_1", "`d_x__1_`")
  )    
  
  expect_equal( # test the.vcov
 	  # Function output
      colnames(the.vcov), # to get mpoly obj as character, you need to print
  	    	  
  	  # Expected output
  	  c("(Intercept)", "x_1", "`d_x__1_`")
  )
})




    



