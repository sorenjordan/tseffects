#####################################################################
# shared model setup in case not installed
#####################################################################
model.kardl <- NULL

test_that("kardl_lm model can be constructed", {
  skip_if_not_installed("kardl")
  
  library(kardl)
  
  # will likely warn about this not being ts data
  model.kardl_lm <<- suppressWarnings(kardl::kardl(y ~ x + z, data = toy.ts.interaction.data, mode = c(1, 2, 2)))
  
  expect_s3_class(model.kardl_lm, "kardl_lm")
})

#####################################################################
# check.model.class
#####################################################################

test_that("check.model.class returns correct values (kardl_lm)", {
  skip_if_not_installed("kardl")
  skip_if(is.null(model.kardl_lm), "kardl_lm model could not be constructed")
  
  # Store results for testing
  kardl_lm.class <- check.model.class(model.kardl_lm)
  
  expect_equal( # the class is correct
    # Function output
    kardl_lm.class$model.class,
    
    # Expected output
    "kardl_lm"
  )
  
  expect_equal( # the class is supported
    # Function output
    kardl_lm.class$supported,
    
    # Expected output
    TRUE
  )

  expect_equal( # the class is not panel
    # Function output
    kardl_lm.class$is.panel,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not glm
    # Function output
    kardl_lm.class$is.glm,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not a wrapper
    # Function output
    kardl_lm.class$is.wrapper,
    
    # Expected output
    FALSE
  )

  expect_equal( # the link function is identity
    # Function output
    kardl_lm.class$link.fn,
    
    # Expected output
    "identity"
  )

})

#####################################################################
# get.model.coef
#####################################################################

test_that("get.model.coef returns correct values (kardl_lm)", {
  skip_if_not_installed("kardl")
  skip_if(is.null(model.kardl_lm), "kardl_lm model could not be constructed")
  
  # get the coefficients
  kardl_lm.coef <- get.model.coef(model.kardl_lm)

  # test the qualities of the coefficient vector
  expect_true(is.numeric(kardl_lm.coef)) 
  expect_true(is.vector(kardl_lm.coef))
  expect_true(!is.null(names(kardl_lm.coef)))

  expect_equal( # number of coefficients
    # Function output
    length(kardl_lm.coef),
    
    # Expected output: kardl adds lagged differences of the order, presuming everything is a GECM lol
    11
  )
})  

#####################################################################
# get.model.vcov
#####################################################################

test_that("get.model.vcov returns correct values (kardl_lm)", {
  skip_if_not_installed("kardl")
  skip_if(is.null(model.kardl_lm), "kardl_lm model could not be constructed")
  
  # get the coefficients and vcov
  kardl_lm.coef <- get.model.coef(model.kardl_lm)  
  kardl_lm.vcov <- get.model.vcov(model.kardl_lm, check.model.class(model.kardl_lm), se.type = "const")

  # test the qualities of the coefficient vector
  expect_true(is.matrix(kardl_lm.vcov)) 
  expect_true(isSymmetric(kardl_lm.vcov)) 
  expect_true(!is.null(rownames(kardl_lm.vcov)))
  expect_true(!is.null(colnames(kardl_lm.vcov)))
  
  # do the names match?
  expect_equal(names(kardl_lm.coef), rownames(kardl_lm.vcov))
  expect_equal(names(kardl_lm.coef), colnames(kardl_lm.vcov))

})  

#####################################################################
# get.model.data
#####################################################################

test_that("get.model.data returns correct values (kardl_lm)", {
  skip_if_not_installed("kardl")
  skip_if(is.null(model.kardl_lm), "kardl_lm model could not be constructed")
  
  # get the coefficients and data
  kardl_lm.coef <- get.model.coef(model.kardl_lm)    
  kardl_lm.data <- get.model.data(model.kardl_lm, model.info = check.model.class(model.kardl_lm))

  # Is it a dataframe?
  expect_true(is.data.frame(kardl_lm.data))

  # are the coefficients in it?
  kardl_lm.coef.vars <- setdiff(names(kardl_lm.coef), "(Intercept)")
  expect_true(all(kardl_lm.coef.vars %in% names(kardl_lm.data)))  

  # Expected output: correct number of rows/columns 
  expect_equal( # same number of rows
    # Function output
    nrow(kardl_lm.data), 
    
    # Expected output: kardl requires trimming off the rows for the lags (extra for the lagged differences)
    nrow(toy.ts.interaction.data) - 3
  ) 
  
  # Some columns lol
  expect_true(ncol(kardl_lm.data) > 0)

})  

#####################################################################
# calculation
#####################################################################

test_that("adl.plot calculates values correctly for method (kardl_lm)", {
  skip_if_not_installed("kardl")
  skip_if(is.null(model.kardl_lm), "kardl_lm model could not be constructed")
  
  # the model. this formula is wrong but we will just feed it the wrong thing in adl.plot too
  lrm.formula <- "(L1.x) / (1 - L1.y)"
  
  # raw calculations
  lrm.est.from.raw <- (coef(model.kardl_lm)["L1.x"])/(1 - coef(model.kardl_lm)["L1.y"])
  lrm.se.from.raw <- deltaMethod(coef(model.kardl_lm), g = lrm.formula, vcov. = vcov(model.kardl_lm))$SE

  # tseffects calculations

  adl.out <- suppressWarnings(adl.plot(model = model.kardl_lm, 
    y.vrbl = c("L1.y" = 1), 
    x.vrbl = c("L1.x" = 1), 
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

