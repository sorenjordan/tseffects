# version 0.4.1
# 10/2/2026
# Authors: Soren Jordan, Garrett N. Vande Kamp, Reshi Rajan

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
#' @format A data frame with 50 rows and 32 variables:
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




### Dependencies: 	
#		mpoly (for formula construction)
#		car (for deltaMethod)
#		ggplot2 (for plots)
#		sandwich (for vcovHC)
#		stats (for lm coef vcov)
#		utils (for capture.output)

### Functions
## Not exported
# (0.1) GDRF.dummy.checks
# (0.2) adl.dummy.checks
# (0.3) gecm.dummy.checks
# (0.4) what.to.return
# (0.5) mpoly.subber
# (0.6) get.value
# (0.7) lrm.existr
# (0.8) shockr.and.cumr
# (0.9) inference.adjustr
# (0.10) make.fill.scale
## Exported
# (1) pulse.calculator
# (2a) convolution.calculator
# (2b) general.calculator
# (3) gecm.to.adl
# (4) yhat.calculator
# (5) GDRF.adl.plot
# (5.1) adl.plot
# (6) GDRF.gecm.plot
# (6.1) gecm.plot
# (7) interact.adl.plot




	
	
#####################################################
# ------------- FUNCTIONS NOT EXPORTED -------------#
#####################################################
##########################################
# ------ (0.1) GDRF.dummy.checks ------- #
##########################################
#' Do consistent dummy checks for GDRF functions that might take fitted values
#' @param effect.type a character string indicating whether to return discrete effects or fitted values. \code{discrete} returns the GDRF as a discrete effect estimate. \code{fitted} returns the GDRF as a fitted value, relative to a baseline value of the dependent variable. The default is \code{discrete}
#' @param prediction.values a named list of values for non-y variables in the model, used to calculate a steady-state baseline of the dependent variable when \code{effect.type = "fitted"} and \code{d.y = 0} and \code{baseline.y} is not supplied. Model-based uncertainty will be calculated around the formula for this value. If any differenced variables are included in the model, they should be set to 0. If multiple lags of the same variable are included, they should be set to the same value. Ignored when \code{d.y > 0}
#' @param baseline.y a numeric value for the user-supplied baseline value of y in levels (i.e. the baseline value for effects to accumulate from). Only used when \code{effect.type = "fitted"}. For \code{d.y = 0}, this overrides the steady-state calculation from \code{prediction.values} if provided
#' @param baseline.y.se a numeric value for the user-supplied standard error for the baseline value of y (to suggest uncertainty around predictions). Only used when \code{effect.type = "fitted"} and \code{inferences.y = "levels"}. If supplied, this is added in quadrature to the standard errors of the GDRF estimates. The default is 0: in recognition that this is user-constructed uncertainty. Possible values would be the square root of the standard deviation of y (in levels)
#' @param shock.size a numeric value for the size of the shock to x in the units of x. Defaults to 1 (a discrete effect similar to traditional marginal effects)
#' @param d.y an integer describing how many times the dependent variable was differenced before model estimation
#' @param type a character string whether the effects are estimated from a GDRF model or the interaction model. Accepts either \code{GDRF} or \code{interact}
#' @param inferences.y a character string specifying whether the shock to the independent variable is interpreted in levels or differences (of the dependent variable). Valid arguments include \code{levels} or \code{differences}. (For y variables where \code{d.y} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @return nothing is returned
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

GDRF.dummy.checks <- function(effect.type, prediction.values, baseline.y, baseline.y.se, shock.size, d.y, inferences.y, type = NULL) {
	effect.message <- ifelse(type == "interact", "dynamic conditional effect", 
						ifelse(type == "GDRF", "GDRF", "broken"))

	# Is effect.type valid?
	if(!(effect.type %in% c("discrete", "fitted"))) {
		stop("Invalid effect.type. effect.type must be one of 'discrete' or 'fitted'")
	}
	# make sure no nonsensical options
	if(!is.numeric(shock.size)) {
		stop("shock.size must be numeric")
	}
	if(length(shock.size) > 1) {
		stop("shock.size should be a single value by which to scale the entire shock.history")
	}
	if(effect.type == "discrete") {
		if(!is.null(prediction.values)) {
			stop(paste0("Do not supply prediction.values when effect.type = 'discrete'. The ", effect.message, " is the discrete effect which takes no predicted values"))
		}
		if(!is.null(baseline.y) && baseline.y != 0) {
			stop(paste0("Do not supply baseline.y when effect.type = 'discrete'. The ", effect.message, " is the discrete effect which is always compared to 0"))
		}
		if(!is.null(baseline.y.se) && baseline.y.se != 0) {
			stop(paste0("Do not supply baseline.y.se when effect.type = 'discrete'. The ", effect.message, " is the discrete effect which has its own standard errors"))
		}
		# if(shock.size != 1) {
		#	stop("Do not supply shock.size when effect.type = 'discrete'. Discrete effects are defined by beta. If you want to scale them, switch to effect.type = 'fitted'")
		# }
	} else { # all of the below are effect.type == 'fitted'
		# you can't skip both
		if(is.null(prediction.values) && is.null(baseline.y)) {
			stop("You must provide either a baseline.y value or prediction.values (to use to calculate a steady-state). If unsure, set baseline.y = 0 (no assumed starting value for y)")
		}
		# if providing prediction values
		if(!is.null(prediction.values) && !is.list(prediction.values)) {
			stop("If using prediction.values, it must be a list. Be sure to set any differenced variables to 0")
		}
		if(!is.null(prediction.values) && baseline.y.se != 0) {
			stop("If using prediction.values, do not change baseline.y.se from 0. Let the model provide model-based uncertainty around the steady state")
		}
		# if providing a baseline.y
		if(!is.null(baseline.y) && !is.numeric(baseline.y)) {
			stop("If providing a baseline.y, it must be numeric")
		}
		if(!is.null(baseline.y) && length(baseline.y) > 1) {
			stop("Only provide a single baseline.y value")
		}
		# if providing a baseline.y.se
		if(!is.null(baseline.y.se) && !is.numeric(baseline.y.se)) {
			stop("If providing a baseline.y.se, it must be numeric")
		}
		if(is.null(prediction.values) && length(baseline.y.se) > 1) {
			stop("Only provide a single baseline.y.se value")
		}
		# consistency checks on combinations
		if(d.y == 0) {
			if(!is.null(baseline.y)) {
				# if they supplied both, tell them that's dumb
				if(!is.null(prediction.values)) {
					warning("Both baseline.y and prediction.values supplied; baseline.y takes precedence and prediction.values will be ignored")
				}
			} else { # if we're using their predicted.values
				# warning about d.x and multiple lags
				warning("If any differenced variables are included in the model, ensure they are set to 0 in prediction.values for a meaningful steady-state prediction. Multiple lags of the same variable should also be set to the same value")
			}
    		} else if(d.y > 0) {
			#  First, a warning. if they're still trying to use prediction.values
			if(!is.null(prediction.values)) {
				warning("prediction.values is ignored when d.y > 0: there is no steady-state prediction for y")
			}
			if(inferences.y == "differences") {
				# if they're asking for inferences in differences, there is no baseline to change (since it's still in differences). so we set it to 0
				if(!is.null(baseline.y) && baseline.y != 0) {
					warning("Assuming anything other than baseline.y = 0 when inferences.y = 'differences' suggests the model is unstable (y is always changing). Using 0 as baseline.y")
				}
				# we should also tell them that this is redundant if they're not also scaling the shock size
				if(shock.size == 1) {
					warning("effect.type = 'fitted' with inferences.y = 'differences' and shock.size = 1 is identical to effect.type = 'discrete'; returning formulae unchanged") 				
				} 
			} else if (inferences.y == "levels") {
				# if it's in levels, we just set it to their arbitrary baseline.
				if(is.null(baseline.y)) {
					stop("There is no baseline for y if effect.type = 'fitted' if d.y > 0. You must specify a baseline value through baseline.y (with optional uncertainty through baseline.y.se). If you just want to observe changes with no meaningful baseline, use baseline.y = baseline.y.se = 0")
				}
			}
		}
	} 
}


##########################################
# ------ (0.2) adl.dummy.checks -------- #
##########################################
#' Do consistent dummy checks for functions that use an ADL model
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable and the numbers correspond to the specific lag order of each variable. Can be \code{NULL} if the model has no lagged dependent variables
#' @param d.x an integer describing how many times the independent variable was differenced before model estimation
#' @param d.y an integer describing how many times the dependent variable was differenced before model estimation
#' @param inferences.x a character string specifying whether the shock to the independent variable is applied in levels or differences. Valid arguments include \code{levels} or \code{differences}. (For independent variables where \code{d.x} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param inferences.y a character string specifying whether the shock to the independent variable is interpreted in levels or differences (of the dependent variable). Valid arguments include \code{levels} or \code{differences}. (For y variables where \code{d.y} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param the.coef the coefficient vector from the estimated ADL model
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param type a string whether the effects are estimated from a GDRF model or the interaction model. Accepts either \code{GDRF} or \code{interact}
#' @return nothing is returned
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

adl.dummy.checks <- function(x.vrbl, y.vrbl, z.vrbl, x.z.vrbl, d.x, d.y, inferences.x, inferences.y, the.coef, se.type, type = NULL) {
	effect.message <- ifelse(type == "interact", "dynamic conditional effect", 
						ifelse(type == "GDRF", "GDRF", "broken"))
	
	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl)) {
		stop("Variables in ", effect.message, " terms (x and possibly y) must be specified through x.vrbl and possibly y.vrbl")
	}

	if(is.null(y.vrbl)) {
		warning("No y.vrbl in ", effect.message, " terms implies a static or finite dynamics model: are you sure you want this?")
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
	
	# Specific checks for GDRF models
	if(type == "GDRF") {
		# Dummy checks. Is d supplied for all variables specified?	
		if(is.null(d.x)) {
			stop(paste0("Order of differencing of variables in ", effect.message, " terms must be specified through d.x and d.y"))
		}
	
		# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified? even if they didn't supply a y.d.vrbl ...
		if(is.null(y.vrbl) & is.null(d.y)) {
			stop("Even if there is no y.vrbl in ", effect.message, " included in the model, the order of differencing (of the dependent variable) must be specified through d.y")
		}
		
		# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified? even if they didn't supply a y.d.vrbl ...
		if(!(is.null(y.vrbl)) & is.null(d.y)) {
			stop("Order of differencing of variables in ", effect.message, " terms must be specified through d.x and d.y")
		}			

		# orders of integration must be integers
		if((d.x%%1 != 0) | (d.y%%1 != 0)) {
			stop(paste0("Order of differencing of variables in ", effect.message, " terms (d.x and d.y) must be an integer"))
		}

		# Dummy checks: are x/y inferences specified?
		if(!(inferences.x %in% c("levels", "differences"))) {
			stop(paste0("Invalid inferences.x. The shock.history for x must be either in levels or differences"))
		}

		if(!(inferences.y %in% c("levels", "differences"))) {
			stop(paste0("Invalid inferences.y. The response function for y must be either in levels or differences"))
		}
	
		# Dummy checks: did they ask for inferences that don't make sense?
		if(inferences.x == "differences" & d.x == 0) {
			stop(paste0("Invalid inferences.x. The shock.history for x cannot be in a higher order of differencing (d.x) than the original independent variable"))
		}

		if(inferences.y == "differences" & d.y == 0) {
			stop(paste0("Invalid inferences.y. The response function for y cannot be in a higher order of differencing (d.y) than the original dependent variable"))
		}
	}
	
	# Specific checks for interaction models	
	if(type == "interact") {	
		# need to have interaction terms
		if(is.null(x.vrbl) | is.null(z.vrbl) | is.null(x.z.vrbl)) {
			stop("Variables in interaction term (x, z, and x.z) must be specified through x.vrbl, z.vrbl, and x.z.vrbl")
		}

		# test whether z.vrbl is named vectors with numeric lag order elements
		if(!(is.numeric(z.vrbl)) | is.null(names(z.vrbl))) {
			stop("z.vrbl should be a named vector with elements equal to lag orders of z and names equal to z variable names in model")
		}
	
		# test whether x.z.vrbl is named vectors with numeric lag order elements
		if(!(is.numeric(x.z.vrbl)) | is.null(names(x.z.vrbl))) {
			stop("x.z.vrbl should be a named vector with elements equal to lag orders of x:z and names equal to x:z variable names in model")
		}

		if(!(all(names(z.vrbl) %in% names(the.coef)))) {
			stop("z.vrbl not present in estimated model")
		}
		
		if(!(is.null(x.z.vrbl)) & !(all(names(x.z.vrbl) %in% names(the.coef)))) {
			stop("x.z.vrbl not present in estimated model")
		}	
	}
}

##########################################
# ------ (0.3) gecm.dummy.checks ------- #
##########################################
#' Do consistent dummy checks for functions that use a GECM model
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags (of the lower order of differencing, usually in levels d = 0) and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the lower order of differencing, usually in levels d = 0) and the numbers correspond to the specific lag order of each variable
#' @param x.vrbl.d.x an integer describing how many times the independent variable (of the lower order of differencing, usually in levels d = 0) was differenced before model estimation
#' @param y.vrbl.d.y an integer describing how many times the dependent variable (of the lower order of differencing, usually in levels d = 0) was differenced before model estimation
#' @param x.d.vrbl a named numeric vector in which the names correspond to an independent variable and its lags (of the higher order of differencing, usually in first differences d = 1) and the numbers correspond to the specific lag order of each variable
#' @param y.d.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the higher order of differencing, usually in first differences d = 1) and the numbers correspond to the specific lag order of each variable
#' @param x.d.vrbl.d.x an integer describing how many times the independent variable (of the higher order of differencing, usually in first differences d = 1) was differenced before model estimation
#' @param y.d.vrbl.d.y an integer describing how many times the dependent variable (of the higher order of differencing, usually in first differences d = 1) was differenced before model estimation
#' @param inferences.x a character string specifying whether the shock to the independent variable is applied in levels or differences. Valid arguments include \code{levels} or \code{differences}. (For independent variables where \code{d.x} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param inferences.y a character string specifying whether the shock to the independent variable is interpreted in levels or differences (of the dependent variable). Valid arguments include \code{levels} or \code{differences}. (For y variables where \code{d.y} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param the.coef the coefficient vector from the estimated GECM model
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param type a string whether the effects are estimated from a GDRF model or the interaction model. For now, just \code{GDRF}. But we will eventually develop \code{interact.gecm.plot}
#' @return nothing is returned
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

gecm.dummy.checks <- function(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl, 
							x.vrbl.d.x, y.vrbl.d.y, x.d.vrbl.d.x, y.d.vrbl.d.y, 
							inferences.x, inferences.y, the.coef, se.type, type = NULL) {

	effect.message <- ifelse(type == "interact", "dynamic conditional effect", 
						ifelse(type == "GDRF", "GDRF", "broken"))

	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(y.vrbl) | is.null(x.d.vrbl)) {
		stop("Variables in ", effect.message, " terms (x and y) and lagged differences must be specified through x.vrbl, y.vrbl, x.d.vrbl, and (possibly) y.d.vrbl for a GECM")
	}
	
	# Dummy checks. if the order of differencing for x.vrbl/y.vrbl specified?
	if(is.null(x.vrbl.d.x) | is.null(y.vrbl.d.y)) {
		stop("Order of differencing of variables in ", effect.message, " terms must be specified through x.vrbl.d.x and y.vrbl.d.y")
	}
	
	# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified?
	if(is.null(x.d.vrbl.d.x)) {
		stop("Order of differencing of variables in lagged differences in ", effect.message, " must be specified through x.d.vrbl.d.x")
	}	

	# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified? if they supplied a y.d.vrbl ...
	if(!(is.null(y.d.vrbl)) & is.null(y.d.vrbl.d.y)) {
		stop("Order of differencing of variables in lagged differences in ", effect.message, " must be specified through y.d.vrbl.d.y")
	}

	# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified? even if they didn't supply a y.d.vrbl ...
	if(is.null(y.d.vrbl) & is.null(y.d.vrbl.d.y)) {
		stop("Even if variables in lagged differences in ", effect.message, " are not included in the model, the order of differencing (of the dependent variable) must be specified through y.d.vrbl.d.y")
	}
		
	# Is the order of differencing an integer? (d(0) term)
	if((x.vrbl.d.x%%1 != 0) | (y.vrbl.d.y%%1 != 0)) {
		stop("Order of differencing of variables in ", effect.message, " term (x.vrbl.d.x and y.vrbl.d.y) must be an integer")
	}		
	
	# Is the order of differencing an integer? (d(1) x term)
	if(x.d.vrbl.d.x%%1 != 0) {
		stop("Order of differencing of variables in lagged differences in ", effect.message, " term (x.d.vrbl.d.x) must be an integer")
	}	

	# Is the order of differencing an integer? (d(1) y term)
	if(!(is.null(y.d.vrbl)) & (y.d.vrbl.d.y%%1 != 0)) {
		stop("Order of differencing of variables in lagged differences in ", effect.message, " term (y.d.vrbl.d.y) must be an integer")
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
	if(!(is.null(y.d.vrbl)) & (!(is.numeric(y.d.vrbl)) | is.null(names(y.d.vrbl)))) {
		stop("y.d.vrbl should be a named vector with elements equal to lag orders of differences of y and names equal to differenced y variable names in model")
	}

	# Are they appropriately away from each other? x
	if((x.d.vrbl.d.x - x.vrbl.d.x) != 1) {
		stop("In a GECM, the variable in differences should be one order of differencing from the variable in levels. Check the order of differencing of x and y")
	}

	# Are they appropriately away from each other? y
	if(!(is.null(y.d.vrbl)) & ((y.d.vrbl.d.y - y.vrbl.d.y) != 1)) {
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
		stop("In a GECM, inferences regarding the ", effect.message, " of x on y are automatically recovered in levels")
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
	
	if(!(is.null(y.d.vrbl)) & !(all(names(y.d.vrbl) %in% names(the.coef)))) {
		stop("y.d.vrbl not present in estimated model")
	}
}

##########################################
# ------- (0.4) what.to.return --------- #
##########################################
#' Consistently return the correct objects after a GDRF ADL/GECM
#' @param return.data logical to return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot logical to return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae logical to return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{shocks} (for the shock history). The default is \code{FALSE}
#' @param plot.out the created plot from the GDRF ADL/GECM
#' @param dat.out the created data from the GDRF ADL/GECM
#' @param the.final.formulae the created formulae from the GDRF ADL/GECM
#' @return a list of the requested objects
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

what.to.return <- function(return.plot, return.formulae, return.data, plot.out, dat.out, the.final.formulae) {
	if(return.plot == TRUE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, dat.out, the.final.formulae$formulae, the.final.formulae$shocks)
				names(out) <- c("plot", "estimates", "formulae", "shocks")
			} else if(return.formulae == FALSE) {
				out <- list(plot.out, dat.out)
				names(out) <- c("plot", "estimates")				
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, the.final.formulae$formulae, the.final.formulae$shocks)
				names(out) <- c("plot", "formulae", "shocks")
			} else if(return.formulae == FALSE) {
				out <- plot.out
			}			
		}
	} else if(return.plot == FALSE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(dat.out, the.final.formulae$formulae, the.final.formulae$shocks)
				names(out) <- c("estimates", "formulae", "shocks")
			} else if(return.formulae == FALSE) {
				out <- dat.out
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- list(the.final.formulae$formulae, the.final.formulae$shocks)
				names(out) <- c("formulae", "shocks")
			} else if(return.formulae == FALSE) {
				stop("Return at least one of the plot, the data, or the formulae")
			}			
		}
	}
	out
}


##########################################
# -------- (0.5) mpoly.subber ---------- #
##########################################
#' Replace characters that mpoly does not take with underscores
#' @param env the environment with names to substitute. Defaults to the parent environment
#' @return the environment with the substituted names
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

mpoly.subber <- function(env = environment()) {
	# regex for gsub
	patterns <- c("\\.", "\\(", "\\)", "\\,", "\\s")
	# the symbols as pretty
	labels <- c(".", "(", ")", ",", "whitespace")

	# the places we need to replace the sybmols
	name.objs <- c(
		"the.coef", "x.vrbl", "y.vrbl", "x.d.vrbl", "y.d.vrbl"
	)

	# ignore (Intercept), since it contains () that do not matter and we don't want to replace them
	model.names.noint <- names(coef(env$model))[names(coef(env$model)) != "(Intercept)"]

	for(i in seq_along(patterns)) {
		# if the pattern is not in the model coefficients
		if(!any(grepl(patterns[i], model.names.noint)))
			next
		# if it is ...
		for(obj in name.objs) {
			# if it the object exists (i.e. if we're in ADL vs GECM) AND it is not null (i.e. it is supplied)
			if(exists(obj, envir = env, inherits = FALSE) & !(is.null(env[[obj]]))) {
				# do not change (Intercept)
				the.names <- names(env[[obj]])
				keep.int <- the.names == "(Intercept)"
				the.names[!keep.int] <- gsub(patterns[i], "_", the.names[!keep.int])
				names(env[[obj]]) <- the.names				
				
				## OLD: replace everything
				# do the name.objs first
				# names(env[[obj]]) <- gsub(patterns[i], "_", names(env[[obj]]))
			}
		}
		# do the vcov separate since it has both colnames and rownames
		#  don't need an exists, since there is always a vcov
		# Again, protect (Intercept)
		
		the.vcov.temp <- env$the.vcov
		the.vcov.temp.names <- colnames(the.vcov.temp)
		keep.int.vcov <- the.vcov.temp.names == "(Intercept)"
		the.vcov.temp.names[!keep.int.vcov] <- gsub(patterns[i], "_", the.vcov.temp.names[!keep.int.vcov])
		
		# assign both
		colnames(the.vcov.temp) <- rownames(the.vcov.temp) <- the.vcov.temp.names
		env$the.vcov <- the.vcov.temp

		warning(paste0("Variable names containing ", labels[i], " replaced with _"), call. = FALSE)
	}
	invisible(NULL)
}

##########################################
# ---------- (0.6) get.value ----------- #
##########################################
#' Find starting values for predicted values plots from the data in the model frame, if not supplied
#' @param var a string for var the variable to establish a prediction value for
#' @param prediction.values a named list of values for non-y variables in the model, used to calculate a steady-state baseline of the dependent variable when \code{effect.type = "fitted"} and \code{d.y = 0} and \code{baseline.y} is not supplied. Model-based uncertainty will be calculated around the formula for this value. If any differenced variables are included in the model, they should be set to 0. If multiple lags of the same variable are included, they should be set to the same value. Ignored when \code{d.y > 0}
#' @param model the model containing the dataframe for mean estimation if values are not user-supplied (and warn the user if we're taking the mean)
#' @return the numeric value of the relevant variable
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

get.value <- function(var, prediction.values, model) {
	# use the user-supplied prediction value, if it is available
	if(!is.null(prediction.values[[var]]) && !is.na(prediction.values[[var]])) {
		return(prediction.values[[var]])
	}
	# else, take it from the model frame
	if(var %in% names(model.frame(model))) {
		val <- mean(model.frame(model)[[var]], na.rm = TRUE)
		warning(paste0(var, " not in prediction.values; mean of series used"))
		return(val)
	}
}

##########################################
# ---------- (0.7) lrm.existr ---------- #
##########################################
#' Handle LRM existence check
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param h.order the converted integer shock history order (from the shock.history conversion step), if it exists
#' @param cumulative logical for whether the user wants cumulative effects
#' @param calc.d.x the numeric order of differencing of x used in calculation (after inferences.x adjustment)
#' @param calc.d.y the numeric order of differencing of y used in calculation (after inferences.y adjustment)
#' @param effect.type a character string indicating whether to return discrete effects or fitted values. \code{discrete} returns the GDRF as a discrete effect estimate. \code{fitted} returns the GDRF as a fitted value, relative to a baseline value of the dependent variable. The default is \code{discrete}
#' @param return.LRM logical for whether the user wants the LRM returned
#' @return logical for whether a LRM exists to calculate
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

lrm.existr <- function(shock.history, h.order, cumulative, calc.d.x, calc.d.y, effect.type, return.LRM) {
	# Determine if the lrm.exists 
	#  The LRM exists and should be calculated in the following conditions
	#   (a) return.LRM is TRUE
	#   (b) cumulative is TRUE
	#   (c) effect.type is not "fitted" (we suppress the LRM for fitted values)
	#
	#  There are three possibilities:
	#   (a) We don't know: the shock.history is custom
	#   (b) The LRM is sensible: the condition h - d.x + d.y = 0 holds (from the piecewise limit formula)
	#   (c) The LRM is not sensible: the condition h - d.x + d.y = 0 does not hold (from the piecewise limit formula)
	#  Since these formulae reference the original h, we must be sure to pass the original h in the functions!
	
	lrm.exists <- FALSE  # default to FALSE
	
	if(isTRUE(return.LRM)) {
		if(effect.type == "fitted") {
			# keep lrm.exists as FALSE
		} else {
			if(isTRUE(cumulative)) {
				if(is.numeric(shock.history) && length(shock.history) > 1) { # situation (a)
					# For a custom shock history, the LRM condition is not guaranteed. Set lrm.exists to TRUE, but warn
					warning(paste0("The LRM condition (h - d.x + d.y = 0) holds for integer h but is not guaranteed to hold for a custom shock history. Interpret the LRM with caution"))
					lrm.exists <- TRUE
				} else {
					# we increment the h.order by 1 to account for cumulative = TRUE
					# define the LRM condition from Vande Kamp, Jordan, and Rajan
					if(((as.numeric(h.order)+1) - calc.d.x + calc.d.y) == 0) {
						# if there is a well-defined one, then go for it
						lrm.exists <- TRUE  
					} else if(((as.numeric(h.order)+1) - calc.d.x + calc.d.y) < 0) {
						# if we know it is not well defined, override and warn
						warning(paste0("return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned"))
					} else if(((as.numeric(h.order)+1) - calc.d.x + calc.d.y) > 0) {
						# if we know it is not well defined, override and warn				
						warning(paste0("return.LRM = TRUE but the effects diverge to +/-infinity as s -> infinity. No LRM is returned"))
					}
				}
			} else {	
				if(is.numeric(shock.history) && length(shock.history) > 1) { # custom shock histories are ignored without cumulative == TRUE
					# keep lrm.exists as FALSE
				} else {	
					# these, we do not increment: maybe there is an LRM outside of the cumulative aspect
					# define the LRM condition from Vande Kamp, Jordan, and Rajan
					if((as.numeric(h.order) - calc.d.x + calc.d.y) == 0) {
					# if there is a well-defined one, then go for it
						lrm.exists <- TRUE  
					} else if((as.numeric(h.order) - calc.d.x + calc.d.y) < 0) {
						# if we know it is not well defined, override and warn
						warning(paste0("return.LRM = TRUE but the effects decay to 0 as s -> infinity. No LRM is returned"))
					} else if((as.numeric(h.order) - calc.d.x + calc.d.y) > 0) {
						# if we know it is not well defined, override and warn				
						warning(paste0("return.LRM = TRUE but the effects diverge to +/-infinity as s -> infinity. No LRM is returned"))
					}
				}
			}
		}
	}

	# Return the test
	lrm.exists
}


##########################################
# ------- (0.8) shockr.and.cumr -------- #
##########################################
#' Check shock.histories and assign words describing h to integers, if applicable, and cumulative sum them, if required
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param cumulative logical to return the cumulative effects or the period-specific effects of the given \code{shock.history}. For instance, to obtain the Cumulative Impulse Response Function, set \code{shock.history} to -1 and \code{cumulative = TRUE}. The default is \code{FALSE}
#' @return a list of the relevant \code{h.order}/\code{h.order.plot} (if the shock.history was an integer) or the transformed \code{shock.history}
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

shockr.and.cumr <- function(shock.history, s.limit, cumulative) {
	# Dummy checks. Is there a shock history type? 
	if(is.null(shock.history)) {
		stop("shock.history must be specified")
	}
	
	# Dummy checks. Is the shock history valid?
	if(is.character(shock.history)) {
		if(!(shock.history %in% c("pulse", "step", "impulse"))) {
			stop("Invalid shock.history. shock.history must be one of 'pulse' or 'step', a numeric vector for a custom shock history, or any as.numeric integer h representing the order of the GDRF")
  		}
	} else if(is.numeric(shock.history) && length(shock.history) > 1) {
		# Custom shock history vector
		if(!all(is.numeric(shock.history))) {
			stop("Invalid shock.history. A custom shock history must be a numeric vector")
		}
		if(length(shock.history) != s.limit + 1) {
			stop(paste0("Invalid shock.history. A custom shock history must be of length s.limit + 1 (", s.limit + 1, "). The supplied shock history has length ", length(shock.history)))
		}
	} else if(suppressWarnings(!is.na(as.numeric(shock.history)))) {
		# Single integer h
		if(as.numeric(shock.history) %% 1 != 0) {
			stop("Invalid shock.history. shock.history must be one of 'pulse' or 'step', a numeric vector for a custom shock history, or any as.numeric integer h representing the order of the GDRF")
		}
	}

	# turn the shock.history into the argument h.order
	# h.order.plot <- h.order <- ifelse(shock.history %in% c("pulse", "impulse"), -1,
	#			ifelse(shock.history %in% c("step"), 0, NULL))
	h.order.plot <- h.order <- if(is.character(shock.history) && length(shock.history) == 1) {
									# if it's a single word
									if(shock.history %in% c("pulse", "impulse")) -1
									else if (shock.history == "step") 0
									else NULL
								} else if(is.numeric(shock.history) && length(shock.history) == 1) {
									as.numeric(shock.history) # if they passed a single integer as a character for some reason
								} else {
									# all unexpected cases
									NULL
								}

	# If they want the cumulative effect, cumsum the shock history.
	if(isTRUE(cumulative)) { 
		#  If this is a custom shock.history
		if(is.numeric(shock.history) && length(shock.history) > 1) {
			# User supplied a custom numeric vector: cumsum the vector itself
			shock.history <- cumsum(shock.history)
    		} else {
			# shock.history was a word (e.g. "pulse") or a single integer,
			#  both of which have already been converted to h.order.
			# For cumulative, increment h.order by 1.
			h.order <- as.numeric(h.order) + 1
		}
	}
	
	# Return h.order.plot, h.order, and shock.history				
	out <- list(h.order.plot = h.order.plot,
		h.order = h.order,
		shock.history = shock.history)
	out
}

##########################################
# ------ (0.9) inference.adjustr ------- #
##########################################
#' Convert strings about the desired inferences of x/y to values of d.x/d.y; including for eventual plotting
#' @param inferences.y a character string specifying whether the shock to the independent variable is interpreted in levels or differences (of the dependent variable). Valid arguments include \code{levels} or \code{differences}. (For y variables where \code{d.y} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param inferences.x a character string specifying whether the shock to the independent variable is applied in levels or differences. Valid arguments include \code{levels} or \code{differences}. (For independent variables where \code{d.x} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param the.d.y the numeric order of differencing of the relevant form of y (as appropriate to the ADL/GECM)
#' @param the.d.x the numeric order of differencing of the relevant form of x (as appropriate to the ADL/GECM)
#' @return a list of the transformed orders of \code{d.x}/\code{d.y} for calcualting the GDRF or a plotting label, as appropriate
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

inference.adjustr <- function(inferences.y, inferences.x, the.d.y, the.d.x) {
	# if the user wants inferences in differences (the original form of y), we do not need any adjustment
	#  to the dependent variable when we calculate the GDRF, but we do need it preserved for the plot
	if(inferences.y == "differences") {
		calc.d.y <- 0
		plot.d.y <- the.d.y
	} else if(inferences.y == "levels") {
		calc.d.y <- the.d.y
		plot.d.y <- 0		
	}
	# if the user wants inferences in differences (the original form of x), we do not need any adjustment
	#  to the dependent variable when we calculate the GDRF, but we do need it preserved for the plot
	if(inferences.x == "differences") {
		calc.d.x <- 0
		plot.d.x <- the.d.x
	} else if(inferences.x == "levels") {
		calc.d.x <- the.d.x
		plot.d.x <- 0		
	}	
	out <- list(
		calc.d.y = calc.d.y,
		calc.d.x = calc.d.x,
		plot.d.y = plot.d.y,
		plot.d.x = plot.d.x		
	)
	out	
}


##########################################
# ------- (0.10) make.fill.scale ------- #
##########################################
#' Make heatmap colors for interaction plots
#' @param pal the string for the palette desired
#' @param Effect numeric for the effect estimate
#' @return a ggplot color palette
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords internal

make.fill.scale <- function(pal, Effect) {
	cols <- hcl.colors(3, pal)
	scale_fill_gradient2(
		low = cols[1],
		mid = "white",
		high = cols[3],
		midpoint = 0,
		limits = range(c(0, Effect), na.rm = TRUE)
	)
}




#####################################################
# --------------- FUNCTIONS EXPORTED ---------------#
#####################################################

##########################################
# ------ (1) pulse.calculator -----------#
##########################################
#' Generate the (im)pulse formulae for a dynamic linear model
#'
#' Generate the (im)pulse effect formulae for a given autoregressive distributed lag (ADL) model. This is the Impulse Response Function (a one-unit, one-period increase) for the supplied lag structure, assumed to be from a dynamic linear model 
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable and the numbers correspond to the specific lag order of each variable. Can be \code{NULL} if the model has no lagged dependent variables
#' @param limit an integer representing the number of periods after the initial shock (s) to calculate the Impulse Response Function
#' @return a list of limit + 1 \code{mpoly} formulae containing the pulse effect formula in each period
#' @details
#' \code{pulse.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the pulse effect in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. Note: avoid passing characters not allowed by \code{mpoly}
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
# ----- (2a) convolution.calculator ---- #
##########################################
#' Generate the convolved arbitrary (im)pulses formulae for a dynamic linear model
#'
#' Generate the convolved arbitrary (im)pulse effect formulae for an autoregressive distributed lag (ADL) model, given pulse effects. Take the period-specific impulse response functions (presumably pulses from pulse.calculator) and construct an arbitrary set of effects, given an arbitrary shock history and order of differencing of the independent and/or dependent variable
#' @param d.x an integer determining the order of differencing of the x variable before a shock is applied when parametrized as an ADL model. (Generally, this is the same x variable used in \code{pulse.calculator})
#' @param d.y an integer determining the order of differencing of the y variable when parametrized as an ADL model. (Generally, this is the same y variable used in \code{pulse.calculator})
#' @param shocks a numeric vector of dated impulses of the same length as the pulses, 0 to some limit s, determining the shock history applied to the independent variable in levels
#' @param pulses a list comprising the formulae for Impulse Response Functions, typically generated using \code{pulse.calculator}
#' @return a list with two elements: \code{limit} + 1 \code{mpoly} formulae containing the generalized effect formula (for calculating the GDRF) in each period (under \code{formulae}) as well as the actual shock history (under \code{shocks})
#' @details
#' \code{convolution.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the effect in each period for an arbitrary shock history. This is possible because any arbitrary shock history can be decomposed into a sum of dated impulses, and any shock history in differences has an algebraic equivalence to one in levels. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. Note: avoid passing characters not allowed by \code{mpoly}
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
#' # Instead of a generic h-order shock history, suppose we want something bespoke
#' #  like an interrupted trend. Note this is of length s+1 
#  #  also assume this example is in levels
#' my.shocks <- c(1, 2, 3, 0, 0, 4)
#' custom.shock.formulae <- convolution.calculator(d.x = 0, d.y = 0, 
#'								shocks = my.shocks, pulses = pulse.effects)
#' custom.shock.formulae
#' @export

convolution.calculator <- function(d.x, d.y, shocks, pulses) {
	# Since the shock history is bespoke, we will do the d.x and d.y translations separately
	translated.shocks <- shocks
	# translating d.x means differencing the shocks, because the model's x variable is already in differences
	if(d.x > 0) {
		for(i in 1:d.x) {
			translated.shocks <- c(translated.shocks[1], diff(translated.shocks))
		}
	}
	
	# Now, convolve the pulses with the bespoke shock history + the IRFs
	response.list <- vector("list", length(pulses))
  	for(s in 0:(length(pulses)-1)) {
		# For period s, sum shocks_k * IRF_{s-k} for k = 0 to s
		dated.impulses <- vector("list", s + 1)
		for(k in 0:s) {
			# pulse.list[[(s-k)+1]] is IRF at period s-k
			dated.impulses[[k+1]] <- translated.shocks[k+1]*pulses[[(s-k)+1]]
		}
		# Sum all dated impulses at this period
		response.list[[s+1]] <- Reduce("+", dated.impulses)
	}
	
	# Unwinding to d.y just means cumsum-ing (har har) the response d.y times
	if(d.y > 0) {
		for(i in 1:d.y) {
			cumsummed <- vector("list", length(response.list))		
			cumsummed[[1]] <- response.list[[1]]
			for(s in 2:length(response.list)) {
				cumsummed[[s]] <- cumsummed[[s-1]] + response.list[[s]]
			}
			response.list <- cumsummed
		}
	}

	# save the formula for testing. this is the same weirdness as general.calculator
	for(s in 0:(length(pulses)-1)) {
		intermediate <- capture.output(print(response.list[[s+1]], stars = TRUE))
		response.list[[s+1]] <- intermediate
  	}
	
	# Convert translated.shocks vector to list with s+1 elements
	shocks.list <- vector("list", length(pulses))
	for(s in 0:(length(pulses)-1)) {
		shocks.list[[s+1]] <- translated.shocks[1:(s+1)]
	}

	out <- list("formulae" = response.list, "shocks" = shocks.list)
	out
}




##########################################
# ------- (2b) general.calculator -------#
##########################################
#' Generate the generalized (im)pulse formulae for a dynamic linear model
#'
#' Generate the generalized (im)pulse effect formulae for an autoregressive distributed lag (ADL) model, given pulse effects and shock history. Take the period-specific impulse response functions (presumably pulses from pulse.calculator or convolution.calculator) and generalize them according to a shock history h and order of differencing of the independent and/or dependent variable
#' @param d.x an integer determining the order of differencing of the x variable before a shock is applied when parametrized as an ADL model. (Generally, this is the same x variable used in \code{pulse.calculator})
#' @param d.y an integer determining the order of differencing of the y variable when parametrized as an ADL model. (Generally, this is the same y variable used in \code{pulse.calculator})
#' @param h an integer determining the shock history applied to the independent variable in levels. -1 represents the Impulse Response Function. 0 represents a Step Response Function. For others, see Vande Kamp, Jordan, and Rajan
#' @param limit an integer for the number of periods (s) to determine the generalized effect (beginning at 0)
#' @param pulses a list comprising the formulae for Impulse Response Functions, typically generated using \code{pulse.calculator}
#' @return a list with two elements: \code{limit} + 1 \code{mpoly} formulae containing the generalized effect formula (for calculating the GDRF) in each period (under \code{formulae}) as well as the actual shock history (under \code{shocks})
#' @details
#' \code{general.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the generalized effect in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. Note: avoid passing characters not allowed by \code{mpoly}
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
#' # Assume that both x and y are in levels and we want a pulse shock history
#' general.pulse.effects <- general.calculator(d.x = 0, d.y = 0, 
#'								h = -1, limit = s, pulses = pulse.effects)
#' general.pulse.effects
#' # Apply a step shock response function
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
		the.sum <- Reduce("+", the.comb.formula.list)
		# capturing the console does not play nicely directly
		intermediate <- capture.output(print(the.sum, stars = TRUE))
		# save the formula for testing
		the.final.formula.list[[s+1]] <- intermediate # extra for s = 0
		# store the binomials for testing
		the.final.binomial.list[[s+1]] <- the.binomial.list
	}
	# store the binomials as shocks for user verification
	out <- list("formulae" = the.final.formula.list, "shocks" = the.final.binomial.list)
	out
}


##########################################
# --------- (3) yhat.calculator -------- #
##########################################
#' Transform GDRF formulae to fitted value formulae
#'
#' By default, the GDRF assumes the user is interested in effect estimates (the effect of an independent variable on a dependent variable, calculated in levels or differences, as appropriate). yhat.calculator ``adds'' these effects to a baseline value of the dependent variable to observe how its trajectory changes
#' @param formulae the list of formulae from \code{general.calculator} or \code{convolution.calculator}
#' @param d.y an integer for the order of differencing of the y variable in the ADL model
#' @param model the \code{lm} model containing the model estimates
#' @param the.coef the coefficient vector from the estimated model
#' @param y.vrbl a named vector of the (lagged) y variables and corresponding lag orders in the ADL model
#' @param inferences.y a character string that determines whether the inferences for the dependent variable are in levels or differences. Must be one of \code{levels} or \code{differences}
#' @param prediction.values a named list of values for non-y variables in the model, used to calculate a steady-state baseline when \code{d.y = 0} and \code{baseline.y} is not supplied. If any differenced variables are included in the model, they should be set to 0. If multiple lags of the same variable are included, they should be set to the same value (including for interactions). Ignored when \code{d.y > 0}
#' @param baseline.y a user-supplied numeric baseline value of y in levels. For \code{d.y = 0}, this overrides the steady-state calculation from \code{prediction.values}. For \code{d.y > 0} with \code{inferences.y = "levels"}, this is required. Optional uncertainty around this baseline can be supplied through \code{baseline.y.se} in the calling function
#' @param shock.size a numeric value for the size of the shock to x in the units of x. Defaults to 1 (a discrete effect similar to traditional marginal effects)
#' @param z.val a numeric value for the current value of the moderating variable, if the baseline formula contains an interaction
#' @param z.vrbl a named numeric vector in which the names correspond to the ``moderating'' z variables and its lags and the numbers correspond to the specific lag order of each variable, if the baseline formula contains an interaction
#' @param x.z.vrbl a named numeric vector in which the names correspond to the ``interaction'' x:z variables and its lags and the numbers correspond to the specific lag order of each variable. IMPORTANT: enter the lag order that pertains to the ``main'' x variable. For instance, x_l_1_z (contemporaneous x times lagged z) would be 0 and l_1_x_z (lagged x times contemporaneous z) would be 1
#' @return a list of \code{limit} + 1 formula strings containing the fitted value formula in each period
#' @details
#' \code{yhat.calculator} does no calculation. It transforms the formulae from \code{general.calculator} into fitted value formulae by prepending a baseline value of y. For \code{d.y = 0}, the baseline is either a user-supplied value or a model-implied steady-state prediction, the latter of which incorporates model-based uncertainty. For \code{d.y > 0}, the baseline must be user-supplied through \code{baseline.y}, as the model in differences contains no information about the level of y. Optional uncertainty around a user-supplied baseline can be added through \code{baseline.y.se}, it is added as a post-processing step in the calling function. This ability to observe fitted values of y is most sensible when the underlying model is originally estimated in levels of the dependent variable (so that a pre-shock baseline can be calculated and model-based uncertainty can be added). When the dependent variable is differenced, the baseline is arbitrary (as the model is ignorant of any underlying history or level of the dependent variable). These formulae are evaluated by \code{deltaMethod} in the calling function
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords utilities
#' @examples
#' # ADL model with y in levels
#' model.levels <- lm(y ~ x + l_1_x + l_1_y, data = toy.ts.interaction.data)
#'
#' # set up formulae
#' pulses.levels <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_y" = 1), limit = 5)
#' general.levels <- general.calculator(d.x = 0, d.y = 0, h = -1,
#' 	limit = 5, pulses = pulses.levels)
#'
#' # I(0) y: steady state from means (warns about differenced variables)
#' #  Note this would mean different values for x and l_1_x, which might be undesirable
#' yhat.calculator(formulae = general.levels$formulae, d.y = 0,
#' 	model = model.levels, the.coef = coef(model.levels),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
#' 	prediction.values = NULL, baseline.y = 0, shock.size = 1)
#'
#' # I(0) y: steady state from supplied prediction.values (same values for both x/l_1_x)
#' yhat.calculator(formulae = general.levels$formulae, d.y = 0,
#' 	model = model.levels, the.coef = coef(model.levels),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
#' 	prediction.values = list("x" = 1, "l_1_x" = 1),
#' 	baseline.y = NULL, shock.size = 1)
#'
#' # I(0) y: user-supplied baseline.y overrides prediction.values
#' yhat.calculator(formulae = general.levels$formulae, d.y = 0,
#' 	model = model.levels, the.coef = coef(model.levels),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
#' 	prediction.values = list("x" = 0, "l_1_x" = 1),
#' 	baseline.y = 5, shock.size = 1)
#'
#' # ADL model with differenced y
#' model.diffs <- lm(d_y ~ x + l_1_x + l_1_d_y, data = toy.ts.interaction.data)
#'
#' # set up formulae
#' pulses.diffs <- pulse.calculator(x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_d_y" = 1), limit = 5)
#' general.diffs <- general.calculator(d.x = 0, d.y = 1, h = -1,
#' 	limit = 5, pulses = pulses.diffs)
#'
#' \dontrun{
#' # inferences in differences, baseline.y != 0. warn that this makes no sense (implies the
#' #  model is always changing) and change baseline.y to 0
#' yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
#' 	model = model.diffs, the.coef = coef(model.diffs),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "differences",
#' 	baseline.y = 3, shock.size = 1)
#' 	
#' # inferences in differences, shock size of 1: identical to discrete effect (warns)
#' yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
#' 	model = model.diffs, the.coef = coef(model.diffs),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "differences",
#' 	baseline.y = NULL, shock.size = 1)
#'
#' # inferences in differences, shock size of 2: scales the discrete effect
#' #  Since we're asking for inferences.y in differences, the baseline will automatically be 0
#' yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
#' 	model = model.diffs, the.coef = coef(model.diffs),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "differences",
#' 	baseline.y = NULL, shock.size = 2)
#'
#' # inferences in levels with no baseline.y: stops with an error
#' yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
#' 	model = model.diffs, the.coef = coef(model.diffs),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
#' 	baseline.y = NULL, shock.size = 2)
#'
#' # inferences in levels with prediction.values but no baseline.y: warns and stops
#' yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
#' 	model = model.diffs, the.coef = coef(model.diffs),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
#' 	prediction.values = list("x" = 1, "l_1_x" = 1),
#' 	baseline.y = NULL, shock.size = 2)
#' }
#'
#' # inferences in levels with a supplied baseline
#' yhat.calculator(formulae = general.diffs$formulae, d.y = 1,
#' 	model = model.diffs, the.coef = coef(model.diffs),
#' 	y.vrbl = c("l_1_y" = 1), inferences.y = "levels",
#' 	prediction.values = list("x" = 1, "l_1_x" = 1),
#' 	baseline.y = 5, shock.size = 2)
#' @export

yhat.calculator <- function(formulae, d.y, model, the.coef, y.vrbl = NULL, inferences.y = NULL, prediction.values = NULL, baseline.y = NULL, shock.size = 1, z.val = NULL, z.vrbl = NULL, x.z.vrbl = NULL) {
	# need two cases: I(0) y and I(1) y
	if(d.y == 0) {
		# If y is I(0), we can either take a baseline value (with potential embedded uncertainty) or calculate a steady-state value
		if(!is.null(baseline.y)) {
			# set the baseline as the baseline
			baseline <- baseline.formula <- baseline.y
		} else {
			if(is.null(prediction.values)) {
				stop("No baseline or predicted values for y in levels for yhat.calculator")
			}
			if(any(names(z.vrbl) %in% names(prediction.values))) {
				stop("Do not supply value for any z.vrbl in prediction.values. These come from z.val")
			}
			# calculate the baseline from the predicted values
			# for everything that isn't y (or z, if an interaction), check in prediction.values
			#  (y will be dynamically created from steady state)
			noty.coef <- setdiff(names(the.coef), c(names(y.vrbl), "(Intercept)"))
			steady.vals <- c("(Intercept)" = 1, sapply(noty.coef, function(v) {
													if(!is.null(z.val) && v %in% names(z.vrbl)) { # z.vrbl
														z.val
													} else if(!is.null(z.val) && v %in% names(x.z.vrbl)) { # interaction variable
														get.value(var = v, prediction.values = prediction.values, model = model) * z.val
													} else { #  anything else: probably used the most
														get.value(var = v, prediction.values = prediction.values, model = model)
													}
												}
							))
			
			# Define the formula representation that we will pass. this will not have a numeric
			steady.vals.formula <- c("(Intercept)" = 1, sapply(noty.coef, function(v) {
													if(!is.null(z.val) && v %in% names(z.vrbl)) { # z.vrbl
														"z_val"
													} else if(!is.null(z.val) && v %in% names(x.z.vrbl)) { # interaction variable
														paste0(get.value(var = v, prediction.values = prediction.values, model = model), "* z_val")
													} else { #  anything else: probably used the most
														get.value(var = v, prediction.values = prediction.values, model = model)
													}
												}
							))
							
        		# define the steady state value of y (s = -1, pre-treatment) as a formula
        		# If it's an FDL, there is no denominator
			if(is.null(y.vrbl)) {
				baseline <- paste0("((Intercept) + ", paste(paste0(steady.vals[-1], " * ", names(steady.vals[-1])), collapse = " + "), ")")
				baseline.formula <- paste0("((Intercept) + ", paste(paste0(steady.vals.formula[-1], " * ", names(steady.vals.formula[-1])), collapse = " + "), ")")
			} else {
				baseline <- paste0("((Intercept) + ", paste(paste0(steady.vals[-1], " * ", names(steady.vals[-1])), collapse = " + "), ") / (1 - (", paste(names(y.vrbl), collapse = " + "), "))")
				baseline.formula <- paste0("((Intercept) + ", paste(paste0(steady.vals.formula[-1], " * ", names(steady.vals.formula[-1])), collapse = " + "), ") / (1 - (", paste(names(y.vrbl), collapse = " + "), "))")
			}			
		}
	
	
	} else if(d.y == 1) {
		# I(1) case: use user-supplied baseline.y
		if(inferences.y == "differences") {
			# if they're asking for inferences in differences, there is no baseline to change (since it's still in differences). so we set it to 0
			baseline <- baseline.formula <- 0
		} else if (inferences.y == "levels") {
			# if it's in levels, we just set it to their arbitrary baseline.
			if(is.null(prediction.values) && is.null(baseline.y)) {
				stop("No baseline or predicted values for y in levels for yhat.calculator")
			}			
			baseline <- baseline.formula <- baseline.y
		}
	}
	
    # modify formulae: prepend baseline to each formula string
	modified.formulae <- lapply(formulae, function(f) {
		paste0(baseline, " + ", shock.size, " * (", f, ")")
	})
	
    # modify symbolic formulae: prepend baseline to each formula string
	modified.symbolic.formulae <- lapply(formulae, function(f) {
		paste0(baseline.formula, " + ", shock.size, " * (", f, ")")
	})
	
	# Finally, add the baseline to the front. 
	modified.formulae <- c(list(paste(baseline)), modified.formulae)
	modified.symbolic.formulae <- c(list(paste(baseline.formula)), modified.symbolic.formulae)
	
	out <- list(modified.formulae = modified.formulae, modified.symbolic.formulae = modified.symbolic.formulae)
	out
}


#########################################
# --------- (4) gecm.to.adl ------------#
#########################################
#' Use equivalencies to translate GECM coefficients to ADL coefficients
#'
#' Translate the coefficients from the General Error Correction Model (GECM) to the autoregressive distributed lag (ADL) model. The ADL and the GECM are isomorphic, so this translation loses no information from the model
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable (of the lower level of differencing, usually in levels d = 0) and its lags and the numbers correspond to the specific lag order of each variable in the GECM model
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the lower level of differencing, usually in levels d = 0) and the numbers correspond to the specific lag order of each variable in the GECM model
#' @param x.d.vrbl a named numeric vector in which the names correspond to an independent variable (of the higher level of differencing, usually in first differences d = 1) and its lags and the numbers correspond to the specific lag order of each variable in the GECM model
#' @param y.d.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the higher level of differencing, usually in first differences d = 1) and the numbers correspond to the specific lag order of each variable in the GECM model
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

	# lagged differenced DV is not required for the model
	if(is.null(y.d.vrbl)) {
		y.d.vrbl.helper <- numeric(0)
	} else {
		y.d.vrbl.helper <- 1:max(y.d.vrbl)
		for(i in 1:max(y.d.vrbl)) {
			if(i %in% y.d.vrbl) {
				names(y.d.vrbl.helper)[i] <- names(y.d.vrbl)[which(y.d.vrbl == i)]
			} else {
				names(y.d.vrbl.helper)[i] <- 0
			}
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
		} else if(q == 1 & max(x.d.vrbl.helper) == 0) {
			# if there is just contemporaneous differences, there is another one-off special formula
			names(x.vrbl.adl)[which(x.vrbl.adl == 1)] <- paste0(names(x.vrbl.helper)[which(x.vrbl.helper == 1)], "-", names(x.d.vrbl.helper)[which(x.d.vrbl.helper == 0)])
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
	
	# for y
	if(is.null(y.d.vrbl)) {
		# lagged differenced DV is not required for the model
		#  if it is not there, then the ADL representation will be a single lag in levels + 1
		y.vrbl.adl <- 1
		names(y.vrbl.adl) <- paste0(names(y.vrbl.helper)[1], "+1")
	} else {
		# y will start at 1
		#  Notice the ADL order is one order higher than the GECM order	
		y.vrbl.adl <- 1:(max(y.d.vrbl.helper)+1)
		# For all of the below, p is defined in terms of the ADL side
		for(p in 1:max(y.vrbl.adl)) {
			# 1 is one-off formula
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
	}
	out <- list(x.vrbl.adl = x.vrbl.adl, y.vrbl.adl = y.vrbl.adl)
	out
}

##########################################
# --------- (5) GDRF.adl.plot -----------#
##########################################
#' Evaluate and/or plot the General Dynamic Response Function (GDRF) for an ADL
#'
#' Evaluate (and possibly plot) the General Dynamic Response Function (GDRF) for an autoregressive distributed lag (ADL) model, making use of the GDRF framework (described below and in Vande Kamp, Jordan, and Rajan)
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable and the numbers correspond to the specific lag order of each variable. Can be \code{NULL} if the model has no lagged dependent variables
#' @param d.x an integer describing how many times the independent variable was differenced before model estimation
#' @param d.y an integer describing how many times the dependent variable was differenced before model estimation
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param inferences.x a character string specifying whether the shock to the independent variable is applied in levels or differences. Valid arguments include \code{levels} or \code{differences}. (For independent variables where \code{d.x} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param inferences.y a character string specifying whether the shock to the independent variable is interpreted in levels or differences (of the dependent variable). Valid arguments include \code{levels} or \code{differences}. (For y variables where \code{d.y} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param effect.type a character string indicating whether to return discrete effects or fitted values. \code{discrete} returns the GDRF as a discrete effect estimate. \code{fitted} returns the GDRF as a fitted value, relative to a baseline value of the dependent variable. The default is \code{discrete}
#' @param cumulative logical to return the cumulative effects or the period-specific effects of the given \code{shock.history}. For instance, to obtain the Cumulative Impulse Response Function, set \code{shock.history} to -1 and \code{cumulative = TRUE}. The default is \code{FALSE}
#' @param prediction.values a named list of values for non-y variables in the model, used to calculate a steady-state baseline of the dependent variable when \code{effect.type = "fitted"} and \code{d.y = 0} and \code{baseline.y} is not supplied. Model-based uncertainty will be calculated around the formula for this value. If any differenced variables are included in the model, they should be set to 0. If multiple lags of the same variable are included, they should be set to the same value. Ignored when \code{d.y > 0}
#' @param baseline.y a numeric value for the user-supplied baseline value of y in levels (i.e. the baseline value for effects to accumulate from). Only used when \code{effect.type = "fitted"}. For \code{d.y = 0}, this overrides the steady-state calculation from \code{prediction.values} if provided
#' @param baseline.y.se a numeric value for the user-supplied standard error for the baseline value of y (to suggest uncertainty around predictions). Only used when \code{effect.type = "fitted"} and \code{inferences.y = "levels"}. If supplied, this is added in quadrature to the standard errors of the GDRF estimates. The default is 0: in recognition that this is user-constructed uncertainty. Possible values would be the square root of the standard deviation of y (in levels)
#' @param shock.size a numeric value for the size of the shock to x in the units of x. Defaults to 1 (a discrete effect similar to traditional marginal effects)
#' @param dM.level a numeric value for the significance level of the GDRF, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.LRM logical to return the LRM in the estimates and plots, should the LRM exist for that combination of \code{shock.history} and \code{cumulative}. The default is \code{TRUE}
#' @param return.data logical to return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot logical to return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae logical to return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{shocks} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return if just one of \code{return.data}, \code{return.plot}, and \code{return.formulae} is \code{TRUE}, \code{GDRF.adl.plot} will return just the requested output. If more than one is selected (or just \code{return.data} is selected), it will return a list with elements \code{plot} (for the plot), \code{estimates} (for the data), and \code{formulae} and \code{shocks} for the GDRF formula for each period as well as the applied shock history in integer form
#' @importFrom stats lm coef vcov qnorm
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @importFrom utils capture.output
#' @import ggplot2
#' @details
#' Internally, GDRF.adl.plot uses the separate subfunctions \code{pulse.calculator}, \code{convolution.calculator}/\code{general.calculator}, and (possibly) \code{yhat.calculator} to generate the effect estimates representing the GDRF. These estimates represent the effect of the independent variable (in levels or differences, depending on \code{d.x}) on the dependent variable (in levels or differences, depending on \code{d.y}), given a shock applied to the independent variable (in levels or differences, depending on \code{inferences.x}). The effect on the dependent variable can be calculated in its differenced form or levels form, depending on \code{inferences.y}. The shock history is determined by \code{shock.history}. For more information, see Vande Kamp, Jordan, and Rajan. We assume that the ADL model estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords ADL GDRF
#' @examples
#' 
#' # ADL(1,1)
#' # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository
#' model.toydata <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
#'
#' # Pulse effect of x
#' GDRF.adl.plot(model = model.toydata,
#' 	x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_y" = 1),
#' 	d.x = 0,
#' 	d.y = 0,
#' 	shock.history = "pulse",
#' 	inferences.y = "levels",
#' 	inferences.x = "levels",
#' 	s.limit = 20)
#'
#' # Step effect of x. You can store the data to draw your own plot,
#' #  if you prefer
#' test.step <- GDRF.adl.plot(model = model.toydata,
#' 	x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_y" = 1),
#' 	d.x = 0,
#' 	d.y = 0,
#' 	shock.history = "step",
#' 	inferences.y = "levels",
#' 	inferences.x = "levels",
#' 	s.limit = 20)
#' test.step$plot
#'
#' # Cumulative Impulse Response effect of x. For the dynamic linear model,
#' #  this is equivalent to the step effect
#' test.cumulative <- GDRF.adl.plot(model = model.toydata,
#' 	x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_y" = 1),
#' 	d.x = 0,
#' 	d.y = 0,
#' 	shock.history = "pulse",
#'  cumulative = TRUE,
#' 	inferences.y = "levels",
#' 	inferences.x = "levels",
#' 	s.limit = 20)
#' test.cumulative$plot
#'
#' # Fitted values: steady state baseline from prediction.values
#' GDRF.adl.plot(model = model.toydata,
#' 	x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_y" = 1),
#' 	d.x = 0,
#' 	d.y = 0,
#' 	shock.history = "pulse",
#' 	inferences.y = "levels",
#' 	inferences.x = "levels",
#' 	effect.type = "fitted",
#' 	prediction.values = list("x" = 0, "l_1_x" = 0),
#' 	s.limit = 20)
#'
#' @export

GDRF.adl.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, d.x = NULL, d.y = NULL,
	shock.history = "pulse", inferences.y = "levels", inferences.x = "levels",
	effect.type = "discrete", cumulative = FALSE, 
	prediction.values = NULL, baseline.y = NULL, baseline.y.se = 0, shock.size = 1,  # these are new for the yhats
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.LRM = TRUE, return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
	...) {
	
	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared GDRF dummy check
	########################################################################
	GDRF.dummy.checks(effect.type = effect.type, prediction.values = prediction.values, baseline.y = baseline.y, baseline.y.se = baseline.y.se, 
						shock.size = shock.size, d.y = d.y, inferences.y = inferences.y, type = "GDRF")

	########################################################################
	# subfunctions for shared adl dummy check
	########################################################################
	adl.dummy.checks(x.vrbl = x.vrbl, y.vrbl = y.vrbl, z.vrbl = NULL, x.z.vrbl = NULL, 
						d.x = d.x, d.y = d.y, inferences.x = inferences.x, inferences.y = inferences.y, 
						the.coef = the.coef, se.type = se.type, type = "GDRF")

	########################################################################
	# subfunctions for shock history translation
	########################################################################
	shocks.transformed <- shockr.and.cumr(shock.history = shock.history, s.limit = s.limit, cumulative = cumulative)
	shock.history <- shocks.transformed$shock.history
	h.order <- shocks.transformed$h.order
	h.order.plot <- shocks.transformed$h.order.plot	

	########################################################################
	# convert inferences to numeric, assign vcov, and replace _
	########################################################################
	# translate strings of inferences.x/inferences.y to numerics
	new.inferences <- inference.adjustr(inferences.y = inferences.y, inferences.x = inferences.x, the.d.y = d.y, the.d.x = d.x)
	calc.d.x <- new.inferences$calc.d.x
	calc.d.y <- new.inferences$calc.d.y
	plot.d.x <- new.inferences$plot.d.x
	plot.d.y <- new.inferences$plot.d.y
	
	the.vcov <- vcovHC(model, type = se.type)

	# mpoly does not play nicely with _, (, ), ,, or  . all are typically found in dynlm objects
	#  We have to replace and warn	
	mpoly.subber(env = environment())

	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pulse.calculator(x.vrbl = x.vrbl, y.vrbl = y.vrbl, limit = s.limit)

	# With the PTE, apply either convolution.calculator (custom shock.history) or general.calculator (h integer GDRF)
	if(length(shock.history) > 1) {
		the.final.formulae <- convolution.calculator(d.x = calc.d.x, d.y = calc.d.y, shocks = shock.history, pulses = the.pte.formula.list)
	} else {
		the.final.formulae <- general.calculator(d.x = calc.d.x, d.y = calc.d.y, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	}

	# Generate the effects: discrete effects or fitted values. Allow either to be scaled	
	if(effect.type == "discrete") {
		# scale formulae by shock.size. this is identical to the scaling in yhat.calculator. we will only do this if it is not 1 to prevent
		#  the formulae from looking stupid
		if(shock.size != 1) {
			scaled.formulae <- lapply(the.final.formulae$formulae, function(f) {
				paste0(shock.size, " * (", f, ")")
			})
		} else {
			scaled.formulae <- the.final.formulae$formulae
		}
		
		# establish container for results	
		dat.out <- cbind(0:s.limit, t(sapply(scaled.formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
  
		# update formulae to scaled versions
		the.final.formulae$formulae <- scaled.formulae
  
		# name the formula list
		names(the.final.formulae$formulae) <- names(the.final.formulae$shocks) <- paste0("s = ", 0:s.limit)

	} else if(effect.type == "fitted") {
		to.evaluate <- yhat.calculator(formulae = the.final.formulae$formulae, d.y = d.y,
			model = model, the.coef = the.coef, y.vrbl = y.vrbl,
			inferences.y = inferences.y, prediction.values = prediction.values,
			baseline.y = baseline.y, shock.size = shock.size)$modified.formulae

		dat.out <- cbind(c("baseline", 0:s.limit), t(sapply(to.evaluate, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))

		the.final.formulae$formulae <- to.evaluate
				
		# yhat.calculator appends the baseline formula to the front of the list. we will apppend a similar ``0'' binomial
		the.final.formulae$shocks <- c(list(0), the.final.formulae$shocks)
		
		# name the formula list. Remember that the fitted have a baseline appended to them
		names(the.final.formulae$formulae) <- names(the.final.formulae$shocks) <- c("baseline", paste0("s = ", 0:s.limit))
    }
	
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDRF", "SE", "Lower", "Upper")

	########################################################################
	# post-processing: add baseline.y.se if supplied (I(1) fitted values only)
	########################################################################
	if(effect.type == "fitted" & inferences.y == "levels") {
		if(baseline.y.se == 0) {
			dat.out$SE <- dat.out$SE
		} else {
			# add baseline.y.se in quadrature to the SE of the GDRF estimates
			#  since we're just asserting the standard error of y, we can add them (they're independent)
			dat.out$SE <- sqrt(dat.out$SE^2 + baseline.y.se^2)
			dat.out$Lower <- dat.out$GDRF - qnorm(1 - (1 - dM.level)/2) * dat.out$SE 
			dat.out$Upper <- dat.out$GDRF + qnorm(1 - (1 - dM.level)/2) * dat.out$SE			
		}
	}
	
	########################################################################
	# deal with LRM
	########################################################################	
	# Adjust this function later if we want: it excludes all fitted values from LRM calculations
	lrm.exists <- lrm.existr(shock.history = shock.history, h.order = h.order.plot, cumulative = cumulative, 
						calc.d.x = calc.d.x, calc.d.y = calc.d.y, effect.type = effect.type, return.LRM = return.LRM)
	
	if(lrm.exists == TRUE) {
		# calculate the LRM. start with all of the relevant betas in the numerator, regardless of order
		lrm.numerator <- paste0(names(x.vrbl), collapse = "+")
		# Denominator is the alpha.is. these are unweighted in the sum
		#  so we don't have to do anything but combine them!
		
		# if it's a custom shock history, then the cumulative amount is the last place of the (cumulative) shock history
		if(is.numeric(shock.history) && length(shock.history) > 1) {
			if(is.null(y.vrbl)) {
				lrm <- paste0(shock.history[length(shock.history)], " * ", shock.size, " * (", lrm.numerator, ")")
			} else {
				lrm <- paste0("(", shock.history[length(shock.history)], " * ", shock.size, " * (", lrm.numerator, "))/(1-(", paste(names(y.vrbl), collapse = "+"), "))")		
			}			
		} else { # if it is an integer h, easy
			if(is.null(y.vrbl)) {
				lrm <- paste0(shock.size, " * (", lrm.numerator, ")")
			} else {
				lrm <- paste0("(", shock.size, " * (", lrm.numerator, "))/(1-(", paste(names(y.vrbl), collapse = "+"), "))")		
			}
		}	
		# save the LRM formula for testing
		the.final.formulae$formulae$"LRM" <- lrm
		# evaluate the LRM and add to the dataset as the s.limit + 1 period
		lrm.dat <- c(as.matrix(s.limit+1), as.matrix(deltaMethod(the.coef, lrm, vcov. = the.vcov, level = dM.level)))
		dat.out <- rbind(dat.out, as.numeric(lrm.dat))
	}
	
	########################################################################
	# deal with y label and the baseline period in fitted
	########################################################################
	if(effect.type == "discrete") {
		# If it's custom, just a generic label
		if(length(shock.history) > 1) {
			y.lab <- ifelse(cumulative == TRUE,
				"Cumulative Discrete Effect of Shock History",
				"Discrete Effect of Shock History")
		} else { # conditional assignment if cumulative = TRUE or FALSE
			y.lab <- if(cumulative == TRUE) {
					bquote("Cumulative" ~ GDRF[.(paste0("(", s.limit, ", ", h.order.plot, ", ", plot.d.y, ", ", plot.d.x, ")"))])
				} else {
					bquote(GDRF[.(paste0("(", s.limit, ", ", h.order.plot, ", ", plot.d.y, ", ", plot.d.x, ")"))])
			}
		}
		dat.out$Period.plot <- as.numeric(dat.out$Period)
		x.breaks <- seq(0, s.limit, length.out = 5)
		x.labels <- seq(0, s.limit, length.out = 5)
	} else if(effect.type == "fitted") {
		# If it's custom, just a generic label
		if(length(shock.history) > 1) {
			y.lab <- ifelse(cumulative == TRUE,
				"Cumulative Fitted Values of Shock History",
				"Fitted Values of Shock History")
		} else { # conditional assignment if cumulative = TRUE or FALSE
			y.lab <- if(cumulative == TRUE) {
					bquote("Cumulative Fitted Values of" ~ GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ", plot.d.x, ")"))])
				} else {
					bquote("Fitted Values of" ~ GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ", plot.d.x, ")"))])
			}
		}
		dat.out$Period.plot <- suppressWarnings(ifelse(dat.out$Period == "baseline", -1, as.numeric(dat.out$Period)))
		x.breaks <- c(-1, seq(0, s.limit, length.out = 5))
		x.labels <- c("Baseline", seq(0, s.limit, length.out = 5))
	}

	########################################################################
	# plotting
	########################################################################
	# We're going to separate them because of the LRM
	Effect <- Effect.sig <- GDRF <- Lower <- Period <- Upper <- Z <- Period.plot <- NULL
	if(lrm.exists == FALSE) {
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
						# geom_hline(yintercept = 0, lwd = 1) +
						scale_x_continuous(breaks = x.breaks, labels = x.labels) +
						xlab("Number of Periods Since Initial Shock (s)") +
						ylab(y.lab) +
						theme_bw() + 
							theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
		if(effect.type == "discrete") {
			plot.out <- plot.out +
			geom_hline(yintercept = 0, lwd = 1)
		}										
	} else if(lrm.exists == TRUE) { # if there is an LRM (note that fitted will NEVER end up here: otherwise we would have to change the indexing for the data calls and the scale)
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
		# make a small dataset that excludes the LRM
		plotting.data.nolrm <- dat.out[(dat.out$Period.plot != s.limit + 1),]
		plotting.data.lrm <- dat.out[(dat.out$Period.plot %in% (s.limit + 1)),]
		plotting.data.lrm$Period <- lrm.space
		plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period.plot, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = plotting.data.nolrm, aes(ymin = .data$Lower, ymax = .data$Upper), color = "black", linetype = 1, alpha = 0.2) +
						# geom_hline(yintercept = 0, lwd = 1) +
						geom_segment(data = plotting.data.lrm, aes(x = .data$Period, xend = .data$Period, y = .data$Lower, yend = .data$Upper), lwd = 1.25, color = "black") +
						geom_point(data = plotting.data.lrm, aes(x = .data$Period, y = .data$GDRF), size = 3) +
						scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), lrm.space), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
						xlab("Number of Periods Since Initial Shock (s)") +	
						ylab(y.lab) +
						theme_bw() + 
						theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
		if(effect.type == "discrete") {
			plot.out <- plot.out +
			geom_hline(yintercept = 0, lwd = 1)
		}								
		# rename last row: account for the 0 at the beginning of s
		dat.out$Period[nrow(dat.out)] <- "LRM"	
	}
	
	# drop the Period.plot. Users don't need this lol
	dat.out$Period.plot <- NULL
	
	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
	out
}


##########################################
# ----------- (5.1) adl.plot ----------- #
##########################################
#' Evaluate and/or plot the General Dynamic Response Function (GDRF) for an ADL assumed in levels
#'
#' Evaluate (and possibly plot) the General Dynamic Response Function (GDRF) for an autoregressive distributed lag (ADL) model, making use of the GDRF framework (described below and in Vande Kamp, Jordan, and Rajan), assuming the underlying model is in levels (\code{d.x} = \code{d.y} = 0) and the user wants a discrete effect (the untransformed GDRF) with a shock size of 1. (This is just a wrapper for \code{GDRF.adl.plot} with simplifying assumptions)
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable and the numbers correspond to the specific lag order of each variable. Can be \code{NULL} if the model has no lagged dependent variables
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param dM.level a numeric value for the significance level of the GDRF, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data logical to return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot logical to return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae logical to return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{shocks} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return if just one of \code{return.data}, \code{return.plot}, and \code{return.formulae} is \code{TRUE}, \code{adl.plot} will return just the requested output. If more than one is selected (or just \code{return.data} is selected), it will return a list with elements \code{plot} (for the plot), \code{estimates} (for the data), and \code{formulae} and \code{shocks} for the GDRF formula for each period as well as the applied shock history in integer form
#' @importFrom stats lm coef vcov
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @importFrom utils capture.output
#' @import ggplot2
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords ADL GDRF
#' @examples
#' 
#' # ADL(1,1)
#' # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository
#' model.toydata <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
#'
#' # Since this is in levels, we can quickly look at the adl.plot
#' #  Pulse effect of x
#' adl.plot(model = model.toydata,
#' 	x.vrbl = c("x" = 0, "l_1_x" = 1),
#' 	y.vrbl = c("l_1_y" = 1),
#' 	shock.history = "pulse",
#' 	s.limit = 20)
#' 
#' @export

adl.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL,
                          shock.history = "pulse",
                          dM.level = 0.95, s.limit = 20, se.type = "const",
                          return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
                          ...) {
                          	
	out <- GDRF.adl.plot(model = model, x.vrbl = x.vrbl, y.vrbl = y.vrbl, d.x = 0, d.y = 0,
		shock.history = shock.history, inferences.y = "levels", inferences.x = "levels",
		effect.type = "discrete", cumulative = FALSE, 
		prediction.values = NULL, baseline.y = NULL, baseline.y.se = 0, shock.size = 1,  # these are new for the yhats
		dM.level = dM.level, s.limit = s.limit, se.type = se.type,
		return.LRM = TRUE, return.data = return.data, return.plot = return.plot, return.formulae = return.formulae, ... = ...)
	
	out
}


##########################################
# -------- (6) GDRF.gecm.plot ---------- #
##########################################
#' Evaluate and/or plot the General Dynamic Response Function (GDRF) for a GECM
#'
#' Evaluate (and possibly plot) the General Dynamic Response Function (GDRF) for a Generalized Error Correction Model (GECM), making use of the GDRF framework (described below and in Vande Kamp, Jordan, and Rajan)
#' @param model the \code{lm} model containing the GECM estimates
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags (of the lower order of differencing, usually in levels d = 0) and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the lower order of differencing, usually in levels d = 0) and the numbers correspond to the specific lag order of each variable
#' @param x.vrbl.d.x an integer describing how many times the independent variable (of the lower order of differencing, usually in levels d = 0) was differenced before model estimation
#' @param y.vrbl.d.y an integer describing how many times the dependent variable (of the lower order of differencing, usually in levels d = 0) was differenced before model estimation
#' @param x.d.vrbl a named numeric vector in which the names correspond to an independent variable and its lags (of the higher order of differencing, usually in first differences d = 1) and the numbers correspond to the specific lag order of each variable
#' @param y.d.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the higher order of differencing, usually in first differences d = 1) and the numbers correspond to the specific lag order of each variable
#' @param x.d.vrbl.d.x an integer describing how many times the independent variable (of the higher order of differencing, usually in first differences d = 1) was differenced before model estimation
#' @param y.d.vrbl.d.y an integer describing how many times the dependent variable (of the higher order of differencing, usually in first differences d = 1) was differenced before model estimation
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param inferences.x a character string specifying whether the shock to the independent variable is applied in levels or differences. Valid arguments include \code{levels} or \code{differences}. (For independent variables where \code{d.x} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param inferences.y a character string specifying whether the shock to the independent variable is interpreted in levels or differences (of the dependent variable). Valid arguments include \code{levels} or \code{differences}. (For y variables where \code{d.y} is 0, this is automatically \code{levels}.) The default is \code{levels}
#' @param effect.type a character string indicating whether to return discrete effects or fitted values. \code{discrete} returns the GDRF as a discrete effect estimate. \code{fitted} returns the GDRF as a fitted value, relative to a baseline value of the dependent variable. The default is \code{discrete}
#' @param cumulative logical to return the cumulative effects or the period-specific effects of the given \code{shock.history}. For instance, to obtain the Cumulative Impulse Response Function, set \code{shock.history} to -1 and \code{cumulative = TRUE}. The default is \code{FALSE}
#' @param prediction.values a named list of values for non-y variables in the model, used to calculate a steady-state baseline of the dependent variable when \code{effect.type = "fitted"} and \code{y.vrbl.d.y = 0} and \code{baseline.y} is not supplied. Model-based uncertainty will be calculated around the formula for this value. If any differenced variables are included in the model, they should be set to 0. If multiple lags of the same variable are included, they should be set to the same value. Ignored when \code{y.vrbl.d.y > 0}
#' @param baseline.y a numeric value for the user-supplied baseline value of y in levels (i.e. the baseline value for effects to accumulate from). Only used when \code{effect.type = "fitted"}. For \code{y.vrbl.d.y = 0}, this overrides the steady-state calculation from \code{prediction.values} if provided
#' @param baseline.y.se a numeric value for the user-supplied standard error for the baseline value of y (to suggest uncertainty around predictions). Only used when \code{effect.type = "fitted"} and \code{inferences.y = "levels"}. If supplied, this is added in quadrature to the standard errors of the GDRF estimates. The default is 0: in recognition that this is user-constructed uncertainty. Possible values would be the square root of the standard deviation of y (in levels)
#' @param shock.size a numeric value for the size of the shock to x in the units of x. Defaults to 1 (a discrete effect similar to traditional marginal effects)
#' @param dM.level a numeric value for the significance level of the GDRF, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.LRM logical to return the LRM in the estimates and plots, should the LRM exist for that combination of \code{shock.history} and \code{cumulative}. The default is \code{TRUE}
#' @param return.data logical to return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot logical to return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae logical to return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{shocks} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return if just one of \code{return.data}, \code{return.plot}, and \code{return.formulae} is \code{TRUE}, \code{GDRF.gecm.plot} will return just the requested output. If more than one is selected (or just \code{return.data} is selected), it will return a list with elements \code{plot} (for the plot), \code{estimates} (for the data), and \code{formulae} and \code{shocks} for the GDRF formula for each period as well as the applied shock history in integer form
#' @importFrom stats lm coef vcov qnorm
#' @importFrom mpoly mp
#' @importFrom sandwich vcovHC
#' @importFrom car deltaMethod
#' @import ggplot2
#' @details
#' Internally, GDRF.gecm.plot uses the subfunction \code{gecm.to.adl} to convert the GECM coefficients to ADL coefficients before calculating the GDRF. From there, it uses the separate subfunctions \code{pulse.calculator}, \code{convolution.calculator}/\code{general.calculator}, and (possibly) \code{yhat.calculator} to generate the effect estimates representing the GDRF. The shock history is determined by \code{shock.history}. For more information, see Vande Kamp, Jordan, and Rajan. We assume that the GECM estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords GECM GDRF
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
	effect.type = "discrete", cumulative = FALSE, 
	prediction.values = NULL, baseline.y = NULL, baseline.y.se = 0, shock.size = 1,  # these are new for the yhats	
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.LRM = TRUE, return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
	...) {

	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared GDRF dummy check
	########################################################################
	if(!is.null(prediction.values)) {
		stop("prediction.values not suppported for GECM. Use baseline.y instead")
	}

	GDRF.dummy.checks(effect.type = effect.type, prediction.values = prediction.values, baseline.y = baseline.y, baseline.y.se = baseline.y.se, 
						shock.size = shock.size, d.y = y.vrbl.d.y, inferences.y = inferences.y, type = "GDRF")

	########################################################################
	# subfunctions for shared gecm dummy check
	########################################################################
	gecm.dummy.checks(x.vrbl, y.vrbl, x.d.vrbl, y.d.vrbl, 
							x.vrbl.d.x, y.vrbl.d.y, x.d.vrbl.d.x, y.d.vrbl.d.y, 
							inferences.x, inferences.y, the.coef, se.type, type = "GDRF")

	########################################################################
	# subfunctions for shock history translation
	########################################################################
	shocks.transformed <- shockr.and.cumr(shock.history = shock.history, s.limit = s.limit, cumulative = cumulative)
	shock.history <- shocks.transformed$shock.history
	h.order <- shocks.transformed$h.order
	h.order.plot <- shocks.transformed$h.order.plot

	########################################################################
	# convert inferences to numeric, assign vcov, and replace _
	########################################################################
	# translate strings of inferences.x/inferences.y to numerics
	new.inferences <- inference.adjustr(inferences.y = inferences.y, inferences.x = inferences.x, the.d.y = y.vrbl.d.y, the.d.x = x.vrbl.d.x)
	calc.d.x <- new.inferences$calc.d.x
	calc.d.y <- new.inferences$calc.d.y
	plot.d.x <- new.inferences$plot.d.x
	plot.d.y <- new.inferences$plot.d.y
	
	the.vcov <- vcovHC(model, type = se.type)

	# mpoly does not play nicely with _, (, ), ,, or  . all are typically found in dynlm objects
	#  We have to replace and warn	
	mpoly.subber(env = environment())
	
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

	# With the PTE, apply either convolution.calculator (custom shock.history) or general.calculator (h integer GDRF)
	if(length(shock.history) > 1) {
		the.final.formulae <- convolution.calculator(d.x = calc.d.x, d.y = calc.d.y, shocks = shock.history, pulses = the.pte.formula.list)
	} else {
		the.final.formulae <- general.calculator(d.x = calc.d.x, d.y = calc.d.y, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	}

	if(effect.type == "discrete") {
		# scale formulae by shock.size. this is identical to the scaling in yhat.calculator. we will only do this if it is not 1 to prevent
		#  the formulae from looking stupid
		if(shock.size != 1) {
			scaled.formulae <- lapply(the.final.formulae$formulae, function(f) {
				paste0(shock.size, " * (", f, ")")
			})
		} else {
			scaled.formulae <- the.final.formulae$formulae
		}
		
		# establish container for results	
		dat.out <- cbind(0:s.limit, t(sapply(scaled.formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
  
		# update formulae to scaled versions
		the.final.formulae$formulae <- scaled.formulae
  
		# name the formula list
		names(the.final.formulae$formulae) <- names(the.final.formulae$shocks) <- paste0("s = ", 0:s.limit)
		
	} else if(effect.type == "fitted") {
		to.evaluate <- yhat.calculator(formulae = the.final.formulae$formulae, d.y = y.vrbl.d.y,
			model = model, the.coef = the.coef, y.vrbl = y.vrbl.adl,
			inferences.y = inferences.y, prediction.values = prediction.values,
			baseline.y = baseline.y, shock.size = shock.size)$modified.formulae
			
		dat.out <- cbind(c("baseline", 0:s.limit), t(sapply(to.evaluate, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))

		the.final.formulae$formulae <- to.evaluate

		# yhat.calculator appends the baseline formula to the front of the list. we will apppend a similar ``0'' binomial
		the.final.formulae$shocks <- c(list(0), the.final.formulae$shocks)
							
		# name the formula list. Remember that the fitted have a baseline appended to them
		names(the.final.formulae$formulae) <- names(the.final.formulae$shocks) <- c("baseline", paste0("s = ", 0:s.limit))
    }

	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDRF", "SE", "Lower", "Upper")

	########################################################################
	# post-processing: add baseline.y.se if supplied (I(1) fitted values only)
	########################################################################
	if(effect.type == "fitted" & inferences.y == "levels") {
		if(baseline.y.se == 0) {
			dat.out$SE <- dat.out$SE
		} else {
			# add baseline.y.se in quadrature to the SE of the GDRF estimates
			#  since we're just asserting the standard error of y, we can add them (they're independent)
			dat.out$SE <- sqrt(dat.out$SE^2 + baseline.y.se^2)
			dat.out$Lower <- dat.out$GDRF - qnorm(1 - (1 - dM.level)/2) * dat.out$SE 
			dat.out$Upper <- dat.out$GDRF + qnorm(1 - (1 - dM.level)/2) * dat.out$SE			
		}
	}

	########################################################################
	# deal with LRM
	########################################################################
	# Adjust this function later if we want: it excludes all fitted values from LRM calculations
	lrm.exists <- lrm.existr(shock.history = shock.history, h.order = h.order.plot, cumulative = cumulative, 
					calc.d.x = calc.d.x, calc.d.y = calc.d.y, effect.type = effect.type, return.LRM = return.LRM)
		
	if(lrm.exists == TRUE) {
		# calculate the LRM. GECM means just the first lag of the variables in levels
		lrm <- paste0("(", shock.size, "* (-1) * (", names(x.vrbl), "))/(", names(y.vrbl), ")")		
		# save the LRM formula for testing
		the.final.formulae$formulae$"LRM" <- lrm
		# evaluate the LRM and add to the dataset as the s.limit + 1 period
		lrm.dat <- c(as.matrix(s.limit+1), as.matrix(deltaMethod(the.coef, lrm, vcov. = the.vcov, level = dM.level)))
		dat.out <- rbind(dat.out, as.numeric(lrm.dat))
	}

	########################################################################
	# deal with y label and the baseline period in fitted
	########################################################################
	if(effect.type == "discrete") {
		# If it's custom, just a generic label
		if(length(shock.history) > 1) {
			y.lab <- ifelse(cumulative == TRUE,
				"Cumulative Discrete Effect of Shock History",
				"Discrete Effect of Shock History")
		} else { # conditional assignment if cumulative = TRUE or FALSE
			y.lab <- if(cumulative == TRUE) {
					bquote("Cumulative" ~ GDRF[.(paste0("(", s.limit, ", ", h.order.plot, ", ", plot.d.y, ", ", plot.d.x, ")"))])
				} else {
					bquote(GDRF[.(paste0("(", s.limit, ", ", h.order.plot, ", ", plot.d.y, ", ", plot.d.x, ")"))])
			}
		}
		dat.out$Period.plot <- as.numeric(dat.out$Period)
		x.breaks <- seq(0, s.limit, length.out = 5)
		x.labels <- seq(0, s.limit, length.out = 5)
	} else if(effect.type == "fitted") {
		# If it's custom, just a generic label
		if(length(shock.history) > 1) {
			y.lab <- ifelse(cumulative == TRUE,
				"Cumulative Fitted Values of Shock History",
				"Fitted Values of Shock History")
		} else { # conditional assignment if cumulative = TRUE or FALSE
			y.lab <- if(cumulative == TRUE) {
					bquote("Cumulative Fitted Values of" ~ GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ", plot.d.x, ")"))])
				} else {
					bquote("Fitted Values of" ~ GDRF[.(paste0("(", s.limit, ", ", h.order, ", ", plot.d.y, ", ", plot.d.x, ")"))])
			}
		}
		dat.out$Period.plot <- suppressWarnings(ifelse(dat.out$Period == "baseline", -1, as.numeric(dat.out$Period)))
		x.breaks <- c(-1, seq(0, s.limit, length.out = 5))
		x.labels <- c("Baseline", seq(0, s.limit, length.out = 5))
	}
	
	########################################################################
	# plotting
	########################################################################
	# We're going to separate them because of the LRM
	Effect <- Effect.sig <- GDRF <- Lower <- Period <- Upper <- Z <- Period.plot <- NULL
	if(lrm.exists == FALSE) {
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
						# geom_hline(yintercept = 0, lwd = 1) +
						scale_x_continuous(breaks = x.breaks, labels = x.labels) +						
						xlab("Number of Periods Since Initial Shock (s)") +
						ylab(y.lab) +
						theme_bw() + 
						theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
		if(effect.type == "discrete") {
			plot.out <- plot.out +
			geom_hline(yintercept = 0, lwd = 1)
		}							
	} else if(lrm.exists == TRUE) { # if there is an LRM (note that fitted will NEVER end up here: otherwise we would have to change the indexing for the data calls and the scale)
		#######################
		# x-axis: s; y-axis: GDRF
		#######################
		lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
		# make a small dataset that excludes the LRM
		plotting.data.nolrm <- dat.out[(dat.out$Period.plot %in% 0:s.limit),]
		plotting.data.lrm <- dat.out[(dat.out$Period.plot %in% (s.limit + 1)),]
		plotting.data.lrm$Period <- lrm.space
		plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period.plot, y = GDRF)) + 
						geom_line(lwd = 1.2) + 
						geom_ribbon(data = plotting.data.nolrm, aes(ymin = .data$Lower, ymax = .data$Upper), color = "black", linetype = 1, alpha = 0.2) +
						# geom_hline(yintercept = 0, lwd = 1) +
						geom_segment(data = plotting.data.lrm, aes(x = .data$Period, xend = .data$Period, y = .data$Lower, yend = .data$Upper), lwd = 1.25, color = "black") +
						geom_point(data = plotting.data.lrm, aes(x = .data$Period, y = .data$GDRF), size = 3) +
						scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), lrm.space), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
						xlab("Number of Periods Since Initial Shock (s)") +	
						ylab(y.lab) +
						theme_bw() + 
						theme(panel.border = element_blank(), 
							panel.grid.major = element_blank(),
							panel.grid.minor = element_blank(), 
							axis.line = element_line(colour = "black"))
		if(effect.type == "discrete") {
			plot.out <- plot.out +
			geom_hline(yintercept = 0, lwd = 1)
		}								
		# rename last row: account for the 0 at the beginning of s
		dat.out$Period[nrow(dat.out)] <- "LRM"	
	}

	# drop the Period.plot. Users don't need this lol
	dat.out$Period.plot <- NULL
	
	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae)
	out
}


##########################################
# ---------- (6.1) gecm.plot ----------- #
##########################################
#' Evaluate and/or plot the General Dynamic Response Function (GDRF) for a GECM assumed in levels/first differences
#' 
#' Evaluate (and possibly plot) the General Dynamic Response Function (GDRF) for a GECM(1,1), making use of the GDRF framework (described below and in Vande Kamp, Jordan, and Rajan), assuming the underlying model is in first differences (\code{x.vrbl.d.x} = \code{y.vrbl.d.y} = 0 and \code{x.d.vrbl.d.x} = \code{y.d.vrbl.d.y} = 1), the user wants a discrete effect (the untransformed GDRF) and inferences about y in levels to a shock applied to x in levels, with a shock size of 1. (This is just a wrapper for \code{GDRF.gecm.plot} with simplifying assumptions)
#' @param model the \code{lm} model containing the GECM estimates
#' @param x.vrbl a named numeric vector in which the names correspond to an independent variable and its lags (of the lower order of differencing, in levels d = 0) and the numbers correspond to the specific lag order of each variable
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the lower order of differencing, in levels d = 0) and the numbers correspond to the specific lag order of each variable
#' @param x.d.vrbl a named numeric vector in which the names correspond to an independent variable and its lags (of the higher order of differencing, in first differences d = 1) and the numbers correspond to the specific lag order of each variable
#' @param y.d.vrbl a named numeric vector in which the names correspond to lags of the dependent variable (of the higher order of differencing, in first differences d = 1) and the numbers correspond to the specific lag order of each variable
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param dM.level a numeric value for the significance level of the GDRF, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the GDRF (beginning at s = 0)
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.data logical to return the raw calculated GDRFs as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot logical to return the visualized GDRFs as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae logical to return the formulae for the GDRFs as a list element under \code{formulae} (for the GDRFs) and \code{shocks} (for the shock history). The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return if just one of \code{return.data}, \code{return.plot}, and \code{return.formulae} is \code{TRUE}, \code{gecm.plot} will return just the requested output. If more than one is selected (or just \code{return.data} is selected), it will return a list with elements \code{plot} (for the plot), \code{estimates} (for the data), and \code{formulae} and \code{shocks} for the GDRF formula for each period as well as the applied shock history in integer form
#' @details
#' We assume that the GECM model estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities. Given that, to obtain inferences for the specified shock history, the user only needs a named vector of the x and y variables, as well as the order of the differencing. Internally, the GECM to ADL equivalences are used to calculate the GDRFs from the GECM
#' @importFrom stats lm coef vcov
#' @importFrom mpoly mp
#' @importFrom sandwich vcovHC
#' @importFrom car deltaMethod
#' @import ggplot2
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords GECM GDRF
#' @examples
#' # GECM(1,1). So we can use gecm.plot to quickly check dynamics
#' # Use the toy data to run a GECM. No argument is made this 
#' #  is well specified or even sensible; it is just expository
#' model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
#' test.pulse <- gecm.plot(model = model,
#'                                   x.vrbl = c("l_1_x" = 1), 
#'                                   y.vrbl = c("l_1_y" = 1),
#'                                   x.d.vrbl = c("d_x" = 0, "l_1_d_x" = 1),
#'                                   y.d.vrbl = c("l_1_d_y" = 1),
#'                                   shock.history = "pulse", 
#'                                   s.limit = 10, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' names(test.pulse)
#' 
#' @export

gecm.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL,
                           x.d.vrbl = NULL, y.d.vrbl = NULL,
                           shock.history = "pulse",
                           dM.level = 0.95, s.limit = 20, se.type = "const",
                           return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
                           ...) {
  
	out <- GDRF.gecm.plot(model = model, x.vrbl = x.vrbl, y.vrbl = y.vrbl, x.vrbl.d.x = 0, y.vrbl.d.y = 0, 
		x.d.vrbl = x.d.vrbl, y.d.vrbl = y.d.vrbl, x.d.vrbl.d.x = 1, y.d.vrbl.d.y = 1,
		shock.history = shock.history, inferences.y = "levels", inferences.x = "levels",
		effect.type = "discrete", cumulative = FALSE, 
		prediction.values = NULL, baseline.y = NULL, baseline.y.se = 0, shock.size = 1,  # these are new for the yhats	
		dM.level = dM.level, s.limit = s.limit, se.type = se.type,
		return.LRM = TRUE, return.data = return.data, return.plot = return.plot, return.formulae = return.formulae, ... = ...)

	out
}		


##########################################
# ------- (7) interact.adl.plot -------- #
##########################################
#' Evaluate and/or plot dynamic interactions from dynamic linear models
#'
#' Evaluate (and possibly plot) the dynamic conditional effect from an autoregressive distributed lag (ADL) model (following the framework of Warner, Vande Kamp and Jordan). The description here matches the prose of Warner, Vande Kamp, and Jordan
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl a named numeric vector in which the names correspond to the ``main'' x variables and its lags and the numbers correspond to the specific lag order of each variable
#' @param z.vrbl a named numeric vector in which the names correspond to the ``moderating'' z variables and its lags and the numbers correspond to the specific lag order of each variable
#' @param x.z.vrbl a named numeric vector in which the names correspond to the ``interaction'' x:z variables and its lags and the numbers correspond to the specific lag order of each variable. IMPORTANT: enter the lag order that pertains to the ``main'' x variable. For instance, x_l_1_z (contemporaneous x times lagged z) would be 0 and l_1_x_z (lagged x times contemporaneous z) would be 1
#' @param y.vrbl a named numeric vector in which the names correspond to lags of the dependent variable and the numbers correspond to the specific lag order of each variable. Can be \code{NULL} if the model has no lagged dependent variables
#' @param shock.history either a character string, integer, or numeric vector for the desired shock history. \code{shock.history} determines the shock history (h) that will be applied to the independent variable. Vande Kamp, Jordan, and Rajan express this as the parameter h (an integer). -1 represents the Impulse Response Function; the equivalent string is \code{pulse} or \code{impulse}. 0 represents the Step Response Function; the equivalent string is \code{step}. For others, see Vande Kamp, Jordan, and Rajan. However, since any shock history can be decomposed into a series of dated Impulse Response Functions, users can also supply any numeric vector of the same length as s.limit + 1. The default is \code{pulse}
#' @param effect.type a character string indicating whether to return discrete effects or fitted values. \code{discrete} returns a discrete effect estimate. \code{fitted} returns a fitted value, relative to a baseline value of the dependent variable. The default is \code{discrete}
#' @param cumulative logical to return the cumulative effects or the period-specific effects of the given \code{shock.history}. For instance, to obtain the Cumulative Impulse Response Function, set \code{shock.history} to -1 and \code{cumulative = TRUE}. The default is \code{FALSE}
#' @param prediction.values a named list of values for non-y non-z variables in the model, used to calculate a steady-state baseline of the dependent variable when \code{effect.type = "fitted"} and \code{baseline.y} is not supplied. Model-based uncertainty will be calculated around the formula for this value. If any differenced variables are included in the model, they should be set to 0. If multiple lags of the same variable are included, they should be set to the same value (including for interactions). When working with interactions, these should be provided for any ``main'' x terms as well as the intended value of x for any ``interaction'' x:z terms. It is most sensible to use the same value of x for interaction terms with the same lag order: i.e. \code{x} and \code{x:z} would both be contemporaneous x, so \code{prediction.values = list("x" = 0, "x:z" = 0)} would set both values of contemporaneous x to 0. \code{prediction.values = list("x" = 0, "x:z" = 1)} would set one contemporaneous x to 0 and the other to 1; this is inconsistent. See the vignette for more examples. The ``interaction'' x.z terms will then be multiplied by a value of z, passed either by \code{z.vals} or internally defined by the function. If \code{return.formulae = TRUE}, a generic placeholder \code{z_val} is used in the formula to represent where the relevant \code{z.val} has been inserted to estimated the value
#' @param baseline.y a numeric value for the user-supplied baseline value of y in levels (i.e. the baseline value for effects to accumulate from). Only used when \code{effect.type = "fitted"}
#' @param baseline.y.se a numeric value for the user-supplied standard error for the baseline value of y (to suggest uncertainty around predictions). Only used when \code{effect.type = "fitted"}. If supplied, this is added in quadrature to the standard errors of the predictions. The default is 0: in recognition that this is user-constructed uncertainty. Possible values would be the square root of the standard deviation of y
#' @param shock.size a numeric value for the size of the shock to x in the units of x. Defaults to 1 (a discrete effect similar to traditional marginal effects)
#' @param plot.type a character string for the type of plot to create. \code{heatmap} features the combination of estimated effects across a set of values of z as well as a range of values of s. This is computationally intensive, as many effects are estimated. \code{lines} features the estimated effects at discrete values of s/z. The default is \code{lines}
#' @param line.options a character string for the type of effect to calculate, if \code{plot.type = "lines"}. \code{z.lines} evaluates the moderator as discrete values of z across a range of s. \code{s.lines} evalautes the moderator as discrete values of s across a range of z. The default is \code{z.lines}
#' @param heatmap.options a character string for the type of heatmap to draw, if \code{plot.type = "heatmap"}. \code{all} indicates that all discrete effects should be shown. \code{significant} indicates that only statistically significant discrete effects should be shown (since signficance indicators cannot appear on the heatmap). Note: this just sets the insignificant effects to the numeric value of 0. If the middle value of your scale gradient is white, these will effectively ``disappear.'' If another gradient is used, they will take on the color assigned to 0 values. If estimating fitted values, the function automatically switches to \code{all}, since \code{significant} fitted values are a bit nonsensical. The default is \code{significant}
#' @param line.colors a character string for the line colors. This defaults to the color-safe Okabe-Ito (\code{okabe-ito}) colors. There is also a grayscale option through \code{bw}. Users can also include whatever colors they like; the number of colors must match the number of lines drawn. This is passed to \code{scale_color_discrete}
#' @param heatmap.colors a character string for the heatmap colors. This defaults to the diverging gradient \code{Blue-Red}. Alternate colors must be one of \code{hcl.pals()}. For grayscale plots, use \code{Grays}. This is passed to \code{scale_fill_gradientn}
#' @param z.vals a vector of numeric values for the moderating variable. If \code{plot.type = "lines"}, these are treated as discrete levels of z. If \code{plot.type = "heatmap"}, these are treated as a lower and upper limit of a range of values of z. If none are provided, \code{interact.adl.plot} will pick based on the \code{plot.type}
#' @param s.vals a vector of values for the time since the shock at which to evaluate the discrete effects. This is only used if \code{line.options = s.lines}, meaning s is treated as the moderator. The default is 0 (short-run) and the \code{LRM}
#' @param z.label.rounding a numeric value for the digits to round to for the z labels in the legend (if those values are automatically calculated). The default is 3
#' @param z.vrbl.label an optional string to give as the name of the moderating z variable, used in plotting (to avoid ugly variable names in plot labels and legends)
#' @param dM.level a numeric value for the significance level of the (cumulative) discrete effects, calculated by the delta method. The default is 0.95
#' @param s.limit an integer for the number of periods to determine the (cumulative) discrete effects (beginning at s = 0)
#' @param se.type a character string for the type of standard error to extract from the model. The default is \code{const}, but any argument to \code{vcovHC} from the \code{sandwich} package is accepted
#' @param return.LRM logical to return the LRM in the estimates and plots, should the LRM exist for that combination of \code{shock.history} and \code{cumulative}. The default is \code{TRUE}
#' @param return.data logical to return the raw calculated (cumulative) discrete effects as a list element under \code{estimates}. The default is \code{FALSE}
#' @param return.plot logical to return the visualized (cumulative) discrete effects as a list element under \code{plot}. The default is \code{TRUE}
#' @param return.formulae logical to return the formulae for the (cumulative) discrete effects as a list element under \code{formulae} (for the (cumulative) discrete effects) and \code{shocks} (for the shock history). For interactions, the placeholder of \code{z_val} is used to denote where a specific value of z is substituted. The default is \code{FALSE}
#' @param ... other arguments to be passed to the call to plot
#' @return if just one of \code{return.data}, \code{return.plot}, and \code{return.formulae} is \code{TRUE}, \code{interact.adl.plot} will return just the requested output. If more than one is selected (or just \code{return.data} is selected), it will return a list with elements \code{plot} (for the plot), \code{estimates} (for the data), and \code{formulae} and \code{shocks} for the (cumulative) conditional effects for each period as well as the applied shock history in integer form
#' @importFrom stats lm coef vcov model.frame sd
#' @importFrom ggplot2 ggplot
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @importFrom utils capture.output
#' @importFrom grDevices hcl.colors hcl.pals palette.colors
#' @details
#' We assume that the ADL model estimated is well specified, free of residual autocorrelation, balanced, and meets other standard time-series qualities. It is imperative that you double-check you have referenced all x, y, z, and interaction terms through \code{x.vrbl}, \code{y.vrbl}, \code{z.vrbl}, and \code{x.z.vrbl}. You must also have their orders correctly entered. \code{interact.adl.plot} has no way of determining, from the variable list, which correspond with which
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords interactions ADL
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
#' # Now: discrete effect of X at different levels of Z
#' interact.adl.plot(model = cavari.model, 
#'		x.vrbl = c("APPROVE_ECONOMY" = 0), y.vrbl = c("APPROVE_L1" = 1),
#' 		z.vrbl = c("MIP_MACROECONOMICS" = 0), x.z.vrbl = c("ECONAPP_ECONMIP" = 0),
#'		shock.history = "impulse", plot.type = "lines", line.options = "z.lines")
#' 
#' # Use well-behaved simulated data (included) for even more examples, 
#' #  using the Warner, Vande Kamp, and Jordan general model
#' model.toydata <- lm(y ~ l_1_y + x + l_1_x + z + l_1_z +
#'		x_z + z_l_1_x +
#'		x_l_1_z + l_1_x_l_1_z, data = toy.ts.interaction.data)
#' 
#' # Discrete effect of z (not run: computational time)
#' # Be sure to specify x.z.vrbl orders with respect to x term
#' \dontrun{interact.adl.plot(model = model.toydata, x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'					y.vrbl = c("l_1_y" = 1), z.vrbl = c("z" = 0, "l_1_z" = 1),
#'					x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, 
#'						"x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
#'					z.vals = -2:2,
#'					shock.history = "impulse", 
#'					plot.type = "lines", 
#'					line.options = "z.lines",
#'					s.limit = 20)
#' }
#' 
#' # Heatmap of discrete effects, since X and Z are actually continuous
#' #  (not run: computational time)
#' \dontrun{interact.adl.plot(model = model.toydata, x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'					y.vrbl = c("l_1_y" = 1), z.vrbl = c("z" = 0, "l_1_z" = 1),
#'					x.z.vrbl = c("x_z" = 0, "z_l_1_x" = 1, 
#'						"x_l_1_z" = 0, "l_1_x_l_1_z" = 1),
#'					z.vals = c(-2,2),
#'					shock.history = "impulse", 
#'					plot.type = "heatmap", 
#'					heatmap.options = "all",
#'					s.limit = 20)
#' }
#' @export

interact.adl.plot <- function(model = NULL, x.vrbl = NULL, z.vrbl = NULL, x.z.vrbl = NULL, y.vrbl = NULL,
	shock.history = "impulse",
	cumulative = FALSE,
	effect.type = "discrete",
	prediction.values = NULL,
	baseline.y = NULL,
	baseline.y.se = 0,
	shock.size = 1,	
	plot.type = "lines",
	line.options = "z.lines",
	heatmap.options = "significant",
	line.colors = "okabe-ito",
	heatmap.colors = "Blue-Red", 
	z.vals = NULL, s.vals = c(0, "LRM"), 
	z.label.rounding = 3, z.vrbl.label = names(z.vrbl)[1],
	dM.level = 0.95, s.limit = 20, se.type = "const",
	return.LRM = TRUE, return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,
	...) {

	# Assign coefficients
	the.coef <- coef(model)

	########################################################################
	# subfunctions for shared GDRF dummy check
	########################################################################
	GDRF.dummy.checks(effect.type = effect.type, prediction.values = prediction.values, baseline.y = baseline.y, baseline.y.se = baseline.y.se, shock.size = shock.size, 
						# we would change these if we ever evolved this to a GDRF-style function
						d.y = 0, inferences.y = "levels", 
						type = "interact")

	########################################################################
	# subfunctions for shared adl dummy check
	########################################################################
	adl.dummy.checks(x.vrbl = x.vrbl, y.vrbl = y.vrbl, z.vrbl = z.vrbl, x.z.vrbl = x.z.vrbl, 
						d.x = NULL, d.y = NULL, inferences.x = NULL, inferences.y = NULL, 
						the.coef = the.coef, se.type = se.type, type = "interact")

	########################################################################
	# specific warnings to interaction plots, given the plot types
	########################################################################
	if(return.plot == TRUE) {
		if(is.null(plot.type)) {
			stop("plot.type must be specified")
		} 
		if(!(plot.type %in% c("lines", "heatmap"))) {
			stop("plot.type must be one of 'lines' or 'heatmap'")
		}
		if(plot.type == "lines") {
			if(!(line.options %in% c("s.lines", "z.lines"))) {
				stop("line.options must be one of 's.lines' or 'z.lines'")
			}
		}
		if(plot.type == "heatmap") {
			if(!(heatmap.options %in% c("all", "significant"))) {
				stop("heatmap.options must be one of 'all' or 'significant'")
			}
		}
		if(effect.type == "fitted" & heatmap.options == "significant") {
			warning("'significant' is not applicable to fitted values; fitted values are predictions, not estimated effects. Using 'all' instead")
			heatmap.options <- "all"
		}
	}

	########################################################################
	# subfunctions for shock history translation
	########################################################################
	shocks.transformed <- shockr.and.cumr(shock.history = shock.history, s.limit = s.limit, cumulative = cumulative)
	shock.history <- shocks.transformed$shock.history
	h.order <- shocks.transformed$h.order
	h.order.plot <- shocks.transformed$h.order.plot	

	the.vcov <- vcovHC(model, type = se.type)

	# mpoly does not play nicely with _, (, ), ,, or  . all are typically found in dynlm objects
	#  We have to replace and warn	
	mpoly.subber(env = environment())

	########################################################################
	# does the LRM exist? This is earlier in the workflow, since we have so many more options to declare for these plots
	########################################################################	
	# Adjust this function later if we want: it excludes all fitted values from LRM calculations
	# Since this function doesn't do the GDRF translation, we set d.x and d.y to 0 and effect.type to discrete
	lrm.exists <- lrm.existr(shock.history = shock.history, h.order = h.order.plot, cumulative = cumulative, 
						calc.d.x = 0, calc.d.y = 0, effect.type = effect.type, return.LRM = return.LRM)
	
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
	if(plot.type == "lines" & line.options == "s.lines" & lrm.exists == FALSE) { # if it is slines and there is no LRM
		if(identical(s.vals, c(0, "LRM"))) { # if they didn't specify an alternate value
			s.vals <- c(0, s.limit)
			# they will already get the warning from the lrm.exists function.
			warning(paste0("Using last period (s = ", s.limit, ") as value of s to plot instead of infinity (LRM)"))
		}
	}

	# establish z.vals. identify the moderating variable
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
			stop("heatmap.colors must be one of hcl.pals(). For grayscale heatmap, use 'Grays'")
		}	
	}
		
	########################################################################
	# below begins the calculation / plotting meat
	########################################################################
	# we have a series of both x coefficients and x.z (interaction) coefficients. We need to combine them before we pass to pulse.calculator.
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

	# With the PTE, apply either convolution.calculator (custom shock.history) or general.calculator (h integer GDRF)
	if(length(shock.history) > 1) {
		the.final.formulae <- convolution.calculator(d.x = 0, d.y = 0, shocks = shock.history, pulses = the.pte.formula.list)
	} else {
		the.final.formulae <- general.calculator(d.x = 0, d.y = 0, h = h.order, limit = s.limit, pulses = the.pte.formula.list)
	}
	
	# establish container for results
	dat.out <- matrix(rep(NA, (length(0:s.limit)*length(z.vals))*6), nrow = (length(0:s.limit)*length(z.vals)))

	# replace the first two columns with the relevant values of s and z
	dat.out[,c(1:2)] <- as.matrix(expand.grid(s = 0:s.limit, z_val = z.vals))
	
	# placeholder for updated final formulae
	the.final.formulae.updated <- list()
	
	the.final.formulae.updated$shocks <- the.final.formulae$shocks
	
	
	for(j in 1:nrow(dat.out)) {
		# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
		#  reminder that the formuale are already created in the.final.formulae$formulae. elements 1:(s.limit+1)
		#  and we have s and z in dat.out already
		s <- dat.out[j,1] # look above: s is the first column
		z <- dat.out[j,2] # look above: z is the second column
		the.formula.simple <- the.final.formulae$formulae[[s+1]] # have to increment by one since s starts at 0
		if(effect.type == "discrete") {
			# this is a generic formula of type "x  +  x_z * z_val  +  z_val * x_l_1_z "
			to.evaluate <- to.store <- paste0(shock.size, " * (", the.formula.simple, ")")
		} else if(effect.type == "fitted") {
			# note we would change this if this ever handled levels/differences translations
			the.formula <- yhat.calculator(formulae = list(the.formula.simple), d.y = 0,
							model = model, the.coef = the.coef, y.vrbl = y.vrbl,
							inferences.y = "levels", prediction.values = prediction.values,
							baseline.y = baseline.y, shock.size = shock.size,
							z.val = z, z.vrbl = z.vrbl, x.z.vrbl = x.z.vrbl)	

			# update formulae to scaled OR fitted versions. we will actually be doing this overwriting multiple times, since there are multiple
			#  instances of s. but since they are generic to z, it doesn't matter and isn't super computationally expensive
			to.evaluate <- the.formula$modified.formulae[[2]]
			to.store <- the.formula$modified.symbolic.formulae[[2]]				
		}
		
		the.final.formulae.updated$formulae[s+1] <- to.store
		
		dat.out[j,3:6] <- as.matrix(deltaMethod(the.coef, paste(gsub('z_val', z, to.evaluate)), vcov. = the.vcov, level = dM.level))
	}

	# Just for fitted: attach the baseline values and formula
	if(effect.type == "fitted") {
		# make a separate matrix to store the baseline values in: this will only be used if effect.type == "fitted", 
		dat.out.baseline <- matrix(rep(NA, (length(1)*length(z.vals))*6), nrow = (length(1)*length(z.vals)))
		
		# replace the first two columns with the relevant values of s and z. since this is the baseline, we will call s = -1
		dat.out.baseline[,c(1:2)] <- as.matrix(expand.grid(s = -1, z_val = z.vals))
			
		# the first element of yhat.calculator is the baseline formula. store it
		the.formula.simple <- the.final.formulae$formulae[[1]] # have to increment by one since s starts at 0
		
		for(j in 1:nrow(dat.out.baseline)) {
			# note we would change this if this ever handled levels/differences translations
			the.formula <- yhat.calculator(formulae = list(the.formula.simple), d.y = 0,
							model = model, the.coef = the.coef, y.vrbl = y.vrbl,
							inferences.y = "levels", prediction.values = prediction.values,
							baseline.y = baseline.y, shock.size = shock.size,
							z.val = dat.out.baseline[j,2], z.vrbl = z.vrbl, x.z.vrbl = x.z.vrbl)
			
			to.evaluate <- the.formula$modified.formulae[[1]]
			to.store <- the.formula$modified.symbolic.formulae[[1]]

			# I don't think it matters which s we're evaluating: the baseline is impervious to s
			dat.out.baseline[j,3:6] <- as.matrix(deltaMethod(the.coef, paste(gsub('z_val', dat.out.baseline[j,2], to.evaluate)), vcov. = the.vcov, level = dM.level))		
		}
		
		# prepend the baseline formula to the others
		the.final.formulae.updated$formulae <- c(list(to.store), the.final.formulae.updated$formulae)
		
		# yhat.calculator appends the baseline formula to the front of the list. we will prepend a similar ``0'' binomial
		the.final.formulae.updated$shocks <- c(list(0), the.final.formulae.updated$shocks)
		
		# rbind the baseline and the dataset of actual fitted values from above
		dat.out <- rbind(dat.out.baseline, dat.out)
	}

	dat.out <- data.frame(dat.out)
	names(dat.out) <- c("Period", "Z", "Effect", "SE", "Lower", "Upper")

	########################################################################
	# post-processing: add baseline.y.se if supplied (I(1) fitted values only)
	########################################################################
	if(effect.type == "fitted") {		
		if(baseline.y.se == 0) {
			dat.out$SE <- dat.out$SE
		} else {
			# add baseline.y.se in quadrature to the SE of the GDRF estimates
			#  since we're just asserting the standard error of y, we can add them (they're independent)
			dat.out$SE <- sqrt(dat.out$SE^2 + baseline.y.se^2)
			dat.out$Lower <- dat.out$Effect - qnorm(1 - (1 - dM.level)/2) * dat.out$SE 
			dat.out$Upper <- dat.out$Effect + qnorm(1 - (1 - dM.level)/2) * dat.out$SE			
		}
	}

	the.final.formulae.updated$formulae <- as.list(the.final.formulae.updated$formulae)

	# name the formula list. this will be different for discrete vs. fitted
	if(effect.type == "discrete") {
		names(the.final.formulae.updated$formulae) <- names(the.final.formulae.updated$shocks) <- paste0("s = ", 0:s.limit)
	} else if(effect.type == "fitted") {
		# Rename the baseline periods to ``baseline'', too, in the dataset
		dat.out$Period[dat.out$Period == -1] <- "baseline"		
		names(the.final.formulae.updated$formulae) <- names(the.final.formulae.updated$shocks) <- c("baseline", paste0("s = ", 0:s.limit))
	}

	########################################################################
	# plotting
	########################################################################
	Effect <- Effect.sig <- GDRF <- Lower <- Period <- Upper <- Z <- Period.plot <- NULL

	########################################################################
	# deal with y label and the baseline period in fitted
	########################################################################
	if(effect.type == "discrete") {
		# Since these are not technically GDRF and we don't do the integration translation down here, we will just
		#  give the lazy labels
		y.lab <- ifelse(cumulative == TRUE,
				"Cumulative Discrete Effect of Shock History",
				"Discrete Effect of Shock History")
		fill.lab <- ifelse(cumulative == TRUE,
				"Cumulative Discrete Effect\nof Shock History",
				"Discrete Effect\nof Shock History")				
		dat.out$Period.plot <- as.numeric(dat.out$Period)
		x.breaks <- seq(0, s.limit, length.out = 5)
		x.labels <- seq(0, s.limit, length.out = 5)
	} else if(effect.type == "fitted") {
		y.lab <- ifelse(cumulative == TRUE,
				"Cumulative Fitted Values of Shock History",
				"Fitted Values of Shock History")
		fill.lab <- ifelse(cumulative == TRUE,
				"Cumulative Fitted Values\nof Shock History",
				"Fitted Values\nof Shock History")
		dat.out$Period.plot <- suppressWarnings(ifelse(dat.out$Period == "baseline", -1, as.numeric(dat.out$Period)))
		x.breaks <- c(-1, seq(0, s.limit, length.out = 5))
		x.labels <- c("Baseline", seq(0, s.limit, length.out = 5))
	}

	########################################################################
	# for LRM plots
	########################################################################		

	if(isTRUE(lrm.exists)) {
		# calculate the LRM. remember we already made the numerator! just need to add the terms (regardless of order)
		lrm.numerator <- paste0(names(combined.x.vrbl), collapse = " + ")
		# Denominator is the alpha.is. these are unweighted in the sum
		#  so we don't have to do anything but combine them!
		# if it's a custom shock history, then the cumulative amount is the last place of the (cumulative) shock history
		if(is.numeric(shock.history) && length(shock.history) > 1) {
			if(is.null(y.vrbl)) {
				lrm <- paste0(shock.history[length(shock.history)], " * ", shock.size, " * (", lrm.numerator, ")")
			} else {
				lrm <- paste0("(", shock.history[length(shock.history)], " * ", shock.size, " * (", lrm.numerator, "))/(1-(", paste(names(y.vrbl), collapse = "+"), "))")		
			}
		} else { # if it is an integer h, easy
			if(is.null(y.vrbl)) {
				lrm <- paste0(shock.size, " * (", lrm.numerator, ")")
			} else {
				lrm <- paste0("(", shock.size, " * (", lrm.numerator, "))/(1 - (", paste(names(y.vrbl), collapse = " + "), "))")		
			}
		}
		
		# save the LRM formula for testing
		the.final.formulae.updated$formulae$"LRM" <- lrm
		# make another matrix of values to fill. this is different from normal, as we have many z.vals
		lrm.dat <- matrix(rep(NA, length(z.vals)*6), nrow = length(z.vals))
		for(z in 1:length(z.vals)) {
			# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
			that.zsum <- gsub('z_val', z.vals[z], lrm)
			lrm.dat[z,] <- c(as.matrix(c((s.limit+1), z.vals[z])), as.matrix(deltaMethod(the.coef, paste(that.zsum), vcov. = the.vcov, level = dM.level)))
		}
		lrm.dat <- data.frame(lrm.dat)
		names(lrm.dat) <- c("Period", "Z", "Effect", "SE", "Lower", "Upper")
		lrm.dat$Period.plot <- lrm.dat$Period
		lrm.dat$Period[lrm.dat$Period == (s.limit + 1)] <- "LRM"
		
		dat.out <- rbind(dat.out, lrm.dat)

		#######################
		# actual plots
		#######################

		if(plot.type == "lines") {
			if(line.options == "z.lines") {
				#######################
				# lines, z.lines, and there is an LRM (likely impulse + cumulative) (but no fitted values: disallowed with LRM)
				#######################
				lrm.space <- s.limit + round((s.limit * 0.2), digits = 0) + 2
				plotting.data.nolrm <- dat.out[(dat.out$Period.plot %in% 0:s.limit),]
			
				# have to position the lrm lines for each z.val out past the s.limit
				lrm.lines <- dat.out[dat.out$Period.plot == (s.limit + 1),]
				lrm.lines$xloc <-  seq((s.limit + round((s.limit * 0.2), digits = 0)) - ((length(z.vals) - 1)/2),
									(s.limit + round((s.limit * 0.2), digits = 0)) + ((length(z.vals) - 1)/2),
									length.out = length(z.vals))
		
				plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period.plot, y = Effect, lty = as.factor(Z), col = as.factor(Z))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
							geom_segment(data = lrm.lines, aes(x = .data$xloc, xend = .data$xloc, y = .data$Lower, yend = .data$Upper), lwd = 1.25, color = line.colors) +
							geom_point(data = lrm.lines, aes(x = .data$xloc, y = .data$Effect), size = 3, color = line.colors)	+
							geom_hline(yintercept = 0, lwd = 1) +
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space-2)), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							scale_color_discrete(type = line.colors, name = paste0("Value of ", z.vrbl.label), labels = z.plot.labels) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0(y.lab)) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				# dat.out$Period[dat.out$Period == (s.limit+1)] <- "LRM"
			} else if(line.options == "s.lines") {
				#######################
				# lines, s.lines, and there is an LRM (likely impulse + cumulative) (but no fitted values: disallowed with LRM)
				#######################
				# Need to define levels of s for plotting. Really it's only sensical to do 0 and LRM. But I'm not going to stop anyone
				#  change "LRM" to the s.limit + 1 period in the prediction dataset
				#  this just identifies it numerically for plotting
				s.vals[s.vals == "LRM"] <- lrm.space <- s.limit + 1    
				s.vals <- as.numeric(s.vals)
				s.plot.labels <- paste0("s = ", s.vals)
				s.plot.labels[s.plot.labels == "s = 0"] <- "s = 0 (Short-run)"
				s.plot.labels[s.plot.labels == paste0("s = ", (s.limit + 1))] <- paste0("s = ", bquote(.("\U221E")), " (Long-run)")
				plotting.data.justs <- dat.out[(dat.out$Period.plot %in% s.vals),]
				plot.out <- ggplot(data = plotting.data.justs, aes(x = Z, y = Effect, lty = as.factor(Period), col = as.factor(Period))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Period), col = as.factor(Period)), linetype = 1, alpha = 0.1) +
							geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of s"), labels = s.plot.labels) +
							xlab(paste0("Value of ", z.vrbl.label)) +
							ylab(paste0(y.lab)) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				# dat.out$Period[dat.out$Period == (s.limit+1)] <- "LRM"
			}
		} else if(plot.type == "heatmap") {
			if(heatmap.options == "all") {
				#######################
				# heatmap, all effects, and there is an LRM (likely impulse + cumulative) (but no fitted values: disallowed with LRM)
				#######################				
				# adjust the LRM to be a little out from the heatmap to prevent confusion
				lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
				dat.out$Period.plot[dat.out$Period.plot == (s.limit + 1)] <- lrm.space	
				plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = Z, fill = Effect)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect), na.rm = TRUE)) +
							make.fill.scale(heatmap.colors, Effect = dat.out$Effect) +							
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
											labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0(fill.lab)) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				# dat.out$Period[dat.out$Period == lrm.space] <- "LRM"
			} else if(heatmap.options == "significant") {
				#######################
				# heatmap, significant effects, and there is an LRM (likely impulse + cumulative) (but no fitted values: disallowed with LRM)
				#######################
				lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
				dat.out$Period.plot[dat.out$Period.plot == (s.limit + 1)] <- lrm.space

				dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
				dat.out$Effect.sig <- ifelse(dat.out$insig == 0, dat.out$Effect, 0)
				plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = Z, fill = Effect.sig)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect.sig), na.rm = TRUE)) +
							make.fill.scale(heatmap.colors, Effect = dat.out$Effect.sig) +							
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
											labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0("Statistically Significant\n", fill.lab)) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black")) 					
				dat.out$Period[dat.out$Period == lrm.space] <- "LRM"
			} 
		} # ends lines/heatmap  # ends cumulative
		
	#######################
	# plots for non-LRM
	#######################
	} else {
		if(plot.type == "lines") {
			if(line.options == "z.lines") {
				#######################
				# lines, z.lines, and there is no LRM (but could be fitted values)
				#######################
				plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = Effect, lty = as.factor(Z), col = as.factor(Z))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
							# geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of ", z.vrbl.label), labels = z.plot.labels) +
							scale_x_continuous(breaks = x.breaks, labels = x.labels) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0(y.lab)) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				if(effect.type == "discrete") {
					plot.out <- plot.out +
						geom_hline(yintercept = 0, lwd = 1)
				}						
			} else if(line.options == "s.lines") {
				#######################
				# lines, s.lines, and there is no LRM (but could be fitted values)
				#######################
				s.vals <- as.numeric(s.vals)
				s.plot.labels <- paste0("s = ", s.vals)				
				plotting.data.justs <- dat.out[(dat.out$Period.plot %in% s.vals),]
				plot.out <- ggplot(data = plotting.data.justs, aes(x = Z, y = Effect, lty = as.factor(Period), col = as.factor(Period))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Period), col = as.factor(Period)), linetype = 1, alpha = 0.1)	+
							# geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of s"), labels = s.plot.labels) +
							xlab(paste0("Value of ", z.vrbl.label)) +
							ylab(paste0(y.lab)) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
				if(effect.type == "discrete") {
					plot.out <- plot.out +
						geom_hline(yintercept = 0, lwd = 1)
				}										
			}
		} else if(plot.type == "heatmap") {
			if(heatmap.options == "all") {
				#######################
				# heatmap, all effects, and there is no LRM (but could be fitted values)
				#######################	
				plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = Z, fill = Effect)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect), na.rm = TRUE)) +
							make.fill.scale(heatmap.colors, Effect = dat.out$Effect) +
							scale_x_continuous(breaks = x.breaks, labels = x.labels) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0(fill.lab)) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))	
			} else if(heatmap.options == "significant") {
				#######################
				# heatmap, significant effects, and there is no LRM (but could be fitted values)
				#######################	
				dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
				dat.out$Effect.sig <- ifelse(dat.out$insig == 0, dat.out$Effect, 0)
				plot.out <- ggplot(data = dat.out, aes(x = Period.plot, y = Z, fill = Effect.sig)) + 
							geom_tile() + 
							#scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							#scale_fill_gradientn(colors = the.colors,  
							#		values = scales::rescale(seq(-1, 1, length.out = 21)),
							#		limits = range(c(0, dat.out$Effect.sig), na.rm = TRUE)) +
							make.fill.scale(heatmap.colors, Effect = dat.out$Effect.sig) +							
							scale_x_continuous(breaks = x.breaks, labels = x.labels) +
							xlab(paste0("Number of Periods Since Initial Shock (s)")) +
							ylab(paste0("Value of ", z.vrbl.label)) +
							labs(fill = paste0("Statistically Significant\n", fill.lab)) +							
							# labs(fill = paste0("Statistically Significant\nDiscrete Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
			}
		} # ends heatmap	
	} # ends no LRM

	# drop the Period.plot. Users don't need this lol. also note that this will only exist for some heatmap options, but I am max lazy
	dat.out$insig <- dat.out$Effect.sig <- dat.out$Period.plot <- NULL
	
	########################################################################
	# returning elements
	########################################################################	
	out <- what.to.return(return.plot = return.plot, return.formulae = return.formulae, return.data = return.data, 
				plot.out = plot.out, dat.out = dat.out, the.final.formulae = the.final.formulae.updated)
	out
}

