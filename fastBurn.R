library(shellpipes)
rpcall("burnouts.sim.Rout burnouts.R simulate.rda finalSize.rda deSolve.R")

sourceFiles()
loadEnvironments()

slist <- list(
	sim(R0=3, rho=0)
	, sim(R0=3, rho=0, x0=0.9, finTime=35)
	, sim(R0=3, rho=0, x0=0.8, finTime=30)
	, sim(R0=3, rho=0, x0=0.7, finTime=40)
)

saveEnvironment()
