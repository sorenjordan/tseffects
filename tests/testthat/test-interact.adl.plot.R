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
    "Variables in interaction term \\(x, z, and x.z\\) must be specified through x.vrbl, z.vrbl, and x.z.vrbl"
  )

  expect_warning( # no y.vrbl
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1)),
                       
    # Expected error
    "No y.vrbl implies a static or finite model: are you sure you want this"
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
    "shock.history must be one of impulse or cumulative"
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
    "plot.type must be one of lines or heatmap"
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
    "line.options must be one of s.lines or z.lines"
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
    "heatmap.options must be one of all or significant"
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
                   plot.type = "heatmap",
                   heatmap.options = "all",
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
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   z.vals = 1:10,
                   return.plot = TRUE),
                   
    # Expected error
    "Do not supply more than 5 discrete values of z to plot"
  )

  expect_error( # invalid too many z vals for heatmap
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   line.options = "all",
                   z.vals = 1:10,
                   return.plot = TRUE),
                   
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
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   s.vals = 1:10,
                   return.plot = TRUE),
                   
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
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = 1:5,
                   s.vals = 1:3,
                   return.plot = TRUE),
                   
    # Expected warnings
    "s.lines requires two z.vals: a lower and upper"
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
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   z.vals = 1:3,
                   return.plot = FALSE, 
                   return.data = TRUE)$Z),

    # Expected output
    1:3
  )  

  expect_equal( # z.vals not provided: z.lines
    # Function output     
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   return.plot = FALSE, 
                   return.data = TRUE)$Z),

    # Expected output
    c(mean(toy.ts.interaction.data$z) - sd(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z) + sd(toy.ts.interaction.data$z))
  )   

  expect_equal( # two z.vals provided: s.lines
    # Function output     
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = c(0, 1),
                   return.plot = FALSE, 
                   return.data = TRUE)$Z),

    # Expected output
    seq(0, 1, length.out = 50)
  )  

  expect_equal( # no z.vals provided: s.lines
    # Function output     
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   return.plot = FALSE, 
                   return.data = TRUE)$Z),

    # Expected output
    seq(mean(toy.ts.interaction.data$z) - 2*sd(toy.ts.interaction.data$z), mean(toy.ts.interaction.data$z) + 2*sd(toy.ts.interaction.data$z), length.out = 50)
  ) 

  expect_equal( # z.vals provided: heatmap
    # Function output     
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   z.vals = c(0, 1),
                   plot.type = "heatmap",
                   return.plot = FALSE, 
                   return.data = TRUE)$Z),

    # Expected output
    seq(0, 1, length.out = 50)
  )

  expect_equal( # z.vals unprovided: heatmap
    # Function output     
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   return.plot = FALSE, 
                   return.data = TRUE)$Z),

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
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = c(1, 3),
                   return.plot = FALSE, 
                   return.data = TRUE)$Period),

    # Expected output
    0:20
  )  

  expect_equal( # s.vals provided: s.lines
    # Function output     
    unique(interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   z.vals = c(1, 3),
                   s.vals = c(0, 2),
                   return.plot = FALSE, 
                   return.data = TRUE)$Period),

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
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   line.colors = "black",
                   z.vals = 1:5,
                   s.vals = 1:3,
                   return.plot = TRUE),
                   
    # Expected warnings
    "Number of supplied line.colors"
  )

  expect_error( # wrong number of colors: s.lines
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   line.colors = "black",
                   z.vals = 1:2,
                   s.vals = 1:3,
                   return.plot = TRUE),
                   
    # Expected warnings
    "Number of supplied line.colors"
  )

  expect_error( # wrong heatmap colors
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   heatmap.colors = "black",
                   z.vals = 1:2,
                   s.vals = 1:3,
                   return.plot = TRUE),
                   
    # Expected warnings
    "heatmap.colors must be one"
  )
})


test_that("interactive formulae finite dynamics", { # test an early period s = 0; s = 1 for impulse and cumulative since these are very complicates
	
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
    "x  +  x_z * z_val  +  z_val * x_l_1_z "
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
    "l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z "
  ) 

  expect_equal( # s = 0; cumulative
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "cumulative",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`}),

    # Expected output
    "x  +  x_z * z_val  +  z_val * x_l_1_z "
  )   

  expect_equal( # s = 1; cumulative
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "cumulative",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`}),

    # Expected output
    "l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z  +  x  +  z_val * x_z  +  z_val * x_l_1_z "
  ) 

  expect_equal( # cumulative; LRM
    # Function
    suppressWarnings({interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   # y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "cumulative",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$LRM}),

    # Expected output
    "(x+x_z*z_val+x_l_1_z*z_val+l_1_x+z_l_1_x*z_val+l_1_x_l_1_z*z_val)"
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
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "impulse",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`,

    # Expected output
    "x  +  x_z * z_val  +  z_val * x_l_1_z "
  )   

  expect_equal( # s = 1; impulse
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "impulse",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`,

    # Expected output
    "l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z  +  l_1_y * x  +  z_val * l_1_y * x_z  +  z_val * l_1_y * x_l_1_z "
  ) 

  expect_equal( # s = 0; cumulative
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "cumulative",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 0`,

    # Expected output
    "x  +  x_z * z_val  +  z_val * x_l_1_z "
  )   

  expect_equal( # s = 1; cumulative
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "cumulative",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$`s = 1`,

    # Expected output
    "l_1_x  +  z_l_1_x * z_val  +  z_val * l_1_x_l_1_z  +  l_1_y * x  +  z_val * l_1_y * x_z  +  z_val * l_1_y * x_l_1_z  +  x  +  z_val * x_z  +  z_val * x_l_1_z "
  ) 

  expect_equal( # cumulative; LRM
    # Function
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   shock.history = "cumulative",
                   s.limit = 1,
                   return.plot = FALSE, return.data = FALSE, return.formulae = TRUE)$formulae$LRM,

    # Expected output
    "(x+x_z*z_val+x_l_1_z*z_val+l_1_x+z_l_1_x*z_val+l_1_x_l_1_z*z_val)/(1-(l_1_y))"
  ) 
})

test_that("Correct dimensions of interaction output - impulse and lines", { 

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  lines.impulse.dat <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  lines.cumulative.dat <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "cumulative",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)
                   
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

  heatmap.impulse.dat.all <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "impulse",
                   heatmap.options = "all",                  
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  heatmap.cumulative.dat.all <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "cumulative",
                   heatmap.options = "all",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  heatmap.impulse.dat.sign <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "impulse",
                   heatmap.options = "significant",                  
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  heatmap.cumulative.dat.sign <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   shock.history = "cumulative",
                   heatmap.options = "significant",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)
                                      
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
    c("Period", "Z", "Effect", "SE", "Lower", "Upper", "insig", "Effect.sig")
  ) 

  expect_equal( # impulse, heatmap, significant
    # Function
    dim(heatmap.impulse.dat.sign),

    # Expected output.  0:10 * 50 z.vals
    c((11*50), 8)
  ) 

  expect_equal( # cumulative, heatmap, significant
    # Function
    names(heatmap.cumulative.dat.sign),

    # Expected output
    c("Period", "Z", "Effect", "SE", "Lower", "Upper", "insig", "Effect.sig")
  ) 

  expect_equal( # cumulative, heatmap, significant
    # Function
    dim(heatmap.cumulative.dat.sign),

    # Expected output.  0:10 + LRM * 50 z.vals
    c((12*50), 8)
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
    interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = FALSE, return.formulae = FALSE),
                   
    # Expected error
    "Return at least one of the plot, the data"
  )
  
  model_test_allthree <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = TRUE, return.formulae = TRUE)

  expect_true( # are all three objects returned?
    # Function output
    all(c("plot", "estimates", "formulae") %in% names(model_test_allthree))
  )

  model_test_justplot <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = FALSE)

  expect_false( # is formulae or estimates returned?
    # Function output
    all(c("estimates", "formulae") %in% names(model_test_justplot))
  )

  model_test_noplot <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = TRUE)

  expect_false( # is plot returned?
    # Function output
    all(c("plot") %in% names(model_test_noplot))
  )

  model_test_noformulae <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = TRUE, return.formulae = FALSE)

  expect_false( # is formulae returned?
    all(c("formulae") %in% names(model_test_noformulae))
  )

  model_test_nodata <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = TRUE)

  expect_false( # is data returned?
    all(c("estimates") %in% names(model_test_nodata))
  )

  model_test_justdata <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = FALSE, return.data = TRUE, return.formulae = FALSE)

  expect_false( # is data returned?
    all(c("plot", "formulae") %in% names(model_test_justdata))
  )
})

test_that("Correct Plot: adl.interact.plot", {
  local_edition(3)

  model.alllags <- lm(y ~ l_1_y +
		x + l_1_x +
		z + l_1_z  +
		x_z + z_l_1_x + x_l_1_z +
		l_1_x_l_1_z, data = toy.ts.interaction.data)

  p <- interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "z.lines",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = FALSE)                        
                        
  expect_no_error(p) # Check for errors during plot generation
  # expect_doppelganger("adlinteractpulsezlines", p) # Test the plot
  # expect_snapshot("adlinteractpulsezlines")
  
  q <-  interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "heatmap",
                   heatmap.options = "all",
                   shock.history = "impulse",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = FALSE) 
                   
  expect_no_error(q)
  # expect_doppelganger("adlinteractpulseheatmap", q) # Test the plot
  # expect_snapshot("adlinteractpulseheatmap")
    
  n <-  interact.adl.plot(model = model.alllags, 
                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
                   y.vrbl = c("l_1_y" = 1), 
                   z.vrbl = c("z" = 0, "l_1_z" = 1),
                   x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, "x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
                   plot.type = "lines",
                   line.options = "s.lines",
                   shock.history = "step",
                   z.vals = c(0, 1),
                   s.limit = 10,
                   return.plot = TRUE, return.data = FALSE, return.formulae = FALSE) 
                   
  expect_no_error(n) # Check for errors during plot generation
  # expect_doppelganger("adlinteractstepslines", n) # Test the plot
  # expect_snapshot("adlinteractstepslines")
})
