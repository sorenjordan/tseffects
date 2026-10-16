test_that("interact.adl.plot errors and warnings are issued correctly", {  
  
  # run a model to use for warnings
	model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)
  
  expect_error( # no x.vrbl
    # Function
    interact.adl.plot(model = model.alllags, 
                   # x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "Variables in dynamic conditional effect terms \\(x and possibly y\\) must be specified through x.vrbl and possibly y.vrbl"
  )

  expect_warning( # no y.vrbl
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "No y.vrbl in"
  )

  expect_error( # no z.vrbl
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   # z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "Variables in interaction term \\(x, z, and x.z\\) must be specified through x.vrbl, z.vrbl, and x.z.vrbl"
  )

  expect_error( # no x.z.vrbl
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1)),
                   # x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "Variables in interaction term \\(x, z, and x.z\\) must be specified through x.vrbl, z.vrbl, and x.z.vrbl"
  )  

  expect_error( # x.vrbl not numeric
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x", "l_1_x"), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "x.vrbl should be a named vector with elements"
  )  

  expect_error( # x.vrbl not named
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c(0, 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "x.vrbl should be a named vector with elements"
  )  

  expect_error( # y.vrbl not numeric
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y"), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "y.vrbl should be a named vector with elements"
  )  

  expect_error( # y.vrbl not named
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c(1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "y.vrbl should be a named vector with elements"
  )  

  expect_error( # z.vrbl not numeric
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z", "l_1_z"),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "z.vrbl should be a named vector with elements"
  )  

  expect_error( # z.vrbl not named
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c(0, 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "z.vrbl should be a named vector with elements"
  )  

  expect_error( # x.z.vrbl not numeric
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z", "z_l_1_x", "x_l_1_z", "l_1_x_l_1_z")),
                       
    # Expected error
    "z.vrbl should be a named vector with elements"
  )  

  expect_error( # x.z.vrbl not named
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c(0, 1, 0, 1)),
                       
    # Expected error
    "z.vrbl should be a named vector with elements"
  )  

  expect_error( # se.type bad
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   se.type = "no"),
                       
    # Expected error
    "Invalid se.type"
  ) 

  expect_error( # x.vrbl not in model
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("no" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "x.vrbl not present in"
  )  

  expect_error( # y.vrbl not in model
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("no" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "y.vrbl not present in"
  )

  expect_error( # z.vrbl not in model
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("no" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "z.vrbl not present in"
  )

  expect_error( # x.z.vrbl not in model
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("no" = 1)),
                       
    # Expected error
    "x.z.vrbl not present in"
  )

  expect_error( # no shock.history
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   shock.history = NULL),
                   
    # Expected error
    "shock.history must be specified"
  )

  expect_error( # no shock.history
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   shock.history = "no"),
                   
    # Expected error
    "shock.history must be one of 'pulse' or 'step'"
  )

  expect_error( # plot.type missing
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = NULL,
                   return.plot = TRUE),
                   
    # Expected error
    "plot.type must be specified"
  )

  expect_error( # plot.type bad
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "no",
                   return.plot = TRUE),
                   
    # Expected error
    "plot.type must be one of 'lines' or 'heatmap'"
  )

  expect_error( # invalid lines
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "no",
                   return.plot = TRUE),
                   
    # Expected error
    "line.options must be one of 's.lines' or 'z.lines'"
  )

  expect_error( # invalid heatmap
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   heatmap.options = "no",
                   return.plot = TRUE),
                   
    # Expected error
    "heatmap.options must be one of 'all' or 'significant'"
  )
})

test_that("Warning for . issued correctly", {
  
  toy.ts.interaction.data$l.1.x <- toy.ts.interaction.data$l_1_x
  
  # run a model to use for warnings
	model.alllags <- lm(y ~ l_1_y +
		x + l.1.x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)
		  
  expect_warning( # Changing _ to . 
    # Function output
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l.1.x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   z.vals = c(0, 1),
                   s.limit = 1,
                   return.plot = TRUE),

    # Expected warning
    "Variable names containing . replaced with \\_"
  )
})

test_that("too many z.vals", {

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_error( # invalid too many z lines
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   z.vals = 1:10,
                   return.plot = TRUE)),
                   
    # Expected error
    "Do not supply more than 5 discrete values of z to plot"
  )

  expect_error( # invalid too many z vals for heatmap
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   line.options = "all",
                   z.vals = 1:10,
                   return.plot = TRUE)),
                   
    # Expected error
    "heatmap requires two z.vals"
  )
})

test_that("too many s.vals", {

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_error( # invalid too many s lines
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   s.vals = 1:10,
                   return.plot = TRUE)),
                   
    # Expected error
    "Do not supply more than 5 discrete values of s to plot"
  )
})


test_that("z.vals with s.vals", {

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_error( # invalid too many s lines
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = 1:5,
                   s.vals = 1:3,
                   return.plot = TRUE)),
                   
    # Expected warnings
    "s.lines requires two z.vals: a lower and upper"
  )
})

test_that("interact.adl.plot stops when effect.type is invalid", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)
  
  expect_error( # invalid effect.type triggers stop from GDRF.dummy.checks
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "banana",
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Invalid effect.type"
  )

})

test_that("interact.adl.plot stops when shock.size is not numeric", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  expect_error( # non-numeric shock.size triggers stop from GDRF.dummy.checks
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      shock.size = "big",
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "shock.size must be numeric"
  )

})


test_that("interact.adl.plot stops when prediction.values supplied with effect.type='discrete'", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  expect_error( # prediction.values with discrete effect triggers stop
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "discrete",
      prediction.values = list("x" = 0),
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Do not supply prediction.values when effect.type = 'discrete'"
  )

})

test_that("interact.adl.plot stops for fitted values interpretations", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  expect_error( # non-zero baseline.y with discrete effect triggers stop
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "discrete",
      baseline.y = 5,
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Do not supply baseline.y when effect.type = 'discrete'"
  )

  expect_error( # missing both baseline.y and prediction.values for fitted triggers stop
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	  x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "fitted",
      prediction.values = NULL,
      baseline.y = NULL,
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "You must provide either a baseline.y value or prediction.values"
  )
  
  expect_error( # non-list prediction.values triggers stop
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "fitted",
      prediction.values = c("x" = 0),
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "If using prediction.values, it must be a list"
  )

  expect_error( # non-numeric baseline.y triggers stop
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "fitted",
      baseline.y = "high",
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "If providing a baseline.y, it must be numeric"
  )

  expect_error( # vector baseline.y triggers stop
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      effect.type = "fitted",
      baseline.y = c(1, 2),
      return.plot = FALSE, return.data = TRUE),

    # Expected output
    "Only provide a single baseline.y value"
  )

})

test_that("z.vals created correctly", {

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_equal( # z.vals provided: z.lines
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   z.vals = 1:3,
                   s.limit = 1,                   
                   return.plot = FALSE, 
                   return.data = TRUE))$Z),

    # Expected output
    1:3
  )  

  expect_equal( # z.vals not provided: z.lines
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   return.plot = FALSE, 
                   return.data = TRUE))$Z),

    # Expected output
    c(mean(toy.ts.interaction.data$z) - sd(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z) + sd(toy.ts.interaction.data$z))
  )   

  expect_equal( # two z.vals provided: s.lines
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = c(0, 1),
                   return.plot = FALSE, 
                   return.data = TRUE))$Z),

    # Expected output
    seq(0, 1, length.out = 50)
  )  

  expect_equal( # no z.vals provided: s.lines
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   return.plot = FALSE, 
                   return.data = TRUE))$Z),

    # Expected output
    seq(mean(toy.ts.interaction.data$z) - 2*sd(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z) + 2*sd(toy.ts.interaction.data$z), length.out = 50)
  ) 

  expect_equal( # z.vals provided: heatmap
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   z.vals = c(0, 1),
					s.limit = 1, 
                   plot.type = "heatmap",
                   return.plot = FALSE, 
                   return.data = TRUE))$Z),

    # Expected output
    seq(0, 1, length.out = 50)
  )

  expect_equal( # z.vals unprovided: heatmap
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   s.limit = 1,                   
                   return.plot = FALSE, 
                   return.data = TRUE))$Z),

    # Expected output
    seq(mean(toy.ts.interaction.data$z) - 2*sd(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z) + 2*sd(toy.ts.interaction.data$z), length.out = 50)
  )
})

test_that("s.vals created correctly", {

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_equal( # s.vals not provided: s.lines
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = c(1, 3),
                   return.plot = FALSE, 
                   return.data = TRUE))$Period),

    # Expected output
    0:20
  )  

  expect_equal( # s.vals provided: s.lines
    # Function output     
    unique(suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = c(1, 3),
                   s.vals = c(0, 2),
                   return.plot = FALSE, 
                   return.data = TRUE))$Period),

    # Expected output
    0:20
  )  
})

test_that("bad colors", {

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_error( # wrong number of colors: z.lines
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   line.colors = "black",
                   z.vals = 1:5,
                   s.vals = 1:3,
                   return.plot = TRUE)),
                   
    # Expected warnings
    "Number of supplied line.colors"
  )

  expect_error( # wrong number of colors: s.lines
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   line.colors = "black",
                   z.vals = 1:2,
                   s.vals = 1:3,
                   return.plot = TRUE)),
                   
    # Expected warnings
    "Number of supplied line.colors"
  )

  expect_error( # wrong heatmap colors
    # Function
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   heatmap.colors = "black",
                   z.vals = 1:2,
                   s.vals = 1:3,
                   return.plot = TRUE)),
                   
    # Expected warnings
    "heatmap.colors must be one"
  )
})

test_that("interact.adl.plot produces LRM correctly", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  # step -> h=0 -> lrm.exists = TRUE
  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "step",
    z.vals = c(0, 1),
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  expect_true( # step produces LRM rows in the output data
    # Function output
    "LRM" %in% result$Period
  )

  # pulse + cumulative -> h incremented to 0 -> lrm.exists = TRUE
  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = TRUE,
    z.vals = c(0, 1),
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  expect_true( # cumulative pulse produces LRM rows in the output data
    # Function output
    "LRM" %in% result$Period
  )

  # pulse no cumulative -> h=-1 -> lrm.exists = FALSE (decay)
  result <- suppressWarnings(interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = FALSE,
    z.vals = c(0, 1),
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  expect_false( # pulse no-cumulative produces no LRM rows in the output data
    # Function output
    "LRM" %in% result$Period
  )

  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "step",
    z.vals = c(0, 1),
    s.limit = 5,
    return.LRM = FALSE,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  expect_false( # return.LRM=FALSE suppresses LRM even when it would exist
    # Function output
    "LRM" %in% result$Period
  )

})

test_that("interact.adl.plot with custom shock.history of length s.limit+1 runs without error", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  # custom shock history: length must equal s.limit + 1 = 6
  expect_no_error( # valid custom shock history vector runs cleanly
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = c(1, 0, 0, 0, 0, 0),
      z.vals = c(0, 1),
      s.limit = 5,
      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)
  )

})

test_that("interact.adl.plot with custom shock.history produces no LRM without cumulative", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  # custom shock history without cumulative: lrm.exists stays FALSE
  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = c(1, 0, 0, 0, 0, 0),
    cumulative = FALSE,
    z.vals = c(0, 1),
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  expect_false( # custom shock no-cumulative produces no LRM
    # Function output
    "LRM" %in% result$Period
  )

})

test_that("interact.adl.plot with custom shock.history and cumulative=TRUE warns about LRM condition", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  # custom shock + cumulative: LRM condition not guaranteed; warns
  expect_warning( # custom + cumulative warns that LRM condition not guaranteed
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = c(1, 0, 0, 0, 0, 0),
      cumulative = TRUE,
      z.vals = c(0, 1),
      s.limit = 5,
      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

    # Expected output
    "LRM condition"
  )

})

test_that("interact.adl.plot with shock.history='impulse' cumulative=FALSE warns no LRM exists", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  # pulse no cumulative: h - d.x + d.y = -1 < 0 -> decay warning
  expect_warning( # pulse without cumulative warns effects decay to 0
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      cumulative = FALSE,
      return.LRM = TRUE,
      z.vals = c(0, 1),
      s.limit = 5,
      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

    # Expected output
    "effects decay to 0"
  )

})

test_that("interact.adl.plot with s.lines and no LRM warns and substitutes last period for LRM", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  # s.lines + no LRM: default s.vals = c(0, "LRM") gets replaced with c(0, s.limit)
  expect_warning( # s.lines with no LRM warns and uses last period instead
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "impulse",
      cumulative = FALSE,
      plot.type = "lines", line.options = "s.lines",
      z.vals = c(-2, 2),
      s.limit = 5,
      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

    # Expected output
    "last period"
  )

})

test_that("interact.adl.plot with invalid shock.history string stops", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  expect_error( # invalid shock.history string triggers stop from shockr.and.cumr
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = "banana",
      z.vals = c(0, 1),
      s.limit = 5,
      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

    # Expected output
    "Invalid shock.history"
  )

})

test_that("interact.adl.plot with custom shock.history of wrong length stops", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  expect_error( # wrong-length custom shock history triggers stop from shockr.and.cumr
    # Function output
    interact.adl.plot(
      model = model.simple,
      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
      shock.history = c(1, 0, 0),
      z.vals = c(0, 1),
      s.limit = 5,
      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

    # Expected output
    "must be of length s.limit"
  )

})

test_that("interactive formulae finite dynamics", { # test an early period s = 0; s = 1 for impulse and cumulative since these are very complicated
	
  model.alllags <- lm(y ~
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_equal( # s = 0; impulse
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "impulse",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`}),

    # Expected output
    "1 * (x  +  x_z * z_val  +  z_val * x_l_1_z )"
  )   

  expect_equal( # s = 1; impulse
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "impulse",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`}),

    # Expected output
    "1 * (l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z )"
  ) 

  expect_equal( # s = 0; cumulative
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "pulse", cumulative = TRUE,
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`}),

    # Expected output
    "1 * (x  +  x_z * z_val  +  z_val * x_l_1_z )"
  )   

  expect_equal( # s = 1; cumulative
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "pulse", cumulative = TRUE,                   
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`}),

    # Expected output
    "1 * (l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z  +  x  +  z_val * x_z  +  z_val * x_l_1_z )"
  ) 

  expect_equal( # cumulative; LRM
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "pulse", cumulative = TRUE,                   
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$LRM}),

    # Expected output
    "1 * (x+x_z*z_val+x_l_1_z*z_val + l_1_x+z_l_1_x*z_val+l_1_x_l_1_z*z_val)"
  ) 
})

test_that("interactive formulae lagged y", { # test an early period s = 0; s = 1 for impulse and cumulative since these are very complicates
	
  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  expect_equal( # s = 0; impulse
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "impulse",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`}),

    # Expected output
    "1 * (x  +  x_z * z_val  +  z_val * x_l_1_z )"
  )   

  expect_equal( # s = 1; impulse
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "impulse",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`}),

    # Expected output
    "1 * (l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z  +  l_1_y * x  +  z_val * l_1_y * x_z  +  z_val * l_1_y * x_l_1_z )"
  ) 

  expect_equal( # s = 0; cumulative
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "pulse", cumulative = TRUE,                   
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`}),

    # Expected output
    "1 * (x  +  x_z * z_val  +  z_val * x_l_1_z )"
  )   

  expect_equal( # s = 1; cumulative
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "pulse", cumulative = TRUE,                   
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`}),

    # Expected output
    "1 * (l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z  +  l_1_y * x  +  z_val * l_1_y * x_z  +  z_val * l_1_y * x_l_1_z  +  x  +  z_val * x_z  +  z_val * x_l_1_z )"
  ) 

  expect_equal( # cumulative; LRM
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "pulse", cumulative = TRUE,                   
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$LRM}),

    # Expected output
    "(1 * (x+x_z*z_val+x_l_1_z*z_val + l_1_x+z_l_1_x*z_val+l_1_x_l_1_z*z_val))/(1 - (l_1_y))"
  ) 
})

test_that("interact.adl.plot discrete effect at s=0 z=1 matches hand calculation", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.s0.z1.est <- unname(the.coef.simple["x"] + the.coef.simple["x_z"])

  result <- suppressWarnings(interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = FALSE,
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  # row where Period==0 and Z==1
  row.s0 <- result[result$Period == 0 & result$Z == 1, ]

  expect_equal( # s=0 z=1 effect equals coef[x] + coef[x_z]
    # Function output
    as.numeric(row.s0$Effect),

    # Expected output
    hand.s0.z1.est,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot discrete effect at s=1 z=1 matches hand calculation", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.s1.z1.est <- unname(the.coef.simple["l_1_y"] * (the.coef.simple["x"] + the.coef.simple["x_z"]))

  result <- suppressWarnings(interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = FALSE,
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  row.s1 <- result[result$Period == 1 & result$Z == 1, ]

  expect_equal( # s=1 z=1 effect equals l_1_y * (coef[x] + coef[x_z])
    # Function output
    as.numeric(row.s1$Effect),

    # Expected output
    hand.s1.z1.est,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot discrete effect at s=0 z=0 is exactly coef[x]", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  result <- suppressWarnings(interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = FALSE,
    z.vals = 0,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  row.s0.z0 <- result[result$Period == 0 & result$Z == 0, ]

  expect_equal( # s=0 z=0 effect is purely coef[x] (interaction term drops out)
    # Function output
    as.numeric(row.s0.z0$Effect),

    # Expected output
    unname(the.coef.simple["x"]),
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot LRM at z=1 matches hand calculation for step", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.lrm.z1.est <- unname((the.coef.simple["x"] + the.coef.simple["x_z"]) / (1 - the.coef.simple["l_1_y"]))

  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "step",
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  row.lrm <- result[result$Period == "LRM" & result$Z == 1, ]

  expect_equal( # LRM z=1 effect equals (coef[x] + coef[x_z]) / (1 - coef[l_1_y])
    # Function output
    as.numeric(row.lrm$Effect),

    # Expected output
    hand.lrm.z1.est,
    tolerance = 1e-6
  )

})


test_that("custom shock history", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = c(1, 0, 1),
    z.vals = 1,
    s.limit = 2,
    return.plot = FALSE, return.data = TRUE, return.formulae = TRUE)

  # effect: x and x_z from two periods ago and from now
  expect_equal( # LRM z=1 effect equals (coef[x] + coef[x_z]) / (1 - coef[l_1_y])
    # Function output
    as.numeric(result$estimates$Effect[result$estimates$Period == "2"]),

    # Expected output
    unname(coef(model.simple)["l_1_y"]^2*coef(model.simple)["x"] + coef(model.simple)["l_1_y"]^2*coef(model.simple)["x_z"]*1 +
      coef(model.simple)["x"] + coef(model.simple)["x_z"]*1),
    tolerance = 1e-6
  )

})


test_that("custom shock history and shock size", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  result <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = c(1, 0, 1), shock.size = 2,
    z.vals = 1,
    s.limit = 2,
    return.plot = FALSE, return.data = TRUE, return.formulae = TRUE)

  # effect: x and x_z from two periods ago and from now
  expect_equal( # LRM z=1 effect equals (coef[x] + coef[x_z]) / (1 - coef[l_1_y])
    # Function output
    as.numeric(result$estimates$Effect[result$estimates$Period == "2"]),

    # Expected output
    unname(coef(model.simple)["l_1_y"]^2*coef(model.simple)["x"]*2 + coef(model.simple)["l_1_y"]^2*coef(model.simple)["x_z"]*1*2 +
      coef(model.simple)["x"]*2 + coef(model.simple)["x_z"]*1*2),
    tolerance = 1e-6
  )

})


test_that("interact.adl.plot LRM from cumulative pulse matches LRM from step at z=1", {
  
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  result.step <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "step",
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  result.cumpulse <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = TRUE,
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  lrm.step <- as.numeric(result.step[result.step$Period == "LRM" & result.step$Z == 1, "Effect"])
  lrm.cum  <- as.numeric(result.cumpulse[result.cumpulse$Period == "LRM" & result.cumpulse$Z == 1, "Effect"])

  expect_equal( # LRM from step equals LRM from cumulative pulse
    # Function output
    lrm.cum,

    # Expected output
    lrm.step,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot cumulative pulse at s=1 z=1 equals sum of s=0 and s=1 discrete effects", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.s0.z1.est <- unname(the.coef.simple["x"] + the.coef.simple["x_z"])

  hand.s1.z1.est <- unname(the.coef.simple["l_1_y"] * (the.coef.simple["x"] + the.coef.simple["x_z"]))

  hand.cumpulse.s1.z1 <- hand.s0.z1.est + hand.s1.z1.est

  result.discrete <- suppressWarnings(interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = FALSE,
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  result.cumulative <- suppressWarnings(interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = "impulse",
    cumulative = TRUE,
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  disc.s0 <- as.numeric(result.discrete[result.discrete$Period == 0 & result.discrete$Z == 1, "Effect"])
  disc.s1 <- as.numeric(result.discrete[result.discrete$Period == 1 & result.discrete$Z == 1, "Effect"])
  cum.s1  <- as.numeric(result.cumulative[result.cumulative$Period == 1 & result.cumulative$Z == 1, "Effect"])

  expect_equal( # cumulative s=1 equals discrete s=0 + discrete s=1
    # Function output
    cum.s1,

    # Expected output
    hand.cumpulse.s1.z1,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot custom shock.history c(1,0,...) at s=0 z=1 matches pulse s=0", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  custom.pulse.shocks <- c(1, 0, 0, 0, 0, 0)

  result.custom <- interact.adl.plot(
    model = model.simple,
    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
    shock.history = custom.pulse.shocks,
    z.vals = 1,
    s.limit = 5,
    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  result.pulse <- suppressWarnings(interact.adl.plot(
    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  custom.s0 <- as.numeric(result.custom[result.custom$Period == 0 & result.custom$Z == 1, "Effect"])
  pulse.s0  <- as.numeric(result.pulse[result.pulse$Period == 0 & result.pulse$Z == 1, "Effect"])

  expect_equal( # custom shock c(1,0,...) at s=0 equals pulse at s=0
    # Function output
    custom.s0,

    # Expected output
    pulse.s0,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot custom shock.history c(1,0,...) at s=1 z=1 matches pulse s=1", {
  
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  custom.pulse.shocks <- c(1, 0, 0, 0, 0, 0)


  result.custom <- interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = custom.pulse.shocks,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  result.pulse <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  custom.s1 <- as.numeric(result.custom[result.custom$Period == 1 & result.custom$Z == 1, "Effect"])
  pulse.s1  <- as.numeric(result.pulse[result.pulse$Period == 1 & result.pulse$Z == 1, "Effect"])

  expect_equal( # custom shock c(1,0,...) at s=1 equals pulse at s=1
    # Function output
    custom.s1,

    # Expected output
    pulse.s1,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot full model discrete effect at s=0 z=1 matches hand calculation", {

  model.full <- lm(y ~ l_1_y + x + l_1_x + z + l_1_z +
    x_z + z_l_1_x + x_l_1_z + l_1_x_l_1_z,
    data = toy.ts.interaction.data)

  the.coef.full <- coef(model.full)

  hand.full.s0.z1 <- unname(the.coef.full["x"] + the.coef.full["x_z"] + the.coef.full["x_l_1_z"])

  # full model: combined.x.vrbl has lag 0 and lag 1
  # combined names:
  #   lag 0: "x+x_z*z_val+x_l_1_z*z_val"   (x at lag 0, x_z at lag 0, x_l_1_z at lag 0)
  #   lag 1: "l_1_x+z_l_1_x*z_val+l_1_x_l_1_z*z_val" (l_1_x at lag 1, z_l_1_x at lag 1, l_1_x_l_1_z at lag 1)
  # pulse at s=0: just lag-0 combined term evaluated at z=1
  # = coef[x] + coef[x_z]*1 + coef[x_l_1_z]*1

  the.coef.f <- coef(model.full)
  the.vcov.f <- vcovHC(model.full, type = "const")

  hand.full.s0.z1 <- unname(the.coef.f["x"] + the.coef.f["x_z"] + the.coef.f["x_l_1_z"])

  result <- suppressWarnings(interact.adl.plot(
	    model = model.full,
	    x.vrbl    = c("x" = 0, "l_1_x" = 1),
	    z.vrbl    = c("z" = 0, "l_1_z" = 1),
	    x.z.vrbl  = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
	    y.vrbl    = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  row.s0 <- result[result$Period == 0 & result$Z == 1, ]

  expect_equal( # full model s=0 z=1: coef[x] + coef[x_z] + coef[x_l_1_z]
    # Function output
    as.numeric(row.s0$Effect),

    # Expected output
    hand.full.s0.z1,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot full model discrete effect at s=1 z=1 matches hand calculation", {

  model.full <- lm(y ~ l_1_y + x + l_1_x + z + l_1_z +
    x_z + z_l_1_x + x_l_1_z + l_1_x_l_1_z,
    data = toy.ts.interaction.data)

  the.coef.full <- coef(model.full)

  hand.full.s1.z1 <- unname(
    the.coef.full["l_1_y"] * (the.coef.full["x"] + the.coef.full["x_z"] + the.coef.full["x_l_1_z"]) +
    the.coef.full["l_1_x"] + the.coef.full["z_l_1_x"] + the.coef.full["l_1_x_l_1_z"]
  )


  # full model pulse s=1 at z=1:
  # pulse[[2]] = l_1_y * pulse[[1]]
  #            + lag-1 combined term evaluated at z=1
  # = l_1_y * (coef[x] + coef[x_z] + coef[x_l_1_z])
  #   + coef[l_1_x] + coef[z_l_1_x] + coef[l_1_x_l_1_z]

  the.coef.f <- coef(model.full)
  the.vcov.f <- vcovHC(model.full, type = "const")

  hand.full.s1.z1 <- unname(
    the.coef.f["l_1_y"] * (the.coef.f["x"] + the.coef.f["x_z"] + the.coef.f["x_l_1_z"]) +
    the.coef.f["l_1_x"] + the.coef.f["z_l_1_x"] + the.coef.f["l_1_x_l_1_z"]
  )

  result <- suppressWarnings(interact.adl.plot(
	    model = model.full,
	    x.vrbl = c("x" = 0, "l_1_x" = 1),
	    z.vrbl = c("z" = 0, "l_1_z" = 1),
	    x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
	    y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  row.s1 <- result[result$Period == 1 & result$Z == 1, ]

  expect_equal( # full model s=1 z=1 matches hand-calculated pulse formula
    # Function output
    as.numeric(row.s1$Effect),

    # Expected output
    hand.full.s1.z1,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot finite dynamics (no y.vrbl) s=0 z=1 equals coef[x] + coef[x_z]", {

  model.noy <- lm(y ~ x + z + x_z, data = toy.ts.interaction.data)

  the.coef.noy <- coef(model.noy)

  result <- suppressWarnings(interact.adl.plot(
	      model = model.noy,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = NULL,
	      shock.history = "impulse",
	      cumulative = FALSE,
	      z.vals = 1,
	      s.limit = 5,
	      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)
  )

  row.s0 <- result[result$Period == 0 & result$Z == 1, ]

  the.coef.noy <- coef(model.noy)

  expect_equal( # finite dynamics s=0 z=1 equals coef[x] + coef[x_z] with no y propagation
    # Function output
    as.numeric(row.s0$Effect),

    # Expected output
    unname(the.coef.noy["x"] + the.coef.noy["x_z"]), tolerance = 1e-6
  )

})

test_that("interact.adl.plot finite dynamics s=1 z=1 is zero (no y propagation)", {

  model.noy <- lm(y ~ x + z + x_z, data = toy.ts.interaction.data)

  result <- suppressWarnings(
	    interact.adl.plot(
	      model = model.noy,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = NULL,
	      shock.history = "impulse",
	      cumulative = FALSE,
	      z.vals = 1,
	      s.limit = 5,
	      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)
  )

  row.s1 <- result[result$Period == 1 & result$Z == 1, ]

  expect_equal( # finite dynamics s=1 z=1 is 0 since there are no lagged y terms
    # Function output
    as.numeric(row.s1$Effect),

    # Expected output
    0,
    tolerance = 1e-6
  )

})

test_that("interact.adl.plot shock.size=2 doubles the discrete effect at s=0 z=1", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

	  result.size1 <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    shock.size = 1,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  result.size2 <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    shock.size = 2,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  eff.s1 <- as.numeric(result.size1[result.size1$Period == 0 & result.size1$Z == 1, "Effect"])
	  eff.s2 <- as.numeric(result.size2[result.size2$Period == 0 & result.size2$Z == 1, "Effect"])

	  expect_equal( # shock.size=2 effect at s=0 z=1 is exactly double shock.size=1
	    # Function output
	    eff.s2,

	    # Expected output
	    2 * eff.s1,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot shock.size=2 at s=0 z=1 matches hand calculation", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.s0.z1.est <- unname(the.coef.simple["x"] + the.coef.simple["x_z"])

  hand.s0.z1.size2 <- 2 * hand.s0.z1.est


	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    shock.size = 2,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  row.s0 <- result[result$Period == 0 & result$Z == 1, ]

	  expect_equal( # shock.size=2 s=0 z=1 effect equals 2*(coef[x] + coef[x_z])
	    # Function output
	    as.numeric(row.s0$Effect),

	    # Expected output
	    hand.s0.z1.size2,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot shock.size=2 LRM at z=1 is double shock.size=1 LRM", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  result.s1 <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "step",
	    shock.size = 1,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  result.s2 <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "step",
	    shock.size = 2,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  lrm.s1 <- as.numeric(result.s1[result.s1$Period == "LRM" & result.s1$Z == 1, "Effect"])
	  lrm.s2 <- as.numeric(result.s2[result.s2$Period == "LRM" & result.s2$Z == 1, "Effect"])

	  expect_equal( # shock.size=2 LRM is double the shock.size=1 LRM at z=1
	    # Function output
	    lrm.s2,

	    # Expected output
	    2 * lrm.s1,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted with baseline.y runs and returns baseline row", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = 50,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  expect_true( # fitted with baseline.y produces a baseline row in the output
	    # Function output
	    "baseline" %in% result$Period
	  )

})

test_that("interact.adl.plot fitted baseline row value equals supplied baseline.y", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = 50,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  row.baseline <- result[result$Period == "baseline" & result$Z == 1, ]

	  expect_equal( # baseline row Effect equals the supplied baseline.y of 50
	    # Function output
	    as.numeric(row.baseline$Effect),

	    # Expected output
	    50,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted s=0 z=1 with baseline.y matches hand calculation", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.s0.z1.est <- unname(the.coef.simple["x"] + the.coef.simple["x_z"])


	  # fitted s=0 z=1 = baseline.y + shock.size * (coef[x] + coef[x_z]*1)
	  baseline.val <- 50

	  hand.fitted.s0.z1 <- baseline.val + 1 * hand.s0.z1.est

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = baseline.val,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  row.s0 <- result[result$Period == 0 & result$Z == 1, ]

	  expect_equal( # fitted s=0 z=1 = baseline.y + coef[x] + coef[x_z]
	    # Function output
	    as.numeric(row.s0$Effect),

	    # Expected output
	    hand.fitted.s0.z1,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted s=1 z=1 with baseline.y matches hand calculation", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.simple <- coef(model.simple)

  hand.s1.z1.est <- unname(the.coef.simple["l_1_y"] * (the.coef.simple["x"] + the.coef.simple["x_z"]))


	  # fitted s=1 z=1 = baseline.y + shock.size * (coef[l_1_y] * (coef[x] + coef[x_z]))
	  baseline.val <- 50

	  hand.fitted.s1.z1 <- baseline.val + 1 * hand.s1.z1.est

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = baseline.val,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  row.s1 <- result[result$Period == 1 & result$Z == 1, ]

	  expect_equal( # fitted s=1 z=1 = baseline.y + l_1_y*(coef[x] + coef[x_z])
	    # Function output
	    as.numeric(row.s1$Effect),

	    # Expected output
	    hand.fitted.s1.z1,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted with prediction.values runs and returns baseline row", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  # prediction.values sets value of x for the steady-state baseline
	  # z comes from z.val internally; do not supply z in prediction.values
	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    prediction.values = list("x" = 0, "x_z" = 0),
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  expect_true( # fitted with prediction.values produces a baseline row
	    # Function output
	    "baseline" %in% result$Period
	  )

})

test_that("interact.adl.plot fitted prediction.values baseline at z=1 matches steady-state formula", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.s <- coef(model.simple)

  hand.ss.z1 <- unname((the.coef.s["(Intercept)"] + the.coef.s["z"]) / (1 - the.coef.s["l_1_y"]))


	  # steady state at x=0, x_z=0, z=1:
	  # numerator   = (Intercept) + 0*x + 1*z + 0*x_z*1
	  # denominator = 1 - coef[l_1_y]
	  # = ((Intercept) + coef[z]) / (1 - coef[l_1_y])

	  the.coef.s <- coef(model.simple)
	  the.vcov.s <- vcovHC(model.simple, type = "const")

	  hand.ss.z1 <- unname(
	    (the.coef.s["(Intercept)"] + the.coef.s["z"]) /
	      (1 - the.coef.s["l_1_y"])
	  )

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    prediction.values = list("x" = 0, "x_z" = 0),
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  row.baseline <- result[result$Period == "baseline" & result$Z == 1, ]

	  expect_equal( # prediction.values baseline at z=1 equals ((Intercept)+coef[z])/(1-coef[l_1_y])
	    # Function output
	    as.numeric(row.baseline$Effect),

	    # Expected output
	    hand.ss.z1,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted prediction.values s=0 z=1 matches baseline plus discrete effect", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

  the.coef.s <- coef(model.simple)

  hand.ss.z1 <- unname((the.coef.s["(Intercept)"] + the.coef.s["z"]) / (1 - the.coef.s["l_1_y"]))

  hand.s0.z1.est <- unname(the.coef.s["x"] + the.coef.s["x_z"])

  hand.fitted.pv.s0.z1 <- hand.ss.z1 + 1 * hand.s0.z1.est


	  the.coef.s <- coef(model.simple)

	  hand.ss.z1 <- unname(
	    (the.coef.s["(Intercept)"] + the.coef.s["z"]) /
	      (1 - the.coef.s["l_1_y"])
	  )

	  hand.fitted.pv.s0.z1 <- hand.ss.z1 + 1 * hand.s0.z1.est

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    prediction.values = list("x" = 0, "x_z" = 0),
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  row.s0 <- result[result$Period == 0 & result$Z == 1, ]

	  expect_equal( # fitted prediction.values s=0 z=1 = steady-state + discrete s=0
	    # Function output
	    as.numeric(row.s0$Effect),

	    # Expected output
	    hand.fitted.pv.s0.z1,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted warns when mean is used for missing prediction.values variable", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  # x_z not in prediction.values -> mean of x_z series used with a warning
	  expect_warning( # missing prediction.values entry triggers mean-substitution warning
	    # Function output
	    interact.adl.plot(
	      model = model.simple,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	      shock.history = "impulse",
	      cumulative = FALSE,
	      effect.type = "fitted",
	      prediction.values = list("x" = 0),
	      z.vals = 1,
	      s.limit = 5,
	      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

	    # Expected output
	    "mean of series used"
	  )

})

test_that("interact.adl.plot fitted warns when both baseline.y and prediction.values supplied", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  # baseline.y takes precedence; prediction.values ignored; warns
	  expect_warning( # supplying both baseline.y and prediction.values warns about precedence
	    # Function output
	    interact.adl.plot(
	      model = model.simple,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	      shock.history = "impulse",
	      cumulative = FALSE,
	      effect.type = "fitted",
	      prediction.values = list("x" = 0, "x_z" = 0),
	      baseline.y = 50,
	      z.vals = 1,
	      s.limit = 5,
	      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE),

	    # Expected output
	    "baseline.y takes precedence"
	  )

})

test_that("interact.adl.plot fitted with baseline.y and prediction.values uses baseline.y value", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  # baseline.y overrides prediction.values; baseline row must equal baseline.y
	  result <- suppressWarnings(
	    interact.adl.plot(
	      model = model.simple,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	      shock.history = "impulse",
	      cumulative = FALSE,
	      effect.type = "fitted",
	      prediction.values = list("x" = 0, "x_z" = 0),
	      baseline.y = 50,
	      z.vals = 1,
	      s.limit = 5,
	      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)
	  )

	  row.baseline <- result[result$Period == "baseline" & result$Z == 1, ]

	  expect_equal( # baseline.y overrides prediction.values; baseline row = 50
	    # Function output
	    as.numeric(row.baseline$Effect),

	    # Expected output
	    50,
	    tolerance = 1e-6
	  )

})

test_that("interact.adl.plot fitted with baseline.y.se widens confidence intervals", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  result.nose <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = 50,
	    baseline.y.se = 0,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  result.withse <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = 50,
	    baseline.y.se = 5,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

	  se.nose   <- as.numeric(result.nose[result.nose$Period == 0 & result.nose$Z == 1, "SE"])
	  se.withse <- as.numeric(result.withse[result.withse$Period == 0 & result.withse$Z == 1, "SE"])

	  expect_gt( # baseline.y.se > 0 produces strictly larger SE at s=0
	    # Function output
	    se.withse,

	    # Expected output
	    se.nose
	  )

})

test_that("interact.adl.plot fitted heatmap.options='significant' overridden to 'all' with warning", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  # effect.type='fitted' + heatmap.options='significant' -> warns and switches to 'all'
	  expect_warning( # fitted values + significant heatmap warns and switches to all
	    # Function output
	    interact.adl.plot(
	      model = model.simple,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	      shock.history = "impulse",
	      cumulative = FALSE,
	      effect.type = "fitted",
	      baseline.y = 50,
	      plot.type = "heatmap",
	      heatmap.options = "significant",
	      z.vals = c(-2, 2),
	      s.limit = 5,
	      return.plot = TRUE, return.data = FALSE, return.formulae = FALSE),

	    # Expected output
	    "not applicable to fitted values"
	  )

})

test_that("interact.adl.plot fitted with prediction.values stops if z variable supplied in prediction.values", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)


	  # z.vrbl values come from z.val; supplying them in prediction.values triggers stop
	  expect_error( # supplying z.vrbl key in prediction.values triggers stop in yhat.calculator
	    # Function output
	    suppressWarnings(interact.adl.plot(
	      model = model.simple,
	      x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	      x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	      shock.history = "impulse",
	      cumulative = FALSE,
	      effect.type = "fitted",
	      prediction.values = list("x" = 0, "x_z" = 0, "z" = 1),
	      z.vals = 1,
	      s.limit = 5,
	      return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)),

	    # Expected output
	    "Do not supply value for any z.vrbl in prediction.values"
	  )

})

test_that("interact.adl.plot fitted formulae contain z_val placeholder when return.formulae=TRUE", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z,
    data = toy.ts.interaction.data)


	  result <- interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    effect.type = "fitted",
	    baseline.y = 50,
	    z.vals = 1,
	    s.limit = 5,
	    return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)

	  expect_true( # formulae contain the z_val placeholder string for the moderator
	    # Function output
	    any(grepl("z_val", result$formulae)),

	    # Expected output
	    TRUE
	  )

})

test_that("Correct dimensions of interaction output - impulse and lines", { 

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  lines.impulse.dat <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  lines.cumulative.dat <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "pulse", cumulative = TRUE,                   
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))
                   
  expect_equal( # impulse, lines
    # Function
    names(lines.impulse.dat),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper")
  ) 

  expect_equal( # impulse, lines
    # Function
    dim(lines.impulse.dat),

    # Expected output.  0:10 * 2 z.vals
    c(22, 6)
  ) 

  expect_equal( # cumulative, lines
    # Function
    names(lines.cumulative.dat),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper")
  ) 

  expect_equal( # cumulative, lines
    # Function
    dim(lines.cumulative.dat),

    # Expected output.  0:10 + LRM * 2 z.vals
    c(24, 6)
  ) 

  heatmap.impulse.dat.all <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "impulse",
                   heatmap.options = "all",                  
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  heatmap.cumulative.dat.all <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "pulse", cumulative = TRUE,                   
                   heatmap.options = "all",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  heatmap.impulse.dat.sign <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "impulse",
                   heatmap.options = "significant",                  
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  heatmap.cumulative.dat.sign <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "pulse", cumulative = TRUE,                   
                   heatmap.options = "significant",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))
                                      
  expect_equal( # impulse, heatmap, all
    # Function
    names(heatmap.impulse.dat.all),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper")
  ) 

  expect_equal( # impulse, heatmap, all
    # Function
    dim(heatmap.impulse.dat.all),

    # Expected output.  0:10 * 50 z.vals
    c((11*50), 6)
  ) 

  expect_equal( # cumulative, heatmap, all
    # Function
    names(heatmap.cumulative.dat.all),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper")
  ) 

  expect_equal( # cumulative, heatmap, all
    # Function
    dim(heatmap.cumulative.dat.all),

    # Expected output.  0:10 + LRM * 50 z.vals
    c((12*50), 6)
  ) 

  expect_equal( # impulse, heatmap, significant
    # Function
    names(heatmap.impulse.dat.sign),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper")
  ) 

  expect_equal( # impulse, heatmap, significant
    # Function
    dim(heatmap.impulse.dat.sign),

    # Expected output.  0:10 * 50 z.vals
    c((11*50), 6)
  ) 

  expect_equal( # cumulative, heatmap, significant
    # Function
    names(heatmap.cumulative.dat.sign),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper")
  ) 

  expect_equal( # cumulative, heatmap, significant
    # Function
    dim(heatmap.cumulative.dat.sign),

    # Expected output.  0:10 + LRM * 50 z.vals
    c((12*50), 6)
  ) 
})

test_that("interact.adl.plot combinations return a ggplot", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    plot.type = "lines", line.options = "z.lines",
	    z.vals = c(-1, 0, 1),
	    s.limit = 5,
	    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

	  expect_s3_class( # lines z.lines returns a ggplot object
	    # Function output
	    result,

	    # Expected output
	    "gg"
	  )

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    plot.type = "lines", line.options = "s.lines",
	    z.vals = c(-2, 2),
	    s.vals = c(0, 5),
	    s.limit = 5,
	    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

	  expect_s3_class( # lines s.lines returns a ggplot object
	    # Function output
	    result,

	    # Expected output
	    "gg"
	  )

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
	    shock.history = "impulse",
	    cumulative = FALSE,
	    plot.type = "heatmap", heatmap.options = "all",
	    z.vals = c(-2, 2),
	    s.limit = 5,
	    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

	  expect_s3_class( # heatmap all returns a ggplot object
	    # Function output
	    result,

	    # Expected output
	    "gg"
	  )

	  result <- suppressWarnings(interact.adl.plot(
	    model = model.simple,
	    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
	    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "heatmap", heatmap.options = "significant",
		    z.vals = c(-2, 2),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # heatmap significant returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "step",
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # lines z.lines with LRM (step) returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "step",
		    plot.type = "lines", line.options = "s.lines",
		    z.vals = c(-2, 2),
		    s.vals = c(0, "LRM"),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # lines s.lines with LRM (step) returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "step",
		    plot.type = "heatmap", heatmap.options = "all",
		    z.vals = c(-2, 2),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # heatmap all with LRM (step) returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "step",
		    plot.type = "heatmap", heatmap.options = "significant",
		    z.vals = c(-2, 2),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # heatmap significant with LRM (step) returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    effect.type = "fitted",
		    baseline.y = 50,
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # fitted lines z.lines returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    effect.type = "fitted",
		    baseline.y = 50,
		    plot.type = "lines", line.options = "s.lines",
		    z.vals = c(-2, 2),
		    s.vals = c(0, 5),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # fitted lines s.lines returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    effect.type = "fitted",
		    baseline.y = 50,
		    plot.type = "heatmap", heatmap.options = "all",
		    z.vals = c(-2, 2),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # fitted heatmap all returns a ggplot object
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

})

test_that("interact.adl.plot labels correct", {
  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_true( # discrete impulse no-cumulative y-label contains 'Discrete Effect'
		    # Function output
		    grepl("Discrete Effect", result$labels$y),

		    # Expected output
		    TRUE
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = TRUE,
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_true( # cumulative discrete y-label contains 'Cumulative'
		    # Function output
		    grepl("Cumulative", result$labels$y),

		    # Expected output
		    TRUE
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    effect.type = "fitted",
		    baseline.y = 50,
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_true( # fitted impulse no-cumulative y-label contains 'Fitted Values'
		    # Function output
		    grepl("Fitted Values", result$labels$y),

		    # Expected output
		    TRUE
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = TRUE,
		    effect.type = "fitted",
		    baseline.y = 50,
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_true( # fitted cumulative y-label contains 'Cumulative'
		    # Function output
		    grepl("Cumulative", result$labels$y),

		    # Expected output
		    TRUE
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "lines", line.options = "s.lines",
		    z.vrbl.label = "My Moderator",
		    z.vals = c(-2, 2),
		    s.vals = c(0, 5),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_true( # s.lines x-axis label contains custom z.vrbl.label
		    # Function output
		    grepl("My Moderator", result$labels$x),

		    # Expected output
		    TRUE
		  )

		  # z.vals has 3 values; okabe-ito should assign 3 distinct colors
		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "lines", line.options = "z.lines",
		    line.colors = "okabe-ito",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # okabe-ito colors produce a valid ggplot without error
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "lines", line.options = "z.lines",
		    line.colors = "bw",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # bw line colors produce a valid ggplot without error
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "lines", line.options = "z.lines",
		    line.colors = c("red", "blue", "green"),
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # correct-length user colors produce a valid ggplot without error
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "heatmap", heatmap.options = "all",
		    heatmap.colors = "Greens",
		    z.vals = c(-2, 2),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # alternate hcl.pals() palette produces a valid ggplot without error
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    plot.type = "heatmap", heatmap.options = "all",
		    heatmap.colors = "Grays",
		    z.vals = c(-2, 2),
		    s.limit = 5,
		    return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

		  expect_s3_class( # Grays palette for grayscale heatmap produces a valid ggplot
		    # Function output
		    result,

		    # Expected output
		    "gg"
		  )

})





test_that("interact.adl.plot fitted period column includes 'baseline' label", {

  model.simple <- lm(y ~ l_1_y + x + z + x_z, data = toy.ts.interaction.data)

		  result <- suppressWarnings(interact.adl.plot(
		    model = model.simple,
		    x.vrbl = c("x" = 0), z.vrbl = c("z" = 0),
		    x.z.vrbl = c("x_z" = 0), y.vrbl = c("l_1_y" = 1),
		    shock.history = "impulse",
		    cumulative = FALSE,
		    effect.type = "fitted",
		    baseline.y = 50,
		    plot.type = "lines", line.options = "z.lines",
		    z.vals = c(-1, 0, 1),
		    s.limit = 5,
		    return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

		  expect_true( # fitted output data Period column contains 'baseline' label
		    # Function output
		    "baseline" %in% result$Period,

		    # Expected output
		    TRUE
		  )

})

test_that("Function returns objects correctly (including errors)", { 

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)
		
  expect_error( # No plot, estimates, formulae 
    # Function output
    suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = FALSE, return.formulae = FALSE)),
                   
    # Expected error
    "Return at least one of the plot, the data"
  )
  
  model_test_allthree <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = TRUE, return.formulae = TRUE))

  expect_true( # are all three objects returned?
    # Function output
    all(c("plot", "estimates", "formulae") %in% names(model_test_allthree))
  )

  model_test_justplot <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = FALSE))

  expect_false( # is formulae or estimates returned?
    # Function output
    all(c("estimates", "formulae") %in% names(model_test_justplot))
  )

  model_test_noplot <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = TRUE))

  expect_false( # is plot returned?
    # Function output
    all(c("plot") %in% names(model_test_noplot))
  )

  model_test_noformulae <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = TRUE, return.formulae = FALSE))

  expect_false( # is formulae returned?
    all(c("formulae") %in% names(model_test_noformulae))
  )

  model_test_nodata <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = TRUE))

  expect_false( # is data returned?
    all(c("estimates") %in% names(model_test_nodata))
  )

  model_test_justdata <- suppressWarnings(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE))

  expect_false( # is data returned?
    all(c("plot", "formulae") %in% names(model_test_justdata))
  )
})

























# test_that("Correct Plot: adl.interact.plot", {
  # local_edition(3)

  # model.alllags <- lm(y ~ l_1_y +
		# x + l_1_x +
		# z + l_1_z  +
		# x_z + z_l_1_x + x_l_1_z +
		# l_1_x_l_1_z, data = toy.ts.interaction.data)

  # p <- interact.adl.plot(model = model.alllags, 
                   # x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   # z.vrbl = c("z" = 0, "l_1_z" = 1),
                   # x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   # plot.type = "lines",
                   # line.options = "z.lines",
                   # shock.history = "impulse",
                   # z.vals = c(0, 1),
                   # s.limit = 10,
                   # return.plot = TRUE, return.data = FALSE, return.formulae = FALSE)                        
                        
  # expect_no_error(p) # Check for errors during plot generation
  # # expect_doppelganger("adlinteractpulsezlines", p) # Test the plot
  # # expect_snapshot("adlinteractpulsezlines")
  
  # q <-  interact.adl.plot(model = model.alllags, 
                   # x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   # z.vrbl = c("z" = 0, "l_1_z" = 1),
                   # x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   # plot.type = "heatmap",
                   # heatmap.options = "all",
                   # shock.history = "impulse",
                   # z.vals = c(0, 1),
                   # s.limit = 10,
                   # return.plot = TRUE, return.data = FALSE, return.formulae = FALSE) 
                   
  # expect_no_error(q)
  # # expect_doppelganger("adlinteractpulseheatmap", q) # Test the plot
  # # expect_snapshot("adlinteractpulseheatmap")
    
  # n <-  interact.adl.plot(model = model.alllags, 
                   # x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   # z.vrbl = c("z" = 0, "l_1_z" = 1),
                   # x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   # plot.type = "lines",
                   # line.options = "s.lines",
                   # shock.history = "step",
                   # z.vals = c(0, 1),
                   # s.limit = 10,
                   # return.plot = TRUE, return.data = FALSE, return.formulae = FALSE) 
                   
  # expect_no_error(n) # Check for errors during plot generation
  # # expect_doppelganger("adlinteractstepslines", n) # Test the plot
  # # expect_snapshot("adlinteractstepslines")
# })
