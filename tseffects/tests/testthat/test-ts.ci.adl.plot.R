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
library(vdiffr)

source("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects-nextversion-draft.R")
load("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects/data/toy.ts.interaction.data.rda")
toy.ts.interaction.data$d.y <- dshift(toy.ts.interaction.data$y)
toy.ts.interaction.data$d.2.y <- dshift(toy.ts.interaction.data$d.y)
toy.ts.interaction.data$l.d.2.y <- lshift(toy.ts.interaction.data$d.2.y, 1)

toy.ts.interaction.data$l.1.d.y <- lshift(toy.ts.interaction.data$d.y, 1)
toy.ts.interaction.data$l.2.d.y <- lshift(toy.ts.interaction.data$d.y, 2)
toy.ts.interaction.data$l.3.d.y <- lshift(toy.ts.interaction.data$d.y, 3)

toy.ts.interaction.data$d.x <- dshift(toy.ts.interaction.data$x)
toy.ts.interaction.data$l.1.d.x <- lshift(toy.ts.interaction.data$d.x, 1)
toy.ts.interaction.data$l.2.d.x <- lshift(toy.ts.interaction.data$d.x, 2)
toy.ts.interaction.data$l.3.d.x <- lshift(toy.ts.interaction.data$d.x, 3)

test_that("Warnings are issued correctly", {
  
  # run a model to use for warnings
  model <- lm(d.2.y ~ l.d.2.y + d.x + l.1.d.x, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function
    ts.ci.adl.plot(model = model, 
                   #x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Variables in effects term \\(x and y\\) must be specified through x.vrbl and y.vrbl"
  ) 
  
  expect_error( # no y.vrbl
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   # y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Variables in effects term \\(x and y\\) must be specified through x.vrbl and y.vrbl"
  )
  
  expect_error( # no d.x
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   # d.x = 1, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Order of differencing of variables in treatment effect terms must be specified"
  )
  
  expect_error( # no d.y
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1, 
                   # d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Order of differencing of variables in treatment effect terms must be specified"
  )
  
  expect_error( # whole number differences in x
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1.82, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Order of differencing of variables in treatment effect terms \\(d.x"
  )
  
  expect_error( # whole number differences in y
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1, 
                   d.y = 2.89,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Order of differencing of variables in treatment effect terms \\(d.x"
  )
  
  # expect_error( # treatment effect correctly specified
  #   # Function
  #   ts.ci.adl.plot(model = model, 
  #                  x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
  #                  y.vrbl = c("l.d.2.y" = 1),
  #                  d.x = 1, 
  #                  d.y = 2,
  #                  # te.type = "pulse", 
  #                  inferences.y = "differences", 
  #                  inferences.x = "differences",
  #                  h.limit = 5, 
  #                  return.plot = TRUE, 
  #                  return.formulae = TRUE),
  #   # Expected Error
  #   "Treatment effect type \\(te.type\\) must be" 
  #   )
  
  expect_error( # inference type specified - y
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "the doctor", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Invalid inferences.y. The counterfactual response for y" 
  )

  expect_error( # inference type specified - x
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 1, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "the Rani",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Invalid inferences.x. The counterfactual treatment" 
  )
  
  expect_error( # inference type correctly specified
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "differences", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "The counterfactual response for y cannot be in" 
  )
  
  expect_error( # inference type correctly specified
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "differences",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "The counterfactual response for x cannot be in a higher" 
  )
  
  expect_error( # te.type makes sense
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "the Master", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "Invalid te.type. te.type must be one of pte \\(pulse\\) or ste \\(step\\)" 
  )
  
  expect_error( # x vrbl is named
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c(0,1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl values not given
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x", "l.1.d.x"),
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "x.vrbl should be a named vector"
  )
 
  expect_error( # y vrbl not named
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c(1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl values not given
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c(0,1),
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl values not given
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("Time Lord" = 0, "Time Lady" = 1),
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pte", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "x.vrbl not present in estimated model"
  )
  
  expect_error( # y.vrbl values missing
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("Time Tot" = 1),
                   d.x = 1, 
                   d.y = 2,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected Error
    "y.vrbl not present in estimated model" 
  )
  
  model_warning <- lm(d.2.y ~ l.d.2.y + d.x + l.1.d.x, data = toy.ts.interaction.data)
  
  expect_warning( # Changing _ to . 
    # Function
    ts.ci.adl.plot(model = model_warning, 
                   x.vrbl = c("d.x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.d.2.y" = 1),
                   d.x = 0, 
                   d.y = 0,
                   te.type = "pulse", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 5, 
                   return.plot = TRUE, 
                   return.formulae = TRUE),
    # Expected warning
    "Variable names containing . replaced with \\_"
  )
  
  model <- lm(d.y ~ l.1.d.y + x + l.1.d.x, data = toy.ts.interaction.data)
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 0 + 0 = pulse
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               te.type = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 0 + 0 = step 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 0, 
                               d.y = 0,
                               te.type = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE,
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, x.z = 1, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x"
  )   
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # y=1, x={0,1}, x.z = 1, h=3, pulse, is correct value 
    # Function
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x")
  
    expect_equal( 
      # Function
      model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
      # position = 4 bc counter starts at h = 0
      # Expected output
      c(1, 1, 1, 1)
    )   
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 0 + 0 = pulse
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               te.type = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 0 + 0 = step
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               te.type = "step", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, x.z = 1, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal( # y=1, x={0,1}, x.z = 1, h=3, step, is correct value 
    # Function
    
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
    )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  ) 
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 0 + 1 = step
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               te.type = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 0 + 1 = trend
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 0, 
                               d.y = 1,
                               te.type = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  ) 
  
  expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
    # Function
    
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  2 * l_1_d_y * l_1_d_x  +  2 * l_1_d_y**2 * x  +  3 * l_1_d_x  +  3 * l_1_d_y * x  +  4 * x"
    )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 2, 3, 4)
  ) 
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 0 + 0  = pulse
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               te.type = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 0 + 0 = step 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 0,
                               te.type = "step", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  ) 
  
  expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
    # Function
    
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
  )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  ) 
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 1 + 0 = TIF
                                   x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                                   y.vrbl = c("l.1.d.y" = 1),
                                   d.x = 1, 
                                   d.y = 0,
                                   te.type = "pulse", 
                                   inferences.y = "levels", 
                                   inferences.x = "levels",
                                   h.limit = 3, 
                                   return.plot = TRUE, 
                                   return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 1 + 0 = pulse
                                   x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                                   y.vrbl = c("l.1.d.y" = 1),
                                   d.x = 1, 
                                   d.y = 0,
                                   te.type = "step", 
                                   inferences.y = "levels", 
                                   inferences.x = "levels",
                                   h.limit = 3, 
                                   return.plot = TRUE, 
                                   return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  -  l_1_d_y * l_1_d_x  -  l_1_d_y**2 * x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, -1, 0, 0)
  ) 
  
  expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
    # Function
    
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x"
    )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  ) 
  
  model <- lm(d.y ~ l.1.d.y + x + l.1.d.x, data = toy.ts.interaction.data)

  model_test_pulse <- ts.ci.adl.plot(model = model, # - 1 - 1 + 1 = pulse
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 1 + 1 = step
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "step", 
                               inferences.y = "differences", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  ) 
  
  expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
    # Function
    
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
    )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  ) 
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1  - 1 + 0 = TIF
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "pulse", 
                               inferences.y = "differences", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 0 + 0 = step
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "step", 
                               inferences.y = "differences", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  -  l_1_d_y * l_1_d_x  -  l_1_d_y**2 * x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, -1, 0, 0)
  ) 
  
  expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
    # Function
    
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
  )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  ) 
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 0 + 1 = step
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 0 + 1 = trend 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "step", 
                               inferences.y = "levels", 
                               inferences.x = "differences",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
    # Function
    
    model_test_pulse$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
  )
  
  expect_equal( 
    # Function
    model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  ) 
  
  expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
    # Function
    model_test_step$formulae[['h = 3']],
    # Expected output
    "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  2 * l_1_d_y * l_1_d_x  +  2 * l_1_d_y**2 * x  +  3 * l_1_d_x  +  3 * l_1_d_y * x  +  4 * x"
    )
  
  expect_equal( 
    # Function
    model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 2, 3, 4)
  ) 
    
  
  model_test_pulse <- ts.ci.adl.plot(model = model, # -1 - 1 + 1 = pulse
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "pulse", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
  model_test_step <- ts.ci.adl.plot(model = model, # 0 - 1 + 1 = step
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                               y.vrbl = c("l.1.d.y" = 1),
                               d.x = 1, 
                               d.y = 1,
                               te.type = "step", 
                               inferences.y = "levels", 
                               inferences.x = "levels",
                               h.limit = 3, 
                               return.plot = TRUE, 
                               return.formulae = TRUE)
  
    expect_equal( # y=1, x={0,1}, h=3, pulse, is correct value 
      # Function
      model_test_pulse$formulae[['h = 3']],
      # Expected output
      "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x"
    )
    
    expect_equal( 
      # Function
      model_test_pulse$binomials[[4]], # to get mpoly obj as character, you need to print
      # position = 4 bc counter starts at h = 0
      # Expected output
      c(1, 0, 0, 0)
    ) 
    
    expect_equal( # y=1, x={0,1}, h=3, step, is correct value 
      # Function
      model_test_step$formulae[['h = 3']],
      # Expected output
      "l_1_d_y**2 * l_1_d_x  +  l_1_d_y**3 * x  +  l_1_d_y * l_1_d_x  +  l_1_d_y**2 * x  +  l_1_d_x  +  l_1_d_y * x  +  x"
  )
    
    expect_equal( 
      # Function
      model_test_step$binomials[[4]], # to get mpoly obj as character, you need to print
      # position = 4 bc counter starts at h = 0
      # Expected output
      c(1, 1, 1, 1)
    ) 
  
  dim_store <- length(model_test_pulse$binomials)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test_pulse$binomials),
    length(model_test_pulse$binomials)))))
  
  dim_store <- length(model_test_pulse$formulae)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test_pulse$formulae),
    length(model_test_pulse$formulae)))))
  
  model_test <- ts.ci.adl.plot(model = model, 
                                x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                                y.vrbl = c("l.1.d.y" = 1),
                                d.x = 2, 
                                d.y = 2,
                                te.type = "step", 
                                inferences.y = "levels", 
                                inferences.x = "levels",
                                h.limit = 3, 
                                return.plot = TRUE, 
                                return.formulae = TRUE,
                                return.data = TRUE)
  
  make_expectation('GDTE' %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates))
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  expect_error( # No plot, estimates, formulae 
    # Function
    ts.ci.adl.plot(model = model, 
                   x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                   y.vrbl = c("l.1.d.y" = 1),
                   d.x = 2, 
                   d.y = 2,
                   te.type = "step", 
                   inferences.y = "levels", 
                   inferences.x = "levels",
                   h.limit = 3, 
                   return.plot = FALSE, 
                   return.formulae = FALSE,
                   return.data = FALSE),
    # Expected Error
    "Return at least one of the plot, the data"
  )
  #### Final Tests
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.plot = TRUE, 
                               return.formulae = TRUE, return.data = TRUE)
  
  expect_true(all(c("plot", "estimates", "formulae") %in% names(model_test)))
  
  
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.plot = TRUE, 
                               return.formulae = FALSE, return.data = FALSE)
  expect_false("formulae" %in% names(model_test))
  
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.plot = TRUE, 
                               return.formulae = FALSE, return.data = FALSE)
  expect_false(all(c("estimates", "formulae") %in% names(model_test)))
  
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.formulae = TRUE, return.data = TRUE,
                               return.plot = FALSE)
  expect_false(all(c("plot") %in% names(model_test)))
  
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.plot = TRUE, 
                               return.formulae = FALSE, return.data = TRUE)
  expect_false(all(c("formulae") %in% names(model_test)))
  
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.plot = TRUE, 
                               return.formulae = TRUE, return.data = FALSE)
  expect_false(all(c("estimates") %in% names(model_test)))
  
  model_test <- ts.ci.adl.plot(model = model, 
                               x.vrbl = c("x" = 0, "l.1.d.x" = 1), y.vrbl = c("l.1.d.y" = 1),
                               d.x = 2, d.y = 2,
                               te.type = "step", 
                               inferences.y = "levels", inferences.x = "levels",
                               h.limit = 3, return.plot = FALSE, 
                               return.formulae = FALSE, return.data = TRUE)
  expect_false(all(c("plot", "formulae") %in% names(model_test)))
  
}
)

test_that("Correct Plot", {
  model <- lm(d.y ~ l.1.d.y + x + l.1.d.x, data = toy.ts.interaction.data)
  
  p <- ts.ci.adl.plot(model = model, 
                                   x.vrbl = c("x" = 0, "l.1.d.x" = 1), 
                                   y.vrbl = c("l.1.d.y" = 1),
                                   d.x = 0, 
                                   d.y = 0,
                                   te.type = "pulse", 
                                   inferences.y = "levels", 
                                   inferences.x = "levels",
                                   h.limit = 3, 
                                   return.plot = TRUE,
                                   return.formulae = FALSE)
  expect_no_error(p) # Check for errors during plot generation
  expect_doppelganger("p", p) # Test the plot
  expect_snapshot("p")
  
})