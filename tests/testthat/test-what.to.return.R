test_that("what.to.return returns correct combinations of elements", {

  # make some objects. the function doesn't check what the elements are, just their existence.
  plot.out <- list("plot" = 1)
  dat.out <- list("estimates" = 1)
  the.final.formulae <- list("formulae" = 1, "binomials" = 2)

  expect_equal( # return.plot TRUE | return.formulae TRUE | return.data TRUE
    # Function output
    what.to.return(return.plot = TRUE, return.formulae = TRUE, return.data = TRUE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    list("plot" = plot.out, "estimates" = dat.out, "formulae" = the.final.formulae$formulae, "binomials" = the.final.formulae$binomials)
  )

  expect_equal( # return.plot TRUE | return.formulae FALSE | return.data TRUE
    # Function output
    what.to.return(return.plot = TRUE, return.formulae = FALSE, return.data = TRUE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    list("plot" = plot.out, "estimates" = dat.out)
  )

  expect_equal( # return.plot TRUE | return.formulae TRUE | return.data FALSE
    # Function output
    what.to.return(return.plot = TRUE, return.formulae = TRUE, return.data = FALSE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    list("plot" = plot.out, "formulae" = the.final.formulae$formulae, "binomials" = the.final.formulae$binomials)
  )

  expect_equal( # return.plot TRUE | return.formulae FALSE | return.data FALSE
    # Function output
    what.to.return(return.plot = TRUE, return.formulae = FALSE, return.data = FALSE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    plot.out
  )

  expect_equal( # return.plot FALSE | return.formulae TRUE | return.data TRUE
    # Function output
    what.to.return(return.plot = FALSE, return.formulae = TRUE, return.data = TRUE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    list("estimates" = dat.out, "formulae" = the.final.formulae$formulae, "binomials" = the.final.formulae$binomials)
  )

  expect_equal( # return.plot FALSE | return.formulae FALSE | return.data TRUE
    # Function output
    what.to.return(return.plot = FALSE, return.formulae = FALSE, return.data = TRUE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
	dat.out
  )

  expect_equal( # return.plot FALSE | return.formulae TRUE | return.data FALSE
    # Function output
    what.to.return(return.plot = FALSE, return.formulae = TRUE, return.data = FALSE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    the.final.formulae
  )

  expect_error( # return.plot FALSE | return.formulae FALSE | return.data FALSE
    # Function output
    what.to.return(return.plot = FALSE, return.formulae = FALSE, return.data = FALSE,
      				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae),

    # Expected output
    "Return at least one of the plot, the data, or the formulae"
  )

})




    



