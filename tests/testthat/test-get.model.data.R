test_that("get.model.data returns correct values (generic)", {
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # get the coefficients
  lm.data <- get.model.data(model.lm, model.info = check.model.class(model.lm))

  # test the qualities of the data.frame
  expect_true(is.data.frame(lm.data)) 
})

test_that("get.model.data returns variables in the model (generic)", { 

  # Fit a simple lm model 
  model <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)  

  # Function output 
  result <- get.model.data(model, model.info = check.model.class(model))

  # Expected output: contains all RHS model variables 
  expect_true("x" %in% names(result))
  expect_true("l_1_x" %in% names(result))
  expect_true("l_1_y" %in% names(result))

  # and the data is the same
  expect_equal(result$x, toy.ts.interaction.data$x)
  expect_equal(result$l_1_x, toy.ts.interaction.data$l_1_x)
  expect_equal(result$l_1_y, toy.ts.interaction.data$l_1_y)
})

test_that("get.model.data returns correct dimensionality (generic)", { 

  # Fit a simple lm model 
  model <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)  

  # Function output 
  result <- get.model.data(model, model.info = check.model.class(model))

  expect_equal( # the dimensions match
    # Function output
    nrow(result),
    
    # Expected output
    nrow(model.frame(model))
  )
})

test_that("get.model.data returns user-defined data", {
  
  fake.data <- data.frame(x = rnorm(10), y = rnorm(10))
  
  expect_equal( # these should be unaltered
    # Function output
    get.model.data(data. = fake.data),
    
    # Expected output
    fake.data
  )
})