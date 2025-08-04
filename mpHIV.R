
## Load the library
library(macpan2)
library(ggplot2); theme_set(theme_bw(base_size=14))

## Build a model structure

## default values for quantities required to run simulations
dPar <- list(
	  beta = 0.2 
	, gamma = 0.1 
)

initVals <- list(
	N = 100
	, I = 1
 )

## flow diagram specification
## try ?mp_per_capita_flow, and make sure you understand the arguments here
flows = list(
	  mp_per_capita_flow("S", "I", "beta * I / N", "infection")
	, mp_per_capita_outflow("I", "gamma", "death")
)

initialize_state = list(S ~ N - I)

## model specification
sirSpec = mp_tmb_model_spec(
	  before = initialize_state
	, during = flows
	, default = dPar
	, inits = initVals
)

print(sirSpec)

######################################################################

## Simulate 
time_steps = 100

# rk4 will construct steps that more closely match a continuous process
sirContinuous = mp_simulator(model = mp_rk4(sirSpec)
	, time_steps = time_steps
	, outputs = "I"
)

sirTraj <- mp_trajectory(sirContinuous, include_initial=TRUE)
print(sirTraj)

print(ggplot(sirTraj)
	+ aes(time, value, color=matrix)
	+ geom_line()
)

