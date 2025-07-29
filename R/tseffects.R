# version 0.1.2.9001
# 7/25/2025
# Authors: Soren Jordan, Garrett N. Vande Kamp, Reshi Rajan

# TO DO (next version):
#   Somehow test whether someone is using ts.effect.plot when they are also specifying an interaction
#   Include ts.effects.plot
#   Include ts.interact.plot
#   When more colors, update Imports: mpoly, car, ggplot2, sandwich, see, colorspace, stats, utils

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
#		see (for okabe-ito)
#		colorspace (for grays)
#		stats (for lm coef vcov)
#		sandwich (for vcovHC)
#		utils (for capture.output)
#
## Functions included:
# (1) pte.calculator
# (2) GDTE.calculator
# (3) ts.ci.adl.plot
# (4) ts.ci.gecm.plot



##########################################
# --------(1) pte.calculator ------------#
##########################################
#' Generate the Pulse Treatment Effect (PTE) for a given autoregressive distributed lag (ADL) model
#' @param x.vrbl a named vector of the x variables and corresponding lag orders in an ADL model
#' @param y.vrbl a named vector of the (lagged) y variables and corresponding lag orders in an ADL model
#' @param limit an integer for the number of periods to determine the PTE (beginning at 0)
#' @return a list of limit + 1 \code{mpoly} formulae containing the PTE in each period
#' @details
#' \code{pte.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the PTE in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. It is used as a subfunction in both \code{ts.ci.adl.plot} and \code{ts.ci.gecm.plot}. Note: \code{mpoly} does not allow variable names with a .; variables passed to \code{GDTE.calculator} should not include this character
#' @importFrom mpoly mp
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords utilities
#' @examples
#' # ADL(1,1)
#' x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
#' y.lags <- c("l_1_y" = 1)
#' h <- 5
#' PTEs <- pte.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = h)
#' PTEs
#' @export

pte.calculator <- function(x.vrbl, y.vrbl, limit) {
	the.final.formula.list <- the.comb.formula.list <- vector("list", 1 + limit) # extra for h = 0
	for(h in 0:limit) {
		# evaluate h = 0 seperately: no dynamics
		if(h == 0) {
			# It's whatever coefficient there is (if any) in the x.vrbl in the 0 period
			#  there is no lagged LTE(h) (the alpha.xi elements) to carry forward
			the.comb.formula.list[[h+1]] <- mp(ifelse(0 %in% x.vrbl, names(x.vrbl)[which(x.vrbl == 0)], 0)) + 0
		} else {
			# First: define the quantity that will be carried forward by the lag y (alpha*xi)
			# max number of elements is either going to be minimum of the y.order specified <or> how far
			#  into the future we've gone since s (to sync the y.order )
				alpha.xi.elements <- vector("list", length = min(h, max(y.vrbl)))
			# now, loop over these elements to replace them
			for(counter in 1:length(alpha.xi.elements)) {
				# test to see if that particular h pairs with a y lag order for the quantity alpha_i * xi_{h-i}
				if(counter %in% y.vrbl) {
					# if it does, it's the relevant y coefficient times the relevant xi quantity that matches 
					#  (have to increment by 1 since position 1 is h = 0)
					alpha.xi.elements[[counter]] <- mp(names(y.vrbl)[which(y.vrbl == counter)]) * the.comb.formula.list[[(h+1)-counter]]
				} else {
					# if there is no relevant alpha_i for that lag order, replace it with 0
					alpha.xi.elements[[counter]] <- 0
				}
			}
			# now, form the actual sum
			sum.alpha.xi <- Reduce("+", alpha.xi.elements)
			# finally, place the sum in the lted.d.elements list. this is for the LTED(h, d) elements
			#  if there is a relevant beta for that period h (beta_h), add that to the sum of the alpha_i elements
			the.comb.formula.list[[h+1]] <- mp(ifelse(h %in% x.vrbl, names(x.vrbl)[which(x.vrbl == h)], 0)) + sum.alpha.xi
		}
		### Since we're going to pass this to a GDTE calculator, we're going to leave it as mpoly rather than transform to a formula
	}
	# return the mpoly object
	the.comb.formula.list
}



##########################################
# --------(2) GDTE.calculator -----------#
##########################################
#' Generate the General Dynamic Treatment Effect (GDTE) for an autoregressive distributed lag (ADL) model, given Pulse Treatment Effects (PTEs)
#' @param d.x the order of differencing of the x variable in the ADL model. (Generally, this is the same x variable used in \code{pte.calculator})
#' @param d.y the order of differencing of the y variable in the ADL model. (Generally, this is the same y variable used in \code{pte.calculator})
#' @param n an integer for the treatment history. \code{n} determines the counterfactual series that will be applied to the independent variable. -1 represents a Pulse Treatment Effect (PTE). 0 represents a Step Treatment Effect (STE). For others, see Vande Kamp, Jordan, and Rajan
#' @param limit an integer for the number of periods to determine the GDTE (beginning at 0)
#' @param pte a list of PTEs used to construct the GDTE. We expect this will be provided by \code{pte.calculator}
#' @return a list of limit + 1 \code{mpoly} formulae containing the GDTE in each period
#' @details
#' \code{GDTE.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the GDTE in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. It is used as a subfunction in both \code{ts.ci.adl.plot} and \code{ts.ci.gecm.plot}. Note: \code{mpoly} does not allow variable names with a .; variables passed to \code{GDTE.calculator} should not include this character
#' @importFrom mpoly mp
#' @importFrom utils capture.output
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords utilities
#' @examples
#' # ADL(1,1)
#' x.lags <- c("x" = 0, "l_1_x" = 1) # lags of x
#' y.lags <- c("l_1_y" = 1)
#' h <- 5
#' PTEs <- pte.calculator(x.vrbl = x.lags, y.vrbl = y.lags, limit = h)
#' # Assume that both x and y are in levels and we want a pulse treatment
#' GDTEs.pte <- GDTE.calculator(d.x = 0, d.y = 0, n = -1, limit = h, pte = PTEs)
#' GDTEs.pte
#' # Apply a step treatmentr
#' GDTEs.ste <- GDTE.calculator(d.x = 0, d.y = 0, n = 0, limit = h, pte = PTEs)
#' GDTEs.ste
#' @export

GDTE.calculator <- function(d.x, d.y, n, limit, pte) {
	# store the binomials for double checking
	the.final.binomial.list <- vector("list", 1 + limit) # extra for h = 0
	# create a container for the GDTEs by period
	the.final.formula.list <- vector("list", 1 + limit) # extra for h = 0
	for(h in 0:limit) {
		# store the binomials for double checking
		the.binomial.list <- rep(NA, (1 + h)) # extra for j = 0
		# create a placeholder for the within-period (h) formulas. the total number of periods
		#  will depend on which period h we are in from the loop
		the.comb.formula.list <- vector("list", 1 + h) # extra for j = 0
		for(j in 0:h) {
			# following Eqn XX. within-period transformation depends on the binomial coefficient
			the.binomial <- (2 * 0^(abs(n - d.x + d.y) - (n - d.x + d.y)) - 1)^j *
						choose((abs(n - d.x + d.y) - 1 + (1 + j) * 0^(abs(n - d.x + d.y)-(n - d.x + d.y))), j)
			# store the binomial coefficient*the relevant PTE
			the.comb.formula.list[[j+1]] <- mp(the.binomial)*pte[[h-j+1]]  # extra for first element of pte = 0
			# store the binomials for double checking
			the.binomial.list[j+1] <- the.binomial
		}
		# reduce the formula elements to a sum
		sum <- Reduce("+", the.comb.formula.list)
		# capturing the console does not play nicely directly
		intermediate <- capture.output(print(sum, stars = TRUE))
		# save the formula for testing
		the.final.formula.list[[h+1]] <- intermediate # extra for h = 0
		# store the binomials for testing
		the.final.binomial.list[[h+1]] <- the.binomial.list
	}
	# store the binomials for double checking
	out <- list("formulae" = the.final.formula.list, "binomials" = the.final.binomial.list)
	out
}













##########################################
# ---------(3) ts.ci.adl.plot -----------#
##########################################
#' Evaluate (and possibly plot) the General Dynamic Treatment Effect (GDTE) for an autoregressive distributed lag (ADL) model
#' @param model the \code{lm} model containing the ADL estimates
#' @param x.vrbl a named vector of the x variables and corresponding lag orders in the ADL model
#' @param y.vrbl a named vector of the (lagged) y variables and corresponding lag orders in the ADL model
#' @param d.x the order of differencing of the x variable in the ADL model
#' @param d.y the order of differencing of the y variable in the ADL model
#' @param te.type the desired treatment history. \code{te.type} determines the counterfactual series that will be applied to the independent variable. -1 represents a Pulse Treatment Effect (PTE). 0 represents a Step Treatment Effect (STE). These can also be specified via \code{pte}, \code{pulse}, \code{ste}, and \code{step}. For others, see Vande Kamp, Jordan, and Rajan. The default is \code{pte}
#' @param inferences.x does the user want to apply the counterfactual treatment to the independent variable in levels or in differences? (For x variables where \code{d.x} is 0, this is automatically levels.) The default is \code{levels}
#' @param inferences.y does the user want resulting inferences about the dependent variable in levels or in differences? (For y variables where \code{d.y} is 0, this is automatically levels.) The default is \code{levels}
#' @param dM.level level of significance of the GDTE, calculated by the delta method. The default is 0.95
#' @param h.limit limit an integer for the number of periods to determine the GDTE (beginning at 0)
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
#' @keywords ADL plot
#' @examples
#' # ADL(1,1)
#' # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository 
#' model <- lm(y ~ l_1_y + x + l_1_x, data = toy.ts.interaction.data)
#' test.pulse <- ts.ci.adl.plot(model = model,
#'                                   x.vrbl = c("x" = 0, "l_1_x" = 1), 
#'                                   y.vrbl = c("l_1_y" = 1),
#'                                   d.x = 0, 
#'                                   d.y = 0,
#'                                   te.type = "pulse", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   h.limit = 20, 
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
#' cavari.step <- ts.ci.adl.plot(model = cavari.model,
#'                                   x.vrbl = c("MIP_FOREIGN" = 0), 
#'                                   y.vrbl = c("APPROVE_L1" = 1),
#'                                   d.x = 0,
#'                                   d.y = 0,
#'                                   te.type = "ste", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   h.limit = 10, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' @export

ts.ci.adl.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, d.x = NULL, d.y = NULL,
	te.type = "pte", inferences.y = "levels", inferences.x = "levels",
	dM.level = 0.95, h.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,
	...) {

	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(y.vrbl)) {
		stop("Variables in effects term (x and y) must be specified through x.vrbl and y.vrbl")
	}
	# Dummy checks. Is d supplied for all variables specified?
	if(is.null(d.x) | is.null(d.y)) {
		stop("Order of differencing of variables in treatment effect terms must be specified through d.x and d.y")
	}
	if((d.x%%1 != 0) | (d.y%%1 != 0)) {
		stop("Order of differencing of variables in treatment effect terms (d.x and d.y) must be an integer")
	}	
	# Dummy checks. Is there an te type?
	if(is.null(te.type)) {
		stop("Treatment effect type (te.type) must be specified")
	}
	# Dummy checks. Is the effect type valid?
	if(is.character(te.type)) {
		if(!(te.type %in% c("pte", "ste", "pulse", "step"))) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer n representing the order of the GDTE")	
		}
	} else if(suppressWarnings(as.numeric(te.type))) {
		if(te.type%%1 != 0) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer n representing the order of the GDTE")	
		}
	}
	# Dummy checks: are x/y inferences specified?
	if(!(inferences.y %in% c("levels", "differences"))) {
		stop("Invalid inferences.y. The counterfactual response for y must be either in levels or differences")
	}
	if(!(inferences.x %in% c("levels", "differences"))) {
		stop("Invalid inferences.x. The counterfactual treatment for x must be either in levels or differences")
	}
	# Dummy checks: did they ask for inferences that don't make sense?
	if(inferences.y == "differences" & d.y == 0) {
		stop("The counterfactual response for y cannot be in a higher order of differencing (d.y) than the original dependent variable")
	}
	# Dummy checks: did they ask for inferences that don't make sense?
	if(inferences.x == "differences" & d.x == 0) {
		stop("The counterfactual response for x cannot be in a higher order of differencing (d.x) than the original independent variable")
	}

	# test whether x.vrbl and y.vrbl are named vectors with numeric lag order elements
	if(!(is.numeric(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model")
	}
	# test whether x.vrbl and y.vrbl are named vectors with numeric lag order elements
	if(!(is.numeric(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model")
	}
	# test whether x.vrbl and y.vrbl are named vectors
	if(is.null(names(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model")
	}
	# test whether x.vrbl and y.vrbl are named vectors
	if(is.null(names(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model")
	}
	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}

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

	# turn the te.type into the argument n.order
	n.order <- ifelse(te.type %in% c("pte", "pulse"), -1,
				ifelse(te.type %in% c("ste", "step"), 0, te.type))
	
	the.coef <- coef(model)
	the.vcov <- vcovHC(model, type = se.type)

	# are the variables in the model?
	if(!(all(names(x.vrbl) %in% names(the.coef)))) {
		stop("x.vrbl not present in estimated model")
	}
	if(!(all(names(y.vrbl) %in% names(the.coef)))) {
		stop("y.vrbl not present in estimated model")
	}
	
	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))
		
		warning("Variable names containing . replaced with _")
	}

	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pte.calculator(x.vrbl = x.vrbl, y.vrbl = y.vrbl, limit = h.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- GDTE.calculator(d.x = calc.d.x, d.y = calc.d.y, n = n.order, limit = h.limit, pte = the.pte.formula.list)
	
	dat.out <- cbind(0:h.limit, t(sapply(the.final.formulae$formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
					
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDTE", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- paste0("h = ", 0:h.limit)		


	########################################################################
	# deal with LRM
	########################################################################		
		# #  calculate the LRM. first start with the sum of the alpha.is. these are unweighted in the sum
		# #  so we don't have to do anything but combine them!
		# alpha.is <- paste0("(1/(1-(", paste(names(y.vrbl), collapse = "+"), ")))")
		# beta.j.elements <- vector("list", length = (max(x.vrbl)+1))
		# # now we see whether the betas are there and multiply by the alpha.is sum
		# for(counter in 0:max(x.vrbl)) {
			# # test to see if that particular j pairs with a x lag order for the quantity beta_j * alpha.is (defined above)
			# if(counter %in% x.vrbl) {
				# # if that lag order is in x.vrbl, it's the relevant x (beta) coefficient times alpha.is
				# beta.j.elements[[(counter+1)]] <- paste(names(x.vrbl)[which(x.vrbl == counter)], "*", alpha.is)
			# } else {
				# # if there is no relevant beta_j for that lag order of x, replace it with 0
				# beta.j.elements[[(counter+1)]] <- 0
			# }
		# }
		# # sum all of the elements in the formula
		# sum.of.beta.j.elements <- paste(beta.j.elements, collapse = "+")
		# # save the LRM formula for testing
		# the.final.formula.list[[h.limit+2]] <- sum.of.beta.j.elements
		# # evaluate the LRM and add to the dataset as the s.limit + 1 period
		# lrm.dat <- c(as.matrix(h.limit+1), as.matrix(deltaMethod(the.coef, sum.of.beta.j.elements, vcov. = the.vcov, level = dM.level)))
		# dat.out <- rbind(dat.out, lrm.dat)

	
	########################################################################
	# plotting
	########################################################################	
	#  the.ylab <- substitute(paste("GDTE of ",
	#	Delta^xd, " ", xvar, " (in ", infx, ") on ", 
	#	Delta^yd, " ", yvar, " (in ", infy, ")"), 
	#	list(xd = original.d.x, xvar = names(x.vrbl)[1], infx = inferences.x,
	#		yd = original.d.y, yvar = names(y.vrbl)[1], infy = inferences.y))
	
	# Set plotted variables to NULL initially or else R CMD gets confused by the data call
	Period <- GDTE <- Lower <- Upper <- NULL
	plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDTE)) + 
				geom_line(lwd = 1.2) + 
				geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
				geom_hline(yintercept = 0, lwd = 1) +
				xlab("Number of Periods Since Treatment Onset (h)") +
				# ylab("Generalized Dynamic Treatment Effect") +
				ylab(bquote(GDTE[.(paste0("(", h.limit, ", ", n.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
				theme_bw() + 
				theme(panel.border = element_blank(), 
					panel.grid.major = element_blank(),
					panel.grid.minor = element_blank(), 
					axis.line = element_line(colour = "black"))	

	########################################################################
	# returning elements
	########################################################################	
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





##########################################
# ---------(4) ts.ci.gecm.plot ----------#
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
#' @param te.type the desired treatment history. \code{te.type} determines the counterfactual series that will be applied to the independent variable. -1 represents a Pulse Treatment Effect (PTE). 0 represents a Step Treatment Effect (STE). These can also be specified via \code{pte}, \code{pulse}, \code{ste}, and \code{step}. For others, see Vande Kamp, Jordan, and Rajan. The default is \code{pte}
#' @param inferences.x does the user want to apply the counterfactual treatment to the independent variable in levels or in differences? The default is \code{levels}
#' @param inferences.y does the user want resulting inferences about the dependent variable in levels or in differences? The default is \code{levels}
#' @param dM.level level of significance of the GDTE, calculated by the delta method. The default is 0.95
#' @param h.limit limit an integer for the number of periods to determine the GDTE (beginning at 0)
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
#' @keywords GECM plot
#' @examples
#' # ADL(1,1)
#' # Use the toy data to run a GECM. No argument is made this 
#' #  is well specified or even sensible; it is just expository
#' model <- lm(d_y ~ l_1_y + l_1_x + l_1_d_y + d_x + l_1_d_x, data = toy.ts.interaction.data)
#' test.pulse <- ts.ci.gecm.plot(model = model,
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
#'                                   h.limit = 10, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' names(test.pulse)
#' @export

ts.ci.gecm.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, x.vrbl.d.x = NULL, y.vrbl.d.y = NULL,
	x.d.vrbl = NULL, y.d.vrbl = NULL, x.d.vrbl.d.x = NULL, y.d.vrbl.d.y = NULL,
	te.type = "pte", inferences.y = "levels", inferences.x = "levels",
	dM.level = 0.95, h.limit = 20, se.type = "const",
	return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,	
	...) {

	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(y.vrbl) | is.null(x.d.vrbl) | is.null(y.d.vrbl)) {
		stop("Variables in treatment effects term (x and y) and lagged differences must be specified through x.vrbl, y.vrbl, x.d.vrbl, and y.d.vrbl for a GECM")
	}
	# Dummy checks. if the order of differencing for x.vrbl/y.vrbl specified?
	if(is.null(x.vrbl.d.x) | is.null(y.vrbl.d.y)) {
		stop("Order of differencing of variables in treatment effects term (x and y) must be specified through x.vrbl.d.x and y.vrbl.d.y")
	}
	# Dummy checks. if the order of differencing for x.d.vrbl/y.d.vrbl specified?
	if(is.null(x.d.vrbl.d.x) | is.null(y.d.vrbl.d.y)) {
		stop("Order of differencing of variables in lagged differences (x and y) must be specified through x.d.vrbl.d.x and y.d.vrbl.d.y")
	}
	# Is the order of differencing an integer? (d(0) term)
	if((x.vrbl.d.x%%1 != 0) | (y.vrbl.d.y%%1 != 0)) {
		stop("Order of differencing of variables in treatment effects term (x.vrbl.d.x and y.vrbl.d.y) must be an integer")
	}
	# Is the order of differencing an integer? (d(1) term)
	if((x.d.vrbl.d.x%%1 != 0) | (y.d.vrbl.d.y%%1 != 0)) {
		stop("Order of differencing of variables in lagged differences (x.d.vrbl.d.x and y.d.vrbl.d.y) must be an integer")
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
	# Dummy checks. Is there an effect type? 
	if(is.null(te.type)) {
		stop("Treatment effect type must be specified")
	}
	# Dummy checks. Is the effect type valid?
	if(is.character(te.type)) {
		if(!(te.type %in% c("pte", "ste", "pulse", "step"))) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer n representing the order of the GDTE")	
		}
	} else if(suppressWarnings(as.numeric(te.type))) {
		if(te.type%%1 != 0) {
			stop("Invalid te.type. te.type must be one of pte (pulse) or ste (step), or any as.numeric integer n representing the order of the GDTE")	
		}
	}
	if(inferences.x != "levels" | inferences.y != "levels") {
		stop("In a GECM, causal inferences regarding the treatment effect of x on y are automatically recovered in levels")
	}
	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}

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

	# turn the te.type into the argument n.order
	n.order <- ifelse(te.type %in% c("pte", "pulse"), -1,
				ifelse(te.type %in% c("ste", "step"), 0, te.type))

	the.coef <- coef(model)
	the.vcov <- vcovHC(model, type = se.type)

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

	# Reconstruct the ADL equivalents from the GECM. First, make helper versions of x.vrbl and y.vrbl that aren't 
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



	########################################################################
	# subfunctions for calculations
	########################################################################
	# establish container for results
	the.pte.formula.list <- pte.calculator(x.vrbl = x.vrbl.adl, y.vrbl = y.vrbl.adl, limit = h.limit)
	
	# with the PTE, apply Eqn XX from the paper
	the.final.formulae <- GDTE.calculator(d.x = calc.d.x, d.y = calc.d.y, n = n.order, limit = h.limit, pte = the.pte.formula.list)
	
	dat.out <- cbind(0:h.limit, t(sapply(the.final.formulae$formulae, function(f) {
						deltaMethod(the.coef, g = f, vcov. = the.vcov, level = dM.level)
					})))
					
	# frame the data; assign names
	dat.out <- 	data.frame(lapply(data.frame(dat.out), function(x) if (is.list(x)) unlist(x) else x))
	
	names(dat.out) <- c("Period", "GDTE", "SE", "Lower", "Upper")
	# name the formula list
	names(the.final.formulae$formulae) <- paste0("h = ", 0:h.limit)	


	########################################################################
	# deal with LRM
	########################################################################		
		# #  calculate the LRM. first start with the sum of the alpha.is. these are unweighted in the sum
		# #  so we don't have to do anything but combine them!
		# alpha.is <- paste0("(1/(1-(", paste(names(y.vrbl), collapse = "+"), ")))")
		# beta.j.elements <- vector("list", length = (max(x.vrbl)+1))
		# # now we see whether the betas are there and multiply by the alpha.is sum
		# for(counter in 0:max(x.vrbl)) {
			# # test to see if that particular j pairs with a x lag order for the quantity beta_j * alpha.is (defined above)
			# if(counter %in% x.vrbl) {
				# # if that lag order is in x.vrbl, it's the relevant x (beta) coefficient times alpha.is
				# beta.j.elements[[(counter+1)]] <- paste(names(x.vrbl)[which(x.vrbl == counter)], "*", alpha.is)
			# } else {
				# # if there is no relevant beta_j for that lag order of x, replace it with 0
				# beta.j.elements[[(counter+1)]] <- 0
			# }
		# }
		# # sum all of the elements in the formula
		# sum.of.beta.j.elements <- paste(beta.j.elements, collapse = "+")
		# # save the LRM formula for testing
		# the.final.formula.list[[h.limit+2]] <- sum.of.beta.j.elements
		# # evaluate the LRM and add to the dataset as the s.limit + 1 period
		# lrm.dat <- c(as.matrix(h.limit+1), as.matrix(deltaMethod(the.coef, sum.of.beta.j.elements, vcov. = the.vcov, level = dM.level)))
		# dat.out <- rbind(dat.out, lrm.dat)


	########################################################################
	# plotting
	########################################################################	
	#  the.ylab <- substitute(paste("GDTE of ",
	#	Delta^xd, " ", xvar, " (in ", infx, ") on ", 
	#	Delta^yd, " ", yvar, " (in ", infy, ")"), 
	#	list(xd = original.d.x, xvar = names(x.vrbl)[1], infx = inferences.x,
	#		yd = original.d.y, yvar = names(y.vrbl)[1], infy = inferences.y))

	# Set plotted variables to NULL initially or else R CMD gets confused by the data call
	Period <- GDTE <- Lower <- Upper <- NULL
	plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDTE)) + 
				geom_line(lwd = 1.2) + 
				geom_ribbon(data = dat.out, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
				geom_hline(yintercept = 0, lwd = 1) +
				xlab("Number of Periods Since Treatment Onset (h)") +
				# ylab("Generalized Dynamic Treatment Effect") +
				ylab(bquote(GDTE[.(paste0("(", h.limit, ", ", n.order, ", ", plot.d.y, ", ",  plot.d.x, ")"))])) +
				theme_bw() + 
				theme(panel.border = element_blank(), 
					panel.grid.major = element_blank(),
					panel.grid.minor = element_blank(), 
					axis.line = element_line(colour = "black"))

	########################################################################
	# returning elements
	########################################################################	
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

