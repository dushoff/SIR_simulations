library(shellpipes)
rpcall("newPlots.sim.Rout newPlots.R simulate.rda finalSize.rda deSolve.R")

sourceFiles()
loadEnvironments()

slist <- list(
	sim(R0=3, rho=0)
	, sim(R0=3, rho=0, x0=0.9, finTime=25)
	, sim(R0=3, rho=0, x0=0.8, finTime=30)
	, sim(R0=3, rho=0, x0=0.7, finTime=40)
)

saveEnvironment()
