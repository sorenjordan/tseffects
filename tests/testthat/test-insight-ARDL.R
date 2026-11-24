#####################################################################
# shared model setup in case not installed
#####################################################################
model.ardl <- NULL

test_that("ardl model can be constructed", {
  skip_if_not_installed("ARDL")
  
  library(ARDL)
  
  model.ardl <<- ARDL::ardl(y ~ x + z, data = toy.ts.interaction.data, order = c(1, 2, 2))
  
  expect_s3_class(model.ardl, "ardl")
})

#####################################################################
# check.model.class
#####################################################################

test_that("check.model.class returns correct values (ardl)", {
  skip_if_not_installed("ARDL")
  skip_if(is.null(model.ardl), "ardl model could not be constructed")

  # Store results for testing
  ardl.class <- check.model.class(model.ardl)
  
  expect_equal( # the class is correct
    # Function output
    ardl.class$model.class,
    
    # Expected output
    "ardl"
  )
  
  expect_equal( # the class is supported
    # Function output
    ardl.class$supported,
    
    # Expected output
    TRUE
  )

  expect_equal( # the class is not panel
    # Function output
    ardl.class$is.panel,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not glm
    # Function output
    ardl.class$is.glm,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not a wrapper
    # Function output
    ardl.class$is.wrapper,
    
    # Expected output
    FALSE
  )

  expect_equal( # the link function is identity
    # Function output
    ardl.class$link.fn,
    
    # Expected output
    "identity"
  )

})

#####################################################################
# get.model.coef
#####################################################################

test_that("get.model.coef returns correct values (ardl)", {
  skip_if_not_installed("ARDL")
  skip_if(is.null(model.ardl), "ardl model could not be constructed")
  
  # get the coefficients
  ardl.coef <- get.model.coef(model.ardl)

  # test the qualities of the coefficient vector
  expect_true(is.numeric(ardl.coef)) 
  expect_true(is.vector(ardl.coef))
  expect_true(!is.null(names(ardl.coef)))

  expect_equal( # number of coefficients
    # Function output
    length(ardl.coef),
    
    # Expected output
    8
  )
})  

#####################################################################
# get.model.vcov
#####################################################################

test_that("get.model.vcov returns correct values (ardl)", {
  skip_if_not_installed("ARDL")
  skip_if(is.null(model.ardl), "ardl model could not be constructed")
  
  # get the coefficients and vcov
  ardl.coef <- get.model.coef(model.ardl)  
  ardl.vcov <- get.model.vcov(model.ardl, check.model.class(model.ardl), se.type = "const")

  # test the qualities of the coefficient vector
  expect_true(is.matrix(ardl.vcov)) 
  expect_true(isSymmetric(ardl.vcov)) 
  expect_true(!is.null(rownames(ardl.vcov)))
  expect_true(!is.null(colnames(ardl.vcov)))
  
  # do the names match?
  expect_equal(names(ardl.coef), rownames(ardl.vcov))
  expect_equal(names(ardl.coef), colnames(ardl.vcov))

})  

#####################################################################
# get.model.data
#####################################################################

test_that("get.model.data returns correct values (ardl)", {
  skip_if_not_installed("ARDL")
  skip_if(is.null(model.ardl), "ardl model could not be constructed")
  
  # get the coefficients and data
  ardl.coef <- get.model.coef(model.ardl)    
  ardl.data <- get.model.data(model.ardl, model.info = check.model.class(model.ardl))

  # Is it a dataframe?
  expect_true(is.data.frame(ardl.data))

  # are the coefficients in it?
  ardl.coef.vars <- setdiff(names(ardl.coef), "(Intercept)")
  expect_true(all(ardl.coef.vars %in% names(ardl.data)))  

  # Expected output: correct number of rows/columns 
  expect_equal( # same number of rows
    # Function output
    nrow(ardl.data), 
    
    # Expected output: ardl requires trimming off the rows for the lags
    nrow(toy.ts.interaction.data) - 2
  ) 
  
  # Some columns lol
  expect_true(ncol(ardl.data) > 0)

})  

#####################################################################
# calculation
#####################################################################

test_that("adl.plot calculates values correctly for method (ardl)", {
  skip_if_not_installed("ARDL")
  skip_if(is.null(model.ardl), "ardl model could not be constructed")
  
  # the model
  lrm.formula <- "(x + `L(x, 1)` + `L(x, 2)`) / (1 - `L(y, 1)`)"
  
  # raw calculations
  lrm.est.from.raw <- (coef(model.ardl)["x"] + coef(model.ardl)["L(x, 1)"] + coef(model.ardl)["L(x, 2)"])/(1 - coef(model.ardl)["L(y, 1)"])
  lrm.se.from.raw <- deltaMethod(coef(model.ardl), g = lrm.formula, vcov. = vcov(model.ardl))$SE

  # tseffects calculations

  adl.out <- suppressWarnings(adl.plot(model = model.ardl, 
    y.vrbl = c("L(y, 1)" = 1),
    x.vrbl = c("x" = 0, "L(x, 1)" = 1, "L(x, 2)" = 2), 
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

