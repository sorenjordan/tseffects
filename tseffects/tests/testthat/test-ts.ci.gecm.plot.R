# required for package
library(mpoly)
library(car)
library(ggplot2)
library(see)
library(colorspace)
library(stats)
library(sandwich)

# required for tester
library(tidyverse)
library(dynamac)
library(lmtest)
library(lattice)
library(ggpubr)
library(testthat)
library(vdiffr)

source("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects-nextversion-draft.R")
load("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects/data/toy.ts.interaction.data.rda")
toy.ts.interaction.data$l.y <- lshift(toy.ts.interaction.data$y,1)
toy.ts.interaction.data$d.y <- dshift(toy.ts.interaction.data$y)
toy.ts.interaction.data$d.2.y <- dshift(toy.ts.interaction.data$d.y)
toy.ts.interaction.data$l.d.2.y <- lshift(toy.ts.interaction.data$d.2.y, 1)

toy.ts.interaction.data$l.1.d.y <- lshift(toy.ts.interaction.data$d.y, 1)
toy.ts.interaction.data$l.2.d.y <- lshift(toy.ts.interaction.data$d.y, 2)
toy.ts.interaction.data$l.x <- lshift(toy.ts.interaction.data$x, 1)
toy.ts.interaction.data$d.x <- dshift(toy.ts.interaction.data$x)
toy.ts.interaction.data$l.1.d.x <- lshift(toy.ts.interaction.data$d.x, 1)
toy.ts.interaction.data$l.2.d.x <- lshift(toy.ts.interaction.data$d.x, 2)

test_that("Warnings are issued correctly", {
  
  # run a model to use for warnings
  model <- lm(d.y ~ l.y + l.x + l.1.d.y + d.x + l.1.d.x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function
    ts.ci.gecm.plot(model = model, 
                    # x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Variables in treatment effects term \\(x and y\\) and lagged differences"
  ) 
  
  expect_error( # no y.vrbl
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    #y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Variables in treatment effects term \\(x and y\\) and lagged differences"
  )
  
  expect_error( # no x.d.vrbl
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    # x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Variables in treatment effects term \\(x and y\\) and lagged differences"
  ) 
  
  expect_error( # no y.d.vrbl
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    # y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "lagged differences must be specified through x.vrbl, y.vrbl, x.d.vrbl, and y.d.vrbl for a GECM"
  )

  expect_error( # no x.vrbl.d.x
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    # x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in treatment effects term"  ) 
  
  expect_error( # no y.vrbl.d.y
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    #y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in treatment effects term"  )
  
  expect_error( # no x.d.vrbl.d.x
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    # x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in lagged differences \\(x and y\\) must be specified through x.d.vrbl.d.x"
  ) 
  
  expect_error( # no y.d.vrbl.d.y
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                   # y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in lagged differences \\(x and y\\) must be specified through x.d.vrbl.d.x"
  )
  
  expect_error( # whole number d(0) in x
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1.24, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in lagged differences \\(x.d.vrbl.d.x and y.d.vrbl.d.y\\) must be an integer"  )
  
  expect_error( # whole number d(0) in y
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 3.14,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in lagged differences \\(x.d.vrbl.d.x and y.d.vrbl.d.y\\) must be an integer"
  )
  
  expect_error( # whole number d(1) in x
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0.753654, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in treatment effects term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an"  )
  
  expect_error( # whole number d(1) in y
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 74.645,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Order of differencing of variables in treatment effects term \\(x.vrbl.d.x and y.vrbl.d.y\\) must be an"  )
  
  expect_error( # x vrbl is named
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c(1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl values not given
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x"), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl not named
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c(1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl values not given
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y"),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x.d.vrbl values not named
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c(0, 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl values not given
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x", "l.1.d.x"), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "x.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl values not named
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c(1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # y.d.vrbl values not given
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y"),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "y.d.vrbl should be a named vector with elements"
  )
  
  expect_error( # x.d.vrbl.d.order-x.vrbl.d.order = 1?
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 3, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # y.d.vrbl.d.order-y.vrbl.d.order = 1?
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 9,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "In a GECM, the variable in differences should"
  )
  
  expect_error( # first lag?
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 2),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # first lag?
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 9), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # first lag of x onl.y one value?
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 0, 'd.x' = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )
  
  expect_error( # first lag of y onl.y one value?
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 0), 
                    y.vrbl = c("l.y" = 1, "l.1.d.y" = 2),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "pte", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "In a GECM, include only the first lag of the variable"
  )

 expect_error( # treatment effect is correct
      # Function
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l.x" = 1), 
                      y.vrbl = c("l.y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                      y.d.vrbl = c("l.1.d.y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "Daleks", 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      # Expected error
      "Invalid te.type. te.type must be one of pte \\(pulse\\) or ste \\(step\\)"
    )
    
    expect_error( # in levels?
      # Function
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l.x" = 1), 
                      y.vrbl = c("l.y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                      y.d.vrbl = c("l.1.d.y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "ste", 
                      inferences.y = "New Jersey", 
                      inferences.x = "levels",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      # Expected error
      "In a GECM, causal inferences regarding the treatment effect of x on y are automatically recovered in" 
    )
    
    expect_error( # in levels?
      # Function
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l.x" = 1), 
                      y.vrbl = c("l.y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                      y.d.vrbl = c("l.1.d.y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "ste", 
                      inferences.y = "levels", 
                      inferences.x = "Pennsylvania",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE),
      # Expected error
      "In a GECM, causal inferences regarding the treatment effect of x on y are automatically recovered in"
    )
  
    expect_error( # SE correct
      # Function
      ts.ci.gecm.plot(model = model, 
                      x.vrbl = c("l.x" = 1), 
                      y.vrbl = c("l.y" = 1),
                      x.vrbl.d.x = 0, 
                      y.vrbl.d.y = 0,
                      x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                      y.d.vrbl = c("l.1.d.y" = 1),
                      x.d.vrbl.d.x = 1, 
                      y.d.vrbl.d.y = 1,
                      te.type = "ste", 
                      inferences.y = "levels", 
                      inferences.x = "levels",
                      h.limit = 2, 
                      return.plot = TRUE, 
                      return.formulae = TRUE,
                      se.type = 'Cyberman'),
      # Expected error
      "Invalid se.type. se.type must be an accepted" 
    )
  
  expect_error( # x vrbl values not given
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("weeping angel" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # inference type specified - x.d
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "Sontaran" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "x.d.vrbl not present in estimated model" 
  )
  
  expect_error( # y vrbl values not given
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("androzani" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "y.vrbl not present in estimated model"
  )
  
  expect_error( # inference type specified - y.d
    # Function
    ts.ci.gecm.plot(model = model, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("Rassilon" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "y.d.vrbl not present in estimated model" 
  )
  
  toy.ts.interaction.data$d.d.x <- toy.ts.interaction.data$d.x
  model_warning <- lm(d.y ~ l.y + l.x + l.1.d.y + d.d.x + l.1.d.x, data = toy.ts.interaction.data)
  
  expect_warning( # Changing _ to . 
    # Function
    ts.ci.gecm.plot(model = model_warning, 
                    x.vrbl = c("l.x" = 1), 
                    y.vrbl = c("l.y" = 1),
                    x.vrbl.d.x = 0, 
                    y.vrbl.d.y = 0,
                    x.d.vrbl = c("d.d.x" = 0, "l.1.d.x" = 1), 
                    y.d.vrbl = c("l.1.d.y" = 1),
                    x.d.vrbl.d.x = 1, 
                    y.d.vrbl.d.y = 1,
                    te.type = "ste", 
                    inferences.y = "levels", 
                    inferences.x = "levels",
                    h.limit = 2, 
                    return.plot = TRUE, 
                    return.formulae = TRUE),
    # Expected error
    "Variable names containing . replaced with \\_"
  )
  
  ##### Where I Left Off #####
  
  model_test_pte <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "pte", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.plot = TRUE, 
                                return.formulae = TRUE)
  
  model_test_ste <- ts.ci.gecm.plot(model = model, 
                                    x.vrbl = c("l.x" = 1), 
                                    y.vrbl = c("l.y" = 1),
                                    x.vrbl.d.x = 0, 
                                    y.vrbl.d.y = 0,
                                    x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                    y.d.vrbl = c("l.1.d.y" = 1),
                                    x.d.vrbl.d.x = 1, 
                                    y.d.vrbl.d.y = 1,
                                    te.type = "ste", 
                                    inferences.y = "levels", 
                                    inferences.x = "levels",
                                    h.limit = 2, 
                                    return.plot = TRUE, 
                                    return.formulae = TRUE)
  
  
  
  expect_equal( # x={0, 1}, y={1}, h=2, LTE, is correct value 
    # Function
    
    model_test_pte$formulae[['h = 2']],
    # Expected output
    "l_y * l_x  +  l_y * l_1_d_x  +  l_y**2 * d_x  +  2 * l_y * d_x * l_1_d_y  +  l_x * l_1_d_y  +  l_1_d_x * l_1_d_y  +  d_x * l_1_d_y**2  +  l_x  +  l_y * d_x"
  )   
  
  expect_equal( # x={0, 1}, y={1}, h=2, CTE, is correct value 
    # Function
    
    model_test_ste$formulae[['h = 2']],
    # Expected output
    "l_y * l_x  +  l_y * l_1_d_x  +  l_y**2 * d_x  +  2 * l_y * d_x * l_1_d_y  +  l_x * l_1_d_y  +  l_1_d_x * l_1_d_y  +  d_x * l_1_d_y**2  +  2 * l_x  +  2 * l_y * d_x  +  l_1_d_x  +  d_x * l_1_d_y  +  d_x"
    )
  
  make_expectation('GDTE' %in% names(model_test_pte$plot$data) &
                     'Period' %in% names(model_test_pte$plot$data) &
                     'SE' %in% names(model_test_pte$plot$data) & 
                     'Lower' %in% names(model_test_pte$plot$data) & 
                     'Upper' %in% names(model_test_pte$plot$data))
  
  make_expectation('GDTE' %in% names(model_test_ste$plot$data) &
                     'Period' %in% names(model_test_ste$plot$data) &
                     'SE' %in% names(model_test_ste$plot$data) & 
                     'Lower' %in% names(model_test_ste$plot$data) & 
                     'Upper' %in% names(model_test_ste$plot$data))
  
  dim_store <- dim(model_test_pte$plot$data)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test_pte$plot$data$Period),
    length(model_test_pte$plot$data)))))
  
  dim_store <- dim(model_test_ste$plot$data)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test_ste$plot$data$Period),
    length(model_test_ste$plot$data)))))
  
  #### Final Tests 
  model_test <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.plot = TRUE, return.formulae = TRUE,
                                return.data = TRUE)
  expect_true(all(c("plot", "estimates", "formulae") %in% names(model_test)))
  
  
  model_test <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2,
                                return.formulae = FALSE, return.plot = TRUE,
                                return.data = TRUE)
  expect_false("formulae" %in% names(model_test))
  
  model_test <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2,
                                return.formulae = FALSE, return.plot = TRUE,
                                return.data = FALSE)
  expect_false(all(c("estimates", "formulae") %in% names(model_test)))
  
  model_test <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2,
                                return.plot = FALSE, return.data = TRUE,
                                return.formulae = TRUE)
  expect_false(all(c("plot") %in% names(model_test)))
  
  model_test <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.formulae = TRUE, return.plot = TRUE,
                                return.data = FALSE)
  expect_false(all(c("estimates") %in% names(model_test)))
  
  model_test <- ts.ci.gecm.plot(model = model, 
                                x.vrbl = c("l.x" = 1), 
                                y.vrbl = c("l.y" = 1),
                                x.vrbl.d.x = 0, 
                                y.vrbl.d.y = 0,
                                x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                                y.d.vrbl = c("l.1.d.y" = 1),
                                x.d.vrbl.d.x = 1, 
                                y.d.vrbl.d.y = 1,
                                te.type = "ste", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 2, 
                                return.formulae = FALSE, return.plot =  FALSE,
                                return.data = TRUE)
  expect_false(all(c("plot", "formulae") %in% names(model_test)))
  
}
)

test_that("Correct Plots", {
  model <- lm(d.y ~ l.y + l.x + l.1.d.y + d.x + l.1.d.x, data = toy.ts.interaction.data)  
  p <- ts.ci.gecm.plot(model = model, 
                       x.vrbl = c("l.x" = 1), 
                       y.vrbl = c("l.y" = 1),
                       x.vrbl.d.x = 0, 
                       y.vrbl.d.y = 0,
                       x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                       y.d.vrbl = c("l.1.d.y" = 1),
                       x.d.vrbl.d.x = 1, 
                       y.d.vrbl.d.y = 1,
                       te.type = "pte", 
                       inferences.y = "levels", 
                       inferences.x = "levels",
                       h.limit = 2,  
                       return.formulae = FALSE, 
                       return.plot =  TRUE,
                       return.data = FALSE)
  expect_no_error(p) 
  expect_doppelganger("p", p)
  expect_snapshot("p")
  
  q <- ts.ci.gecm.plot(model = model, 
                       x.vrbl = c("l.x" = 1), 
                       y.vrbl = c("l.y" = 1),
                       x.vrbl.d.x = 0, 
                       y.vrbl.d.y = 0,
                       x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                       y.d.vrbl = c("l.1.d.y" = 1),
                       x.d.vrbl.d.x = 1, 
                       y.d.vrbl.d.y = 1,
                       te.type = "ste", 
                       inferences.y = "levels", 
                       inferences.x = "levels",
                       h.limit = 2,  
                       return.formulae = FALSE, 
                       return.plot =  TRUE,
                       return.data = FALSE)
  expect_no_error(q) 
  expect_doppelganger("q", q)
  expect_snapshot("q")
})