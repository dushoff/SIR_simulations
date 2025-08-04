library(shellpipes)
library(dplyr)
library(macpan2)
startGraphics()

sample <- 1000

## Data
anc <- (csvRead()
	|> transmute(
		time = `...1`
		, value=sample*prev/100
		, matrix = "pos"
	)
)

## flow diagram specification
initVals <- list(I = 1e-2)
flows <- list(
	  mp_per_capita_flow("S", "I", "beta*prev*exp(-alpha*prev)", "infection")
	, mp_per_capita_outflow("I", "gamma", "death")
)
fn <- list(
	prev ~ I/(S+I)
	, pos ~ sample*I/(S+I)
)

spec = mp_tmb_model_spec(
	  before = list(S ~ 1 - I)
	, during = c(fn, flows)
	, default = list(
		  beta = 0.2 
		, gamma = 0.1 
		, alpha = 0
		, sample = sample
	)
	, inits = initVals
)

######################################################################

simulator = mp_simulator(model = mp_rk4(spec)
	, time_steps = nrow(anc)
	, outputs = "pos"
)

######################################################################

nohetCal = (spec
  |> mp_tmb_calibrator(
        data = anc
      , traj = list(
            pos = mp_pois()
      )
      , par = c("log_beta", "log_gamma")
  )
)

mp_optimize(nohetCal)
print(mp_optimizer_output(nohetCal)$convergence)

print(mp_tmb_coef(nohetCal, conf.int = TRUE)
	|> select(-term, -row, -col, -type)
)

hetCal = (spec
  |> mp_tmb_update(default = list(alpha=0.5))
  |> mp_tmb_calibrator(
        data = anc
      , traj = list(
            pos = mp_pois()
      )
      , par = c("log_beta", "log_gamma", "alpha")
  )
)
rpt <- mp_optimize(hetCal)
print(mp_optimizer_output(hetCal)$convergence)

print(mp_tmb_coef(hetCal, conf.int = TRUE)
	|> select(-term, -row, -col, -type)
)

library(ggplot2); theme_set(theme_bw())

calPlot <- (ggplot()
	+ geom_line(aes(time, value), colour = "red")
	+ geom_ribbon(aes(time, ymin = conf.low, ymax = conf.high)
		, alpha = 0.2, fill = "red")
	+ geom_line(aes(time, value), data = anc)
)

print(calPlot %+% (nohetCal |> mp_trajectory_sd(conf.int = TRUE))
	+ ggtitle("No heterogeneity")
)

print(calPlot %+% (hetCal |> mp_trajectory_sd(conf.int = TRUE))
	+ ggtitle("Simple heterogeneity")
)
