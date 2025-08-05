library(shellpipes)
library(dplyr)
library(macpan2)
startGraphics()
rpcall("mpHIV.Rout mpHIV.pipestar mpHIV.R za.csv nserc.md")

sample <- 1000
I0 <- 1e-2

## Data
anc <- (csvRead()
	|> transmute(
		time = `...1`
		, value=sample*prev/100
		, matrix = "pos"
	)
)

## flow diagram specification
flows <- list(
	mp_per_capita_flow("S", "I"
		, "rho*gamma*prev * exp(-alpha*prev) * (1-prev)^k", "infection"
	)
	, mp_per_capita_outflow("I", "gamma", "death")
)
fn <- list(
	prev ~ I/(S+I)
	, pos ~ sample*I/(S+I)
)

spec = mp_tmb_model_spec(
	before = list(
		I ~ I0, S ~ 1 - I)
	, during = c(fn, flows)
	, default = list(
		  rho = 2 
		, gamma = 0.1 
		, alpha = 0
		, k = 0
		, sample = sample
		, I0 = I0
	)
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
      , par = c("log_rho", "log_gamma", "log_I0")
  )
)

mp_optimize(nohetCal)
stopifnot(mp_optimizer_output(nohetCal)$convergence==0)
print(mp_tmb_coef(nohetCal, conf.int = TRUE)
	|> select(-term, -row, -col, -type)
)

granichCal = (spec
  |> mp_tmb_update(default = list(alpha=0.5))
  |> mp_tmb_calibrator(
        data = anc
      , traj = list(
            pos = mp_pois()
      )
      , par = c("log_rho", "log_gamma", "alpha", "log_I0")
  )
)
mp_optimize(granichCal)
stopifnot(mp_optimizer_output(granichCal)$convergence==0)
print(mp_tmb_coef(granichCal, conf.int = TRUE)
	|> select(-term, -row, -col, -type)
)

zhaoCal = (spec
  |> mp_tmb_calibrator(
        data = anc
      , traj = list(
            pos = mp_pois()
      )
      , par = c("log_rho", "log_gamma", "k", "log_I0")
  )
)
mp_optimize(zhaoCal)
stopifnot(mp_optimizer_output(zhaoCal)$convergence==0)
print(mp_tmb_coef(zhaoCal, conf.int = TRUE)
	|> select(-term, -row, -col, -type)
)

saveEnvironment()
