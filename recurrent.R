library(shellpipes)
rpcall("recurrent.sim.Rout recurrent.R simulate.rda finalSize.rda deSolve.R")

loadEnvironments()
sourceFiles()

sdat <- sim(R0=4, rho=0.02, finTime=100, timeStep=0.2)

saveEnvironment()
