library(shellpipes)
library(deSolve)

loadEnvironments()

R0 <- exp(seq(log(2), log(8), length.out=5))
print(R0)
simList <- list()

for (i in 1:length(R0)){
	simList[[i]]<- sim(R0=R0[[i]],
		finTime=2, timeStep=0.02, rho=0.2, y0=0.01)
}

saveEnvironment()
