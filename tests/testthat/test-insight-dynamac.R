#####################################################################
# shared model setup in case not installed
#####################################################################
model.dynardl <- NULL

test_that("dynardl model can be constructed", {
  skip_if_not_installed("dynamac")
  
  library(dynamac)
  
  model.dynardl <<- dynamac::dynardl(y ~ x + z,
   levels = c("x", "z"), lags = list("x" = c(1, 2), "z" = c(1, 2), "y" = c(1)), 
   data = toy.ts.interaction.data, simulate = FALSE)
  
  expect_s3_class(model.dynardl, "dynardl")
})

#####################################################################
# check.model.class
#####################################################################

test_that("check.model.class returns correct values (dynamac)", {
  skip_if_not_installed("dynamac")
  skip_if(is.null(model.dynardl), "dynardl model could not be constructed")

  # Store results for testing
  dynardl.class <- check.model.class(model.dynardl)
  
  expect_equal( # the class is correct
    # Function output
    dynardl.class$model.class,
    
    # Expected output
    "dynardl"
  )
  
  expect_equal( # the class is supported
    # Function output
    dynardl.class$supported,
    
    # Expected output
    TRUE
  )

  expect_equal( # the class is not panel
    # Function output
    dynardl.class$is.panel,
    
    # Expected output
    FALSE
  )

  expect_equal( # the class is not glm
    # Function output
    dynardl.class$is.glm,
    
    # Expected output
    FALSE
  )

  expect_equal( # dynardl IS a wrapper for this function
    # Function output
    dynardl.class$is.wrapper,
    
    # Expected output
    TRUE
  )

  expect_equal( # the link function is identity
    # Function output
    dynardl.class$link.fn,
    
    # Expected output
    "identity"
  )

})

#####################################################################
# get.model.coef
#####################################################################

test_that("get.model.coef returns correct values (dynamac)", {
  skip_if_not_installed("dynamac")
  skip_if(is.null(model.dynardl), "dynardl model could not be constructed")

  # get the coefficients
  dynardl.coef <- get.model.coef(model.dynardl)

  # test the qualities of the coefficient vector
  expect_true(is.numeric(dynardl.coef)) 
  expect_true(is.vector(dynardl.coef))
  expect_true(!is.null(names(dynardl.coef)))

  expect_equal( # number of coefficients
    # Function output
    length(dynardl.coef),
    
    # Expected output
    8
  )
})  

#####################################################################
# get.model.vcov
#####################################################################

test_that("get.model.vcov returns correct values (dynamac)", {
  skip_if_not_installed("dynamac")
  skip_if(is.null(model.dynardl), "dynardl model could not be constructed")

  # get the coefficients and vcov
  dynardl.coef <- get.model.coef(model.dynardl)  
  dynardl.vcov <- get.model.vcov(model.dynardl, check.model.class(model.dynardl), se.type = "const")

  # test the qualities of the coefficient vector
  expect_true(is.matrix(dynardl.vcov)) 
  expect_true(isSymmetric(dynardl.vcov)) 
  expect_true(!is.null(rownames(dynardl.vcov)))
  expect_true(!is.null(colnames(dynardl.vcov)))
  
  # do the names match?
  expect_equal(names(dynardl.coef), rownames(dynardl.vcov))
  expect_equal(names(dynardl.coef), colnames(dynardl.vcov))

})  

#####################################################################
# get.model.data
#####################################################################

test_that("get.model.data returns correct values (dynamac)", {
  skip_if_not_installed("dynamac")
  skip_if(is.null(model.dynardl), "dynardl model could not be constructed")

  # get the coefficients and data
  dynardl.coef <- get.model.coef(model.dynardl)    
  dynardl.data <- get.model.data(model.dynardl, model.info = check.model.class(model.dynardl))

  # Is it a dataframe?
  expect_true(is.data.frame(dynardl.data))

  # are the coefficients in it?
  dynardl.coef.vars <- setdiff(names(dynardl.coef), "(Intercept)")
  expect_true(all(dynardl.coef.vars %in% names(dynardl.data)))  

  # Expected output: correct number of rows/columns 
  expect_equal( # same number of rows
    # Function output
    nrow(dynardl.data), 
    
    # Expected output: dynardl requires trimming off the rows for the lags
    nrow(toy.ts.interaction.data) - 2
  ) 
  
  # Some columns lol
  expect_true(ncol(dynardl.data) > 0)

})  

#####################################################################
# calculation
#####################################################################

test_that("adl.plot calculates values correctly for method (dynamac)", {
  skip_if_not_installed("dynamac")
  skip_if(is.null(model.dynardl), "dynardl model could not be constructed")

  # the model
  lrm.formula <- "(x + l.1.x + l.2.x) / (1 - l.1.y)"
  
  # raw calculations
  lrm.est.from.raw <- (coef(model.dynardl$model)["x"] + coef(model.dynardl$model)["l.1.x"] + coef(model.dynardl$model)["l.2.x"])/(1 - coef(model.dynardl$model)["l.1.y"])
  lrm.se.from.raw <- deltaMethod(coef(model.dynardl$model), g = lrm.formula, vcov. = vcov(model.dynardl$model))$SE

  # tseffects calculations

  adl.out <- suppressWarnings(adl.plot(model = model.dynardl, 
    y.vrbl = c("l.1.y" = 1), 
    x.vrbl = c("x" = 0, "l.1.x" = 1, "l.2.x" = 2), 
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

