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

source('C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects-nextversion-draft.R')
load("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects/data/approval.rda")
load("C:/Users/reshi/Dropbox/03 Research/TS Interactions/R/tseffects/data/toy.ts.interaction.data.rda")


context("Warnings for ts.effect.plot")

#### Warnings Correctly Generated - TS Effect Plot####

test_that("Warnings are issued correctly", {
	
	# run a model to use for warnings
    model.alllags <- lm(y ~ l.1.y +
                        x + l.1.x, data = toy.ts.interaction.data)

    expect_error( # no x.vrbl
    	# Function
    	ts.effect.plot(model = model.alllags, # x.vrbl = c("x" = 0, "l.1.x" = 1), 
    			y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, effect.type = "x.me", return.data = TRUE, s.limit = 20),
    	# Expected error
    	"Variables in effects term \\(x and y\\)"
    )

    expect_error( # no .vrbl
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
    			# y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, effect.type = "x.me", return.data = TRUE, s.limit = 20),
    	# Expected error
    	"Variables in effects term \\(x and y\\)"
    ) 
# Test 3    
    expect_error( # no effect.type
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
    			y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, 
    			# effect.type = "x.me", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"Effect type must be specified"
    ) 
# Test 4
	expect_error( # invalid effect.type
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
    			y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, 
    			effect.type = "x.mce", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"Invalid effect.type."
    ) 

# 	expect_error( # z is included
#     	# Function
#     	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
#     			y.vrbl = c("l.1.y" = 1), 
#     			z.vrbl = c('z' = 24), # z included 
#     			return.plot = FALSE, 
#     			effect.type = "x.me", 
#     			return.data = TRUE, s.limit = 20),
#     	# Expected error
#     	"Do not use ts.effect.plot with an interaction."
#     ) 
#     
#     expect_error( # x.z is included
#     	# Function
#     	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
#     			y.vrbl = c("l.1.y" = 1), 
#     			x.z.vrbl = c('z' = 8), # x.z included 
#     			return.plot = FALSE, 
#     			effect.type = "x.me", 
#     			return.data = TRUE, s.limit = 20),
#     	# Expected error
#     	"Do not use ts.effect.plot with an interaction."
#     ) 
    
    expect_error( # x vrbl not named 
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c(0, 1), 
    			y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, 
    			effect.type = "x.me", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"x.vrbl should be a named vector with elements"
    ) 
    
    expect_error( # x vrbl values not given 
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" , "l.1.x"), 
    			y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, 
    			effect.type = "x.me", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"x.vrbl should be a named vector with elements"
    ) 
    
    expect_error( # y vrbl not named 
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
    			y.vrbl = c(1), 
    			return.plot = FALSE, 
    			effect.type = "x.me", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"y.vrbl should be a named vector with elements"
    ) 
    
    expect_error( # y vrbl values not given 
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
    			y.vrbl = c("l.1.y"), 
    			return.plot = FALSE, 
    			effect.type = "x.me", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"y.vrbl should be a named vector with elements"
    )
    
    ## Test 5
    
    expect_warning( # y vrbl values not given 
    	# Function
    	ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
    			y.vrbl = c("l.1.y" = 1), 
    			return.plot = FALSE, 
    			effect.type = "x.me", 
    			return.data = TRUE, s.limit = 20),
    	# Expected error
    	"Variable names containing . replaced with \\_"
    )
    
    
    ## Test 6
    model.no.x <- lm(y ~ l.1.y, data = toy.ts.interaction.data)
    
    expect_error( # x.vrbl missing from model
      # Function
      ts.effect.plot(model = model.no.x, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     return.plot = FALSE, 
                     effect.type = "x.me", 
                     return.data = TRUE, s.limit = 20),
      # Expected error
      "x.vrbl not present in estimated model"
    )
    
    ## Test 7
    model.no.y <- lm(l.1.y ~ l.2.y + x + 
                       l.1.x, data = toy.ts.interaction.data)
    
    expect_error( # y.vrbl missing from model
      # Function
      ts.effect.plot(model = model.no.y, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
                     y.vrbl = c("Australia" = 2), 
                     return.plot = FALSE, 
                     effect.type = "x.me", 
                     return.data = TRUE, s.limit = 20),
      # Expected error
      "y.vrbl not present in estimated model"
    )
    
    ## Test 7.5 
    expect_error( # Incorrect SE 
      # Function
      ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
                     y.vrbl = c("l.1.y" = 1), 
                     return.plot = FALSE, 
                     effect.type = "x.me", 
                     se.type = 'CH5',
                     return.data = TRUE, s.limit = 20),
      # Expected error
      "Invalid se.type. se.type must"
    )
    
    
    
}) # this ends the test_that for warnings

#### Formula Correctly Generated ####

test_that("Formulae correctly generated", {

	# run a model to use for warnings
    model.alllags <- lm(y ~ l.2.y +
                        l.1.x, data = toy.ts.interaction.data)
    
    model_test_me <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), 
                                    y.vrbl = c("l.2.y" = 2), 
                                    return.plot = TRUE, 
                                    effect.type = "x.me", return.formulae = TRUE,
                                    return.data = TRUE, s.limit = 20)
    
    model_test_cme <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), 
                                     y.vrbl = c("l.2.y" = 2), 
                                     return.plot = TRUE, 
                                     effect.type = "x.cme", return.formulae = TRUE,
                                     return.data = TRUE, s.limit = 20)
         
	expect_equal( #  x=1, y=2, s=3, ME, is correct value 
    	# Function
    	model_test_me$formulae[['s = 3']],
    	# Expected output
			"l_2_y * l_1_x"
    )  
	
	expect_equal( #  x=1, y=2, s=0, ME, is correct value 
	  # Function
	  
	  model_test_me$formulae[['s = 0']],
	  # Expected output
	  "0")    
	expect_equal( #  x=1, y=2, s=0, CME, is correct value 
	  # Function
	  
	  model_test_cme$formulae[['s = 0']],
	  # Expected output
	  "0"
	)   
	
	expect_equal( #  x=1, y=2, s=3, CME, is correct value 
	  # Function
	  model_test_cme$formulae[['s = 3']],
	  # Expected output
	  "l_1_x  +  l_1_x * l_2_y"
	)   
	
	expect_equal( #  x=1, y=2, s=LRM, CME, is correct value 
	  # Function
	  model_test_cme$formulae[['LRM']],
	  # Expected output
	  "0+l_1_x * (1/(1-(l_2_y)))"
	) 
	
	# Run ME Model
	me_model <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), 
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = TRUE, 
	                           effect.type = "x.me", return.formulae = TRUE,
	                           return.data = TRUE, s.limit = 10)
	make_expectation('ME' %in% names(me_model$estimates) &
	                 'Period' %in% names(me_model$estimates) &
	                 'SE' %in% names(me_model$estimates) & 
	                 'Lower' %in% names(me_model$estimates) & 
	                 'Upper' %in% names(me_model$estimates))  # Test ME in data output
	
	# Store ME dimensions
  dim_store_me <- dim(me_model$estimates)
	make_expectation(dim_store_me == as.vector(as.integer(cbind( # Test dimensions
	  length(me_model$estimates$Period),
	  length(me_model$estimates)))))
	
	
	# Run CME Model
	cme_model <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), 
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = TRUE, 
	                           effect.type = "x.cme", return.formulae = TRUE,
	                           return.data = TRUE, s.limit = 10)
	make_expectation('CME' %in% names(cme_model$estimates) & # Test names in df 
	                   'Period' %in% names(cme_model$estimates) &
	                   'SE' %in% names(cme_model$estimates) & 
	                   'Lower' %in% names(cme_model$estimates) & 
	                   'Upper' %in% names(cme_model$estimates))
	
	make_expectation('LRM' %in% cme_model$estimates$Period) #LRM in df
	
	# Store ME dimensions
	dim_store_cme <- dim(cme_model$estimates)
	make_expectation(dim_store_cme == as.vector(as.integer(cbind( # Test dimensions
	  length(cme_model$estimates$Period),
	  length(cme_model$estimates)))))
	
	# Task 13
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), # all yes
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = TRUE, 
	                           effect.type = "x.me", return.formulae = TRUE,
	                           return.data = TRUE, s.limit = 10)
	expect_true(all(c("plot", "estimates", "formulae") %in% names(model_test)))
	
	
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), #no formulae
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = TRUE, 
	                           effect.type = "x.me", return.formulae = FALSE,
	                           return.data = TRUE, s.limit = 10)
	expect_false("formulae" %in% names(model_test))
	
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), # no formulae & estimates
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = TRUE, 
	                           effect.type = "x.me", return.formulae = FALSE,
	                           return.data = FALSE, s.limit = 10)
	expect_false(all(c("estimates", "formulae") %in% names(model_test)))
	
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1),# no plot
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = FALSE, 
	                           effect.type = "x.me", return.formulae = TRUE,
	                           return.data = TRUE, s.limit = 10)
	expect_false(all(c("plot") %in% names(model_test)))
	
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), # no plot & estimates
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = FALSE, 
	                           effect.type = "x.me", return.formulae = TRUE,
	                           return.data = FALSE, s.limit = 10)
	expect_false(all(c("formulae") %in% names(model_test)))
	
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), # no estimates
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = TRUE, 
	                           effect.type = "x.me", return.formulae = TRUE,
	                           return.data = FALSE, s.limit = 10)
	expect_false(all(c("estimates") %in% names(model_test)))
	
	model_test <- ts.effect.plot(model = model.alllags, x.vrbl = c("l.1.x" = 1), # no plot & formulae
	                           y.vrbl = c("l.2.y" = 2), 
	                           return.plot = FALSE, 
	                           effect.type = "x.me", return.formulae = FALSE,
	                           return.data = TRUE, s.limit = 10)
	expect_false(all(c("plot", "formulae") %in% names(model_test)))
	
	model.alllags <- lm(y ~ l.1.y +
	                      x + l.1.x, data = toy.ts.interaction.data)
	
	expect_error( # No plot, estimates, formulae 
	  # Function
	  ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0 , "l.1.x" = 1), 
	                 y.vrbl = c("l.1.y" = 1), 
	                 return.plot = FALSE, 
	                 effect.type = "x.me", 
	                 return.formulae = FALSE,
	                 return.data = FALSE, s.limit = 10),
	  # Expected error
	  "Return at least one of the plot, the data"
	)
	
	p <- ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
	                    y.vrbl = c("l.1.y" = 1), 
	                    return.plot = TRUE, 
	                    effect.type = "x.me", 
	                    return.data = FALSE, s.limit = 20)
	expect_no_error(p)
	expect_doppelganger("p", p) # Test the plot
	expect_snapshot("p")
	
	q <- ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
	                    y.vrbl = c("l.1.y" = 1), 
	                    return.plot = TRUE, 
	                    effect.type = "x.cme", 
	                    return.data = FALSE, s.limit = 20)
	expect_no_error(q)
	expect_doppelganger("q", q) # Test the plot
	expect_snapshot("q")
	
})

# #### Test Plot is Correct ####
# 
# test_that("Correct Plot", {
#   p <- ts.effect.plot(model = model.alllags, x.vrbl = c("x" = 0, "l.1.x" = 1), 
#                       y.vrbl = c("l.1.y" = 1), 
#                       return.plot = TRUE, 
#                       effect.type = "x.me", 
#                       return.data = FALSE, s.limit = 20)
#   # expect_s3_class(p, "ggplot") # Check if it's a ggplot object
#   # expect_true("layers" %in% names(p)) 
#   # expect_no_error(p) 
#   expect_doppelganger('Plot is correct', p)
# })