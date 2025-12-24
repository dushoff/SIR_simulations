library(shellpipes)

sir <- function(time, vars, parms){
	x <- with(as.list(vars), exp(lx))
	y <- with(as.list(vars), exp(ly))
	
	Rx <- with(parms, R0 * x^zeta)

	return(with(parms, list(c(
		lxdot = rho*(1-x)/x - Rx*y,
		lydot = Rx*x-1,
		cumdot = Rx*x*y
	))))
}

sim <- function(x0=NULL, y0=0.001, R0=5, rho=0.01, zeta=1, finTime=20, timeStep=0.1, dfun=sir){
	if(is.null(x0)){x0 <- 1-y0}
	sim <- as.data.frame(ode(
		y=c(lx=log(x0), ly=log(y0), cum=0),
		func=dfun,
		times=seq(from=0, to=finTime, by=timeStep),
		parms=list(R0=R0, rho=rho, zeta=zeta)
	))

	return(within(sim, {
		x <- exp(lx)
		y <- exp(ly)
		z <- 1-x-y
		inc <- c(NA, cum[-1] - cum[-nrow(sim)])
		incGen <- inc/timeStep
	}))
}
saveEnvironment()
