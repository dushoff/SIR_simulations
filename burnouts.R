library(shellpipes)

sourceFiles()
loadEnvironments()

slist <- list(
	sim(R0=2, rho=0)
	, sim(R0=2, rho=0, x0=0.9, finTime=25)
	, sim(R0=2, rho=0, x0=0.8, finTime=30)
	, sim(R0=2, rho=0, x0=0.7, finTime=40)
)

saveEnvironment()
