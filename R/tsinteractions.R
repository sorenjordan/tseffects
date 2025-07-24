# version 0.0.1
# 9/6/2023
# Authors: Soren Jordan, Garrett N. Vande Kamp

# TO DO: 
#  dnynamc integration
#  allow to specify orders (i.e. do not loop over fixated j, but instead the j's specified by user)


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
#'	 \item{l.1.x}{First lag of x}
#'	 \item{l.2.x}{Second lag of x}
#'	 \item{l.3.x}{Third lag of x}
#'	 \item{l.4.x}{Fourth lag of x}
#'	 \item{l.5.x}{Fifth lag of x}
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
#'	 \item{x.z}{Interaction of contemporaneous x and z}
#'	 \item{x.l.1.z}{Interaction of contemporaneous x and lagged z}
#'	 \item{z.l.1.x}{Interaction of lagged x and contemporaneous z}
#'	 \item{l.1.x.l.1.z}{Interaction of lagged x and lagged z}
#' }
#' @docType data
#' @keywords datasets
#' @usage data(toy.ts.interaction.data)
#' @name toy.ts.interaction.data
NULL

## Functions:
## Dependencies: 	car (for deltaMethod)
#		stats (for lm coef vcov)
#		ggplot (for ts interactions)
#
## Functions included:
# (1) ts_interact_plot()
#	model = [NULL]			lm model for the ts interaction
#	x.vrbl = [NULL]			first variable (along x-axis)
#	z.vrbl	 = [NULL]		second variable (moderating)
#	y.vrbl = [NULL]			dependent variable
#	x.z.vrbl = [NULL]		interaction coefficient variable
#	effect.type = [x.me]		plot type
#	dM.level = [0.05	]		deltaMethod significance level
#	return.data = [NULL]		return the data so that you can write your own ggplot
#	return.plot = TRUE		return the plot so you can see a pretty picture
#	bw.lines = [FALSE]			black and white plot or not
#	heatmap.colors = [BR-3]	color scale for the heatmap
#	line.colors = [NULL]		what colors do you want your line to be? defaults to OE
#	z.vals = [NULL]			values for the moderating variable. discrete if under 5. +/- sd if more
#	z.limits = [NULL]		what range of z values do you want plotted between? chiefly for heatmaps
#	s.limit = [20]				number of time periods to forecast out
#	z.label.rounding	 = [0]		number of digits to round to for the z labels in the legend
#	s.plot.vals	= [c(0, "LRM")]			discrete s values, if the the lines are chunked by z 
#	...								arguments to plot



##########################################
# -------(1) ts_interact_plot ----------#
##########################################
#' Plot the interaction in a single-equation time series model estimated via \code{lm}
#' @param model \code{lm} model that contains the time series interaction
#' @param x.vrbl string with the ``main'' x variable: usually presented along x-axis. If lags are included, a string of the lags in order (i.e. 0, 1, 2)
#' @param z.vrbl string with the ``moderating'' z variable: line type, y-axis, or other. If lags are included, a string of the lags in order (i.e. 0, 1, 2)
#' @param y.vrbl string with the dependent variable from the model
#' @param x.z.vrbl string with the interaction variable
#' @param effect.type one of \code{x.me} (marginal effect of x), \code{x.cme} (cumulative marginal effect of x), \code{xz.me.zlines} (marginal effects, with the line types by values of the moderating variable), \code{xz.me.heatmap.onlysig} (heatmap of the marginal effects, but colored white if the effect does not meet the \code{dM.level}), \code{xz.me.heatmap} (heatmap of the marginal effects, as estimated), \code{xz.cme.zlines} (cumulative marginal effects, with the line types by values of the moderating variable), \code{xz.cme.slines} (cumulative marginal effects, with the line types by values of the period since the shock), \code{xz.cme.heatmap.onlysig} (heatmap of the cumulative marginal effects, but colored white if the effect does not meet the \code{dM.level}), or \code{xz.cme.heatmap} (heatmap of the marginal effects, as estimated)
#' @param dM.level the significance level of the (cumulative) marginal effects: set to \code{deltaMethod}
#' @param return.data return the estimated effects dataframe in the created object (as opposed to just creating the plot)
#' @param return.plot return the plot to the console (as opposed to just creating the data)
#' @param bw.lines should the line colors be black and white or full color? The option is labeled ``lines,'' since a black and white heatmap would be dubiously useful
#' @param heatmap.colors what color scale would you like for the heatmap? The default is ``Blue-Red 3''
#' @param line.colors what color lines would you like for line type plots? If \code{bw.lines} is not \code{TRUE}, this defaults to the color-safe Okabe-Ito colors
#' @param z.vals values for the moderating variable, if a line type plot is to be drawn
#' @param z.limits what is the range of values of the moderating variable to plot, if a heatmap is to be drawn
#' @param s.limit number of time periods from a shock to calculate
#' @param z.label.rounding number of digits to round to for the z labels in the legend (if those values are automatically calculated)
#' @param s.plot.vals values for the time since the shock, if a line type plot is to be drawn
#' @param ... other arguments to be passed to the call to plot
#' @importFrom stats lm coef vcov model.frame sd
#' @importFrom grDevices palette.colors
#' @importFrom car deltaMethod
#' @importFrom colorspace scale_fill_continuous_diverging
#' @import ggplot2
#' @author Soren Jordan and Garrett N. Vande Kamp
#' @keywords interaction plot
#' @examples
#' # Using Cavari's approval data in dynamac
#' # Cavari's original model: APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + 
#' #     MIP_FOREIGN + APPROVE_ECONOMY*MIP_MACROECONOMICS + APPROVE_FOREIGN*MIP_FOREIGN + 
#' #     APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#' #     DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT)
#' 
#' approval$ECONAPP_ECONMIP <- approval$APPROVE_ECONOMY*approval$MIP_MACROECONOMICS
#' approval$FPAPP_ECONFP <- approval$APPROVE_FOREIGN*approval$MIP_FOREIGN
#' approval$PRESIDENT.num <- cbind(approval$PRESIDENT)
#'
#' # As of 0.0.1, only works with lm()
#' cavari.model <- lm(APPROVE ~ APPROVE_ECONOMY + APPROVE_FOREIGN + MIP_MACROECONOMICS + 
#'      MIP_FOREIGN + ECONAPP_ECONMIP + FPAPP_ECONFP + 
#'      APPROVE_L1 + PARTY_IN + PARTY_OUT + UNRATE + 
#'      DIVIDEDGOV + ELECTION + HONEYMOON + as.factor(PRESIDENT.num), data = approval)
#' 
#' # If model included lags of x.vrbl, we would add them to c()
#' # First: cumulative marginal effect of X
#' ts_interact_plot(model = cavari.model, x.vrbl = c("APPROVE_ECONOMY"), y.vrbl = "APPROVE_L1",
#' 		effect.type = "x.cme")
#' 
#' # Now: marginal effect of X at different levels of Z
#' ts_interact_plot(model = cavari.model, x.vrbl = c("APPROVE_ECONOMY"), y.vrbl = "APPROVE_L1",
#' 		z.vrbl = "MIP_MACROECONOMICS", x.z.vrbl = "ECONAPP_ECONMIP",
#'		effect.type = "xz.me.zlines")
#' 
#' # Use well-behaved simulated data (included) for even more examples
#' model.toydata <- lm(y ~ l.1.y + x + l.1.x + z + l.1.z +
#'		x.z + l.1.x.l.1.z, data = toy.ts.interaction.data)
#' 
#' # Cumulative marginal effect of x. You can store the data to draw your own plot,
#' #  if you prefer
#' test.x.cme <- ts_interact_plot(model = model.toydata, 
#'					x.vrbl = c("x", "l.1.x"), y.vrbl = "l.1.y",
#'					effect.type = "x.cme", return.data = TRUE, s.limit = 20)
#' test.x.cme$plot
#'
#' # Marginal effect of z
#' ts_interact_plot(model = model.toydata, x.vrbl = c("x", "l.1.x"), 
#'					y.vrbl = "l.1.y", z.vrbl = c("z", "l.1.z"),
#'					x.z.vrbl = c("x.z", "l.1.x.l.1.z"),
#'					z.vals = -2:2,
#'					effect.type = "xz.me.zlines", s.limit = 20)
#' @export

ts_interact_plot <- function(model = NULL, x.vrbl = NULL, z.vrbl = NULL, y.vrbl = NULL, x.z.vrbl = NULL,
					effect.type = "x.me", dM.level = 0.95, 
					return.data = FALSE, return.plot = TRUE,
					bw.lines = FALSE, heatmap.colors = "Blue-Red 3", line.colors = NULL,
					z.vals = NULL, z.limits = NULL, s.limit = 20, z.label.rounding = 0, s.plot.vals = c(0, "LRM"), ...) {  # only for the interactive ME/CME plots
	# This is going to assume that the vars passed in x.vrbl, y.varbl, z.vrbl are ordered (i.e. 0, 1, 2) for lags
	# Global plotting variables
	CME <- CME.sig <- Lower <- ME <- ME.sig <- Period <- Upper <- Z <- xloc <- NULL
	if(!(effect.type %in% c("x.me", "x.cme", "xz.me.zlines", "xz.me.heatmap.onlysig", "xz.me.heatmap",
							"xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap"))) {
		stop("Invalid effect.type. effect.type must be one of x.me, x.cme, xz.me.zlines, 
							xz.me.heatmap.onlysig, xz.me.heatmap, xz.cme.zlines, xz.cme.slines, 
							xz.cme.heatmap.onlysig, or xz.cme.heatmap")						
	}
	
	x.order <- length(x.vrbl)
	y.order <- length(y.vrbl)
	z.order <- length(z.vrbl)
	x.z.order <- length(x.z.vrbl)
	the.coef <- coef(model)
	the.vcov <- vcov(model)
	
	if(!(all(x.vrbl %in% names(the.coef)))) {
		stop("x.vrbl not present in estimated model")
	}
	if(!(is.null(z.vrbl)) & !(all(z.vrbl %in% names(the.coef)))) {
		stop("z.vrbl not present in estimated model")
	}
	if(!(all(y.vrbl %in% names(the.coef)))) {
		stop("y.vrbl not present in estimated model")
	}
	if(!(is.null(x.z.vrbl)) & !(all(x.z.vrbl %in% names(the.coef)))) {
		stop("x.z.vrbl not present in estimated model")
	}
	if(!(is.null(z.limits))) {
		if(length(z.limits) != 2) {
			stop("z.limits should only be two values: the lower and upper limits of the z variable for which the (cumulative) marginal effect of x will be calculated")			
		}	
		if(z.limits[1] >= z.limits[2]) {
			stop("First z.limit should be lower than second z.limit")
		} 
		if(!(is.null(z.vals))) {
			stop("Specify only z.limits or z.vals")
		}
	}
	if(!(is.null(z.vals))) {
		if(length(z.vals) > 5) {
			stop("Do not supply more than 5 discrete values of z to plot. The plot is too busy")
		}
		if(!(is.null(line.colors))) {
			if(length(line.colors) != length(z.vals)) {
				stop("Number of supplied line.colors is not equal to number of z.vals to plot")
			}
		}
	}	
	if(!(is.null(line.colors)) & (bw.lines == TRUE)) {
		stop("Supply either line.colors OR bw.lines = TRUE")
	}
	if(effect.type %in% c("xz.me.zlines", "xz.me.heatmap.onlysig", "xz.me.heatmap", 
						"xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap")) {
		if(!(is.null(z.vals)) & (effect.type %in% c("xz.cme.slines", "xz.me.heatmap.onlysig", "xz.me.heatmap", "xz.cme.heatmap.onlysig", "xz.cme.heatmap"))) {
			if(length(z.vals) < 6) {
				if(effect.type %in% c("xz.me.heatmap.onlysig", "xz.me.heatmap", "xz.cme.heatmap.onlysig", "xz.cme.heatmap")) {
					warning("Heatmap will be very blocky for so few z.vals. Consider supplying a range of z through z.limits")
				} else {
					warning("s lines will be very choppy for so few z.vals. Consider supplying a range of z through z.limits")
				}	
			}
		}
		if(is.null(z.vals)) {			# First, assume the user knows what they are doing. If z.vals are null
			if(!is.null(z.limits)) {	# And limits are provided
				if(effect.type %in% c("xz.me.zlines", "xz.cme.zlines")) { # if it's lines, it's 3
					z.vals <- seq(z.limits[1], z.limits[2], length.out = 3) # Make the values using their limits
				} else { # if it's heatmap OR slines, it's 50
					z.vals <- seq(z.limits[1], z.limits[2], length.out = 50) # Make the values using their limits					
				}
			} else {  # If z.vals AND z.limits are NULL, which is nothing provided, figure it out for them
				the.z <- model.frame(model)[z.vrbl[1]]
				z.limits <- c((mean(the.z[,1], na.rm = TRUE) - sd(the.z[,1], na.rm = TRUE)), (mean(the.z[,1], na.rm = TRUE) + sd(the.z[,1], na.rm = TRUE)))
				if(length(table(the.z)) < 6) {  # if the variable is discrete
					z.vals <- as.numeric(names(table(the.z)))
				} else { # if it's continuous
					if(effect.type %in% c("xz.me.zlines", "xz.cme.zlines")) { # if it's lines, it's 3
						z.vals <- seq(z.limits[1], z.limits[2], length.out = 3) # Make the values using their limits
					} else { # if it's heatmap OR slines, it's 50
						z.vals <- seq(z.limits[1], z.limits[2], length.out = 50) # Make the values using their limits					
					}						
				}	
			}
		} # now set z plot vals
		z.plot.vals <- z.vals
		z.plot.labels <- z.plot.vals.rounded <- format(round(z.plot.vals, digits = z.label.rounding), nsmall = z.label.rounding)
	}
	if(effect.type %in% c("xz.me.zlines", "xz.cme.zlines")) {
		if(is.null(line.colors)) {
			if(bw.lines == FALSE) {
				line.colors <- unname(palette.colors())[2:(length(z.plot.vals)+1)]
			} else {
				line.colors <- paste0("grey", round(seq(0, 60, length.out = length(z.plot.vals))))
			}
		}
	}
	if(effect.type %in% c("xz.cme.slines")) {
		if(is.null(line.colors)) {
			if(bw.lines == FALSE) {
				line.colors <- unname(palette.colors())[2:(length(s.plot.vals)+1)]
			} else {
				line.colors <- paste0("grey", round(seq(0, 60, length.out = length(s.plot.vals))))
			}
		}
	}
	
	###############################################
	# Plot type: univariate for X, marginal effects
	###############################################	
	if(effect.type == "x.me") {
		s.vals <- seq(0, s.limit, 1)
		dat.out <- matrix(rep(NA, length(s.vals)*5), nrow = length(s.vals))	
		for(s in s.vals) {   # Loop over the s periods
			the.formula <- rep(NA, x.order)  # Declare a holder for the formula. We'll fill the elements to paste for sum
			for(j in 0:(length(the.formula) - 1)) {  # For each of the orders of X (counting the summation of j in the formula)
				the.yformula.sj <- the.yformula.sj1 <- the.yformula.p <- rep(NA, y.order)  # Declare holders for y. This will rarely be > 1
				for(p in 1:length(the.yformula.sj)) {  # For each y summation element in the formula
					the.yformula.sj[p] <- paste0(y.vrbl[p], "^", max((s-j), 0))   #   Sum from i = 1 to p of lag y to the max(s-j, 0)
					the.yformula.sj1[p] <- paste0(y.vrbl[p], "^",max((s-j+1), 0)) #   Sum from i = 1 to p of lag y to the max(s-j+1, 0)
					the.yformula.p[p] <- paste0(y.vrbl[p])                        #   Sum from i = 1 to p of lag y
				}
				the.comb.yformula.sj <- paste0("(", paste0(the.yformula.sj, collapse = "+"), ")")   # Collapse sum
				the.comb.yformula.sj1 <- paste0("(", paste0(the.yformula.sj1, collapse = "+"), ")") # Collapse sum
				the.comb.yformula.p <- paste0("(", paste0(the.yformula.p, collapse = "+"), ")")     # Collapse sum
				# Now, build the formula elements for each j (order of X)
				the.formula[j + 1] <- paste0(x.vrbl[j + 1], "*((", # beta_j outside
							the.comb.yformula.sj, " - ", the.comb.yformula.sj1, ")/", # numerator
							"(1 - ", the.comb.yformula.p, "))") #denominator					
			}
			# Collapse together the combined formula
			the.comb.formula <- paste0(the.formula, collapse = " + ")
			# Actually evaluate the thing using deltaMethod, save in first row of dat.out
			dat.out[(s+1),] <- c(as.matrix(s), as.matrix(deltaMethod(the.coef, paste(the.comb.formula), vcov. = the.vcov, level = dM.level)))
		}
		dat.out <- data.frame(dat.out)
		names(dat.out) <- c("Period", "ME", "SE", "Lower", "Upper")
		#######################
		# x-axis: s; y-axis: ME; lty is X value
		#######################
		plot.out <- ggplot(data = dat.out, aes(x = Period, y = ME)) + 
					geom_line(lwd = 1.2) + 
					geom_ribbon(aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.1) +
					geom_hline(yintercept = 0, lwd = 1) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Marginal Effect of ", x.vrbl[1])) +
					theme_bw() + 
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
	}
	
	###############################################
	# Plot type: univariate for X, cumulative marginal effects
	###############################################	
	if(effect.type == "x.cme") {
		s.vals <- seq(0, (s.limit+1), 1)  # add an extra row for the LRM. we're going to trick it as the "last" time period and override the label in the plot
		dat.out <- matrix(rep(NA, length((s.vals))*5), nrow = length(s.vals))	
		for(s in s.vals) {   # Loop over the s periods
			the.formula <- rep(NA, x.order)  # Declare a holder for the formula. We'll fill the elements to paste for sum
			for(j in 0:(length(the.formula) - 1)) {  # For each of the orders of X (counting the summation of j in the formula)
				the.yformula.sj1 <- the.yformula.p <- rep(NA, y.order)  # Declare holders for y. This will rarely be > 1
				for(p in 1:length(the.yformula.sj1)) {  # For each y summation element in the formula
					the.yformula.sj1[p] <- paste0(y.vrbl[p], "^",max((s-j+1), 0)) #   Sum from i = 1 to p of lag y to the max(s-j+1, 0)
					the.yformula.p[p] <- paste0(y.vrbl[p])                        #   Sum from i = 1 to p of lag y
				}
				the.comb.yformula.sj1 <- paste0("(", paste0(the.yformula.sj1, collapse = "+"), ")") # Collapse sum
				the.comb.yformula.p <- paste0("(", paste0(the.yformula.p, collapse = "+"), ")")     # Collapse sum
				# Now, build the formula elements for each j (order of X)
				the.formula[j + 1] <- paste0(x.vrbl[j + 1], "*((", # beta_j outside
							"1 - ", the.comb.yformula.sj1, ")/", # numerator
							"(1 - ", the.comb.yformula.p, "))") #denominator					
			}
			# Collapse together the combined formula
			the.comb.formula <- paste0(the.formula, collapse = " + ")
			# Actually evaluate the thing using deltaMethod, save in first row of dat.out
			dat.out[(s+1),] <- c(as.matrix(s), as.matrix(deltaMethod(the.coef, paste(the.comb.formula), vcov. = the.vcov, level = dM.level)))
		}
		# Append the LRM separately as the last row
		the.formula <- rep(NA, x.order)  # Declare a holder for the formula. We'll fill the elements to paste for sum
		the.yformula.p <- rep(NA, y.order)  # Declare holders for y. This will rarely be > 1
		for(p in 1:length(the.yformula.p)) {  # For each y summation element in the formula
			the.yformula.p[p] <- paste0(y.vrbl[p])                        #   Sum from i = 1 to p of lag y
		}			
		the.comb.yformula.p <- paste0("(", paste0(the.yformula.p, collapse = "+"), ")")     # Collapse sum	
		for(j in 0:(length(the.formula) - 1)) {  # For each of the orders of X (counting the summation of j in the formula)
			# Now, build the formula elements for each j (order of X)
			the.formula[j + 1] <- paste0(x.vrbl[j + 1], "*(", # beta_j outside
							"1/", # numerator
							"(1 - ", the.comb.yformula.p, "))") #denominator					
		}
		# Collapse together the combined formula
		the.comb.formula <- paste0(the.formula, collapse = " + ")
		# Evaluate the LRM as the final row of dat.out	
		dat.out[length(s.vals),] <- c(as.matrix((s.limit+1)), as.matrix(deltaMethod(the.coef, paste(the.comb.formula), vcov. = the.vcov, level = dM.level)))	
		dat.out <- data.frame(dat.out)
		names(dat.out) <- c("Period", "CME", "SE", "Lower", "Upper")
				
		#######################
		# x-axis: s; y-axis: CME; lty is X value
		#######################
		lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
		plotting.data.lrm <- dat.out[(dat.out$Period %in% 0:s.limit),]
		
		plot.out <- ggplot(data = plotting.data.lrm, aes(x = Period, y = CME)) + 
					geom_line(lwd = 1.2) + 
					geom_ribbon(data = plotting.data.lrm, aes(ymin = Lower, ymax = Upper), color = "black", linetype = 1, alpha = 0.1) +
					geom_hline(yintercept = 0, lwd = 1) +
					geom_segment(aes(x = lrm.space, xend = lrm.space, y = Lower[s.limit+1], yend = Upper[s.limit+1]), lwd = 1.25, color = "black") +
					geom_point(aes(x = lrm.space, y = CME[s.limit+1]), size = 3) +
					scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), lrm.space), 
									labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Cumulative Marginal Effect of ", x.vrbl[1])) +
					theme_bw() + 
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
		# rename last row: account for the 0 at the beginning of s
		dat.out$Period[s.limit+2] <- "LRM"
	}
	
	###############################################
	# Plot types: interactive for X and Z, but marginal effects (so the heatmap, or the ME of Z at S)
	###############################################
	if(effect.type %in% c("xz.me.zlines", "xz.me.heatmap.onlysig", "xz.me.heatmap")) {
		s.vals <- seq(0, s.limit, 1)
		ME.combinations <- expand.grid(s.vals, z.vals)
		dat.out <- matrix(rep(NA, nrow(ME.combinations)*6), nrow = nrow(ME.combinations))	
		for(sz in 1:nrow(dat.out)) {   # loop over the combinations of s periods and z values (combined in rows)
			the.bj.formula <- the.tj.formula <- rep(NA, (x.order))  # Declare a holder for the formula (since we restrict order to be equal)
			s <- ME.combinations[sz,1]
			z <- ME.combinations[sz,2]
			for(j in 0:(length(the.bj.formula) - 1)) {  # For each of the orders of X (counting the summation of j in the formula) (since we restrict to be equal)
				the.yformula.sj <- the.yformula.sj1 <- the.yformula.p <- rep(NA, y.order)  # Declare holders for y. This will rarely be > 1
				for(p in 1:length(the.yformula.sj)) {  # For each y summation element in the formula
					the.yformula.sj[p] <- paste0(y.vrbl[p], "^", max((s-j), 0))   #   Sum from i = 1 to p of lag y to the max(s-j, 0)
					the.yformula.sj1[p] <- paste0(y.vrbl[p], "^",max((s-j+1), 0)) #   Sum from i = 1 to p of lag y to the max(s-j+1, 0)
					the.yformula.p[p] <- paste0(y.vrbl[p])                        #   Sum from i = 1 to p of lag y
				}
				the.comb.yformula.sj <- paste0("(", paste0(the.yformula.sj, collapse = "+"), ")")   # Collapse sum
				the.comb.yformula.sj1 <- paste0("(", paste0(the.yformula.sj1, collapse = "+"), ")") # Collapse sum
				the.comb.yformula.p <- paste0("(", paste0(the.yformula.p, collapse = "+"), ")")     # Collapse sum
				
				# Now, build the formula elements for each j (order of X)
				the.bj.formula[j + 1] <- paste0(x.vrbl[j + 1], "*((", # beta_j outside
							the.comb.yformula.sj, " - ", the.comb.yformula.sj1, ")/", # numerator
							"(1 - ", the.comb.yformula.p, "))") #denominator					
				
				# Now, build the formula elements for each j (order of Z)
				the.tj.formula[j + 1] <- paste0(x.z.vrbl[j + 1], "*((", # theta_j outside
							the.comb.yformula.sj, " - ", the.comb.yformula.sj1, ")/", # numerator
							"(1 - ", the.comb.yformula.p, "))*(", z, ")") #denominator and value of z
			
			}
			# Collapse together the combined formula
			the.comb.bj.formula <- paste0("(", paste0(the.bj.formula, collapse = " + "), ")")
			the.comb.tj.formula <- paste0("(", paste0(the.tj.formula, collapse = " + "), ")")
			the.comb.formula <- paste0(the.comb.bj.formula, " + ", the.comb.tj.formula)
			# Actually evaluate the thing using deltaMethod, save in first row of dat.out
			dat.out[sz,] <- c(as.matrix(c(s, z)), as.matrix(deltaMethod(the.coef, paste(the.comb.formula), vcov. = the.vcov, level = dM.level)))
		}
		dat.out <- data.frame(dat.out)
		names(dat.out) <- c("Period", "Z", "ME", "SE", "Lower", "Upper")
		if(effect.type %in% c("xz.me.heatmap.onlysig")) {
			#######################
			# x-axis: s; y-axis: Z; tile color is ME
			#######################
			dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
			dat.out$ME.sig <- ifelse(dat.out$insig == 0, dat.out$ME, 0)
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = ME.sig)) + 
					geom_tile() + 
					scale_fill_continuous_diverging(palette = heatmap.colors) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Value of ", z.vrbl[1])) +
					labs(fill = paste0("Statistically Significant\nMarginal Effects of ", x.vrbl[1])) +
					theme_bw() + 
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
							}
		if(effect.type %in% c("xz.me.heatmap")) {
			#######################
			# x-axis: s; y-axis: Z; tile color is ME
			#######################
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = ME)) + 
					geom_tile() + 
					scale_fill_continuous_diverging(palette = heatmap.colors) +
					# scale_fill_gradient(low = "white", high = "grey10", name = "Marginal Effect") + 
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Value of ", z.vrbl[1])) +
					labs(fill = paste0("Marginal Effect of ", x.vrbl[1])) +
					theme_bw() + 
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
		}
		if(effect.type == "xz.me.zlines") {
			#######################
			# x-axis: s; y-axis: ME; lty is Z value
			#######################
			plotting.data <- dat.out[(dat.out$Z %in% z.plot.vals),]		
			plot.out <- ggplot(data = plotting.data, aes(x = Period, y = ME, lty = as.factor(Z), col = as.factor(Z))) + 
					geom_line(lwd = 1.2) +
					geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
					geom_hline(yintercept = 0, lwd = 1) +
					scale_color_discrete(type = line.colors, name = paste0("Value of ", z.vrbl[1]), labels = z.plot.labels) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Marginal Effect of ", x.vrbl[1])) +
					theme_bw() + 
					guides(lty = "none") +
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
		}
	} # This ends the interactive ME set
	
	###############################################
	# Plot types: interactive for X and Z, cumulative marginal effects (so the heatmap, or the CME of Z at S OR S at Z)
	###############################################
	if(effect.type %in% c("xz.cme.zlines", "xz.cme.slines", "xz.cme.heatmap.onlysig", "xz.cme.heatmap")) {
		s.vals <- seq(0, (s.limit+1), 1)  # add an extra row for the LRM. we're going to trick it as the "last" time period and override the label in the plot
		ME.combinations <- expand.grid(s.vals, z.vals)
		dat.out <- matrix(rep(NA, nrow(ME.combinations)*6), nrow = nrow(ME.combinations))	
		for(sz in 1:nrow(dat.out)) {   # loop over the combinations of s periods and z values (combined in rows)
			the.bj.formula <- the.tj.formula <- rep(NA, (x.order))  # Declare a holder for the formula (since we restrict order to be equal)
			s <- ME.combinations[sz,1]
			z <- ME.combinations[sz,2]
			if(s <= s.limit) { # If it's a real value of s: not the LRM {
				for(j in 0:(length(the.bj.formula) - 1)) {  # For each of the orders of X (counting the summation of j in the formula) (since we restrict to be equal)
					the.yformula.sj1 <- the.yformula.p <- rep(NA, y.order)  # Declare holders for y. This will rarely be > 1
					for(p in 1:length(the.yformula.sj1)) {  # For each y summation element in the formula
						the.yformula.sj1[p] <- paste0(y.vrbl[p], "^",max((s-j+1), 0)) #   Sum from i = 1 to p of lag y to the max(s-j+1, 0)
						the.yformula.p[p] <- paste0(y.vrbl[p])                        #   Sum from i = 1 to p of lag y
					}
					the.comb.yformula.sj1 <- paste0("(", paste0(the.yformula.sj1, collapse = "+"), ")") # Collapse sum
					the.comb.yformula.p <- paste0("(", paste0(the.yformula.p, collapse = "+"), ")")     # Collapse sum
				
					# Now, build the formula elements for each j (order of X)
					the.bj.formula[j + 1] <- paste0(x.vrbl[j + 1], "*((", # beta_j outside
								"1 - ", the.comb.yformula.sj1, ")/", # numerator
								"(1 - ", the.comb.yformula.p, "))") #denominator					
				
					# Now, build the formula elements for each j (order of Z)
					the.tj.formula[j + 1] <- paste0(x.z.vrbl[j + 1], "*((", # theta_j outside
								"1 - ", the.comb.yformula.sj1, ")/", # numerator
								"(1 - ", the.comb.yformula.p, "))*(", z, ")") #denominator and value of z
				}
				# Collapse together the combined formula
				the.comb.bj.formula <- paste0("(", paste0(the.bj.formula, collapse = " + "), ")")
				the.comb.tj.formula <- paste0("(", paste0(the.tj.formula, collapse = " + "), ")")
				the.comb.formula <- paste0(the.comb.bj.formula, " + ", the.comb.tj.formula)
				# Actually evaluate the thing using deltaMethod, save in current row of dat.out
				dat.out[sz,] <- c(as.matrix(c(s, z)), as.matrix(deltaMethod(the.coef, paste(the.comb.formula), vcov. = the.vcov, level = dM.level)))
			} else { # if it's the LRM, i.e. the fake "last" row of s
				# Append the LRM separately as the last row
				the.bj.formula <- the.tj.formula <- rep(NA, x.order)  # Declare a holder for the formula. We'll fill the elements to paste for sum
				the.yformula.p <- rep(NA, y.order)  # Declare holders for y. This will rarely be > 1
				for(p in 1:length(the.yformula.p)) {  # For each y summation element in the formula
					the.yformula.p[p] <- paste0(y.vrbl[p])                        #   Sum from i = 1 to p of lag y
				}				
				the.comb.yformula.p <- paste0("(", paste0(the.yformula.p, collapse = "+"), ")")     # Collapse sum	
				for(j in 0:(length(the.bj.formula) - 1)) {  # For each of the orders of X (counting the summation of j in the formula)
					# Now, build the formula elements for each j (order of X)
					the.bj.formula[j + 1] <- paste0(x.vrbl[j + 1], "*(", # beta_j outside
									"1/", # numerator
									"(1 - ", the.comb.yformula.p, "))") #denominator
							
					# Now, build the formula elements for each j (order of Z)
					the.tj.formula[j + 1] <- paste0(x.z.vrbl[j + 1], "*(", # theta_j outside
									"1/", # numerator
									"(1 - ", the.comb.yformula.p, "))*(", z, ")") #denominator and value of z															
				}
				# Collapse together the combined formula
				the.comb.bj.formula <- paste0("(", paste0(the.bj.formula, collapse = " + "), ")")
				the.comb.tj.formula <- paste0("(", paste0(the.tj.formula, collapse = " + "), ")")
				the.comb.formula <- paste0(the.comb.bj.formula, " + ", the.comb.tj.formula)		
				# Evaluate the LRM 
				dat.out[sz,] <- c(as.matrix(c(s, z)), as.matrix(deltaMethod(the.coef, paste(the.comb.formula), vcov. = the.vcov, level = dM.level)))	
			}
		}
		dat.out <- data.frame(dat.out)
		names(dat.out) <- c("Period", "Z", "CME", "SE", "Lower", "Upper")

		if(effect.type == "xz.cme.zlines") {
			#######################
			# x-axis: s; y-axis: ME; lty is Z value
			#######################
			plotting.data <- dat.out[(dat.out$Z %in% z.plot.vals),]	
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0) + 2
			plotting.data.lrm <- plotting.data[(plotting.data$Period %in% 0:s.limit),]
			
			lrm.lines <- plotting.data[plotting.data$Period == (s.limit + 1),]
			lrm.lines$xloc <-  seq((s.limit + round((s.limit * 0.2), digits = 0)) - ((length(z.plot.vals) - 1)/2),
									(s.limit + round((s.limit * 0.2), digits = 0)) + ((length(z.plot.vals) - 1)/2),
									length.out = length(z.plot.vals))
		
			plot.out <- ggplot(data = plotting.data.lrm, aes(x = Period, y = CME, lty = as.factor(Z), col = as.factor(Z))) + 
					geom_line(lwd = 1.2) +
					geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Z), col = as.factor(Z)), linetype = 1, alpha = 0.1)	+
					geom_segment(data = lrm.lines, aes(x = xloc, xend = xloc, y = Lower, yend = Upper), lwd = 1.25, color = line.colors) +
					geom_point(data = lrm.lines, aes(x = xloc, y = CME), size = 3, color = line.colors)	+
					geom_hline(yintercept = 0, lwd = 1) +
					scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space-2)), 
									labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
					scale_color_discrete(type = line.colors, name = paste0("Value of ", z.vrbl[1]), labels = z.plot.labels) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Cumulative Marginal Effect of ", x.vrbl[1])) +
					theme_bw() + 
					guides(lty = "none") +
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
	
		}
		if(effect.type == "xz.cme.slines") {
			#######################
			# x-axis: Z; y-axis: CME; lty is s value
			#######################
			# Need to define levels of s for plotting. Really it's only sensical to do 0 and LRM. But I'm not going to stop anyone
			s.plot.vals[s.plot.vals == "LRM"] <- lrm.space <- s.limit + 1    #  change "LRM" to the s.limit + 1 period in the prediction dataset
			s.plot.vals <- as.numeric(s.plot.vals)
			s.plot.labels <- paste0("s = ", s.plot.vals)
			s.plot.labels[s.plot.labels == "s = 0"] <- "s = 0 (Short-run)"
			s.plot.labels[s.plot.labels == paste0("s = ", (s.limit + 1))] <- paste0("s = ", bquote(.("\U221E")), " (Long-run)")
			plotting.data <- dat.out[(dat.out$Period %in% s.plot.vals),]
			plot.out <- ggplot(data = plotting.data, aes(x = Z, y = CME, lty = as.factor(Period), col = as.factor(Period))) + 
					geom_line(lwd = 1.2) +
					geom_ribbon(aes(ymin = Lower, ymax = Upper, lty = as.factor(Period), col = as.factor(Period)), linetype = 1, alpha = 0.1) +
					geom_hline(yintercept = 0, lwd = 1) +
					scale_color_discrete(type = line.colors, name = paste0("Value of s"), labels = s.plot.labels) +
					xlab(paste0("Value of ", z.vrbl[1])) +
					ylab(paste0("Cumulative Marginal Effect of ", x.vrbl[1])) +
					theme_bw() + 
					guides(lty = "none") +
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black"))
		}		
		if(effect.type %in% c("xz.cme.heatmap.onlysig")) {
			#######################
			# x-axis: s; y-axis: Z; tile color is CME
			#######################
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
			dat.out$Period[dat.out$Period == (s.limit + 1)] <- lrm.space

			dat.out$insig <- ifelse(((dat.out$Lower < 0 & dat.out$Upper > 0) | (dat.out$Upper < 0 & dat.out$Lower > 0)), 1, 0)
			dat.out$CME.sig <- ifelse(dat.out$insig == 0, dat.out$CME, 0)
			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = CME.sig)) + 
					geom_tile() + 
					scale_fill_continuous_diverging(palette = heatmap.colors) +
					scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
									labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Value of ", z.vrbl[1])) +
					labs(fill = paste0("Statistically Significant\nCumulative Marginal Effects of ", x.vrbl[1])) +
					theme_bw() + 
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black")) 
		}
		if(effect.type %in% c("xz.cme.heatmap")) {
			#######################
			# x-axis: s; y-axis: Z; tile color is CME of LRM
			#######################
			lrm.space <- s.limit + round((s.limit * 0.2), digits = 0)
			dat.out$Period[dat.out$Period == (s.limit + 1)] <- lrm.space

			plot.out <- ggplot(data = dat.out, aes(x = Period, y = Z, fill = CME)) + 
					geom_tile() + 
					scale_fill_continuous_diverging(palette = heatmap.colors) +
					scale_x_continuous(breaks = c(seq(0, s.limit, length.out = 5), (lrm.space)), 
									labels = c(seq(0, s.limit, length.out = 5), "LRM")) +
					xlab(paste0("Number of Periods Since Change in ", x.vrbl[1], " (s)")) +
					ylab(paste0("Value of ", z.vrbl[1])) +
					labs(fill = paste0("Cumulative Marginal Effects of ", x.vrbl[1])) +
					theme_bw() + 
					theme(panel.border = element_blank(), 
						panel.grid.major = element_blank(),
						panel.grid.minor = element_blank(), 
						axis.line = element_line(colour = "black")) 
		}
		# rename last row: account for the 0 at the beginning of s
		dat.out$Period[dat.out$Period == lrm.space] <- "LRM"						
	} # This ends the interactive CME set
	if(return.plot == TRUE) {
		if(return.data == TRUE) {
			out <- list(plot.out, dat.out)
			names(out) <- c("plot", "estimates")
		} else {
			out <- plot.out
		}
	} else { # no return plot. doesn't make sense to return nothing
		if(return.data == TRUE) {
			out <- dat.out
		} else{
			stop("Return either the plot, the data, or both")
		}
	}
	out
}						

