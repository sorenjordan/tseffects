# version 0.2.1.9001
# 2/2/2026
# Authors: Soren Jordan, Garrett N. Vande Kamp, Reshi Rajan

# TO DO (next version):
#   More robust README.md
#   Somehow test whether someone is using ts.effect.plot when they are also specifying an interaction
#   Allow for varying levels of Z?
#   Make sure that all of the formulae in the interaction SM are covered
#   Does dyn/dynsim/dynamac/ardl + work with tseffects?
#   Add a visual indicator for some kind of threshold effects? Or median lag?
#   Add a R Journal citation or something to the bottom of the README once we get something
#   Continuously update references in the vignette
#   Add a citation("") method
#	Moving averages

# CHANGES (since last CRAN):
#

# Datasets exported: 
#' Data on US Presidential Approval
#'
#' A dataset from: Cavari, Amnon. 2019. "Evaluating the President on Your Priorities: Issue Priorities, Policy Performance, and Presidential Approval, 1981–2016." Presidential Studies Quarterly 49(4): 798-826.
#'
#' @format A data frame with 140 rows and 14 variables:
#' \describe{
#'	 \item{APPROVE}{Presidential approval}
#'	 \item{APPROVE_ECONOMY}{Presidential approval: economy}
#'	 \item{APPROVE_FOREIGN}{Presidential approval: foreign affairs}
#'	 \item{MIP_MACROECONOMICS}{Salience (Most Important Problem): economy}
#'	 \item{MIP_FOREIGN}{Salience (Most Important Problem): foreign affairs}
#'	 \item{PARTY_IN}{Macropartisanship (in-party)}
#'	 \item{PARTY_OUT}{Macropartisanship (out-party)}
#'	 \item{PRESIDENT}{Numeric indicator for president}
#'	 \item{DIVIDEDGOV}{Dummy variable for divided government}
#'	 \item{ELECTION}{Dummy variable for election years}
#'	 \item{HONEYMOON}{Dummy variable for honeymoon period}
#'	 \item{UMCSENT}{Consumer sentiment}
#'	 \item{UNRATE}{Unemployment rate}
#'	 \item{APPROVE_L1}{Lagged presidential approval}
#' }
#' @source \doi{10.1111/psq.12594}
#' @docType data
#' @keywords datasets
#' @usage data(approval)
#' @name approval
NULL

# Datasets exported: 
#' Simulated interactive time series data
#'
#' A simulated, well-behaved dataset of interactive time series data
#'
#' @format A data frame with 50 rows and 23 variables:
#' \describe{
#'	 \item{time}{Indicator for time period}
#'	 \item{x}{Contemporaneous x}
#'	 \item{l_1_x}{First lag of x}
#'	 \item{l_2_x}{Second lag of x}
#'	 \item{l_3_x}{Third lag of x}
#'	 \item{l_4_x}{Fourth lag of x}
#'	 \item{l_5_x}{Fifth lag of x}
#'	 \item{d_x}{First difference of x}
#'	 \item{l_1_d_x}{First lag of first difference of x}
#'	 \item{l_2_d_x}{Second lag of first difference of x}
#'	 \item{l_3_d_x}{Third lag of first difference of x}
#'	 \item{z}{Contemporaneous z}
#'	 \item{l_1_z}{First lag of z}
#'	 \item{l_2_z}{Second lag of z}
#'	 \item{l_3_z}{Third lag of z}
#'	 \item{l_4_z}{Fourth lag of z}
#'	 \item{l_5_z}{Fifth lag of z}
#'	 \item{y}{Contemporaneous y}
#'	 \item{l_1_y}{First lag of y}
#'	 \item{l_2_y}{Second lag of y}
#'	 \item{l_3_y}{Third lag of y}
#'	 \item{l_4_y}{Fourth lag of y}
#'	 \item{l_5_y}{Fifth lag of y}
#'	 \item{d_y}{First difference of y}
#'	 \item{l_1_d_y}{First lag of first difference of y}
#'	 \item{l_2_d_y}{Second lag of first difference of y}
#'	 \item{d_2_y}{Second difference of y}
#'	 \item{l_1_d_2_y}{First lag of second difference of y}
#'	 \item{x_z}{Interaction of contemporaneous x and z}
#'	 \item{x_l_1_z}{Interaction of contemporaneous x and lagged z}
#'	 \item{z_l_1_x}{Interaction of lagged x and contemporaneous z}
#'	 \item{l_1_x_l_1_z}{Interaction of lagged x and lagged z}
#' }
#' @docType data
#' @keywords datasets
#' @usage data(toy.ts.interaction.data)
#' @name toy.ts.interaction.data
NULL




## Functions:
## Dependencies: 	
#		mpoly (for formula construction)
#		car (for deltaMethod)
#		ggplot2 (for plots)
#		sandwich (for vcovHC)
#		stats (for lm coef vcov)
#		utils (for capture.output)

### Functions
## Not exported
# (0.1) adl.dummy.checks
# (0.2) gecm.dummy.checks
# (0.3) what.to.return
## Exported
# (1) pulse.calculator
# (2) general.calculator
# (3) gecm.to.adl
# (4) GDTE.adl.plot
# (5) GDRF.adl.plot
# (6) GDTE.gecm.plot
# (7) GDRF.gecm.plot
# (8) interact.adl.plot



#####################################################
# ------------- FUNCTIONS NOT EXPORTED -------------#
#####################################################

##########################################
# ------ (0.1) adl.dummy.checks -------- #
##########################################
#' Do consistent dummy checks for functions (GDTE/GDRF) that use an ADL model
#' @param x.vrbl a named vector of the x variables and corresponding lag orders in an ADL model
#' @param y.vrbl a named vector of the y variables and corresponding lag orders in an ADL model
#' @param d.x the order of differencing of the x variable in the ADL model
#' @param d.y the order of differencing of the y variable in the ADL model
#' @param inferences.x is the independent variable treated in levels or in differences?
#' @param inferences.y are the inferences for the dependent variable expected in levels or in differences?
#' @param the.coef the coefficient vector from the estimated ADL model
#' @param se.type the type of standard error calculated
#' @param type whether the effects are estimated in the context of a GDTE/GDRF
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

adl.dummy.checks <- function(x.vrbl, y.vrbl, d.x, d.y, inferences.x, inferences.y, the.coef, se.type, type = NULL) {
	effect.message <- ifelse(type == "GDTE", "treatment effect", 
						ifelse(type == "GDRF", "shock history", "broken"))

	counter.x.message <- ifelse(type == "GDTE", "counterfactual treatment", 
						ifelse(type == "GDRF", "shock history", "broken"))
	
	counter.y.message <- ifelse(type == "GDTE", "counterfactual response", 
						ifelse(type == "GDRF", "response function", "broken"))
	
	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl)) {
		stop("Variables in ", effect.message, " terms (x and possibly y) must be specified through x.vrbl and possibly y.vrbl")
	}

	if(is.null(y.vrbl)) {
		warning("No y.vrbl in ", effect.message, " terms implies a static or finite dynamics model: are you sure you want this?")
	}

	# Dummy checks. Is d supplied for all variables specified?	
	if(is.null(d.x) | is.null(d.y)) {
		stop(paste0("Order of differencing of variables in ", effect.message, " terms must be specified through d.x and d.y"))
	}	

	# orders of integration must be integers
	if((d.x%%1 != 0) | (d.y%%1 != 0)) {
		stop(paste0("Order of differencing of variables in ", effect.message, " terms (d.x and d.y) must be an integer"))
	}

	# Dummy checks: are x/y inferences specified?
	if(!(inferences.x %in% c("levels", "differences"))) {
		stop(paste0("Invalid inferences.x. The ", counter.x.message, " for x must be either in levels or differences"))
	}

	if(!(inferences.y %in% c("levels", "differences"))) {
		stop(paste0("Invalid inferences.y. The ", counter.y.message, " for y must be either in levels or differences"))
	}
	
	# Dummy checks: did they ask for inferences that don't make sense?
	if(inferences.x == "differences" & d.x == 0) {
		stop(paste0("Invalid inferences.x. The ", counter.x.message, " for x cannot be in a higher order of differencing (d.x) than the original independent variable"))
	}

	if(inferences.y == "differences" & d.y == 0) {
		stop(paste0("Invalid inferences.y. The ", counter.y.message, " for y cannot be in a higher order of differencing (d.y) than the original dependent variable"))
	}
	
	# test whether x.vrbl is named vectors with numeric lag order elements
	if(!(is.numeric(x.vrbl)) | is.null(names(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model.")
	}
	
	# test whether y.vrbl is named vectors with numeric lag order elements
	if(!is.null(y.vrbl)) {
		if(!(is.numeric(y.vrbl)) | is.null(names(y.vrbl))) {
			stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
		}
	}
	
	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}	
	
	# are the variables in the model?
	if(!(all(names(x.vrbl) %in% names(the.coef)))) {
		stop("x.vrbl not present in estimated model")
	}
	
	if(!is.null(y.vrbl)) {
		if(!(all(names(y.vrbl) %in% names(the.coef)))) {
			stop("y.vrbl not present in estimated model")
		}
	}
}

##########################################
# ------ (0.2) gecm.dummy.checks ------- #
##########################################
#' Do consistent dummy checks for functions (GDTE/GDRF) that use a GECM model
#' @param x.vrbl a named vector of the x variables and corresponding lag orders of lower order of integration (typically levels, 0) in a GECM model
#' @param y.vrbl a named vector of the y variables and corresponding lag orders of lower order of integration (typically levels, 0) in a GECM model
#' @param x.d.vrbl a named vector of the x variables and corresponding lag orders of higher order of integration (typically first differences, 1) in a GECM model
#' @param y.d.vrbl a named vector of the y variables and corresponding lag orders of higher order of integration (typically first differences, 1) in a GECM model
#' @param x.vrbl.d.x the order of differencing of the x variable of lower order of integration (typically levels, 0) in a GECM model
#' @param y.vrbl.d.y the order of differencing of the y variable of lower order of integration (typically levels, 0) in a GECM model
#' @param x.d.vrbl.d.x the order of differencing of the x variable of higher order of integration (typically first differences, 1) in a GECM model
#' @param y.d.vrbl.d.y the order of differencing of the y variable of higher order of integration (typically first differences, 1) in a GECM model
#' @param inferences.x is the independent variable treated in levels or in differences?
#' @param inferences.y are the inferences for the dependent variable expected in levels or in differences?
#' @param the.coef the coefficient vector from the estimated GECM model
#' @param se.type the type of standard error calculated
#' @param type whether the effects are estimated in the context of a GDTE/GDRF
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

gecm.dummy.checks <- function(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl, 
							x.vrbl.d.x, y.vrbl.d.y, x.d.vrbl.d.x, y.d.vrbl.d.y, 
							inferences.x, inferences.y, the.coef, se.type, type = NULL) {

	effect.message <- ifelse(type == "GDTE", "treatment effect", 
						ifelse(type == "GDRF", "shock history", "broken"))

	counter.x.message <- ifelse(type == "GDTE", "counterfactual treatment", 
						ifelse(type == "GDRF", "shock history", "broken"))
	
	counter.y.message <- ifelse(type == "GDTE", "counterfactual response", 
						ifelse(type == "GDRF", "response function", "broken"))

	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(y.vrbl) | is.null(x.d.vrbl) | is.null(y.d.vrbl)) {
		stop("Variables in ", effect.message, " terms (x and y) and lagged differences must be specified through x.vrbl, y.vrbl, x.d.vrbl, and y.d.vrbl for a GECM")
	}
	
	# Dummy checks. if the order of differencing for x.vrbl/y.vrbl specified?
	if(is.null(x.vrbl.d.x) | is.null(y.vrbl.d.y)) {
		stop("Order of differencing of variables in ", effect.message, " terms must be specified through x.vrbl.d.x and y.vrbl.d.y")
	}
	
	# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified?
	if(is.null(x.d.vrbl.d.x) | is.null(y.d.vrbl.d.y)) {
		stop("Order of differencing of variables in lagged differences in ", effect.message, " must be specified through x.d.vrbl.d.x and y.d.vrbl.d.y")
	}	
	
	# Is the order of differencing an integer? (d(0) term)
	if((x.vrbl.d.x%%1 != 0) | (y.vrbl.d.y%%1 != 0)) {
		stop("Order of differencing of variables in ", effect.message, " term (x.vrbl.d.x and y.vrbl.d.y) must be an integer")
	}		
	
	# Is the order of differencing an integer? (d(1) term)
	if((x.d.vrbl.d.x%%1 != 0) | (y.d.vrbl.d.y%%1 != 0)) {
		stop("Order of differencing of variables in lagged differences in ", effect.message, " term (x.d.vrbl.d.x and y.d.vrbl.d.y) must be an integer")
	}	
	
	# test whether x.vrbl is named vector with numeric lag order elements
	if(!(is.numeric(x.vrbl)) | is.null(names(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model")
	}	
	
	# test whether y.vrbl is named vector with numeric lag order elements
	if(!(is.numeric(y.vrbl)) | is.null(names(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model")
	}
	
	# test whether x.d.vrbl is named vector with numeric lag order elements
	if(!(is.numeric(x.d.vrbl)) | is.null(names(x.d.vrbl))) {
		stop("x.d.vrbl should be a named vector with elements equal to lag orders of differences of x and names equal to differenced x variable names in model")
	}
	
	# test whether y.d.vrbl is named vector with numeric lag order elements
	if(!(is.numeric(y.d.vrbl)) | is.null(names(y.d.vrbl))) {
		stop("y.d.vrbl should be a named vector with elements equal to lag orders of differences of y and names equal to differenced y variable names in model")
	}

	# Are they appropriately away from each other?
	if((x.d.vrbl.d.x - x.vrbl.d.x) != 1 | (y.d.vrbl.d.y - y.vrbl.d.y) != 1) {
		stop("In a GECM, the variable in differences should be one order of differencing from the variable in levels. Check the order of differencing of x and y")
	}

	# Did they include multiple lags?
	if(length(x.vrbl) != 1 | length(y.vrbl) != 1) {
		stop("In a GECM, include only the first lag of the variable in levels (x.vrbl and y.vrbl)")
	}

	# Did they include something other than the first lag?
	if(x.vrbl[1] != 1 | y.vrbl[1] != 1) {
		stop("In a GECM, include only the first lag of the variable in levels (x.vrbl and y.vrbl)")
	}

	if(inferences.x != "levels" | inferences.y != "levels") {
		stop("In a GECM, inferences regarding the ", counter.x.message, " of x on y are automatically recovered in levels")
	}

	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}

	# are the variables in the model?
	if(!(all(names(x.vrbl) %in% names(the.coef)))) {
		stop("x.vrbl not present in estimated model")
	}
	
	if(!(all(names(y.vrbl) %in% names(the.coef)))) {
		stop("y.vrbl not present in estimated model")
	}

	if(!(all(names(x.d.vrbl) %in% names(the.coef)))) {
		stop("x.d.vrbl not present in estimated model")
	}
	
	if(!(all(names(y.d.vrbl) %in% names(the.coef)))) {
		stop("y.d.vrbl not present in estimated model")
	}
}

##########################################
# ------- (0.3) what.to.return --------- #
##########################################
#' Do consistent dummy checks for functions (GDTE/GDRF) that use a GECM model
#' @param return.plot a TRUE/FALSE on whether the plot should be returned from the function
#' @param return.formulae a TRUE/FALSE on whether the formulae should be returned from the function
#' @param return.formulae a TRUE/FALSE on whether the data from the effect should be returned from the function
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal
what.to.return <- function(return.plot, return.formulae, return.data, plot.out, dat.out, the.final.formulae) {
	if(return.plot == TRUE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, dat.out, the.final.formulae$formulae, the.final.formulae$binomials)
				names(out) <- c("plot", "estimates", "formulae", "binomials")
			} else if(return.formulae == FALSE) {
				out <- list(plot.out, dat.out)
				names(out) <- c("plot", "estimates")				
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, the.final.formulae$formulae, the.final.formulae$binomials)
				names(out) <- c("plot", "formulae", "binomials")
			} else if(return.formulae == FALSE) {
				out <- plot.out
			}			
		}
	} else if(return.plot == FALSE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(dat.out, the.final.formulae$formulae, the.final.formulae$binomials)
				names(out) <- c("estimates", "formulae", "binomials")
			} else if(return.formulae == FALSE) {
				out <- dat.out
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- list(the.final.formulae$formulae, the.final.formulae$binomials)
				names(out) <- c("formulae", "binomials")
			} else if(return.formulae == FALSE) {
				stop("Return at least one of the plot, the data, or the formulae")
			}			
		}
	}
	out
}

#####################################################
# --------------- FUNCTIONS EXPORTED ---------------#
#####################################################

##########################################
# ------ (1) pulse.calculator -----------#
##########################################
#' Generate pulse effect formulae for a given autoregressive distributed lag (ADL) model
#' @param x.vrbl a named vector of the x variables and corresponding lag orders in an ADL model
#' @param y.vrbl a named vector of the (lagged) y variables and corresponding lag orders in an ADL model
#' @param limit an integer for the number of periods (s) to determine the pulse effect (beginning at 0)
#' @return a list of limit + 1 \code{mpoly} formulae containing the pulse effect formula in each period
#' @details
#' \code{pulse.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the pulse effect in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. Note: \code{mpoly} does not allow variable names with a .; variables passed to \code{pulse.calculator} should not include this character
#' @importFrom mpoly mp
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords utilities
#' @examples
#' # ADL(1,1)
#' x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
#' y.lags <- c("l_1_y" = 1)
#' s <- 5
#' pulses <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
#' pulses
#' # Will also handle finite dynamics
#' x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
#' finite.pulses <- pulse.calculator(x.vrbl = x.lags, limit = s)
#' @export

pulse.calculator <- function(x.vrbl, y.vrbl = NULL, limit) {
	the.final.formula.list <- the.comb.formula.list <- vector("list", 1 + limit) # extra for s = 0
	if(is.null(y.vrbl)) {
		y.vrbl <- c("0" = 0)
	}
	for(s in 0:limit) {
		# evaluate s = 0 seperately: no dynamics
		if(s == 0) {
			# It's whatever coefficient there is (if any) in the x.vrbl in the 0 period
			#  there is no lagged LTE(h) (the alpha.xi elements) to carry forward
			the.comb.formula.list[[s+1]] <- mp(ifelse(0 %in% x.vrbl, names(x.vrbl)[which(x.vrbl == 0)], 0)) + 0
		} else {
			# First: define the quantity that will be carried forward by the lag y (alpha*xi)
			# max number of elements is either going to be minimum of the y.order specified <or> how far
			#  into the future we've gone since s (to sync the y.order )
			alpha.xi.elements <- vector("list", length = min(s, max(y.vrbl)))
			
			# if there are y.vrbl dynamics
			if(length(alpha.xi.elements) != 0) {			
				# now, loop over these elements to replace them
				for(counter in 1:length(alpha.xi.elements)) {
					# test to see if that particular s pairs with a y lag order for the quantity alpha_i * xi_{s-i}
					if(counter %in% y.vrbl) {
						# if it does, it's the relevant y coefficient times the relevant xi quantity that matches 
						#  (have to increment by 1 since position 1 is s = 0)
						alpha.xi.elements[[counter]] <- mp(names(y.vrbl)[which(y.vrbl == counter)]) * the.comb.formula.list[[(s+1)-counter]]
					} else {
						# if there is no relevant alpha_i for that lag order, replace it with 0
						alpha.xi.elements[[counter]] <- 0
					}
				}
				# now, form the actual sum
				sum.alpha.xi <- Reduce("+", alpha.xi.elements)
				# finally, place the sum in the lted.d.elements list. this is for the LTED(s, d) elements
				#  if there is a relevant beta for that period s (beta_h), add that to the sum of the alpha_i elements
			} else { # if there are not y.vrbl dynamics, just assign 0
				sum.alpha.xi <- 0
			}
			the.comb.formula.list[[s+1]] <- mp(ifelse(s %in% x.vrbl, names(x.vrbl)[which(x.vrbl == s)], 0)) + sum.alpha.xi
		}
		### Since we're going to pass this to a GDTE calculator, we're going to leave it as mpoly rather than transform to a formula
	}
	# return the mpoly object
	the.comb.formula.list
}

##########################################
# ------- (2) general.calculator --------#
##########################################
#' Generate the generalized effect formulae for an autoregressive distributed lag (ADL) model, given pulse effects and shock/treatment history
#' @param d.x the order of differencing of the x variable in the ADL model. (Generally, this is the same x variable used in \code{pulse.calculator})
#' @param d.y the order of differencing of the y variable in the ADL model. (Generally, this is the same y variable used in \code{pulse.calculator})
#' @param h an integer for the shock/treatment history. \code{h} determines the counterfactual series that will be applied to the independent variable. -1 represents a pulse. 0 represents a step. For others, see Vande Kamp, Jordan, and Rajan
#' @param limit an integer for the number of periods (s) to determine the generalized effect (beginning at 0)
#' @param pulses a list of pulse effect formulae used to construct the generalized effect formulae. We expect this will be provided by \code{pulse.calculator}
#' @return a list of \code{limit} + 1 \code{mpoly} formulae containing the generalized effect formula in each period
#' @details
#' \code{general.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the generalized effect in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. Note: \code{mpoly} does not allow variable names with a .; variables passed to \code{general.calculator} should not include this character
#' @importFrom mpoly mp
#' @importFrom utils capture.output
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords utilities
#' @examples
#' # ADL(1,1)
#' x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
#' y.lags <- c("l_1_y" = 1)
#' s <- 5
#' pulse.effects <- pulse.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = s)
#' # Assume that both x and y are in levels and we want a pulse treatment
#' general.pulse.effects <- general.calculator(d.x = 0, d.y = 0, 
#'								h = -1, limit = s, pulses = pulse.effects)
#' general.pulse.effects
#' # Apply a step treatment
#' general.step.effects <- general.calculator(d.x = 0, d.y = 0, 
#'								h = 0, limit = s, pulses = pulse.effects)
#' general.step.effects
#' @export

general.calculator <- function(d.x, d.y, h, limit, pulses) {
	# store the binomials for double checking
	the.final.binomial.list <- vector("list", 1 + limit) # extra for s = 0
	# create a container for the GDTEs by period
	the.final.formula.list <- vector("list", 1 + limit) # extra for s = 0
	for(s in 0:limit) {
		# store the binomials for double checking
		the.binomial.list <- rep(NA, (1 + s)) # extra for j = 0
		# create a placeholder for the within-period (s) formulas. the total number of periods
		#  will depend on which period s we are in from the loop
		the.comb.formula.list <- vector("list", 1 + s) # extra for j = 0
		for(j in 0:s) {
			# following Eqn XX. within-period transformation depends on the binomial coefficient
			the.binomial <- (2 * 0^(abs(h - d.x + d.y) - (h - d.x + d.y)) - 1)^j *
						choose((abs(h - d.x + d.y) - 1 + (1 + j) * 0^(abs(h - d.x + d.y)-(h - d.x + d.y))), j)
			# store the binomial coefficient*the relevant pulse
			the.comb.formula.list[[j+1]] <- mp(the.binomial)*pulses[[s-j+1]]  # extra for first element of pulses = 0
			# store the binomials for double checking
			the.binomial.list[j+1] <- the.binomial
		}
		# reduce the formula elements to a sum
		sum <- Reduce("+", the.comb.formula.list)
		# capturing the console does not play nicely directly
		intermediate <- capture.output(print(sum, stars = TRUE))
		# save the formula for testing
		the.final.formula.list[[s+1]] <- intermediate # extra for s = 0
		# store the binomials for testing
		the.final.binomial.list[[s+1]] <- the.binomial.list
	}
	# store the binomials for double checking
	out <- list("formulae" = the.final.formula.list, "binomials" = the.final.binomial.list)
	out
}

#########################################
# --------- (3) gecm.to.adl ------------#
#########################################
#' Translate the coefficients from the General Error Correction Model (GECM) to the autoregressive distributed lag (ADL) model
#' @param x.vrbl a named vector of the x variables (of the lower level of differencing, usually in levels d = 0) and corresponding lag orders in the GECM model
#' @param y.vrbl a named vector of the (lagged) y variables (of the lower level of differencing, usually in levels d = 0) and corresponding lag orders in the GECM model
#' @param x.d.vrbl a named vector of the x variables (of the higher level of differencing, usually first differences d = 1) and corresponding lag orders in the GECM model
#' @param y.d.vrbl a named vector of the y variables (of the higher level of differencing, usually first differences d = 1) and corresponding lag orders in the GECM model
#' @return a list of named vectors of translated ADL coefficients for the x and y variables of interest
#' @details
#' \code{gecm.to.adl} utilizes the mathematical equivalence between the GECM and ADL models to translate the coefficients from one to the other. This way, we can apply a single function using the ADL math to calculate effects
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords utilities
#' @examples
#' # GECM(1,1)
#' the.x.vrbl <- c("l_1_x" = 1) 
#' the.y.vrbl <- c("l_1_y" = 1) 
#' the.x.d.vrbl <- c("d_x" = 0, "l_1_d_x" = 1) 
#' the.y.d.vrbl <- c("l_1_d_y" = 1) 
#' adl.coef <- gecm.to.adl(x.vrbl = the.x.vrbl, y.vrbl = the.y.vrbl, 
#'				x.d.vrbl = the.x.d.vrbl, y.d.vrbl = the.y.d.vrbl)
#' adl.coef$x.vrbl.adl
#' adl.coef$y.vrbl.adl
#' @export

gecm.to.adl <- function(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl) {
	# First, make helper versions of x.vrbl and y.vrbl that aren't 
	#  missing any lags (i.e. if they're non-consecutive, it fills their name with 0). 
	#  Since this is the levels component, there cannot be a zero-order level in the GECM, so the loop starts at 1
	x.vrbl.helper <- 1:max(x.vrbl)
	for(i in 1:max(x.vrbl)) {
		if(i %in% x.vrbl) {
			names(x.vrbl.helper)[i] <- names(x.vrbl)[which(x.vrbl == i)]
		} else {
			names(x.vrbl.helper)[i] <- 0
		}
	}
	y.vrbl.helper <- 1:max(y.vrbl)
	for(i in 1:max(y.vrbl)) {
		if(i %in% y.vrbl) {
			names(y.vrbl.helper)[i] <- names(y.vrbl)[which(y.vrbl == i)]
		} else {
			names(y.vrbl.helper)[i] <- 0
		}
	}
	# Now, do the same thing with the lagged differences (x.d.vrbl and y.d.vrbl)
	# Reconstruct the ADL equivalents from the GECM. First, make helper versions of x.vrbl and y.vrbl that aren't 
	#  missing any lags (i.e. if they're non-consecutive, it fills their name with 0). 
	#  x.d.vrbl can begin at 0
	x.d.vrbl.helper <- 0:max(x.d.vrbl)
	for(i in 0:max(x.d.vrbl)) {
		if(i %in% x.d.vrbl) {
			# adjust position by 1: because it starts at 0
			names(x.d.vrbl.helper)[(i+1)] <- names(x.d.vrbl)[which(x.d.vrbl == i)]
		} else {
			# adjust position by 1: because it starts at 0
			names(x.d.vrbl.helper)[(i+1)] <- 0
		}
	}
	y.d.vrbl.helper <- 1:max(y.d.vrbl)
	for(i in 1:max(y.d.vrbl)) {
		if(i %in% y.d.vrbl) {
			names(y.d.vrbl.helper)[i] <- names(y.d.vrbl)[which(y.d.vrbl == i)]
		} else {
			names(y.d.vrbl.helper)[i] <- 0
		}
	}

	# Now turn the GECM parameters into the ADL parameters
	#  Notice the ADL order is one order higher than the GECM order
	x.vrbl.adl <- 0:(max(x.d.vrbl.helper)+1)
	# For all of the below, q is defined in terms of the ADL side
	for(q in 0:max(x.vrbl.adl)) {
		# 0 and 1 are one-off formulae
		if(q == 0) {
			# \beta_0 for the ADL is \beta_0 in the GECM (x.d.vrbl.helper at 0)
			names(x.vrbl.adl)[which(x.vrbl.adl == 0)] <- names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 0)]
		} else if(q == 1) {
			# \beta_1 for the ADL is \theta_1 (x.vrbl.helper at 1) + \beta_1 in the GECM (x.d.vrbl.helper at 1) - \beta_0 in the GECM (x.d.vrbl.helper at 0)
			names(x.vrbl.adl)[which(x.vrbl.adl == 1)] <- paste0(names(x.vrbl.helper)[which(x.vrbl.helper == 1)], "+", 
														names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 1)], "-", 
														names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 0)])
		} else if(q == max(x.vrbl.adl)) {
			# \beta_q for the ADL is -\beta_{q-1} in the GECM
			names(x.vrbl.adl)[which(x.vrbl.adl == max(x.vrbl.adl))] <- paste0("(-1)*", names(x.d.vrbl.helper)[which(x.d.vrbl.helper == (q-1))])
		} else {
			# all other \beta_j for the ADL is -\beta_{j-1} in the GECM + \beta_j in the GECM
			names(x.vrbl.adl)[which(x.vrbl.adl == q)] <- paste0("(-1)*", names(x.d.vrbl.helper)[which(x.d.vrbl.helper == (q-1))], "+", 
														names(x.d.vrbl.helper)[which(x.d.vrbl.helper == q)])
		}
	}
	# y will start at 1
	#  Notice the ADL order is one order higher than the GECM order
	y.vrbl.adl <- 1:(max(y.d.vrbl.helper)+1)
	# For all of the below, p is defined in terms of the ADL side
	for(p in 1:max(y.vrbl.adl)) {
		# 0 is one-off formula
		if(p == 1) {
			# \alpha_1 for the ADL is \theta_0 (y.vrbl.helper at 1) + \alpha_1 in the GECM (y.d.vrbl.helper at 1) + 1
			names(y.vrbl.adl)[which(y.vrbl.adl == 1)] <- paste0(names(y.vrbl.helper)[which(y.vrbl.helper == 1)], "+",
														names(y.d.vrbl.helper)[which(y.d.vrbl.helper == 1)], "+1")
		} else if(p == max(y.vrbl.adl)) {
			# \alpha_p for the ADL is -\alpha_{p-1}
			names(y.vrbl.adl)[which(y.vrbl.adl == max(y.vrbl.adl))] <- paste0("(-1)*", names(y.d.vrbl.helper)[which(y.d.vrbl.helper == (p-1))])
		} else {
			# all other \alpha_j for the ADL is -\alpha_{j-1} in the GECM + \alpha_j in the GECM
			names(y.vrbl.adl)[which(y.vrbl.adl == p)] <- paste0("(-1)*", names(y.d.vrbl.helper)[which(y.d.vrbl.helper == (p-1))], "+", 
														names(y.d.vrbl.helper)[which(y.d.vrbl.helper == p)])
		}
	}
	out <- list(x.vrbl.adl = x.vrbl.adl, y.vrbl.adl = y.vrbl.adl)
	out
}

#########################################
# -------- (4) GDTE.adl.plot -----------#
#########################################
#' Evaluate (and possibly plot) the General Dynamic Treatment Effect (GDTE) for an autoregressive distributed lag (ADL) model
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl a named vector of the x variables and corresponding lag orders in the ADL model
#' @param y.vrbl a named vector of the (lagged) y variables and corresponding lag orders in the ADL model
#' @param d.x the order of differencing of the x variable in the ADL model
#' @param d.y the order of differencing of the y variable in the ADL model
#' @param te.type the desired treatment history. \code{te.type} determines the counterfactual series (h) that will be applied to the independent variable. -1 represents a Pulse Treatment Effect (PTE). 0 represents a Step Treatment Effect (STE). These can also be specified via \code{pte}, \code{pulse}, \code{ste}, and \code{step}. For others, see Vande Kamp, Jordan, and Rajan. The default is \code{pte}
#' @param inferences.x does the user want to apply the counterfactual treatment to the independent variable in levels or in differences? (For x variables where \code{d.x} is 0, this is automatically levels.) The default is \code{levels}
#' @param inferences.y does the user want resulting inferences about the dependent variable in levels or in differences? (For y variables where \code{d.y} is 0, this is automatically levels.) The default is \code{levels}
#' @param dM.level level of significance of the GDTE, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDTE (beginning at s = 0)
#' @param se.type the type of standard error to extract from the ADL model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data return the raw calculated GDTEs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot return the visualized GDTEs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae return the formulae for the GDTEs as a list element under \code{formulae} (for the GDTEs) and \code{binomials} (for the treatment history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return depending on \code{return.data}, \code{return.plot}, and \code{return.formulae}, a list of elements relating to the GDTE
#' @details
#' We assume that the ADL model estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities. Given that, to obtain causal inferences for the specified treatment history, the user only needs a named vector of the x and y variables, as well as the order of the differencing
#' @importFrom stats lm coef vcov
#' @importFrom mpoly mp
#' @importFrom sandwich vcovHC
#' @importFrom car deltaMethod
#' @import ggplot2
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords ADL plot GDTE
#' @examples
#' # ADL(1,1)
#' # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository 
#' model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
#' test.pulse <- GDTE.adl.plot(model = model,
#'                                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'                                   y.vrbl = c("l_1_y" = 1),
#'                                   d.x = 0, 
#'                                   d.y = 0,
#'                                   te.type = "pulse", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   s.limit = 20, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' names(test.pulse)
#' 
#' # Using Cavari's (2019) approval model (without interactions)
#' # Cavari's original model: APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + 
#' #     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#' #	     MIP_MACROECONOMICS + MIP_FOREIGN + 
#' #     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT)
#' 
#' cavari.model <- lm(APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + MIP_FOREIGN +
#'      APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#'      DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT), data = approval)
#' 
#' # What if there was a permanent, one-unit change in the salience of foreign affairs?
#' cavari.step <- GDTE.adl.plot(model = cavari.model,
#'                                   x.vrbl = c("MIP_FOREIGN" = 0), 
#'                                   y.vrbl = c("APPROVE_L1" = 1),
#'                                   d.x = 0,
#'                                   d.y = 0,
#'                                   te.type = "ste", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   s.limit = 10, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' @export

GDTE.adl.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, d.x = NULL, d.y = NULL,
	te.type = "pte", inferences.y = "levels", inferences.x = "levels",
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,
	...) {

	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared adl dummy check
	########################################################################
	adl.dummy.checks(x.vrbl, y.vrbl, d.x, d.y, inferences.x, inferences.y, the.coef, se.type, type = "GDTE")

	########################################################################
	# specific to function: te.type checks, assign te.type, convert inferences to numeric, assign vcov, and replace _
	########################################################################
	# Dummy checks specific to GDTE: te.type
	if(is.null(te.type)) {
		stop("Treatment effect type (te.type) must be specified")
	}
	
	# Dummy checks. Is the effect type valid?
	if(is.character(te.type)) {
		if(!(te.type %in% c("pte", "ste", "pulse", "step", "impulse", "cumulative"))) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer h representing the order of the GDTE")	
		}
	} else if(suppressWarnings(as.numeric(te.type))) {
		if(te.type%%1 != 0) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer h representing the order of the GDTE")	
		}
	}

	# turn the te.type into the argument h.order
	h.order <- ifelse(te.type %in% c("pte", "pulse", "impulse"), -1,
				ifelse(te.type %in% c("ste", "step", "cumulative"), 0, te.type))

	# if the user wants inferences in differences (the original form of y), we do not need any adjustment
	#  to the dependent variable when we calculate the GDTE, but we do need it preserved for the plot
	if(inferences.y == "differences") {
		calc.d.y <- 0
		plot.d.y <- d.y
	} else if(inferences.y == "levels") {
		calc.d.y <- d.y
		plot.d.y <- 0		
	}
	# if the user wants inferences in differences (the original form of x), we do not need any adjustment
	#  to the dependent variable when we calculate the GDTE, but we do need it preserved for the plot
	if(inferences.x == "differences") {
		calc.d.x <- 0
		plot.d.x <- d.x
	} else if(inferences.x == "levels") {
		calc.d.x <- d.x
		plot.d.x <- 0		
	}
	
	the.vcov <- vcovHC(model, type = se.type)
	
	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		if(!is.null(y.vrbl)) {
			names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))		
		}
		warning("Variable names containing . replaced with _")
	}

	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pulse.calculator(x.vrbl = x.vrbl, y.vrbl = y.vrbl, limit = s.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- general.calculator(d.x = calc.d.x, d.y = calc.d.y, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	
	dat.out <- cbind(0:s.limit, t(sapply(the.final.formulae$formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
					
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDTE", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- names(the.final.formulae$binomials) <- paste0("s = ", 0:s.limit)
	
	########################################################################
	# plotting
	########################################################################	
	# Set plotted variables to NULL initially or else R CMD gets confused by the data call
	Period <- GDTE <- Lower <- Upper <- NULL
	plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDTE)) + 
				geom_line(lwd = 1.2) + 
				geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
				geom_hline(yintercept = 0, lwd = 1) +
				xlab("Number of Periods Since Treatment Onset (s)") +
				# ylab("Generalized Dynamic Treatment Effect") +
				ylab(bquote(GDTE[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
				theme_bw() + 
				theme(panel.border = element_blank(), 
					panel.grid.major = element_blank(),
					panel.grid.minor = element_blank(), 
					axis.line = element_line(colour = "black"))	

	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
	out
}

##########################################
# --------- (5) GDRF.adl.plot -----------#
##########################################
#' Evaluate (and possibly plot) the General Dynamic Response Function (GDRF) for an autoregressive distributed lag (ADL) model
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl named vector of the x variables and corresponding lag orders in the ADL model
#' @param y.vrbl named vector of the (lagged) y variables and corresponding lag orders in the ADL model
#' @param d.x the order of differencing of the x variable in the ADL model
#' @param d.y the order of differencing of the y variable in the ADL model
#' @param shock.history the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. -1 represents a pulse. 0 represents a step. These can also be specified via \code{pulse} and \code{step}. For others, see Vande Kamp, Jordan, and Rajan. The default is \code{pulse}
#' @param inferences.x does the user want to apply the shock history to the independent variable in levels or in differences? (For x variables where \code{d.x} is 0, this is automatically levels.) The default is \code{levels}
#' @param inferences.y does the user want resulting inferences about the dependent variable in levels or in differences? (For y variables where \code{d.y} is 0, this is automatically levels.) The default is \code{levels}
#' @param dM.level significance level of the GDRF, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param se.type the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{binomials} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @importFrom stats lm coef vcov
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @importFrom utils capture.output
#' @import ggplot2
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshikesav Rajan
#' @keywords ADL plot GDRF
#' @examples
#' 
#' # ADL(1,1)
#' # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository 
#' model.toydata <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
#'
#' # Pulse effect of x
#' GDRF.adl.plot(model = model.toydata, 
#'					x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'					y.vrbl = c("l_1_y" = 1),
#'					d.x = 0,
#'					d.y = 0,
#'					shock.history = "pulse", 
#'					inferences.y = "levels",
#'					inferences.x = "levels",
#'					s.limit = 20)
#' 
#' # Step effect of x. You can store the data to draw your own plot,
#' #  if you prefer
#' test.cumulative <- GDRF.adl.plot(model = model.toydata, 
#'					x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'					y.vrbl = c("l_1_y" = 1),
#'					d.x = 0,
#'					d.y = 0,
#'					shock.history = "step", 
#'					inferences.y = "levels",
#'					inferences.x = "levels",
#'					s.limit = 20)
#' test.cumulative$plot
#'
#' @export

GDRF.adl.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, d.x = NULL, d.y = NULL,
	shock.history = "pulse", inferences.y = "levels", inferences.x = "levels",
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
	...) {
	
	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared adl dummy check
	########################################################################
	adl.dummy.checks(x.vrbl, y.vrbl, d.x, d.y, inferences.x, inferences.y, the.coef, se.type, type = "GDRF")

	########################################################################
	# specific to function: shock.history checks, assign shock.history, convert inferences to numeric, assign vcov, and replace _
	########################################################################
	# Dummy checks. Is there a shock history type? 
	if(is.null(shock.history)) {
		stop("Shock history type must be specified")
	}
	
	# Dummy checks. Is the shock history valid?
	if(is.character(shock.history)) {
		if(!(shock.history %in% c("pulse", "step", "impulse", "cumulative"))) {
			stop("Invalid shock.history. shock.history must be one of pulse or step, or any as.numeric integer h representing the order of the GDRF")	
		}
	} else if(suppressWarnings(as.numeric(shock.history))) {
		if(shock.history%%1 != 0) {
			stop("Invalid shock.history. shock.history must be one of pulse or step, or any as.numeric integer h representing the order of the GDRF")	
		}
	}

	# turn the shock.history into the argument h.order
	h.order <- ifelse(shock.history %in% c("pulse", "impulse"), -1,
				ifelse(shock.history %in% c("step", "cumulative"), 0, shock.history))

	# if the user wants inferences in differences (the original form of y), we do not need any adjustment
	#  to the dependent variable when we calculate the GDRF, but we do need it preserved for the plot
	if(inferences.y == "differences") {
		calc.d.y <- 0
		plot.d.y <- d.y
	} else if(inferences.y == "levels") {
		calc.d.y <- d.y
		plot.d.y <- 0		
	}
	# if the user wants inferences in differences (the original form of x), we do not need any adjustment
	#  to the dependent variable when we calculate the GDRF, but we do need it preserved for the plot
	if(inferences.x == "differences") {
		calc.d.x <- 0
		plot.d.x <- d.x
	} else if(inferences.x == "levels") {
		calc.d.x <- d.x
		plot.d.x <- 0		
	}
	
	the.vcov <- vcovHC(model, type = se.type)
	
	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		if(!is.null(y.vrbl)) {
			names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))		
		}		
		warning("Variable names containing . replaced with _")
	}

	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pulse.calculator(x.vrbl = x.vrbl, y.vrbl = y.vrbl, limit = s.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- general.calculator(d.x = calc.d.x, d.y = calc.d.y, h = h.order, limit = s.limit, pulses = the.pte.formula.list)

	# establish container for results	
	dat.out <- cbind(0:s.limit, t(sapply(the.final.formulae$formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
					
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDRF", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- names(the.final.formulae$binomials) <- paste0("s = ", 0:s.limit)		
	
	
	########################################################################
	# deal with LRM
	########################################################################
	lrm.d.x <- ifelse(inferences.x == "differences", 0, d.x)
	lrm.d.y <- ifelse(inferences.y == "differences", 0, d.y)
	lrm.exists <- ifelse(((h.order - lrm.d.x + lrm.d.y) == 0), TRUE, FALSE)
	
	if(lrm.exists == TRUE) {
		# if it's just a finite model, assign a zero
		# calculate the LRM. start with all of the relevant betas in the numerator, regardless of order
		lrm.numerator <- paste0(names(x.vrbl), collapse = "+")
		# Denominator is the alpha.is. these are unweighted in the sum
		#  so we don't have to do anything but combine them!
		if(is.null(y.vrbl)) {
			lrm <- paste0("(", lrm.numerator, ")")
		} else {
			lrm <- paste0("(", lrm.numerator, ")/(1-(", paste(names(y.vrbl), collapse = "+"), "))")		
		}
		# save the LRM formula for testing
		the.final.formulae$formulae$"LRM" <- lrm
		# evaluate the LRM and add to the dataset as the s.limit + 1 period
		lrm.dat <- c(as.matrix(s.limit+1), as.matrix(deltaMethod(the.coef, lrm, vcov. = the.vcov, level = dM.level)))
		dat.out <- rbind(dat.out, as.numeric(lrm.dat))
	}
	
	########################################################################
	# plotting
	########################################################################
	# We're going to separate them because of the LRM
	Effect <- Effect.sig <- GDRF <- Lower <- Period <- Upper <- Z <- NULL
	if(lrm.exists == FALSE) {
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
						geom_hline(yintercept = 0, lwd = 1) +
						xlab("Number of Periods Since Initial Shock (s)") +
						ylab(bquote(GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
						theme_bw() + 
							theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))			
	} else if(lrm.exists == TRUE) { # if there is an LRM
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
		# make a small dataset that excludes the LRM
		plotting.data.nolrm <- dat.out[(dat.out$Period %in% 0:s.limit),]
		plotting.data.lrm <- dat.out[(dat.out$Period %in% (s.limit + 1)),]
		plotting.data.lrm$Period <- lrm.space
		plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = plotting.data.nolrm, aes(ymin = .data$Lower, ymax = .data$Upper), color = "black", linetype = 1, alpha = 0.2) +
						geom_hline(yintercept = 0, lwd = 1) +
						geom_segment(data = plotting.data.lrm, aes(x = .data$Period, xend = .data$Period, y = .data$Lower, yend = .data$Upper), lwd = 1.25, color = "black") +
						geom_point(data = plotting.data.lrm, aes(x = .data$Period, y = .data$GDRF), size = 3) +
						scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), lrm.space), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
						xlab("Number of Periods Since Initial Shock (s)") +	
						ylab(bquote(GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
						theme_bw() + 
						theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
			# rename last row: account for the 0 at the beginning of s
			dat.out$Period[s.limit+2] <- "LRM"	
	}

	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
	out
}

##########################################
# -------- (6) GDTE.gecm.plot ---------- #
##########################################
#' Evaluate (and possibly plot) the General Dynamic Treatment Effect (GDTE) for a Generalized Error Correction Model (GECM)
#' @param model the \code{lm} model containing the GECM estimates
#' @param x.vrbl a named vector of the x variables (of the lower level of differencing, usually in levels d = 0) and corresponding lag orders in the GECM model
#' @param y.vrbl a named vector of the (lagged) y variables (of the lower level of differencing, usually in levels d = 0) and corresponding lag orders in the GECM model
#' @param x.vrbl.d.x the order of differencing of the x variable (of the lower level of differencing, usually in levels d = 0) in the GECM model
#' @param y.vrbl.d.y the order of differencing of the y variable (of the lower level of differencing, usually in levels d = 0) in the GECM model
#' @param x.d.vrbl a named vector of the x variables (of the higher level of differencing, usually first differences d = 1) and corresponding lag orders in the GECM model
#' @param y.d.vrbl a named vector of the y variables (of the higher level of differencing, usually first differences d = 1) and corresponding lag orders in the GECM model
#' @param x.d.vrbl.d.x the order of differencing of the x variable (of the higher level of differencing, usually first differences d = 1) in the GECM model
#' @param y.d.vrbl.d.y the order of differencing of the y variable (of the higher level of differencing, usually first differences d = 1) in the GECM model
#' @param te.type the desired treatment history. \code{te.type} determines the counterfactual series (h) that will be applied to the independent variable. -1 represents a Pulse Treatment Effect (PTE). 0 represents a Step Treatment Effect (STE). These can also be specified via \code{pte}, \code{pulse}, \code{ste}, and \code{step}. For others, see Vande Kamp, Jordan, and Rajan. The default is \code{pte}
#' @param inferences.x does the user want to apply the counterfactual treatment to the independent variable in levels or in differences? The default is \code{levels}
#' @param inferences.y does the user want resulting inferences about the dependent variable in levels or in differences? The default is \code{levels}
#' @param dM.level level of significance of the GDTE, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDTE (beginning at s = 0)
#' @param se.type the type of standard error to extract from the GECM model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data return the raw calculated GDTEs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot return the visualized GDTEs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae return the formulae for the GDTEs as a list element under \code{formulae} (for the GDTEs) and \code{binomials} (for the treatment history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return depending on \code{return.data}, \code{return.plot}, and \code{return.formulae}, a list of elements relating to the GDTE
#' @details
#' We assume that the GECM model estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities. Given that, to obtain causal inferences for the specified treatment history, the user only needs a named vector of the x and y variables, as well as the order of the differencing. Internally, the GECM to ADL equivalences are used to calculate the GDTEs from the GECM
#' @importFrom stats lm coef vcov
#' @importFrom mpoly mp
#' @importFrom sandwich vcovHC
#' @importFrom car deltaMethod
#' @import ggplot2
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords GECM plot GDTE
#' @examples
#' # GECM(1,1)
#' # Use the toy data to run a GECM. No argument is made this 
#' #  is well specified or even sensible; it is just expository
#' model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
#' test.pulse <- GDTE.gecm.plot(model = model,
#'                                   x.vrbl = c("l_1_x" = 1), 
#'                                   y.vrbl = c("l_1_y" = 1),
#'                                   x.vrbl.d.x = 0, 
#'                                   y.vrbl.d.y = 0,
#'                                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
#'                                   y.d.vrbl = c("l_1_d_y" = 1),
#'                                   x.d.vrbl.d.x = 1,
#'                                   y.d.vrbl.d.y = 1,
#'                                   te.type = "pulse", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   s.limit = 10, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' names(test.pulse)
#' @export

GDTE.gecm.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, x.vrbl.d.x = NULL, y.vrbl.d.y = NULL,
	x.d.vrbl = NULL, y.d.vrbl = NULL, x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = NULL,
	te.type = "pte", inferences.y = "levels", inferences.x = "levels",
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
	...) {

	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared adl dummy check
	########################################################################
	gecm.dummy.checks(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl, 
							x.vrbl.d.x, y.vrbl.d.y, x.d.vrbl.d.x, y.d.vrbl.d.y, 
							inferences.x, inferences.y, the.coef, se.type, type = "GDTE")

	########################################################################
	# specific to function: shock.history checks, assign shock.history, convert inferences to numeric, assign vcov, and replace _
	########################################################################
	# Dummy checks. Is there an effect type? 
	if(is.null(te.type)) {
		stop("Treatment effect type must be specified")
	}
	
	# Dummy checks. Is the effect type valid?
	if(is.character(te.type)) {
		if(!(te.type %in% c("pte", "ste", "pulse", "step", "impulse", "cumulative"))) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer h representing the order of the GDTE")	
		}
	} else if(suppressWarnings(as.numeric(te.type))) {
		if(te.type%%1 != 0) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer h representing the order of the GDTE")	
		}
	}
	
	# turn the te.type into the argument h.order
	h.order <- ifelse(te.type %in% c("pte", "pulse", "impulse"), -1,
				ifelse(te.type %in% c("ste", "step", "cumulative"), 0, te.type))

	# if the user wants inferences in differences (the original form of y), we do not need any adjustment
	#  to the dependent variable when we calculate the GDTE, but we do need it preserved for the plot
	if(inferences.y == "differences") {
		calc.d.y <- 0
		plot.d.y <- y.vrbl.d.y
	} else if(inferences.y == "levels") {
		calc.d.y <- y.vrbl.d.y
		plot.d.y <- 0		
	}
	
	# if the user wants inferences in differences (the original form of x), we do not need any adjustment
	#  to the dependent variable when we calculate the GDTE, but we do need it preserved for the plot
	if(inferences.x == "differences") {
		calc.d.x <- 0
		plot.d.x <- x.vrbl.d.x
	} else if(inferences.x == "levels") {
		calc.d.x <- x.vrbl.d.x
		plot.d.x <- 0		
	}

	the.vcov <- vcovHC(model, type = se.type)

	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))
		names(x.d.vrbl) <- gsub('\\.', '\\_', names(x.d.vrbl))
		names(y.d.vrbl) <- gsub('\\.', '\\_', names(y.d.vrbl))
				
		warning("Variable names containing . replaced with _")
	}
	
	########################################################################
	# translate gecm to adl
	########################################################################
	adl.coefficients <- gecm.to.adl(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl) 
	x.vrbl.adl <- adl.coefficients$x.vrbl.adl
	y.vrbl.adl <- adl.coefficients$y.vrbl.adl
	
	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pulse.calculator(x.vrbl = x.vrbl.adl, y.vrbl = y.vrbl.adl, limit = s.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- general.calculator(d.x = calc.d.x, d.y = calc.d.y, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	
	dat.out <- cbind(0:s.limit, t(sapply(the.final.formulae$formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
					
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDTE", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- names(the.final.formulae$binomials) <- paste0("s = ", 0:s.limit)	

	########################################################################
	# plotting
	########################################################################	
	# Set plotted variables to NULL initially or else R CMD gets confused by the data call
	Period <- GDTE <- Lower <- Upper <- NULL
	plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDTE)) + 
				geom_line(lwd = 1.2) + 
				geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
				geom_hline(yintercept = 0, lwd = 1) +
				xlab("Number of Periods Since Treatment Onset (s)") +
				# ylab("Generalized Dynamic Treatment Effect") +
				ylab(bquote(GDTE[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
				theme_bw() + 
				theme(panel.border = element_blank(), 
					panel.grid.major = element_blank(),
					panel.grid.minor = element_blank(), 
					axis.line = element_line(colour = "black"))

	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
}

##########################################
# -------- (7) GDRF.gecm.plot ---------- #
##########################################
#' Evaluate (and possibly plot) the General Dynamic Treatment Effect (GDRF) for a Generalized Error Correction Model (GECM)
#' @param model the \code{lm} model containing the GECM estimates
#' @param x.vrbl a named vector of the x variables (of the lower level of differencing, usually in levels d = 0) and corresponding lag orders in the GECM model
#' @param y.vrbl a named vector of the (lagged) y variables (of the lower level of differencing, usually in levels d = 0) and corresponding lag orders in the GECM model
#' @param x.vrbl.d.x the order of differencing of the x variable (of the lower level of differencing, usually in levels d = 0) in the GECM model
#' @param y.vrbl.d.y the order of differencing of the y variable (of the lower level of differencing, usually in levels d = 0) in the GECM model
#' @param x.d.vrbl a named vector of the x variables (of the higher level of differencing, usually first differences d = 1) and corresponding lag orders in the GECM model
#' @param y.d.vrbl a named vector of the y variables (of the higher level of differencing, usually first differences d = 1) and corresponding lag orders in the GECM model
#' @param x.d.vrbl.d.x the order of differencing of the x variable (of the higher level of differencing, usually first differences d = 1) in the GECM model
#' @param y.d.vrbl.d.y the order of differencing of the y variable (of the higher level of differencing, usually first differences d = 1) in the GECM model
#' @param shock.history the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. -1 represents a pulse. 0 represents a step. These can also be specified via \code{pulse} and \code{step}. For others, see Vande Kamp, Jordan, and Rajan. The default is \code{pulse}
#' @param inferences.x does the user want to apply the shock history to the independent variable in levels or in differences? The default is \code{levels}
#' @param inferences.y does the user want resulting inferences about the dependent variable in levels or in differences? The default is \code{levels}
#' @param dM.level level of significance of the GDRF, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param se.type the type of standard error to extract from the GECM model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{binomials} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return depending on \code{return.data}, \code{return.plot}, and \code{return.formulae}, a list of elements relating to the GDTE
#' @details
#' We assume that the GECM model estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities. Given that, to obtain inferences for the specified shock history, the user only needs a named vector of the x and y variables, as well as the order of the differencing. Internally, the GECM to ADL equivalences are used to calculate the GDRFs from the GECM
#' @importFrom stats lm coef vcov
#' @importFrom mpoly mp
#' @importFrom sandwich vcovHC
#' @importFrom car deltaMethod
#' @import ggplot2
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords GECM plot GDRF
#' @examples
#' # GECM(1,1)
#' # Use the toy data to run a GECM. No argument is made this 
#' #  is well specified or even sensible; it is just expository
#' model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
#' test.pulse <- GDRF.gecm.plot(model = model,
#'                                   x.vrbl = c("l_1_x" = 1), 
#'                                   y.vrbl = c("l_1_y" = 1),
#'                                   x.vrbl.d.x = 0, 
#'                                   y.vrbl.d.y = 0,
#'                                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
#'                                   y.d.vrbl = c("l_1_d_y" = 1),
#'                                   x.d.vrbl.d.x = 1,
#'                                   y.d.vrbl.d.y = 1,
#'                                   shock.history = "pulse", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   s.limit = 10, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' names(test.pulse)
#' @export

GDRF.gecm.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, x.vrbl.d.x = NULL, y.vrbl.d.y = NULL,
	x.d.vrbl = NULL, y.d.vrbl = NULL, x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = NULL,
	shock.history = "pulse", inferences.y = "levels", inferences.x = "levels",
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
	...) {

	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared adl dummy check
	########################################################################
	gecm.dummy.checks(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl, 
							x.vrbl.d.x, y.vrbl.d.y, x.d.vrbl.d.x, y.d.vrbl.d.y, 
							inferences.x, inferences.y, the.coef, se.type, type = "GDRF")

	########################################################################
	# specific to function: shock.history checks, assign shock.history, convert inferences to numeric, assign vcov, and replace _
	########################################################################
	# Dummy checks. Is there a shock history type? 
	if(is.null(shock.history)) {
		stop("Shock history type must be specified")
	}
	
	# Dummy checks. Is the effect type valid?
	if(is.character(shock.history)) {
		if(!(shock.history %in% c("pulse", "step", "impulse", "cumulative"))) {
			stop("Invalid shock.history. shock.history must be one of pulse or step, or any as.numeric integer h representing the order of the GDRF")	
		}
	} else if(suppressWarnings(as.numeric(shock.history))) {
		if(shock.history%%1 != 0) {
			stop("Invalid shock.history. shock.history must be one of pulse or step, or any as.numeric integer h representing the order of the GDRF")	
		}
	}

	# turn the shock.history into the argument h.order
	h.order <- ifelse(shock.history %in% c("pulse", "impulse"), -1,
				ifelse(shock.history %in% c("step", "cumulative"), 0, shock.history))

	# if the user wants inferences in differences (the original form of y), we do not need any adjustment
	#  to the dependent variable when we calculate the GDRF, but we do need it preserved for the plot
	if(inferences.y == "differences") {
		calc.d.y <- 0
		plot.d.y <- y.vrbl.d.y
	} else if(inferences.y == "levels") {
		calc.d.y <- y.vrbl.d.y
		plot.d.y <- 0		
	}
	
	# if the user wants inferences in differences (the original form of x), we do not need any adjustment
	#  to the dependent variable when we calculate the GDRF, but we do need it preserved for the plot
	if(inferences.x == "differences") {
		calc.d.x <- 0
		plot.d.x <- x.vrbl.d.x
	} else if(inferences.x == "levels") {
		calc.d.x <- x.vrbl.d.x
		plot.d.x <- 0		
	}

	the.vcov <- vcovHC(model, type = se.type)

	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))
		names(x.d.vrbl) <- gsub('\\.', '\\_', names(x.d.vrbl))
		names(y.d.vrbl) <- gsub('\\.', '\\_', names(y.d.vrbl))
				
		warning("Variable names containing . replaced with _")
	}
	
	########################################################################
	# translate gecm to adl
	########################################################################
	adl.coefficients <- gecm.to.adl(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl) 
	x.vrbl.adl <- adl.coefficients$x.vrbl.adl
	y.vrbl.adl <- adl.coefficients$y.vrbl.adl
	
	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pulse.calculator(x.vrbl = x.vrbl.adl, y.vrbl = y.vrbl.adl, limit = s.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- general.calculator(d.x = calc.d.x, d.y = calc.d.y, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	
	dat.out <- cbind(0:s.limit, t(sapply(the.final.formulae$formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
					
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDRF", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- names(the.final.formulae$binomials) <- paste0("s = ", 0:s.limit)	

	########################################################################
	# deal with LRM
	########################################################################
	lrm.exists <- ifelse((inferences.x == "levels" & inferences.y == "levels" & x.d.vrbl.d.x == 1 & y.d.vrbl.d.y == 1 & h.order == 0), TRUE, FALSE)
	
	if(lrm.exists == TRUE) {
		# calculate the LRM. GECM means just the first lag of the variables in levels
		lrm <- paste0("(-1) * (", names(x.vrbl), ")/(", names(y.vrbl), ")")		
		# save the LRM formula for testing
		the.final.formulae$formulae$"LRM" <- lrm
		# evaluate the LRM and add to the dataset as the s.limit + 1 period
		lrm.dat <- c(as.matrix(s.limit+1), as.matrix(deltaMethod(the.coef, lrm, vcov. = the.vcov, level = dM.level)))
		dat.out <- rbind(dat.out, as.numeric(lrm.dat))
	}

	########################################################################
	# plotting
	########################################################################
	# We're going to separate them because of the LRM
	Effect <- Effect.sig <- GDRF <- Lower <- Period <- Upper <- Z <- NULL
	if(lrm.exists == FALSE) {
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
						geom_hline(yintercept = 0, lwd = 1) +
						xlab("Number of Periods Since Initial Shock (s)") +
						# ylab("Generalized Dynamic Treatment Effect") +
						ylab(bquote(GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
						theme_bw() + 
						theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
	} else if(lrm.exists == TRUE) { # if there is an LRM
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
		# make a small dataset that excludes the LRM
		plotting.data.nolrm <- dat.out[(dat.out$Period %in% 0:s.limit),]
		plotting.data.lrm <- dat.out[(dat.out$Period %in% (s.limit + 1)),]
		plotting.data.lrm$Period <- lrm.space
		plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = plotting.data.nolrm, aes(ymin = .data$Lower, ymax = .data$Upper), color = "black", linetype = 1, alpha = 0.2) +
						geom_hline(yintercept = 0, lwd = 1) +
						geom_segment(data = plotting.data.lrm, aes(x = .data$Period, xend = .data$Period, y = .data$Lower, yend = .data$Upper), lwd = 1.25, color = "black") +
						geom_point(data = plotting.data.lrm, aes(x = .data$Period, y = .data$GDRF), size = 3) +
						scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), lrm.space), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
						xlab("Number of Periods Since Initial Shock (s)") +	
						ylab(bquote(GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
						theme_bw() + 
						theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
		# rename last row: account for the 0 at the beginning of s
		dat.out$Period[s.limit+2] <- "LRM"	
	}

	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
	out
}


##########################################
# ------- (8) interact.adl.plot -------- #
##########################################
#' Plot the interaction in a single-equation time series model estimated via \code{lm}. It is imperative that you double-check you have referenced all x, y, z, and interaction terms through \code{x.vrbl}, \code{y.vrbl}, \code{z.vrbl}, and \code{x.z.vrbl}. You must also have their orders correctly entered. \code{interact.adl.plot} has no way of determining, from the variable list, which correspond with which
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl named vector of the ``main'' x variables and corresponding lag orders in the ADL model
#' @param z.vrbl named vector of the ``moderating'' z variables and corresponding lag orders in the ADL model
#' @param x.z.vrbl named vector with the interaction variables and corresponding lag orders in the ADL model. IMPORTANT: enter the lag order that pertains to the ``main'' x variable. For instance, x_l_1_z (contemporaneous x times lagged z) would be 0 and l_1_x_z (lagged x times contemporaneous z) would be 1
#' @param y.vrbl named vector of the (lagged) y variables and corresponding lag orders in the ADL model
#' @param effect.type whether impulse or cumulative effects should be calculated. \code{impulse} generates impulse effects, or short-run/instantaneous effects specific to each period. \code{cumulative} generates the accumulated, or long-run/cumulative effects up to each period (including the long-run multiplier). The default is \code{impulse}
#' @param plot.type whether to feature marginal effects at discrete values of s/z as lines, or across a range of values through a heatmap. The default is \code{lines}
#' @param line.options if drawing lines, whether the moderator should be values of z (\code{z.lines}) or values of s (\code{s.lines}). The default is \code{z.lines}
#' @param heatmap.options if drawing a heatmap, whether all marginal effects should be shown or just statistically significant ones. (Note: this just sets the insignificant effects to the numeric value of 0. If the middle value of your scale gradient is white, these will effectively ``disappear.'' If another gradient is used, they will take on the color assigned to 0 values.) The default is \code{significant}
#' @param line.colors what color lines would you like for line plots? This defaults to the color-safe Okabe-Ito (\code{okabe-ito}) colors. There is also a grayscale option through \code{bw}. Users can also include whatever colors they like. The number of colors must match the number of lines drawn. This is passed to \code{scale_color_discrete}
#' @param heatmap.colors what color scale would you like for the heatmap? The default is \code{Blue-Red}. Alternate colors must be one of \code{hcl.pals()}. For grayscale plots, use \code{Grays}. This is passed to \code{scale_fill_gradientn}
#' @param z.vals values for the moderating variable. If \code{plot.type = lines}, these are treated as discrete levels of z. If \code{plot.type = heatmap}, these are treated as a lower and upper level of a range of values of z. If none are provided, \code{interact.adl.plot} will pick
#' @param s.vals values for the time since the shock. This is only used if \code{line.options = s.lines}, meaning s is treated as the moderator. The default is 0 (short-run) and the \code{LRM}
#' @param z.label.rounding number of digits to round to for the z labels in the legend (if those values are automatically calculated)
#' @param z.vrbl.label the name of the moderating z variable, used in plotting
#' @param dM.level significance level of the (cumulative) marginal effects, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the (cumulative) marginal effects (beginning at s = 0)
#' @param se.type the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data return the raw calculated (cumulative) marginal effects as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot return the visualized (cumulative) marginal effects as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae return the formulae for the (cumulative) marginal effects as a list element under \code{formulae} (for the (cumulative) marginal effects) and \code{binomials} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @importFrom stats lm coef vcov model.frame sd
#' @importFrom ggplot2 ggplot
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @importFrom utils capture.output
#' @importFrom grDevices hcl.colors hcl.pals palette.colors
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshikesav Rajan
#' @keywords interaction plot
#' @examples
#' # Using Cavari's (2019) approval model
#' # Cavari's original model: APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + 
#' #     MIP_FOREIGN + APPROVE_ECONOMY*MIP_MACROECONOMICS + APPROVE_FOREIGN*MIP_FOREIGN + 
#' #     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#' #     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT)
#' 
#' approval$ECONAPP_ECONMIP <- approval$APPROVE_ECONOMY*approval$MIP_MACROECONOMICS
#' approval$FPAPP_ECONFP <- approval$APPROVE_FOREIGN*approval$MIP_FOREIGN
#' 
#' cavari.model <- lm(APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + 
#'      MIP_FOREIGN + ECONAPP_ECONMIP + FPAPP_ECONFP + 
#'      APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#'      DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT), data = approval)
#' 
#' # Now: marginal effect of X at different levels of Z
#' interact.adl.plot(model = cavari.model, 
#'		x.vrbl = c("APPROVE_ECONOMY" = 0), y.vrbl = c("APPROVE_L1" = 1),
#' 		z.vrbl = c("MIP_MACROECONOMICS" = 0), x.z.vrbl = c("ECONAPP_ECONMIP" = 0),
#'		effect.type = "impulse", plot.type = "lines", line.options = "z.lines")
#' 
#' # Use well-behaved simulated data (included) for even more examples, 
#' #  using the Warner, Vande Kamp, and Jordan general model
#' model.toydata <- lm(y ~ l_1_y + x + l_1_x + z + l_1_z +
#'		x_z + z_l_1_x +
#'		x_l_1_z + l_1_x_l_1_z, data = toy.ts.interaction.data)
#' 
#' # Marginal effect of z (not run: computational time)
#' # Be sure to specify x.z.vrbl orders with respect to x term
#' \dontrun{interact.adl.plot(model = model.toydata, x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'					y.vrbl = c("l_1_y" = 1), z.vrbl = c("z" = 0, "l_1_z" = 1),
#'					x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, 
#'						"x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
#'					z.vals = -2:2,
#'					effect.type = "impulse", 
#'					plot.type = "lines", 
#'					line.options = "z.lines",
#'					s.limit = 20)
#' }
#' 
#' # Heatmap of marginal effects, since X and Z are actually continuous
#' #  (not run: computational time)
#' \dontrun{interact.adl.plot(model = model.toydata, x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'					y.vrbl = c("l_1_y" = 1), z.vrbl = c("z" = 0, "l_1_z" = 1),
#'					x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, 
#'						"x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
#'					z.vals = c(-2,2),
#'					effect.type = "impulse", 
#'					plot.type = "heatmap", 
#'					heatmap.options = "all",
#'					s.limit = 20)
#' }
#' @export

interact.adl.plot <- function(model = NULL, x.vrbl = NULL, z.vrbl = NULL, x.z.vrbl = NULL, y.vrbl = NULL,
	effect.type = "impulse",
	plot.type = "lines",
	line.options = "z.lines",
	heatmap.options = "significant",
	line.colors = "okabe-ito",
	heatmap.colors = "Blue-Red", 
	z.vals = NULL, s.vals = c(0, "LRM"), 
	z.label.rounding = 3, z.vrbl.label = names(z.vrbl)[1],
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,
	...) {

	# Assign coefficients
	the.coef <- coef(model)
	
	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(z.vrbl) | is.null(x.z.vrbl)) {
		stop("Variables in interaction term (x, z, and x.z) must be specified through x.vrbl, z.vrbl, and x.z.vrbl")
	}

	if(is.null(y.vrbl)) {
		warning("No y.vrbl implies a static or finite model: are you sure you want this?")
	}

	# NO d.x/d.y/d.x.z checks. This function is not built to resolve integration, as x/z could mix orders of differencing

	# NO inferences.x/inferences.y/inferences.x.z checks. This function is not built to resolve integration, as x/z could mix orders of differencing

	# test whether x.vrbl is named vectors with numeric lag order elements
	if(!(is.numeric(x.vrbl)) | is.null(names(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model.")
	}

	# test whether y.vrbl is named vectors with numeric lag order elements
	if(!is.null(y.vrbl)) {
		if(!(is.numeric(y.vrbl)) | is.null(names(y.vrbl))) {
			stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
		}
	}
	
	# test whether z.vrbl is named vectors with numeric lag order elements
	if(!(is.numeric(z.vrbl)) | is.null(names(z.vrbl))) {
		stop("z.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
	}
	
	# test whether x.z.vrbl is named vectors with numeric lag order elements
	if(!(is.numeric(x.z.vrbl)) | is.null(names(x.z.vrbl))) {
		stop("x.z.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
	}

	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}
	
	# are the variables in the model?
	if(!(all(names(x.vrbl) %in% names(the.coef)))) {
		stop("x.vrbl not present in estimated model")
	}

	if(!is.null(y.vrbl)) {
		if(!(all(names(y.vrbl) %in% names(the.coef)))) {
			stop("y.vrbl not present in estimated model")
		}
	}

	if(!(all(names(z.vrbl) %in% names(the.coef)))) {
		stop("z.vrbl not present in estimated model")
	}
		
	if(!(is.null(x.z.vrbl)) & !(all(names(x.z.vrbl) %in% names(the.coef)))) {
		stop("x.z.vrbl not present in estimated model")
	}	

	# Dummy checks specific to interact: effect.type/plot.type
	if(is.null(effect.type)) {
		stop("effect.type must be specified")		
	}
	
	if(!(effect.type %in% c("impulse", "pulse", "cumulative", "step"))) {
		stop("effect.type must be one of impulse or cumulative")
	}
	
	if(return.plot == TRUE) {
		if(is.null(plot.type)) {
			stop("plot.type must be specified")
		} 
		if(!(plot.type %in% c("lines", "heatmap"))) {
			stop("plot.type must be one of lines or heatmap")
		}
		if(plot.type == "lines") {
			if(!(line.options %in% c("s.lines", "z.lines"))) {
				stop("line.options must be one of s.lines or z.lines")
			}
		}
		if(plot.type == "heatmap") {
			if(!(heatmap.options %in% c("all", "significant"))) {
				stop("heatmap.options must be one of all or significant")
			}
		}
	}
	
	# change h.order to reflect the effect.type
	if(effect.type %in% c("impulse", "pulse")) {
		h.order <- -1	
	} else if(effect.type %in% c("cumulative", "step")) {
		h.order <- 0
	}

	the.vcov <- vcovHC(model, type = se.type)

	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		if(!is.null(y.vrbl)) {
			names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))		
		}
		if(!(is.null(x.z.vrbl))) {
			names(x.z.vrbl) <- gsub('\\.', '\\_', names(x.z.vrbl))	
		}
		warning("Variable names containing . replaced with _")
	}
	
	########################################################################
	# below establish: z.vals/s.vals; z.plot.lables; lines.colors/heatmap.colors
	########################################################################
	
	# if the z.vals are specified, do they meet minimums?
	if(!(is.null(z.vals))) {
		if(length(z.vals) == 2) { # if the z.vals are potentially limits, and there is only 2
			z.vals <- sort(z.vals)
		} 
	}

	# svals: if it is a slines plot, and it is an impulse, we can't use the LRM (it doesn't exist)
	if(plot.type == "lines" & line.options == "s.lines" & effect.type == "impulse") { # if it is slines
		if(identical(s.vals, c(0, "LRM"))) {
			s.vals <- c(0, s.limit)
		}
	}

	# establish z.vals. if it's an interactive model
	the.z <- model.frame(model)[names(z.vrbl)[1]]
	
	# useful later for defaults: z +/- 1sd (for discrete values) or 2 (for a range)
	potential.zline.limits <- c((mean(the.z[,1], na.rm = TRUE) - sd(the.z[,1], na.rm = TRUE)), (mean(the.z[,1], na.rm = TRUE) + sd(the.z[,1], na.rm = TRUE)))
	potential.zrange.limits <- c((mean(the.z[,1], na.rm = TRUE) - 2*sd(the.z[,1], na.rm = TRUE)), (mean(the.z[,1], na.rm = TRUE) + 2*sd(the.z[,1], na.rm = TRUE)))

	if(plot.type == "lines" & line.options == "z.lines") { 		# if it is z.lines
		if(!(is.null(z.vals))) {  # if they specified z.vals
			if(length(z.vals) > 5) { # make sure it's only 5
				stop("Do not supply more than 5 discrete values of z to plot. The plot is too busy")
			}				
		} else if(is.null(z.vals)) { # if they didn't specify z.vals
			if(length(table(the.z)) < 6) {  # if the variable is discrete
				z.vals <- as.numeric(names(table(the.z)))
			} else { # if it's continuous: for zlines, its mean +/- 1 s.d. (and the mean)
				z.vals <- seq(potential.zline.limits[1], potential.zline.limits[2], length.out = 3)
			}
		}
	} else if(plot.type == "lines" & line.options == "s.lines") { # if it is slines
		if(length(s.vals) > 5) { # make sure it's only 5 s values to plot
			stop("Do not supply more than 5 discrete values of s to plot. The plot is too busy")				
		} else if(!(is.null(z.vals))) { # if they specified z.vals
			if(!(length(z.vals) == 2)) { # if there are more than two values provided
				stop("s.lines requires two z.vals: a lower and upper limit of the range of z values on the x-axis")
			} else if(length(z.vals) == 2) { # if it is just two values, build the range
				z.vals <- seq(z.vals[1], z.vals[2], length.out = 50)			
			}			
		} else if(is.null(z.vals)) {  # if they didn't specify z.vals, make 50 vals using mean +/- 2 s.d. 
			z.vals <- seq(potential.zrange.limits[1], potential.zrange.limits[2], length.out = 50)			
		}
	} else if(plot.type == "heatmap") { #if it's a heatmap
		if(!(is.null(z.vals))) { # if they specified z.vals
			if(!(length(z.vals) == 2)) { # if there are more than two values provided
				stop("heatmap requires two z.vals: a lower and upper limit of the range of z values on the x-axis")
			} else if(length(z.vals) == 2) { # if it is just two values, build the range
				z.vals <- seq(z.vals[1], z.vals[2], length.out = 50)			
			}
		} else if(is.null(z.vals)) {  # if they didn't specify z.limits or z.vals, make 50 vals using mean +/- 2 s.d. 
			z.vals <- seq(potential.zrange.limits[1], potential.zrange.limits[2], length.out = 50)			
		}
	}

	# Plot labels
	if(max(abs(z.vals)) < 10) {
		z.plot.labels <- format(round(z.vals, digits = z.label.rounding), nsmall = z.label.rounding)
	} else {
		z.plot.labels <- z.vals
	}
	
	# establish line.colors
	if(plot.type %in% c("lines")) { # if it is a line plot
		if(line.options %in% c("z.lines")) { #  if it's z.lines, we need colors equal to number of z.vals
			if(!(all(line.colors %in% c("bw", "okabe-ito")))) { # if it isn't one of ours: bw or okabe-ito
				# we just need to see if they supplied the correct number of colors
				if(length(line.colors) != length(z.vals)) {
					stop(paste0("Number of supplied line.colors (", length(line.colors), ") is not equal to number of z.vals (", length(z.vals), ") to plot"))			
				}
			} else if(all(line.colors %in% "okabe-ito")) { # if it is okabe-ito
				line.colors <- unname(palette.colors())[2:(length(z.vals)+1)] # okabe.ito
			} else if(all(line.colors %in% "bw")) { # if it is bw
				line.colors <- paste0("grey", round(seq(0, 60, length.out = length(z.vals)))) # grays
			}
		}
		if(line.options %in% c("s.lines")) {
			if(!(all(line.colors %in% c("bw", "okabe-ito")))) { # if it isn't one of ours: bw or okabe-ito
				# we just need to see if they supplied the correct number of colors
				if(length(line.colors) != length(s.vals)) {
					stop(paste0("Number of supplied line.colors (", length(line.colors), ") is not equal to number of s.vals (", length(s.vals), ") to plot"))			
				}
			} else if(all(line.colors %in% "okabe-ito")) { # if it is okabe-ito
				line.colors <- unname(palette.colors())[2:(length(s.vals)+1)] # okabe.ito
			} else if(all(line.colors %in% "bw")) { # if it is bw
				line.colors <- paste0("grey", round(seq(0, 60, length.out = length(s.vals)))) # grays
			}
		}	
	}

	# establish heatmap.colors
	if(plot.type %in% c("heatmap")) {
		# the default is "Blue-Red", but any hcl.pals() will work
		if(!(heatmap.colors %in% hcl.pals())) {
			stop("heatmap.colors must be one of hcl.pals(). For grayscale heatmap, use ``Grays''")
		}	
	}

	make_fill_scale <- function(pal, Effect) {
		cols <- hcl.colors(3, pal)
		scale_fill_gradient2(
			low = cols[1],
			mid = "white",
			high = cols[3],
			midpoint = 0,
			limits = range(c(0, Effect), na.rm = TRUE)
		)
	}
		
	########################################################################
	# below begins the calculation / plotting meat
	########################################################################
	# Unlike with ts.effect.plot, we have a series of both x coefficients and x.z (interaction) coefficients. We need to 
	#  combine them before we pass to pulse.calculator.
	# How many elements are we going to have? the max order of x by itself and the x.z interactions
	combined.limit <- max(x.vrbl, x.z.vrbl)
	# Add one for the 0 time period
	combined.x.vrbl.names <- rep(NA, (combined.limit + 1))
	for(i in 0:combined.limit) {
		# for x: don't need to worry about pasting multiple items: only one x coefficient possible
		the.x <- ifelse(i %in% x.vrbl, names(x.vrbl)[x.vrbl == i], 0) 
		# for x*z (the interaction terms): if there's multiple (i.e. z and a crosslag, paste them together and multiply by z_val)
		#  z_val will be specified later
		the.xz <- ifelse(i %in% x.z.vrbl, paste0(names(x.z.vrbl)[x.z.vrbl == i], "*z_val", collapse = "+"), 0) 
		# must increment by 1 because it starts at s = 0
		combined.x.vrbl.names[i+1] <- paste(the.x, the.xz, sep = "+")
	}
	combined.x.vrbl <- 0:combined.limit
	names(combined.x.vrbl) <- combined.x.vrbl.names

	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pulse.calculator(x.vrbl = combined.x.vrbl, y.vrbl = y.vrbl, limit = s.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- general.calculator(d.x = 0, d.y = 0, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	
	# establish container for results
	dat.out <- matrix(rep(NA, (length(0:s.limit)*length(z.vals))*6), nrow = (length(0:s.limit)*length(z.vals)))

	# replace the first two columns with the relevant values of s and z
	dat.out[,c(1:2)] <- as.matrix(expand.grid(s = 0:s.limit, z_val = z.vals))
	
	for(j in 1:nrow(dat.out)) {
		# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
		#  reminder that the formuale are already created in the.final.formulae$formulae. elements 1:(s.limit+1)
		#  and we have s and z in dat.out already
		s <- dat.out[j,1] # look above: s is the first column
		z <- dat.out[j,2] # look above: z is the second column
		the.formula <- the.final.formulae$formulae[s+1] # have to increment by one since s starts at 0		
		dat.out[j,3:6] <- as.matrix(deltaMethod(the.coef, paste(gsub('z_val', z, the.formula)), vcov. = the.vcov, level = dM.level))
	}
	
	dat.out <- data.frame(dat.out)
	names(dat.out) <- c("Period", "Z", "Effect", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- names(the.final.formulae$binomials) <- paste0("s = ", 0:s.limit)		

	########################################################################
	# deal with LRM
	########################################################################		
	if(effect.type %in% c("cumulative", "step")) {
		# calculate the LRM. remember we already made the numerator! just need to add the terms (regardless of order)
		lrm.numerator <- paste0(names(combined.x.vrbl), collapse = "+")
		# Denominator is the alpha.is. these are unweighted in the sum
		#  so we don't have to do anything but combine them!
		if(is.null(y.vrbl)) {
			lrm <- paste0("(", lrm.numerator, ")")
		} else {
			lrm <- paste0("(", lrm.numerator, ")/(1-(", paste(names(y.vrbl), collapse = "+"), "))")
		}		
		# save the LRM formula for testing
		the.final.formulae$formulae$"LRM" <- lrm
		# make another matrix of values to fill. this is different from normal, as we have many z.vals
		lrm.dat <- matrix(rep(NA, length(z.vals)*6), nrow = length(z.vals))
		for(z in 1:length(z.vals)) {
			# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
			that.zsum <- gsub('z_val', z.vals[z], lrm)
			lrm.dat[z,] <- c(as.matrix(c((s.limit+1), z.vals[z])), as.matrix(deltaMethod(the.coef, paste(that.zsum), vcov. = the.vcov, level = dM.level)))
		}
		lrm.dat <- data.frame(lrm.dat)
		names(lrm.dat) <- c("Period", "Z", "Effect", "SE", "Lower", "Upper")
		dat.out <- rbind(dat.out, lrm.dat)
	}

	########################################################################
	# plotting
	########################################################################
	# Branch city: we will do the impulse branch first (4x plots)
	Effect <- Effect.sig <- GDRF <- Lower <- Period <- Upper <- Z <- NULL
	if(effect.type %in% c("impulse", "pulse")) {
		if(plot.type == "lines") {
			if(line.options == "z.lines") {
				# Situation: impulse/marginal effects, lines, by values of Z
				#######################
				# x-axis: s; y-axis: ME; lty is Z value
				#######################
				plot.out <- ggplot(data = dat.out, aes(x = Period, y = Effect, lty = as.factor(Z), col = as.factor(Z))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
							geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of ", z.vrbl.label), labels = z.plot.labels) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))					
			} else if(line.options == "s.lines") {
				# Situation: impulse/marginal effects, lines, by values of s
				#######################
				# x-axis: z; y-axis: ME; lty is s value
				#######################
				s.vals <- as.numeric(s.vals)
				s.plot.labels <- paste0("s = ", s.vals)				
				plotting.data.justs <- dat.out[(dat.out$Period %in% s.vals),]
				plot.out <- ggplot(data = plotting.data.justs, aes(x = Z, y = Effect, lty = as.factor(Period), col = as.factor(Period))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Period), col = as.factor(Period)), linetype = 1, alpha = 0.1)	+
							geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of s"), labels = s.plot.labels) +
							xlab(paste0("Value of ", z.vrbl.label)) +
							ylab(paste0("Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))				
			}
		} else if(plot.type == "heatmap") {
			if(heatmap.options == "all") {
				# Situation: impulse/marginal effects, heatmap, all effects
				#######################
				# x-axis: s; y-axis: Z; tile color is ME
				#######################
				plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = Effect)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect), na.rm = TRUE)) +
							make_fill_scale(heatmap.colors, Effect = dat.out$Effect) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0("Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))	
			} else if(heatmap.options == "significant") {
				# Situation: impulse/marginal effects, heatmap, only significant effects
				#######################
				# x-axis: s; y-axis: Z; tile color is ME
				#######################
				dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
				dat.out$Effect.sig <- ifelse(dat.out$insig == 0, dat.out$Effect, 0)
				plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = Effect.sig)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect.sig), na.rm = TRUE)) +
							make_fill_scale(heatmap.colors, Effect = dat.out$Effect.sig) +							
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0("Statistically Significant\nMarginal Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
			}
		} # ends heatmap
	} else if(effect.type %in% c("cumulative", "step")) {
		if(plot.type == "lines") {
			if(line.options == "z.lines") {
				# Situation: cumulative effects, lines, by values of z
				#######################
				# x-axis: s; y-axis: CME; lty is Z value
				#######################
				lrm.space <- s.limit + round((s.limit * 0.2), digits = 0) + 2
				plotting.data.nolrm <- dat.out[(dat.out$Period %in% 0:s.limit),]
			
				# have to position the lrm lines for each z.val out past the s.limit
				lrm.lines <- dat.out[dat.out$Period == (s.limit + 1),]
				lrm.lines$xloc <-  seq((s.limit + round((s.limit * 0.2), digits = 0)) - ((length(z.vals) - 1)/2),
									(s.limit + round((s.limit * 0.2), digits = 0)) + ((length(z.vals) - 1)/2),
									length.out = length(z.vals))
		
				plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period, y = Effect, lty = as.factor(Z), col = as.factor(Z))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
							geom_segment(data = lrm.lines, aes(x = .data$xloc, xend = .data$xloc, y = .data$Lower, yend = .data$Upper), lwd = 1.25, color = line.colors) +
							geom_point(data = lrm.lines, aes(x = .data$xloc, y = .data$Effect), size = 3, color = line.colors)	+
							geom_hline(yintercept = 0, lwd = 1) +
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space-2)), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							scale_color_discrete(type = line.colors, name = paste0("Value of ", z.vrbl.label), labels = z.plot.labels) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Cumulative Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				dat.out$Period[dat.out$Period == (s.limit+1)] <- "LRM"
			} else if(line.options == "s.lines") {
				# Situation: cumulative effects, lines, by values of s
				#######################
				# x-axis: Z; y-axis: CME; lty is s value
				#######################
				# Need to define levels of s for plotting. Really it's only sensical to do 0 and LRM. But I'm not going to stop anyone
				#  change "LRM" to the s.limit + 1 period in the prediction dataset
				#  this just identifies it numerically for plotting
				s.vals[s.vals == "LRM"] <- lrm.space <- s.limit + 1    
				s.vals <- as.numeric(s.vals)
				s.plot.labels <- paste0("s = ", s.vals)
				s.plot.labels[s.plot.labels == "s = 0"] <- "s = 0 (Short-run)"
				s.plot.labels[s.plot.labels == paste0("s = ", (s.limit + 1))] <- paste0("s = ", bquote(.("\U221E")), " (Long-run)")
				plotting.data.justs <- dat.out[(dat.out$Period %in% s.vals),]
				plot.out <- ggplot(data = plotting.data.justs, aes(x = Z, y = Effect, lty = as.factor(Period), col = as.factor(Period))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Period), col = as.factor(Period)), linetype = 1, alpha = 0.1) +
							geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of s"), labels = s.plot.labels) +
							xlab(paste0("Value of ", z.vrbl.label)) +
							ylab(paste0("Cumulative Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				dat.out$Period[dat.out$Period == (s.limit+1)] <- "LRM"
			}
		} else if(plot.type == "heatmap") {
			if(heatmap.options == "all") {
				# Situation: cumulative effects, heatmap, all effects
				#######################
				# x-axis: s; y-axis: Z; tile color is CME of LRM
				#######################
				# adjust the LRM to be a little out from the heatmap to prevent confusion
				lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
				dat.out$Period[dat.out$Period == (s.limit + 1)] <- lrm.space	
				plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = Effect)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect), na.rm = TRUE)) +
							make_fill_scale(heatmap.colors, Effect = dat.out$Effect) +							
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
											labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0("Cumulative Marginal Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				dat.out$Period[dat.out$Period == lrm.space] <- "LRM"
			} else if(heatmap.options == "significant") {
				# Situation: cumulative effects, heatmap, only significant effects
				#######################
				# x-axis: s; y-axis: Z; tile color is CME
				#######################
				lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
				dat.out$Period[dat.out$Period == (s.limit + 1)] <- lrm.space

				dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
				dat.out$Effect.sig <- ifelse(dat.out$insig == 0, dat.out$Effect, 0)
				plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = Effect.sig)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect.sig), na.rm = TRUE)) +
							make_fill_scale(heatmap.colors, Effect = dat.out$Effect.sig) +							
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
											labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0("Statistically Significant\nCumulative Marginal Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black")) 					
				dat.out$Period[dat.out$Period == lrm.space] <- "LRM"
			} 
		} # ends lines/heatmap
	} # ends cumulative
	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
	out
}
