library(shellpipes)
rpcall("conjecture.Rout conjecture.R forward.sim.rda deSolve.R")
sourceFiles()
loadEnvironments()
R0 <- c(1.2, 1.5, 2, 4, 8)
steps <- 3e2

print(as.data.frame(t(
  sapply(R0, function(x) outbreakStats(R0=x, steps=steps))
)))

