test_that("get.model.vcov returns correct values (generic)", {
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # Store results for testing
  lm.info <- check.model.class(model.lm)  
  lm.vcov <- get.model.vcov(model.lm, model.info = lm.info, se.type = "const")
  lm.coef <- get.model.coef(model.lm)
  
  # test the qualities of the vcov matrix
  expect_true(is.matrix(lm.vcov))
  expect_true(isSymmetric(lm.vcov))
  expect_true(!is.null(rownames(lm.vcov)))
  expect_true(!is.null(colnames(lm.vcov)))
  
  expect_equal( # check the actual names
    # Function output
    rownames(lm.vcov),
    
    # Expected output
    names(lm.coef)
  )
  
  expect_equal( # symmetry bro
    # Function output
    colnames(lm.vcov),
    
    # Expected output
    names(lm.coef)
  )
  
})

test_that("get.model.vcov returns same values as stats::coef (generic)", { 

  # Fit a simple lm model 
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # Function output 
  lm.vcov <- get.model.vcov(model.lm, model.info = lm.info,  se.type = "const")
  
  expect_equal( # returns correctly a trivial example
    # Function output
    lm.vcov, 
    
    # Expected output
    vcov(model.lm)
  ) 
})

test_that("get.model.vcov returns user-defined vcov matrix", { 
	
  # Fit a simple lm model 
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # Create a user-supplied vcov matrix 
  user.vcov <- vcov(model.lm) 
  user.vcov[1, 1] <- user.vcov[1, 1] * 2

  # Function output with user-supplied
  lm.vcov <- get.model.vcov(model.lm, model.info = lm.info, se.type = "const", vcov. = user.vcov)

  expect_equal( # accepts a custom vcov and doesn't butcher it
    # Function output
    lm.vcov, 
    
    # Expected output
    user.vcov
  )
})

test_that("get.model.vcov rejects unnamed user-supplied vcov matrix", { 
	
  # Fit a simple lm model 
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # Create a user-supplied vcov matrix, remove the names
  user.vcov <- vcov(model.lm) 
  rownames(user.vcov) <- colnames(user.vcov) <- NULL 

  expect_error( # doesn't allow unnamed vcov
    # Function output
    get.model.vcov(model.lm, model.info = check.model.class(model.lm), se.type = "const", vcov. = user.vcov), 
    
    # Expected output    
    "must have row and column names"
  ) 
})

test_that("get.model.vcov rejects user-supplied vcov matrix that is not a matrix", { 

  # Fit a simple lm model 
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  expect_error( # doesn't allow vector as vcov
    # Function output
    get.model.vcov(model.lm, model.info = check.model.class(model.lm), se.type = "const", vcov. = c(1, 2, 3)), 
    
    # Expected output    
    "must be a matrix"
  ) 
})






