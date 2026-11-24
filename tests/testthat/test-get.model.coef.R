test_that("get.model.coef returns correct values (generic)", {
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # get the coefficients
  lm.coef <- get.model.coef(model.lm)

  # test the qualities of the coefficient vector
  expect_true(is.numeric(lm.coef)) 
  expect_true(is.vector(lm.coef))
  expect_true(all(names(lm.coef) %in% c("(Intercept)", "x", "l_1_x", "l_1_y"))) 
})  

test_that("get.model.coef returns same values as stats::coef (generic)", { 

  # Fit a simple lm model 
  model <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)  

  # Function output 
  result <- get.model.coef(model)  
  
  expect_equal( # returns correctly a trivial example
    # Function output
    result, 
    
    # Expected output
    coef(model)
  ) 
})  
  
test_that("get.model.coef handles models without intercept", { 

  # Fit a lm model without intercept 
  model.nointercept <- lm(y ~ x + l_1_x + l_1_y - 1, data = toy.ts.interaction.data)  
  
  # Function output 
  result.nointercept <- get.model.coef(model.nointercept)  
  
  expect_equal( # no intercept model = 3 predictors
    # Function output
    length(result.nointercept), 
    
    # Expected output
    3
  ) 
  
  # no intercept in coef()
  expect_false("(Intercept)" %in% names(result.nointercept)) 

})  

test_that("get.model.coef rejects invalid model objects", { # this is an insight:: error, so we let it define
	
  expect_error( # extract information from a dataframe
    # Function output
    get.model.coef(data.frame(x = 1:5))
  ) 
})

test_that("get.model.coef returns user-defined coefficients", {
  
  fake.coef <- c("dog" = 1, "cat" = 1)
  
  expect_equal( # these should be unaltered
    # Function output
    get.model.coef(coef. = fake.coef),
    
    # Expected output
    fake.coef
  )
})




