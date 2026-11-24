# Skip if [PACKAGE] is not installed 
# skip_if_not_installed("__")

# Run the model
model.lm <- lm(y ~ l_1_y + x + l_1_x + l_2_x + z + l_1_z + l_2_z, data = toy.ts.interaction.data)

#####################################################################
# check.model.class
#####################################################################

test_that("check.model.class returns correct values (lm)", {

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

#####################################################################
# get.model.coef
#####################################################################

test_that("get.model.coef returns correct values (lm)", {

  # get the coefficients
  lm.coef <- get.model.coef(model.lm)

  # test the qualities of the coefficient vector
  expect_true(is.numeric(lm.coef)) 
  expect_true(is.vector(lm.coef))
  expect_true(!is.null(names(lm.coef)))

  expect_equal( # number of coefficients
    # Function output
    length(lm.coef),
    
    # Expected output
    8
  )
})  

#####################################################################
# get.model.vcov
#####################################################################

test_that("get.model.vcov returns correct values (lm)", {

  # get the coefficients and vcov
  lm.coef <- get.model.coef(model.lm)  
  lm.vcov <- get.model.vcov(model.lm, check.model.class(model.lm), se.type = "const")

  # test the qualities of the coefficient vector
  expect_true(is.matrix(lm.vcov)) 
  expect_true(isSymmetric(lm.vcov)) 
  expect_true(!is.null(rownames(lm.vcov)))
  expect_true(!is.null(colnames(lm.vcov)))
  
  # do the names match?
  expect_equal(names(lm.coef), rownames(lm.vcov))
  expect_equal(names(lm.coef), colnames(lm.vcov))

})  

#####################################################################
# get.model.data
#####################################################################

test_that("get.model.data returns correct values (lm)", {

  # get the coefficients and data
  lm.coef <- get.model.coef(model.lm)    
  lm.data <- get.model.data(model.lm, model.info = check.model.class(model.lm))

  # Is it a dataframe?
  expect_true(is.data.frame(lm.data))

  # are the coefficients in it?
  lm.coef.vars <- setdiff(names(lm.coef), "(Intercept)")
  expect_true(all(lm.coef.vars %in% names(lm.data)))  

  # Expected output: correct number of rows/columns 
  expect_equal( # same number of rows
    # Functoin output
    nrow(lm.data), 
    
    # Expected output
    nrow(toy.ts.interaction.data)
  ) 
  
  # Some columns lol
  expect_true(ncol(lm.data) > 0)

})  

#####################################################################
# calculation
#####################################################################

test_that("adl.plot calculates values correctly for method (lm)", {

  # the model
  lrm.formula <- "(x + l_1_x + l_2_x) / (1 - l_1_y)"
  
  # raw calculations
  lrm.est.from.raw <- (coef(model.lm)["x"] + coef(model.lm)["l_1_x"] + coef(model.lm)["l_2_x"])/(1 - coef(model.lm)["l_1_y"])
  lrm.se.from.raw <- deltaMethod(coef(model.lm), g = lrm.formula, vcov. = vcov(model.lm))$SE

  # tseffects calculations

  adl.out <- suppressWarnings(adl.plot(model = model.lm, 
    y.vrbl = c("l_1_y" = 1), 
    x.vrbl = c("x" = 0, "l_1_x" = 1, "l_2_x" = 2), 
    shock.history = "step", 
    return.data = TRUE, return.plot = FALSE, return.formulae = FALSE))

  expect_equal( # for the lrm estimate
    # Function output
    adl.out$GDRF[adl.out$Period == "LRM"],
    
    # Expected output
    unname(lrm.est.from.raw),
    
    tolerance = 1e-3
  )
  
  expect_equal( # for the lrm se
    # Function output
    adl.out$SE[adl.out$Period == "LRM"],
    
    # Expected output
    lrm.se.from.raw,
    
    tolerance = 1e-3
  )
})

