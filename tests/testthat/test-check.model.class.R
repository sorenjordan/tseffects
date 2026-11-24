test_that("check.model.class returns correct values (generic)", {
  model.lm <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)

  # Store results for testing
  lm.class <- check.model.class(model.lm)
  
  expect_equal( # the class is correct
    # Function output
    lm.class$model.class,
    
    # Expected output
    "lm"
  )
  
  expect_equal( # the class is supported
    # Function output
    lm.class$supported,
    
    # Expected output
    TRUE
  )

  expect_equal( # the class is not panel
    # Function output
    lm.class$is.panel,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not glm
    # Function output
    lm.class$is.glm,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not a wrapper
    # Function output
    lm.class$is.wrapper,
    
    # Expected output
    FALSE
  )

  expect_equal( # the link function is identity
    # Function output
    lm.class$link.fn,
    
    # Expected output
    "identity"
  )

})

test_that("check.model.class returns a list with correct structure", { 

  # Fit a simple lm model 
  model <- lm(y ~ x, data = toy.ts.interaction.data)  
  
  # Function output 
  result <- check.model.class(model)  
  
  expect_true(is.list(result)) # it's a list with elements and names
  
  expect_named( # the list names are corrected
    # Function output
    result, 
    
    # Expected output
    c("model.class", "supported", "is.panel", "is.glm",  "is.wrapper", "link.fn")
  )
})

test_that("check.model.class rejects non-model objects", { 

  # force-feed not-a-model
  expect_error(
    # Function output 
    check.model.class(data.frame(x = 1:5, y = 1:5)), 
    
    # Expected output
    "does not appear to be a fitted model"
  ) 
})  

test_that("check.model.class warns on untested but supported models", { 

  # Fit a simple lm model 
  model <- lm(y ~ x, data = toy.ts.interaction.data)  
  
  # Temporarily modify class to simulate untested model 
  class(model) <- c("untested_model", "lm")  
  
  # force-feed bad class
  expect_warning(
    # Function output
    check.model.class(model), 
    
    # Expected output
    "has not been explicitly tested in `tseffects`"
  )
})  

test_that("check.model.class warns models with non-identity link functions", { 

  # Fit a glm model with logit link 
  model <- glm(as.numeric(y > median(y)) ~ x,  family = binomial(link = "logit"), data = toy.ts.interaction.data)  
  
  #
  expect_warning(
    # Function output
    check.model.class(model), 
    
    # Expected output
    "no adjustment to effect calculations"
  ) 
})







