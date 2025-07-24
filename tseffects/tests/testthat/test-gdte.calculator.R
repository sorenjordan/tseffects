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

expand.grid(d.x = c(0, 1),
            d.y = c(0, 1),
            n = c(-1, 0, 1))

testthat("GDTE Generates Correct Equations"{
  # Create PTE for ADL (1,1) 
  x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
  y.lags <- c("l_1_y" = 1)
  h <- 5
  pte.test <- as.list(pte.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = h))
  # For GDTE itself
  d.x <- 0
  d.y <- 0
  n <- -1 # -1 - 0 + 0 = pulse 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  )  
  
  d.x <- 1
  d.y <- 0
  n <- -1 # -1 - 1 + 0 = transient 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  -  l_1_y * l_1_x  -  l_1_y**2 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, -1, 0, 0)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  )  
  
  d.x <- 0
  d.y <- 1
  n <- -1 # -1 - 0 + 1 = step 
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  )  
  
  d.x <- 1
  d.y <- 1
  n <- -1 # -1 - 1 + 1 = pulse
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 0
  d.y <- 0
  n <- 0 # 0 - 0 + 0 = step
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 1
  d.y <- 0
  n <- 0 # 0 - 1 + 0 = pulse
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 0, 0, 0)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 0
  d.y <- 1
  n <- 0 # 0 - 0 + 1 = trend
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 1
  d.y <- 1
  n <- 0 # 0 - 1 + 1 = step
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x"
    )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 0
  d.y <- 0
  n <- 1 # 1 - 0 + 0 = trend
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 1
  d.y <- 0
  n <- 1 # 1 - 1 + 0 = step
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  l_1_y * l_1_x  +  l_1_y**2 * x  +  l_1_x  +  l_1_y * x  +  x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 1, 1, 1)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 0
  d.y <- 1
  n <- 1 # 1 - 0 + 1 = triangular
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  3 * l_1_y * l_1_x  +  3 * l_1_y**2 * x  +  6 * l_1_x  +  6 * l_1_y * x  +  10 * x"
  )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 3, 6, 10)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
  d.x <- 1
  d.y <- 1
  n <- 1 # 1 - 1 + 1 = trend
  
  gdte.test <- GDTE.calculator(d.x = d.x, d.y = d.y, n = n, limit = h, pte = pte.test)
  
  expect_equal( 
    # Function
    
    print(gdte.test$formulae[[4]]), # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    "l_1_y**2 * l_1_x  +  l_1_y**3 * x  +  2 * l_1_y * l_1_x  +  2 * l_1_y**2 * x  +  3 * l_1_x  +  3 * l_1_y * x  +  4 * x"
    )   
  
  expect_equal( 
    # Function
    gdte.test$binomials[[4]], # to get mpoly obj as character, you need to print
    # position = 4 bc counter starts at h = 0
    # Expected output
    c(1, 2, 3, 4)
  )   
  
  expect_equal(
    length(gdte.test$formulae), # counter goes from h = 0 to h=5
    h+1
  )  
  
  expect_equal(
    length(gdte.test$binomials), # counter goes from h = 0 to h=5
    h+1
  ) 
  
}
)