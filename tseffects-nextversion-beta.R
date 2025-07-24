# version 0.1.1.9001
# 7/22/2025
# Authors: Soren Jordan, Garrett N. Vande Kamp, Reshi Rajan

stupid

# TO DO (next version):
#   Somehow test whether someone is using ts.effect.plot when they are also specifying an interaction
#   Include ts.effects.plot
#   Include ts.interact.plot

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
#' @usage data(presapp)
#' @name presapp
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
#'	 \item{l.1.x}{First lag of x}
#'	 \item{l.2.x}{Second lag of x}
#'	 \item{l.3.x}{Third lag of x}
#'	 \item{l.4.x}{Fourth lag of x}
#'	 \item{l.5.x}{Fifth lag of x}
#'	 \item{d.x}{First difference of x}
#'	 \item{l.1.d.x}{First lag of first difference of x}
#'	 \item{l.2.d.x}{Second lag of first difference of x}
#'	 \item{z}{Contemporaneous z}
#'	 \item{l.1.z}{First lag of z}
#'	 \item{l.2.z}{Second lag of z}
#'	 \item{l.3.z}{Third lag of z}
#'	 \item{l.4.z}{Fourth lag of z}
#'	 \item{l.5.z}{Fifth lag of z}
#'	 \item{y}{Contemporaneous y}
#'	 \item{l.1.y}{First lag of y}
#'	 \item{l.2.y}{Second lag of y}
#'	 \item{l.3.y}{Third lag of y}
#'	 \item{l.4.y}{Fourth lag of y}
#'	 \item{l.5.y}{Fifth lag of y}
#'	 \item{d.y}{First difference of y}
#'	 \item{l.1.d.y}{First lag of first difference of y}
#'	 \item{x.z}{Interaction of contemporaneous x and z}
#'	 \item{x.l.1.z}{Interaction of contemporaneous x and lagged z}
#'	 \item{z.l.1.x}{Interaction of lagged x and contemporaneous z}
#'	 \item{l.1.x.l.1.z}{Interaction of lagged x and lagged z}
#' }
#' @docType data
#' @keywords datasets
#' @usage data(simdata)
#' @name simdata
NULL




## Functions:
## Dependencies: 	
#		mpoly (for formula construction)
#		car (for deltaMethod)
#		ggplot2 (for plots)
#		see (for okabe-ito)
#		colorspace (for grays)
#		stats (for lm coef vcov)
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
#' \code{pte.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the PTE in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. It is used as a subfunction in both \code{ts.ci.adl.plot} and \code{ts.ci.gecm.plot}
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
#' \code{GDTE.calculator} does no calculation. It generates a list of \code{mpoly} formulae that contain variable names that represent the GDTE in each period. The expectation is that these will be evaluated using coefficients from an object containing an ADL model with corresponding variables. It is used as a subfunction in both \code{ts.ci.adl.plot} and \code{ts.ci.gecm.plot}
#' @importFrom mpoly mp
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
#' @importFrom ggplot2 ggplot
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords ADL plot
#' @examples
#' # ADL(1,1)
#' # Use the toy data to run an ADL. No argument is made this is well specified; it is just expository 
#' model <- lm(y ~ l.1.y + x + l.1.x, data = toy.ts.interaction.data)
#' test.pulse <- ts.ci.adl.plot(model = model,
#'                                   x.vrbl = c("x" = 0, "l.1.x" = 1), 
#'                                   y.vrbl = c("l.1.y" = 1),
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
#' # Cavari's original model: APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + MIP_FOREIGN + 
#' #     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#' #     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT)
#' 
#' cavari.model <- lm(APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + MIP_FOREIGN +
#'      APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#'      DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT), data = approve)
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
#'                                   h.limit = 20, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)

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

	plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDTE)) + 
				geom_line(lwd = 1.2) + 
				geom_ribbon(aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
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
#' @importFrom ggplot2 ggplot
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshi Rajan
#' @keywords GECM plot
#' @examples
#' # ADL(1,1)
#' # Use the toy data to run a GECM. No argument is made this is well specified or even sensible; it is just expository
#' model <- lm(d.y ~ l.1.y + l.1.x + l.1.d.y + d.x + l.1.d.x, data = toy.ts.interaction.data)
#' test.pulse <- ts.ci.gecm.plot(model = model,
#'                                   x.vrbl = c("l.1.x" = 1), 
#'                                   y.vrbl = c("l.1.y" = 1),
#'                                   x.vrbl.d.x = 0, 
#'                                   y.vrbl.d.y = 0,
#'                                   x.d.vrbl = c("d.x" = 0, "l.1.d.x" = 1),
#'                                   y.d.vrbl = c("l.1.d.y" = 1),
#'                                   x.d.vrbl.d.x = 1,
#'                                   y.d.vrbl.d.y = 1,
#'                                   te.type = "pulse", 
#'                                   inferences.y = "levels", 
#'                                   inferences.x = "levels",
#'                                   h.limit = 20, 
#'                                   return.plot = TRUE, 
#'                                   return.formulae = TRUE)
#' names(test.pulse)

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

	plot.out <- ggplot(data = dat.out, aes(x = Period, y = GDTE)) + 
				geom_line(lwd = 1.2) + 
				geom_ribbon(aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.2) +
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
# -------(1) ts.effect.plot ----------#
##########################################
#' Plot the effects from a single-equation time series model estimated via \code{lm}. It is imperative that you double-check you have referenced all x and y terms through \code{x.vrbl} and \code{y.vrbl}. You must also have their orders correctly entered. \code{ts.effect.plot} has no way of determining, from the variable list, which correspond with which
#' @param model \code{lm} model that contains the time series model
#' @param x.vrbl named vector with the ``main'' x variable. Correspond variable names to lag order (i.e. \code{x.vrbl = c("x" = 0, "l.1.x" = 1)})
#' @param y.vrbl named vector with the lagged dependent variable. Correspond variable names to lag order (i.e. \code{y.vrbl = c("l.1.y" = 1, "l.2.y" = 2)})
#' @param effect.type one of \code{x.me} (marginal effect of x), \code{x.cme} (cumulative marginal effect of x)
#' @param dM.level the significance level of the (cumulative) marginal effects (used by \code{deltaMethod})
#' @param return.data return the estimated effects dataframe in the created object (as opposed to just creating the plot)
#' @param return.plot return the plot to the console (as opposed to just creating the data)
#' @param return.formulae return the constructed formulae for the period-specific (s) calculations
#' @param s.limit number of time periods from a shock to calculate
#' @param ... other arguments to be passed to the call to plot
#' @importFrom stats lm coef vcov
#' @importFrom ggplot2 gpplot
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshikesav Rajan
#' @keywords interaction plot
#' @examples
#' 
#' # Use well-behaved simulated data (included)
#' model.toydata <- lm(y ~ l.1.y + x + l.1.x, data = toy.ts.interaction.data)
#'
#' # Marginal effect of x
#' ts.effect.plot(model = model.toydata, x.vrbl = c("x" = 0, "l.1.x" = 1), y.vrbl = c("l.1.y" = 1),
#'					effect.type = "x.me", s.limit = 20)
#' 
#' # Cumulative marginal effect of x. You can store the data to draw your own plot,
#' #  if you prefer
#' test.x.cme <- ts.effect.plot(model = model.toydata, x.vrbl = c("x" = 0, "l.1.x" = 1), y.vrbl = c("l.1.y" = 1),
#'					effect.type = "x.cme", return.data = TRUE, s.limit = 20)
#' test.x.cme$plot
#'
#' @export


ts.effect.plot <- function(model = NULL, x.vrbl = NULL, y.vrbl = NULL, 
	effect.type = NULL, dM.level = 0.95, return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,
	s.limit = 20, se.type = "const",
	...) {

	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(y.vrbl)) {
		stop("Variables in effects term (x and y) must be specified through x.vrbl and y.vrbl")
	}
	
	# Dummy checks. Is there an effect type? The default will be NULL as long as this combines both .me and interactive .me
	if(is.null(effect.type)) {
		stop("Effect type must be specified")
	}
	# Dummy checks. Is the effect type valid?
	if(!(effect.type %in% c("x.me", "x.cme"))) {
		stop("Invalid effect.type. effect.type must be one of x.me or x.cme")						
	}
	# test whether x.vrbl and y.vrbl are named vectors
	if(!(is.numeric(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model.")
	}
	# test whether x.vrbl and y.vrbl are named vectors
	if(!(is.numeric(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
	}
	# test whether x.vrbl and y.vrbl are named vectors
	if(is.null(names(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model.")
	}
	# test whether x.vrbl and y.vrbl are named vectors
	if(is.null(names(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
	}
	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}

	
	the.coef <- coef(model)
	the.vcov <- vcovHC(model, type = se.type)

	x.order <- max(x.vrbl)
	y.order <- max(y.vrbl)

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
	# below begins the calculation / plotting meat
	########################################################################
	if(effect.type %in% c("x.me", "x.cme")) {
		# establish container for results
		dat.out <- matrix(rep(NA, length(0:s.limit)*5), nrow = length(0:s.limit))	
		
		# empty list container for formulas for each s
		if(effect.type == "x.me") {
			the.final.formula.list <- the.comb.formula.list <- vector("list", 1 + s.limit) # extra for s = 0
		} else if(effect.type == "x.cme") {
			the.final.formula.list <- the.comb.formula.list <- vector("list", 2 + s.limit) # extra for s = 0 and LRM
		}
		## We're going to establish the impulse response for all periods. Cumulative just sums them. We will do this the lazy way
		for(s in 0:s.limit) {
			# evaluate s = 0 seperately: no dynamics
			if(s == 0) {
				# if there is a contemporaneous x, that's it, or else it's 0
				#  have to adjust by 1 since the counter for index starts at 1
				the.comb.formula.list[[s+1]] <- mp(ifelse(0 %in% x.vrbl, names(x.vrbl)[which(x.vrbl == 0)], 0))
			} else {
				# First: define the quantity that will be carried forward by the lag y (alpha*xi)
				# max number of elements is either going to be minimum of the y.order specified <or> how far
				#  into the future we've gone since s (to sync the y.order )
				alpha.xi.elements <- vector("list", length = min(s, max(y.vrbl)))
				# now, loop over these elements to replace them
				for(counter in 1:length(alpha.xi.elements)) {
					# test to see if that particular s pairs with a y lag order for the quantity alpha_i * xi_{s-i}
					if(counter %in% y.vrbl) {
						# if it does, it's the relevant y coefficient times the relevant xi quantity that matches 
						#  (have to increment the.comb.formula.list[s] by 1 since it position 1 is s = 0)
						alpha.xi.elements[[counter]] <- mp(names(y.vrbl)[which(y.vrbl == counter)]) * the.comb.formula.list[[(s+1)-counter]]
					} else {
						# if there is no relevant alpha_i for that lag order, replace it with 0
						alpha.xi.elements[[counter]] <- 0
					}
				}
				# now, form the actual sum
				sum.alpha.xi <- Reduce("+", alpha.xi.elements)
				# finally, place the sum in the formula list
				#  if there is a relevant beta for that period s (beta_s), add that to the sum of the alpha_i elements
				the.comb.formula.list[[s+1]] <- mp(ifelse(s %in% x.vrbl, names(x.vrbl)[which(x.vrbl == s)], 0)) + sum.alpha.xi
			}
			# now with the formula, the effect calculation will depend on the effect type
			if(effect.type == "x.me") {
				# for the marginal effect, we evaluate period each by itself
				intermediate <- capture.output(print(the.comb.formula.list[[s+1]], stars = TRUE))
			} else if(effect.type == "x.cme") {
				# only other effect is x.cme. just the sum of the formulae from each s (so far)
				intermediate <- capture.output(print(Reduce("+", the.comb.formula.list[1:(s+1)]), stars = TRUE))
			}
			# save the formula for testing
			the.final.formula.list[[s+1]] <- intermediate
			dat.out[(s+1),] <- c(as.matrix(s), as.matrix(deltaMethod(the.coef, paste(intermediate), vcov. = the.vcov, level = dM.level)))
		} # this closes the s loop
		# with all quantities estimated, we move to plotting. first, frame the data for ggplot
		dat.out <- data.frame(dat.out) 
		# if it's the ME, there is no LRM
		if(effect.type == "x.me") {
			# name the formula list
			names(the.final.formula.list) <- paste0("s = ", 0:s.limit)			
			# name the dataset for use with ggplot
			names(dat.out) <- c("Period", "ME", "SE", "Lower", "Upper")
			#######################
			# x-axis: s; y-axis: ME
			#######################
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = ME)) + 
							geom_line(lwd = 1.2) + 
							geom_ribbon(aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.1) +
							geom_hline(yintercept = 0, lwd = 1) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))			
		} else if(effect.type == "x.cme") { # only other effect is x.cme (in this branch)
			#  calculate the LRM. first start with the sum of the alpha.is. these are unweighted in the sum
			#  so we don't have to do anything but combine them!
			alpha.is <- paste0("(1/(1-(", paste(names(y.vrbl), collapse = "+"), ")))")
			beta.j.elements <- vector("list", length = (max(x.vrbl)+1))
			# now we see whether the betas are there and multiply by the alpha.is sum
			for(counter in 0:max(x.vrbl)) {
				# test to see if that particular j pairs with a x lag order for the quantity beta_j * alpha.is (defined above)
				if(counter %in% x.vrbl) {
					# if that lag order is in x.vrbl, it's the relevant x (beta) coefficient times alpha.is
					beta.j.elements[[(counter+1)]] <- paste(names(x.vrbl)[which(x.vrbl == counter)], "*", alpha.is)
				} else {
					# if there is no relevant beta_j for that lag order of x, replace it with 0
					beta.j.elements[[(counter+1)]] <- 0
				}
			}
			# sum all of the elements in the formula
			sum.of.beta.j.elements <- paste(beta.j.elements, collapse = "+")
			# save the LRM formula for testing
			the.final.formula.list[[s.limit+2]] <- sum.of.beta.j.elements
			# evaluate the LRM and add to the dataset as the s.limit + 1 period
			lrm.dat <- c(as.matrix(s.limit+1), as.matrix(deltaMethod(the.coef, sum.of.beta.j.elements, vcov. = the.vcov, level = dM.level)))
			dat.out <- rbind(dat.out, lrm.dat)
			# name the formula list
			names(the.final.formula.list) <- c(paste0("s = ", 0:s.limit), "LRM")
			# name the dataset for use with ggplot			
			names(dat.out) <- c("Period", "CME", "SE", "Lower", "Upper")
			#######################
			# x-axis: s; y-axis: CME
			#######################
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
			# make a small dataset that excludes the LRM
			plotting.data.lrm <- dat.out[(dat.out$Period %in% 0:s.limit),]
			plot.out <- ggplot(data = plotting.data.lrm, aes(x = Period, y = CME)) + 
							geom_line(lwd = 1.2) + 
							geom_ribbon(data = plotting.data.lrm, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.1) +
							geom_hline(yintercept = 0, lwd = 1) +
							geom_segment(aes(x = lrm.space, xend = lrm.space, y = Lower[s.limit+1], yend = Upper[s.limit+1]), lwd = 1.25, color = "black") +
							geom_point(aes(x = lrm.space, y = CME[s.limit+1]), size = 3) +
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), lrm.space), 
									labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Cumulative Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
			# rename last row: account for the 0 at the beginning of s
			dat.out$Period[s.limit+2] <- "LRM"	
		}
	}  # this ends the x.me and x.cme

	# clean, get out
	if(return.plot == TRUE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, dat.out, the.final.formula.list)
				names(out) <- c("plot", "estimates", "formulae")
			} else if(return.formulae == FALSE) {
				out <- list(plot.out, dat.out)
				names(out) <- c("plot", "estimates")				
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, the.final.formula.list)
				names(out) <- c("plot", "formulae")
			} else if(return.formulae == FALSE) {
				out <- plot.out
			}			
		}
	} else if(return.plot == FALSE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(dat.out, the.final.formula.list)
				names(out) <- c("estimates", "formulae")
			} else if(return.formulae == FALSE) {
				out <- dat.out
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- the.final.formula.list
			} else if(return.formulae == FALSE) {
				stop("Return at least one of the plot, the data, or the formulae")
			}			
		}
	}
	out
}














##########################################
# -------(2) ts.interact.plot ----------#
##########################################
#' Plot the interaction in a single-equation time series model estimated via \code{lm}. It is imperative that you double-check you have referenced all x, y, z, and interaction terms through \code{x.vrbl}, \code{y.vrbl}, \code{z.vrbl}, and \code{x.z.vrbl}. You must also have their orders correctly entered. \code{ts.interact.plot} has no way of determining, from the variable list, which correspond with which
#' @param model \code{lm} model that contains the time series model
#' @param x.vrbl named vector with the ``main'' x variable. Correspond variable names to lag order (i.e. \code{x.vrbl = c("x" = 0, "l.1.x" = 1)})
#' @param z.vrbl named vector with the ``moderating'' z variable. Correspond variable names to lag order (i.e. \code{z.vrbl = c("z" = 0, "l.1.z" = 1)})
#' @param y.vrbl named vector with the lagged dependent variable. Correspond variable names to lag order (i.e. \code{y.vrbl = c("l.1.y" = 1, "l.2.y" = 2)})
#' @param x.z.vrbl named vector with the interaction variable. Correspond variable names to lag order (i.e. \code{x.z.vrbl = c("x.z" = 0, "l.1.x.l.1.z" = 1)})
#' @param effect.type one of \code{xz.me.zlines} (marginal effects, with the line types by values of the moderating variable), \code{xz.me.heatmap.onlysig} (heatmap of the marginal effects, but colored white if the effect does not meet the \code{dM.level}), \code{xz.me.heatmap} (heatmap of the marginal effects, as estimated), \code{xz.cme.zlines} (cumulative marginal effects, with the line types by values of the moderating variable), \code{xz.cme.slines} (cumulative marginal effects, with the line types by values of the period since the shock), \code{xz.cme.heatmap.onlysig} (heatmap of the cumulative marginal effects, but colored white if the effect does not meet the \code{dM.level}), or \code{xz.cme.heatmap} (heatmap of the marginal effects, as estimated)
#' @param dM.level the significance level of the (cumulative) marginal effects (used by \code{deltaMethod})
#' @param return.data return the estimated effects dataframe in the created object (as opposed to just creating the plot)
#' @param return.plot return the plot to the console (as opposed to just creating the data)
#' @param return.formulae return the constructed formulae for the period-specific (s) calculations
#' @param heatmap.colors what color scale would you like for the heatmap? This defaults to ``Blue-Red.'' Alternate colors must be one of \code{hcl.pals()}. For grayscale plots, use \code{Grays}. This is passed to \code{scale_fill_gradientn}
#' @param line.colors what color lines would you like for line type plots? This defaults to the color-safe Okabe-Ito colors. We also included a grayscale option through \code{bw}. Users can also include whatever colors they like. This is passed to \code{scale_color_discrete}
#' @param z.vals values for the moderating variable, if a line type plot is to be drawn
#' @param z.limits what is the range of values of the moderating variable to plot, if a heatmap is to be drawn
#' @param s.limit number of time periods from a shock to calculate
#' @param z.label.rounding number of digits to round to for the z labels in the legend (if those values are automatically calculated)
#' @param s.vals values for the time since the shock, if \code{xz.cme.slines} plot is to be drawn. The default is 0 (short-run) and the \code{LRM}
#' @param ... other arguments to be passed to the call to plot
#' @importFrom stats lm coef vcov
#' @importFrom ggplot2 gpplot
#' @importFrom mpoly mp
#' @importFrom car deltaMethod
#' @importFrom sandwich vcovHC
#' @author Soren Jordan, Garrett N. Vande Kamp, and Reshikesav Rajan
#' @keywords interaction plot
#' @examples
#' # Using Cavari's (2019) approval model
#' # Cavari's original model: APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + 
#' #     MIP_FOREIGN + APPROVE_ECONOMY*MIP_MACROECONOMICS + APPROVE_FOREIGN*MIP_FOREIGN + 
#' #     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#' #     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT)
#' 
#' approve$ECONAPP_ECONMIP <- approve$APPROVE_ECONOMY*approve$MIP_MACROECONOMICS
#' approve$FPAPP_ECONFP <- approve$APPROVE_FOREIGN*approve$MIP_FOREIGN
#' 
#' cavari.model <- lm(APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + 
#'      MIP_FOREIGN + ECONAPP_ECONMIP + FPAPP_ECONFP + 
#'      APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#'      DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT), data = approve)
#' 
#' # Now: marginal effect of X at different levels of Z
#' ts.interact.plot(model = cavari.model, x.vrbl = c("APPROVE_ECONOMY" = 0), y.vrbl = c("APPROVE_L1" = 1),
#' 		z.vrbl = c("MIP_MACROECONOMICS" = 0), x.z.vrbl = c("ECONAPP_ECONMIP" = 0),
#'		effect.type = "xz.me.zlines")
#' 
#' # Use well-behaved simulated data (included) for even more examples
#' model.toydata <- lm(y ~ l.1.y + x + l.1.x + z + l.1.z +
#'		x.z + l.1.x.l.1.z, data = toy.ts.interaction.data)
#' 
#' # Marginal effect of z
#' ts.interact.plot(model = model.toydata, x.vrbl = c("x" = 0, "l.1.x" = 1), y.vrbl = c("l.1.y" = 1), z.vrbl = c("z" = 0, "l.1.z" = 1),
#'					x.z.vrbl = c("x.z" = 0, "l.1.x.l.1.z" = 1),
#'					z.vals = -2:2,
#'					effect.type = "xz.me.zlines", s.limit = 20)
#' 
#' # Heatmap of marginal effects, since X and Z are actually continuous
#' ts.interact.plot(model = model.toydata, x.vrbl = c("x" = 0, "l.1.x" = 1), y.vrbl = c("l.1.y" = 1), z.vrbl = c("z" = 0, "l.1.z" = 1),
#'					x.z.vrbl = c("x.z" = 0, "l.1.x.l.1.z" = 1),
#'					z.limit = c(-2, 2),
#'					effect.type = "xz.me.heatmap.onlysig", s.limit = 20)
#' 
#' # Values of the short- and long-run effects at different Z values
#' ts.interact.plot(model = model.toydata, x.vrbl = c("x" = 0, "l.1.x" = 1), y.vrbl = c("l.1.y" = 1), z.vrbl = c("z" = 0, "l.1.z" = 1),
#'					x.z.vrbl = c("x.z" = 0, "l.1.x.l.1.z" = 1),
#'					s.vals = c(0, "LRM"),
#'					effect.type = "xz.me.slines", s.limit = 20)
#'
#' @export





ts.interact.plot <- function(model = NULL, x.vrbl = NULL, z.vrbl = NULL, y.vrbl = NULL, x.z.vrbl = NULL,
	effect.type = NULL, dM.level = 0.95, return.data = FALSE, return.plot = TRUE, return.formulae = FALSE,
	heatmap.colors = "Blue-Red", line.colors = "okabe-ito",
	z.vals = NULL, z.limits = NULL, s.limit = 20, z.label.rounding = 3, s.vals = c(0, "LRM"), se.type = "const",
	...) {

	# Dummy checks. Are all variables specified?
	if(is.null(x.vrbl) | is.null(y.vrbl) | is.null(z.vrbl) | is.null(x.z.vrbl)) {
		stop("Variables in interaction term (x, y, z, and x.z) must be specified through x.vrbl, y.vrbl, z.vrbl, and x.z.vrbl")
	}
	
	# Dummy checks. Is there an effect type? The default will be NULL as long as this combines both .me and interactive .me
	if(is.null(effect.type)) {
		stop("Effect type must be specified")
	}
	# Dummy checks. Is the effect type valid?
	if(!(effect.type %in% c("xz.me.zlines", "xz.me.heatmap.onlysig", "xz.me.heatmap",
							"xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap"))) {
		stop("Invalid effect.type. effect.type must be one of xz.me.zlines, 
							xz.me.heatmap.onlysig, xz.me.heatmap, xz.cme.zlines, xz.cme.slines, 
							xz.cme.heatmap.onlysig, or xz.cme.heatmap")						
	}

	# test whether x.vrbl is a named vector
	if(!(is.numeric(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model.")
	}
	# test whether y.vrbl is a named vector
	if(!(is.numeric(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
	}
	# test whether z.vrbl is a named vector
	if(!(is.numeric(z.vrbl))) {
		stop("z.vrbl should be a named vector with elements equal to lag orders of z and names equal to z variable names in model.")
	}
	# test whether x.z.vrbl is a named vector
	if(!(is.numeric(x.z.vrbl))) {
		stop("x.z.vrbl should be a named vector with elements equal to lag orders of x.z (the interaction) and names equal to x.z variable names in model.")
	}

	# test whether x.vrbl is a named vector
	if(is.null(names(x.vrbl))) {
		stop("x.vrbl should be a named vector with elements equal to lag orders of x and names equal to x variable names in model.")
	}
	# test whether y.vrbl is a named vector
	if(is.null(names(y.vrbl))) {
		stop("y.vrbl should be a named vector with elements equal to lag orders of y and names equal to y variable names in model.")
	}
	# test whether z.vrbl is a named vector
	if(is.null(names(z.vrbl))) {
		stop("z.vrbl should be a named vector with elements equal to lag orders of z and names equal to z variable names in model.")
	}
	# test whether x.z.vrbl is a named vector
	if(is.null(names(x.z.vrbl))) {
		stop("x.z.vrbl should be a named vector with elements equal to lag orders of x.z (the interaction) and names equal to x.z variable names in model.")
	}
	# test whether se.type is in that for vcov
	if(!(se.type %in% c("HC3", "const", "HC", "HC0", "HC1", "HC2", "HC4", "HC4m", "HC5"))) {
		stop("Invalid se.type. se.type must be an accepted type for the vcovHC() function from the sandwich package")						
	}

	the.coef <- coef(model)
	the.vcov <- vcovHC(model, type = se.type)

	x.order <- max(x.vrbl)
	y.order <- max(y.vrbl)
	z.order <- max(z.vrbl)
	x.z.order <-  max(x.z.vrbl)

	# mpoly does not play nicely with \\. We have to replace and warn
	if(any(grepl("\\.", names(coef(model))))) {
		# replace names of the.coef
		names(the.coef) <- gsub('\\.', '\\_', names(the.coef))
		# vcov is symmetric so we can replace both at once
		colnames(the.vcov) <- rownames(the.vcov) <- gsub('\\.', '\\_', colnames(the.vcov))
		# and for the user-supplied stuff
		names(x.vrbl) <- gsub('\\.', '\\_', names(x.vrbl))
		names(y.vrbl) <- gsub('\\.', '\\_', names(y.vrbl))
		if(!(is.null(z.vrbl))) {
			names(z.vrbl) <- gsub('\\.', '\\_', names(z.vrbl))	
		}
		if(!(is.null(x.z.vrbl))) {
			names(x.z.vrbl) <- gsub('\\.', '\\_', names(x.z.vrbl))	
		}
		warning("Variable names containing . replaced with _")
	}
		
	# are the variables in the model?
	if(!(all(names(x.vrbl) %in% names(the.coef)))) {
		stop("x.vrbl not present in estimated model")
	}
	if(!(all(names(y.vrbl) %in% names(the.coef)))) {
		stop("y.vrbl not present in estimated model")
	}
	if(!(is.null(z.vrbl)) & !(all(names(z.vrbl) %in% names(the.coef)))) {
		stop("z.vrbl not present in estimated model")
	}
	if(!(is.null(x.z.vrbl)) & !(all(names(x.z.vrbl) %in% names(the.coef)))) {
		stop("x.z.vrbl not present in estimated model")
	}

	# z.limits: check if there are only 2; if they form an interval; are only z.vals or z.limits specified?
	if(!(is.null(z.limits))) {
		if(length(z.limits) != 2) {
			stop("z.limits should only be two values: the lower and upper limits of the z variable for which the effect will be calculated")			
		}	
		if(z.limits[1] >= z.limits[2]) {
			stop("First z.limit should be lower than second z.limit")
		} 
		if(!(is.null(z.vals))) {
			stop("Specify only z.limits or z.vals")
		}
	}

	# svals: if it is a slines plot, make sure it's only 5 s values to plot
	if(effect.type %in% c("xz.cme.slines")) { # if it is slines
		if(length(s.vals) > 5) { # make sure it's only 5 s values to plot
			stop("Do not supply more than 5 discrete values of s to plot. The plot is too busy")				
		}
	}			
				
	# establish z.vals. if it's an interactive model
	the.z <- model.frame(model)[names(z.vrbl)[1]]
	potential.zline.limits <- c((mean(the.z[,1], na.rm = TRUE) - sd(the.z[,1], na.rm = TRUE)), (mean(the.z[,1], na.rm = TRUE) + sd(the.z[,1], na.rm = TRUE)))
	potential.zrange.limits <- c((mean(the.z[,1], na.rm = TRUE) - 2*sd(the.z[,1], na.rm = TRUE)), (mean(the.z[,1], na.rm = TRUE) + 2*sd(the.z[,1], na.rm = TRUE)))
	if(effect.type %in% c("xz.me.zlines", "xz.cme.zlines")) { 		# if it is z.lines
		if(!is.null(z.limits)) { # if they specified z.limits, make three lines using their limits
			z.vals <- seq(z.limits[1], z.limits[2], length.out = 3) 
		} else if(!(is.null(z.vals))) {  # if they specified z.vals
			if(length(z.vals) > 5) { # make sure it's only 5
				stop("Do not supply more than 5 discrete values of z to plot. The plot is too busy")
			}				
		} else if(is.null(z.vals)) { # if they didn't specify z.limits or z.vals
			if(length(table(the.z)) < 6) {  # if the variable is discrete
				z.vals <- as.numeric(names(table(the.z)))
			} else { # if it's continuous: for zlines, its mean +/- 1 s.d. (and the mean)
				z.vals <- seq(potential.zline.limits[1], potential.zline.limits[2], length.out = 3)
			}
		}
	} else if(effect.type %in% c("xz.cme.slines")) { # if it is slines
		if(!is.null(z.limits)) { # if they specified z.limits, make 50 vals using their limits
			z.vals <- seq(z.limits[1], z.limits[2], length.out = 50)		
		} else if(!(is.null(z.vals))) { # if they specified z.vals
			if(length(z.vals) < 6) { # if there are too few, warn them
				warning("s lines will be very choppy for so few z.vals. Consider supplying a range of z through z.limits")
			}				
		} else if(is.null(z.vals)) {  # if they didn't specify z.limits or z.vals, make 50 vals using mean +/- 2 s.d. 
			z.vals <- seq(potential.zrange.limits[1], potential.zrange.limits[2], length.out = 50)			
		}
	} else if(effect.type %in% c("xz.me.heatmap", "xz.me.heatmap.onlysig", "xz.cme.heatmap", "xz.cme.heatmap.onlysig")) { #if it's a heatmap
		if (!is.null(z.limits)) { # if they specified z.limits, make 50 vals using their limits
			z.vals <- seq(z.limits[1], z.limits[2], length.out = 50)		
		} else if(!(is.null(z.vals))) { # if they specified z.vals
			if(length(z.vals) < 6) { # if there are too few, warn them
				warning("Heatmap will be very blocky for so few z.vals. Consider supplying a range of z through z.limits")
			}
		} else if(is.null(z.vals)) {   # if they didn't specify z.limits or z.vals, make 50 vals using mean +/- 2 s.d. 
			z.vals <- seq(potential.zrange.limits[1], potential.zrange.limits[2], length.out = 50)			
		}
	}
	if(max(abs(z.vals)) < 10) {
		z.plot.labels <- format(round(z.vals, digits = z.label.rounding), nsmall = z.label.rounding)
	} else {
		z.plot.labels <- z.vals
	}
	
	# establish line.colors
	if(effect.type %in% c("xz.me.zlines", "xz.cme.zlines", "xz.cme.slines")) { # if it is a line color plot
		if(effect.type %in% c("xz.me.zlines", "xz.cme.zlines")) {
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
		if(effect.type %in% c("xz.cme.slines")) {
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
	if(effect.type %in% c("xz.me.heatmap", "xz.me.heatmap.onlysig", "xz.cme.heatmap", "xz.cme.heatmap.onlysig")) {
		# the default is "Blue-Red", but any hcl.pals() will work
		if(!(heatmap.colors %in% hcl.pals())) {
			stop("heatmap.colors must be one of hcl.pals(). For grayscale heatmap, use ``Grays''")
		}
	}

	########################################################################
	# below begins the calculation / plotting meat
	########################################################################

	# establish container for results
	dat.out <- matrix(rep(NA, (length(0:s.limit)*length(z.vals))*6), nrow = (length(0:s.limit)*length(z.vals)))
	# the formulae will be the same regardless of how many values of z, so we just need one set of formulae
	# empty list container for formulas for each s
	if(effect.type %in% c("xz.me.zlines", "xz.me.heatmap.onlysig", "xz.me.heatmap")) {
		the.final.formula.list <- the.comb.formula.list <- vector("list", 1 + s.limit) # extra for s = 0
	} else if(effect.type %in% c("xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap")) {
		the.final.formula.list <- the.comb.formula.list <- vector("list", 2 + s.limit) # extra for s = 0 and LRM
	}
	## We're going to establish the impulse response for all periods. Cumulative just sums them. We will do this the lazy way
	for(s in 0:s.limit) {
		# evaluate s = 0 seperately: no dynamics
		if(s == 0) {
			# if there is a contemporaneous x, that's it, or else it's 0
			#  have to adjust by 1 since the counter for index starts at 1
			#  we're going to multiply by the generic ``z_vals'' which we will replace as a vector later when it is evaluated
			the.comb.formula.list[[s+1]] <- mp(ifelse(0 %in% x.vrbl, names(x.vrbl)[which(x.vrbl == 0)], 0)) + 
													mp(ifelse(0 %in% x.z.vrbl, names(x.z.vrbl)[which(x.z.vrbl == 0)], 0))*mp("z_val")
		} else {
			# First: define the quantity that will be carried forward by the lag y (alpha*xi)
			# max number of elements is either going to be minimum of the y.order specified <or> how far
			#  into the future we've gone since s (to sync the y.order)
			#  (this is identical to the above)
			alpha.xi.elements <- vector("list", length = min(s, max(y.vrbl)))
			# now, loop over these elements to replace them
			for(counter in 1:length(alpha.xi.elements)) {
				# test to see if that particular s pairs with a y lag order for the quantity alpha_i * xi_{s-i}
				if(counter %in% y.vrbl) {
					# if it does, it's the relevant y coefficient times the relevant xi quantity that matches 
					#  (have to increment the.comb.formula.list[s] by 1 since it position 1 is s = 0)
					alpha.xi.elements[[counter]] <- mp(names(y.vrbl)[which(y.vrbl == counter)]) * the.comb.formula.list[[(s+1)-counter]]
				} else {
					# if there is no relevant alpha_i for that lag order, replace it with 0
					alpha.xi.elements[[counter]] <- 0
				}
			}
			# now, form the actual sum
			sum.alpha.xi <- Reduce("+", alpha.xi.elements)
			# finally, place the sum in the formula list
			#  if there is a relevant beta for that period s (beta_s), add that to the sum of the alpha_i elements
			the.comb.formula.list[[s+1]] <- mp(ifelse(s %in% x.vrbl, names(x.vrbl)[which(x.vrbl == s)], 0)) + 
			#  also, add on if there is a relevant theta for that period s (theta_s), times the value of z
											mp(ifelse(s %in% x.z.vrbl, names(x.z.vrbl)[which(x.z.vrbl == s)], 0))*mp("z_val") +
											# plus the carryforward sum defined above
											sum.alpha.xi
		}
		# now with the formula, the effect calculation will depend on the effect type
		if(effect.type %in% c("xz.me.zlines", "xz.me.heatmap.onlysig", "xz.me.heatmap")) { #.me
			# for the marginal effect, we evaluate period each by itself
			#  only difference is that we need to apply it to all of the z.vals
			#  notice this formula contains z_val for us to replace
			intermediate <- capture.output(print(the.comb.formula.list[[s+1]], stars = TRUE))
			the.final.formula.list[[s+1]] <- intermediate
			# we need a way to increment over the position in the dat.out matrix correctly
			adder <- 1
			for(z_val in z.vals) {
				# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
				that.zsum <- gsub('z_val', z_val, intermediate)
				dat.out[((s*length(z.vals))+adder),] <- c(as.matrix(c(s, z_val)), as.matrix(deltaMethod(the.coef, paste(that.zsum), vcov. = the.vcov, level = dM.level)))	
				adder <- adder + 1
			}
		} else if(effect.type %in% c("xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap")) { # cumulative
			# cumulative adds up to s
			intermediate <- capture.output(print(Reduce("+", the.comb.formula.list[1:(s+1)]), stars = TRUE))
			the.final.formula.list[[s+1]] <- intermediate
			# we need a way to increment over the position in the dat.out matrix correctly
			adder <- 1
			for(z_val in z.vals) {
				# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
				that.zsum <- gsub('z_val', z_val, intermediate)
				dat.out[((s*length(z.vals))+adder),] <- c(as.matrix(c(s, z_val)), as.matrix(deltaMethod(the.coef, paste(that.zsum), vcov. = the.vcov, level = dM.level)))	
				adder <- adder + 1
			}	
		}
		dat.out <- data.frame(dat.out)
	} # this ends the calculation loops. now dat.out contains the interactive .me/.cme 
	# Now the plots!
	if(effect.type %in% c("xz.me.zlines", "xz.me.heatmap", "xz.me.heatmap.onlysig")) { # return to the .me plots
		# name the formula list
		names(the.final.formula.list) <- paste0("s = ", 0:s.limit)			
		# name the dataset
		names(dat.out) <- c("Period", "Z", "ME", "SE", "Lower", "Upper")
		if(effect.type == "xz.me.zlines") {
			#######################
			# x-axis: s; y-axis: ME; lty is Z value
			#######################
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = ME, lty = as.factor(Z), col = as.factor(Z))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
							geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of ", names(z.vrbl)[1]), labels = z.plot.labels) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))				
		} else if (effect.type == "xz.me.heatmap") {
			#######################
			# x-axis: s; y-axis: Z; tile color is ME
			#######################
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = ME)) + 
							geom_tile() + 
							scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Value of ", names(z.vrbl)[1])) +
							labs(fill = paste0("Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))	
		} else if (effect.type == "xz.me.heatmap.onlysig") {
			#######################
			# x-axis: s; y-axis: Z; tile color is ME
			#######################
			dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
			dat.out$ME.sig <- ifelse(dat.out$insig == 0, dat.out$ME, 0)
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = ME.sig)) + 
							geom_tile() + 
							scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Value of ", names(z.vrbl)[1])) +
							labs(fill = paste0("Statistically Significant\nMarginal Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))	
		} 
	} # this ends the interactive .me plots
	if(effect.type %in% c("xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap")) { # return to the .cme plots
		#  calculate the LRM. first start with the sum of the alpha.is. these are unweighted in the sum
		#  so we don't have to do anything but combine them!
		alpha.is <- paste0("(1/(1-(", paste(names(y.vrbl), collapse = "+"), ")))")
		# need to set up sums for the beta.js
		beta.j.elements <- vector("list", length = (max(x.vrbl)+1))
		# now we see whether the betas are there and multiply by the alpha.is sum
		for(counter in 0:max(x.vrbl)) {
			# test to see if that particular j pairs with a x lag order for the quantity beta_j * alpha.is (defined above)
			if(counter %in% x.vrbl) {
				# if that lag order is in x.vrbl, it's the relevant x (beta) coefficient times alpha.is
				beta.j.elements[[(counter+1)]] <- paste(names(x.vrbl)[which(x.vrbl == counter)], "*", alpha.is)
			} else {
				# if there is no relevant beta_j for that lag order of x, replace it with 0
				beta.j.elements[[(counter+1)]] <- 0
			}
		}
		# sum all of the elements in the formula
		sum.of.beta.j.elements <- paste0("(", paste(beta.j.elements, collapse = "+"), ")")
		# need to set up sums for the theta.js
		theta.j.elements <- vector("list", length = (max(x.z.vrbl)+1))
		# now we see whether the betas are there and multiply by the alpha.is sum
		for(counter in 0:max(x.z.vrbl)) {
			# test to see if that particular j pairs with a x lag order for the quantity beta_j * alpha.is (defined above)
			if(counter %in% x.z.vrbl) {
				# if that lag order is in x.vrbl, it's the relevant x (beta) coefficient times alpha.is
				theta.j.elements[[(counter+1)]] <- paste(names(x.z.vrbl)[which(x.z.vrbl == counter)], "*", alpha.is)
			} else {
				# if there is no relevant beta_j for that lag order of x, replace it with 0
				theta.j.elements[[(counter+1)]] <- 0
			}
		}
		sum.of.theta.j.elements <- paste0("(", paste(theta.j.elements, collapse = "+"), ") * z_val")
		total.sum <- paste(sum.of.beta.j.elements, sum.of.theta.j.elements, sep = "+")
		the.final.formula.list[[s.limit + 2]] <- total.sum
		lrm.dat <- matrix(rep(NA, length(z.vals)*6), nrow = length(z.vals))
		for(z in 1:length(z.vals)) {
			# deltaMethod only knows to look in the.coef/the.vcov. z_val is a scalar. we just replace it before evaluating
			that.zsum <- gsub('z_val', z.vals[z], total.sum)
			lrm.dat[z,] <- c(as.matrix(c((s.limit+1), z.vals[z])), as.matrix(deltaMethod(the.coef, paste(that.zsum), vcov. = the.vcov, level = dM.level)))
		}
		lrm.dat <- data.frame(lrm.dat)
		dat.out <- rbind(dat.out, lrm.dat)
		# name the formula list
		names(the.final.formula.list) <- c(paste0("s = ", 0:s.limit), "LRM")
		# name the dataset
		names(dat.out) <- c("Period", "Z", "CME", "SE", "Lower", "Upper")
		# Now plots
		if(effect.type == "xz.cme.zlines") {
			#######################
			# x-axis: s; y-axis: ME; lty is Z value
			#######################
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0) + 2
			plotting.data.nolrm <- dat.out[(dat.out$Period %in% 0:s.limit),]
			
			# have to position the lrm lines for each z.val out past the s.limit
			lrm.lines <- dat.out[dat.out$Period == (s.limit + 1),]
			lrm.lines$xloc <-  seq((s.limit + round((s.limit * 0.2), digits = 0)) - ((length(z.vals) - 1)/2),
									(s.limit + round((s.limit * 0.2), digits = 0)) + ((length(z.vals) - 1)/2),
									length.out = length(z.vals))
		
			plot.out <- ggplot(data = plotting.data.nolrm, aes(x = Period, y = CME, lty = as.factor(Z), col = as.factor(Z))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
							geom_segment(data = lrm.lines, aes(x = xloc, xend = xloc, y = Lower, yend = Upper), lwd = 1.25, color = line.colors) +
							geom_point(data = lrm.lines, aes(x = xloc, y = CME), size = 3, color = line.colors)	+
							geom_hline(yintercept = 0, lwd = 1) +
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space-2)), 
								labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							scale_color_discrete(type = line.colors, name = paste0("Value of ", names(z.vrbl)[1]), labels = z.plot.labels) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Cumulative Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))						
		} else if (effect.type == "xz.cme.slines") {
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
			plot.out <- ggplot(data = plotting.data.justs, aes(x = Z, y = CME, lty = as.factor(Period), col = as.factor(Period))) + 
							geom_line(lwd = 1.2) +
							geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Period), col = as.factor(Period)), linetype = 1, alpha = 0.1) +
							geom_hline(yintercept = 0, lwd = 1) +
							scale_color_discrete(type = line.colors, name = paste0("Value of s"), labels = s.plot.labels) +
							xlab(paste0("Value of ", names(z.vrbl)[1])) +
							ylab(paste0("Cumulative Marginal Effect of ", names(x.vrbl)[1])) +
							theme_bw() + 
							guides(lty = "none") +
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black"))
		} else if (effect.type == "xz.cme.heatmap") {
			#######################
			# x-axis: s; y-axis: Z; tile color is CME of LRM
			#######################
			# adjust the LRM to be a little out from the heatmap to prevent confusion
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
			dat.out$Period[dat.out$Period == (s.limit + 1)] <- lrm.space	
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = CME)) + 
							geom_tile() + 
							scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
											labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Value of ", names(z.vrbl)[1])) +
							labs(fill = paste0("Cumulative Marginal Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black")) 
		} else if (effect.type == "xz.cme.heatmap.onlysig") {
			#######################
			# x-axis: s; y-axis: Z; tile color is CME
			#######################
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
			dat.out$Period[dat.out$Period == (s.limit + 1)] <- lrm.space

			dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
			dat.out$CME.sig <- ifelse(dat.out$insig == 0, dat.out$CME, 0)
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = CME.sig)) + 
							geom_tile() + 
							scale_fill_gradientn(colors = hcl.colors(20, paste(heatmap.colors))) +
							scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
											labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
							xlab(paste0("Number of Periods Since Change in ", names(x.vrbl)[1], " (s)")) +
							ylab(paste0("Value of ", names(z.vrbl)[1])) +
							labs(fill = paste0("Statistically Significant\nCumulative Marginal Effects of ", names(x.vrbl)[1])) +
							theme_bw() + 
							theme(panel.border = element_blank(), 
								panel.grid.major = element_blank(),
								panel.grid.minor = element_blank(), 
								axis.line = element_line(colour = "black")) 			
		}
		if(effect.type %in% c("xz.cme.heatmap.onlysig", "xz.cme.heatmap")){
		  dat.out$Period[dat.out$Period == lrm.space] <- "LRM"
		} else if(effect.type %in% c("xz.cme.zlines", "xz.cme.slines")){
		  dat.out$Period[dat.out$Period == (s.limit+1)] <- "LRM"
		}
	} # this ends the interactive .cme plots
	# clean, get out
	if(return.plot == TRUE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, dat.out, the.final.formula.list)
				names(out) <- c("plot", "estimates", "formulae")
			} else if(return.formulae == FALSE) {
				out <- list(plot.out, dat.out)
				names(out) <- c("plot", "estimates")				
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- list(plot.out, the.final.formula.list)
				names(out) <- c("plot", "formulae")
			} else if(return.formulae == FALSE) {
				out <- plot.out
			}			
		}
	} else if(return.plot == FALSE) {
		if(return.data == TRUE) {
			if(return.formulae == TRUE) {
				out <- list(dat.out, the.final.formula.list)
				names(out) <- c("estimates", "formulae")
			} else if(return.formulae == FALSE) {
				out <- dat.out
			}
		} else if(return.data == FALSE) {
			if(return.formulae == TRUE) {
				out <- the.final.formula.list
			} else if(return.formulae == FALSE) {
				stop("Return at least one of the plot, the data, or the formulae")
			}			
		}
	}
	out
}

		
