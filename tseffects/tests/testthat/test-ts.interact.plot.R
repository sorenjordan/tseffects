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


# Change these to DB path
# source("/Users/sorenjordan/Dropbox/Garrett-Soren/Interactions in time series/R/tseffects-nextversion-draft.R")
# load("/Users/sorenjordan/Dropbox/Garrett-Soren/Interactions in time series/R/tseffects/data/approval.rda")
# load("/Users/sorenjordan/Dropbox/Garrett-Soren/Interactions in time series/R/tseffects/data/toy.ts.interaction.data.rda")

source("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects-nextversion-draft.R")
load("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects/data/approval.rda")
load("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects/data/toy.ts.interaction.data.rda")


test_that("Warnings are issued correctly", {
  
  # run a model to use for warnings
  model.alllags <- lm(y ~ l.1.y + l.2.y +
                        x + l.1.x + l.2.x +
                        z + l.1.z + 
                        x.z + l.1.x.l.1.z, 
                      data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function
    ts.interact.plot(model = model.alllags, 
                   # x.vrbl = c("x" = 0, "l.1.x" = 1), 
                   y.vrbl = c("l.1.y" = 1), 
                   z.vrbl = c("z" = 0, "l.1.z" = 1),
                   x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                   return.plot = TRUE, 
                   effect.type = "xz.me.zlines", se.type = "HC3",
                   return.data = TRUE, s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\) must be specified through x.vrbl, y.vrbl, z.vrbl, and x.z.vrbl"
  ) 
  
  expect_error( # no y.vrbl
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     # y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", se.type = "HC3",
                     return.data = TRUE, s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\)"
  )
  
  expect_error( # no z.vrbl
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     #z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", se.type = "HC3",
                     return.data = TRUE, s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\)"
  )
  
  expect_error( # no x.z.vrbl
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     #x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", se.type = "HC3",
                     return.data = TRUE, s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\)"
  )
  
  expect_error( # no effect.type
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     # effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, s.limit = 20),
    # Expected error
    "Effect type must be specified"
  )
  
  expect_error( # no effect.type
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     # effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, s.limit = 20),
    # Expected error
    "Effect type must be specified"
  )
  
  expect_error( # invalid effect.type
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "Reshi is devastatingly handsome", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "Invalid effect.type"
  )
  
  expect_error( # x vrbl not named
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c(0,1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # x vrbl values not given
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x", "l.1.x"), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "x.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl not named
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c(1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # y vrbl values not given
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y"), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "y.vrbl should be a named vector"
  )
  
  expect_error( # z vrbl not named
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c(0, 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "z.vrbl should be a named vector"
  )
  
  expect_error( # z vrbl values not given
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z", "l.1.z"),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "z.vrbl should be a named vector"
  )
  
  expect_error( # x.z vrbl not named
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c(0, 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "x.z.vrbl should be a named vector"
  )
  
  expect_error( # x.z vrbl values not given
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z","l.1.x.l.1.z"), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "HC3",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "x.z.vrbl should be a named vector"
  )
  
  expect_error( #Incorrect SE 
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     se.type = "Loser",
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "Invalid se.type. se.type"
  )
  
  expect_warning( # Changing _ to .  
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected Warning
    "Variable names containing . replaced with \\_"
  )
  
  expect_error( # x.vrbl missing from model
    # Function
    ts.interact.plot(model = model.alllags, 
                     # x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\) must be specified"
  )
  
  expect_error( # y.vrbl missing from model
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     #y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\) must be specified"
  )
  
  expect_error( # z.vrbl missing from model
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     #z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\) must be specified"
  )
  
  expect_error( # x.z.vrbl missing from model
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     #x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20),
    # Expected error
    "Variables in interaction term \\(x, y, z, and x.z\\) must be specified"
  )
  
  expect_error( # z.limits length > 2
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20,
                     z.limit = c(1,3, 7)),
    # Expected error
    "z.limits should only be two values"
  )
  
  expect_error( # z.limits wrong order
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20,
                     z.limit = c(7,1)),
    # Expected error
    "First z.limit should be lower than second z.limit"
  )
  
  expect_error( # both z.limit and z.val
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20,
                     z.limit = c(1,6),
                     z.vals = c(3,9)),
    # Expected error
    "Specify only z.limits or z.vals"
  )
  
  expect_error( # z.limit > 5
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.zlines", 
                     return.data = TRUE, 
                     s.limit = 20,
                     z.vals = c(3:9)),
    # Expected error
    "Do not supply more than 5 discrete values of z"
  )
  
  expect_error( # s.val > 5
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.cme.slines", 
                     return.data = TRUE, 
                     s.vals = c(1,8, 16, 23, 56,98)),
    # Expected error
    "Do not supply more than 5 discrete values of s to plot"
  )
  
  
  expect_warning( # z.val < 5 & slines
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.cme.slines", 
                     return.data = TRUE, 
                     z.vals = c(5:8)),
    # Expected warning
    "s lines will be very choppy for so few z.vals"
  )
  
  expect_warning( # z.val < 5 and heatmap
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.heatmap", 
                     return.data = TRUE, 
                     z.vals = c(5:8)),
    # Expected warning
    "Heatmap will be very blocky for so few z.vals"
  )
  
  expect_error( # z.vals not same length as line.colors
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.cme.zlines", 
                     return.data = TRUE, 
                     line.colors = c("blue", "red", "pink"),
                     z.vals = c(5:8)),
    # Expected warning
    "Number of supplied line.colors \\(3\\) is not equal to number of z.vals"
  )
  
  expect_error( # s.vals not same length as line.colors
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.cme.slines", 
                     return.data = TRUE, 
                     line.colors = c("blue", "red", "pink"),
                     s.vals = c(5:8)),
    # Expected warning
    "Number of supplied line.colors"
  )
  
  expect_error( # unkown color pallette
    # Function
    ts.interact.plot(model = model.alllags, 
                     x.vrbl = c("x" = 0, "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     z.vrbl = c("z" = 0, "l.1.z" = 1),
                     x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                     return.plot = TRUE, 
                     effect.type = "xz.me.heatmap", 
                     return.data = TRUE, 
                     s.limit = 20, 
                     heatmap.colors = 'Victim of Crime'),
    # Expected warning
    "heatmap.colors must be one of hcl.pals"
  )
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), 
                                 y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, 
                                            "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE,   
                                 effect.type = "xz.me.zlines", 
                                 return.formulae = TRUE,
                                 return.data = TRUE)
  
  expect_equal( # x=1, y={1,2}, x.z = 1, s=0, ME, is correct value 
    # Function
    model_test$formulae[['s = 0']],
    # Expected output
    "0"
  )   
  
  expect_equal( # x=1, y={1,2}, x.z = 1, s=3, ME, is correct value 
    ###### Im not sure about this one, it doesn't seem to match the formulae
    # Function
    model_test$formulae[['s = 3']],
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**2 * l_1_x_l_1_z * z_val  +  l_1_x * l_2_y  +  l_1_x_l_1_z * z_val * l_2_y"
    )  
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), 
                                 y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, 
                                            "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE,    
                                 effect.type = "xz.cme.zlines", 
                                 return.formulae = TRUE,
                                 return.data = TRUE)
  
  expect_equal( # x=1, y={1,2}, x.z = 1, s=0, CME, is correct value  
    # Function
    model_test$formulae[['s = 0']],
    # Expected output
    "0"
  )  

  expect_equal( #  x=1, y={1,2}, x.z = 1, s=3, CME, is correct value 
    # Function
    model_test$formulae[['s = 3']],
    # Expected output
    "l_1_x  +  l_1_x_l_1_z * z_val  +  l_1_x * l_1_y  +  l_1_x_l_1_z * z_val * l_1_y  +  l_1_x * l_1_y**2  +  l_1_x_l_1_z * z_val * l_1_y**2  +  l_1_x * l_2_y  +  l_1_x_l_1_z * z_val * l_2_y"
  )  
  
  expect_equal( #  x=1, y={1,2}, x.z = 1, s=3, CME, is correct value 
    # Function
    model_test$formulae[['LRM']],
    # Expected output
    "(0+l_1_x * (1/(1-(l_1_y+l_2_y))))+(0+l_1_x_l_1_z * (1/(1-(l_1_y+l_2_y)))) * z_val"
  )  
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.me.zlines", 
                                 return.formulae = TRUE, return.data = TRUE)
  
  make_expectation('ME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates))  # Test ME in data output
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.me.heatmap.onlysig", 
                                 return.formulae = TRUE, return.data = TRUE)
  
  make_expectation('ME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates) &
                     'insig' %in% names(model_test$estimates) &
                     'ME.sig' %in% names(model_test$estimates))
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.me.heatmap", 
                                 return.formulae = TRUE, return.data = TRUE)
  
  make_expectation('ME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates))
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.cme.zlines", 
                                 return.formulae = TRUE, return.data = TRUE, 
                                 z.vals = 5)
  
  make_expectation('CME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates))  # Test CME in data output
  
  expect_true('LRM' %in% model_test$estimates$Period)
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.cme.slines", 
                                 return.formulae = TRUE, return.data = TRUE, s.vals = 5)
  
  make_expectation('CME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates))  # Test CME in data output
  
  expect_true('LRM' %in% model_test$estimates$Period)
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.cme.heatmap.onlysig", 
                                 return.formulae = TRUE, return.data = TRUE)
  
  make_expectation('CME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                   'Upper' %in% names(model_test$estimates))  # Test CME in data output
  
  expect_true('LRM' %in% model_test$estimates$Period)
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = TRUE, effect.type = "xz.cme.heatmap", 
                                 return.formulae = TRUE, return.data = TRUE)
  
  make_expectation('CME' %in% names(model_test$estimates) &
                     "Z" %in% names(model_test$estimates) &
                     'Period' %in% names(model_test$estimates) &
                     'SE' %in% names(model_test$estimates) & 
                     'Lower' %in% names(model_test$estimates) & 
                     'Upper' %in% names(model_test$estimates))  # Test CME in data output
  
  expect_true('LRM' %in% model_test$estimates$Period)
  
  dim_store <- dim(model_test$estimates)
  make_expectation(dim_store == as.vector(as.integer(cbind( # Test dimensions
    length(model_test$estimates$Period),
    length(model_test$estimates)))))
  
  expect_error( # No plot, estimates, formulae 
    # Function
    ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 return.plot = FALSE, effect.type = "xz.cme.slines", 
                                 return.formulae = FALSE, return.data = FALSE),
    # Expected error
    "Return at least one of the plot, the data"
  )
  #### Final Tests 
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                               effect.type = "xz.cme.zlines", return.formulae = TRUE,
                               return.data = TRUE, z.limit = c(0,10))
  expect_true(all(c("plot", "estimates", "formulae") %in% names(model_test)))
  
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 effect.type = "xz.cme.zlines", return.formulae = FALSE,
                                 return.data = TRUE, z.limit = c(0,10))
  expect_false("formulae" %in% names(model_test))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 effect.type = "xz.cme.zlines", return.formulae = TRUE,
                                 return.data = TRUE, z.limit = c(0,10))
  expect_true(all(c("estimates", "formulae") %in% names(model_test)))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 effect.type = "xz.cme.zlines", return.formulae = TRUE,
                                 return.data = TRUE, z.limit = c(0,10))
  expect_true(all(c("plot") %in% names(model_test)))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 effect.type = "xz.cme.zlines", return.formulae = FALSE,
                                 return.data = TRUE, z.limit = c(0,10))
  expect_false(all(c("formulae") %in% names(model_test)))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 effect.type = "xz.cme.zlines", return.formulae = TRUE,
                                 return.data = FALSE, z.limit = c(0,10))
  expect_false(all(c("estimates") %in% names(model_test)))
  
  model_test <- ts.interact.plot(model = model.alllags, 
                                 x.vrbl = c("l.1.x" = 1), y.vrbl = c("l.1.y" = 1, "l.2.y" = 2), 
                                 z.vrbl = c("z" = 0, "l.1.z" = 1),
                                 x.z.vrbl = c("l.1.x.l.1.z" = 1), 
                                 effect.type = "xz.cme.zlines", return.formulae = FALSE,
                                 return.data = FALSE, z.limit = c(0,10))
  expect_false(all(c("plot", "formulae") %in% names(model_test)))
  
  }
)

test_that("Correct Z-line Plot", {
  model.alllags <- lm(formula = y ~ l.1.y + x + l.1.x + l.2.x + 
                        z + l.1.z + x.z + l.1.x.l.1.z, data = toy.ts.interaction.data)
  
  p <- ts.interact.plot(model = model.alllags, 
                        x.vrbl = c("x" = 0, "l.1.x" = 1), 
                        y.vrbl = c("l.1.y" = 1), 
                        z.vrbl = c("z" = 0, "l.1.z" = 1),
                        x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                        return.plot = TRUE, 
                        effect.type = "xz.me.zlines", se.type = "HC3",
                        return.data = FALSE, s.limit = 20)
  expect_no_error(p) # Check for errors during plot generation
  expect_doppelganger("p", p) # Test the plot
  expect_snapshot("p")
})

test_that("Correct Heatmaps Plot", {
  model.alllags <- lm(formula = y ~ l.1.y + x + l.1.x + l.2.x + 
                        z + l.1.z + x.z + l.1.x.l.1.z, data = toy.ts.interaction.data)
  
  q <- ts.interact.plot(model = model.alllags, 
                        x.vrbl = c("x" = 0, "l.1.x" = 1), 
                        y.vrbl = c("l.1.y" = 1), 
                        z.vrbl = c("z" = 0, "l.1.z" = 1),
                        x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                        return.plot = TRUE, 
                        effect.type = "xz.me.heatmap", se.type = "HC3",
                        return.data = FALSE, s.limit = 20)
  expect_no_error(q)
  expect_doppelganger("q", q) # Test the plot
  expect_snapshot("q")
})

test_that("Correct S-lines Plot", {
  model.alllags <- lm(formula = y ~ l.1.y + x + l.1.x + l.2.x + 
                        z + l.1.z + x.z + l.1.x.l.1.z, data = toy.ts.interaction.data)
  
  n <- ts.interact.plot(model = model.alllags, 
                        x.vrbl = c("x" = 0, "l.1.x" = 1), 
                        y.vrbl = c("l.1.y" = 1), 
                        z.vrbl = c("z" = 0, "l.1.z" = 1),
                        x.z.vrbl = c("x.z" = 0,"l.1.x.l.1.z" = 1), 
                        return.plot = TRUE, 
                        effect.type = "xz.cme.slines", se.type = "HC3",
                        return.data = FALSE, s.limit = 20)
  expect_no_error(n) # Check for errors during plot generation
  expect_doppelganger("n", n) # Test the plot
  expect_snapshot("n")
})
