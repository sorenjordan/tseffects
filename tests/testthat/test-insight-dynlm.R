#####################################################################
# shared model setup in case not installed
#####################################################################
model.dynlm <- NULL

test_that("dynlm model can be constructed", {
  skip_if_not_installed("dynlm")
  
  library(dynlm)

  toy.ts.interaction.data.ts <- ts(toy.ts.interaction.data, start = 1, end = 50, frequency = 1)
  
  model.dynlm <<- dynlm::dynlm(y ~ L(y, 1) + x + L(x, 1) + L(x, 2) + z + L(z, 1) + L(z, 2), data = toy.ts.interaction.data.ts)
  
  expect_s3_class(model.dynlm, "dynlm")
})

#####################################################################
# check.model.class
#####################################################################

test_that("check.model.class returns correct values (dynlm)", {
  skip_if_not_installed("dynlm")
  skip_if(is.null(model.dynlm), "dynlm model could not be constructed")
  
  # Store results for testing
  dynlm.class <- check.model.class(model.dynlm)
  
  expect_equal( # the class is correct
    # Function output
    dynlm.class$model.class,
    
    # Expected output
    "dynlm"
  )
  
  expect_equal( # the class is supported
    # Function output
    dynlm.class$supported,
    
    # Expected output
    TRUE
  )

  expect_equal( # the class is not panel
    # Function output
    dynlm.class$is.panel,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not glm
    # Function output
    dynlm.class$is.glm,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not a wrapper
    # Function output
    dynlm.class$is.wrapper,
    
    # Expected output
    FALSE
  )

  expect_equal( # the link function is identity
    # Function output
    dynlm.class$link.fn,
    
    # Expected output
    "identity"
  )

})

#####################################################################
# get.model.coef
#####################################################################

test_that("get.model.coef returns correct values (dynlm)", {
  skip_if_not_installed("dynlm")
  skip_if(is.null(model.dynlm), "dynlm model could not be constructed")
  
  # get the coefficients
  dynlm.coef <- get.model.coef(model.dynlm)

  # test the qualities of the coefficient vector
  expect_true(is.numeric(dynlm.coef)) 
  expect_true(is.vector(dynlm.coef))
  expect_true(!is.null(names(dynlm.coef)))

  expect_equal( # number of coefficients
    # Function output
    length(dynlm.coef),
    
    # Expected output
    8
  )
})  

#####################################################################
# get.model.vcov
#####################################################################

test_that("get.model.vcov returns correct values (dynlm)", {
  skip_if_not_installed("dynlm")
  skip_if(is.null(model.dynlm), "dynlm model could not be constructed")
  
  # get the coefficients and vcov
  dynlm.coef <- get.model.coef(model.dynlm)  
  dynlm.vcov <- get.model.vcov(model.dynlm, check.model.class(model.dynlm), se.type = "const")

  # test the qualities of the coefficient vector
  expect_true(is.matrix(dynlm.vcov)) 
  expect_true(isSymmetric(dynlm.vcov)) 
  expect_true(!is.null(rownames(dynlm.vcov)))
  expect_true(!is.null(colnames(dynlm.vcov)))
  
  # do the names match?
  expect_equal(names(dynlm.coef), rownames(dynlm.vcov))
  expect_equal(names(dynlm.coef), colnames(dynlm.vcov))

})  

#####################################################################
# get.model.data
#####################################################################

test_that("get.model.data returns correct values (dynlm)", {
  skip_if_not_installed("dynlm")
  skip_if(is.null(model.dynlm), "dynlm model could not be constructed")
  
  # get the coefficients and data
  dynlm.coef <- get.model.coef(model.dynlm)    
  dynlm.data <- get.model.data(model.dynlm, model.info = check.model.class(model.dynlm))

  # Is it a dataframe?
  expect_true(is.data.frame(dynlm.data))

  # are the coefficients in it?
  dynlm.coef.vars <- setdiff(names(dynlm.coef), "(Intercept)")
  expect_true(all(dynlm.coef.vars %in% names(dynlm.data)))  

  # Expected output: correct number of rows/columns 
  expect_equal( # same number of rows
    # Functoin output
    nrow(dynlm.data), 
    
    # Expected output: dynlm requires trimming off the rows for the lags
    nrow(toy.ts.interaction.data) - 2
  ) 
  
  # Some columns lol
  expect_true(ncol(dynlm.data) > 0)

})  

#####################################################################
# calculation
#####################################################################

test_that("adl.plot calculates values correctly for method (dynlm)", {
  skip_if_not_installed("dynlm")
  skip_if(is.null(model.dynlm), "dynlm model could not be constructed")
  
  # the model
  lrm.formula <- "(x + `L(x, 1)` + `L(x, 2)`) / (1 - `L(y, 1)`)"
  
  # raw calculations
  lrm.est.from.raw <- (coef(model.dynlm)["x"] + coef(model.dynlm)["L(x, 1)"] + coef(model.dynlm)["L(x, 2)"])/(1 - coef(model.dynlm)["L(y, 1)"])
  lrm.se.from.raw <- deltaMethod(coef(model.dynlm), g = lrm.formula, vcov. = vcov(model.dynlm))$SE

  # tseffects calculations

  adl.out <- suppressWarnings(adl.plot(model = model.dynlm, 
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

