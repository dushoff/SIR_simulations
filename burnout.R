library(shellpipes)
rpcall("burnout.sim.Rout burnout.R simulate.rda finalSize.rda deSolve.R")

sourceFiles()
loadEnvironments()

## Consider changing this number (for some lecture 2025 Feb 07 (Fri))
sdat <- sim(R0=2, rho=0)
## Use this one for tests; can change R0 without changing lecture
sdat <- sim(R0=3, rho=0)

saveEnvironment()
