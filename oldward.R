library(shellpipes)
rpcall("oldward.sim.Rout oldward.R simulate.rda deSolve.R")
library(rlang)

sourceFiles()
loadEnvironments()

R0 <- 4
rho <- 0
timeStep = 0.1

mfuns <- env()
mderivs <- function(time, vars, parms){
  Ri <- mfuns$sfun(time)
  dens <- with(parms, exp(-(time-T0)))
  return(with(c(parms, vars), list(c(
    Rcdot = Ri
    , ddot = dens
    , Rctotdot = Rc*dens
    , RcSSdot = Rc*Rc*dens
  ))))
}

cMoments <- function(times, sfun, T0){
  mfuns$sfun <- sfun
  mom <- as.data.frame(ode(
    y=c(Rc=0, cum=0, Rctot=0, RcSS=0)
    , func=mderivs
    , times=times
    , parms=list(T0=T0)
  ))
  return(mom)
}

cCalc <- function(sdat, cohort, sfun, bet, tol=1e-4){
  with(sdat, {
    sTime <- time[time>=cohort]
    mom <- cMoments(sTime, sfun, cohort)
    ## print(cohort)
    ## print(mom[nrow(mom), ])
    with(mom[nrow(mom), ], {
      stopifnot(abs(cum-1)<tol)
      return(list(
        Rc=bet*Rctot/cum, kappa=cum*RcSS/Rctot^2-1
      ))
    })
  })
}

cohortStats <- function(R0, rho=0, timeStep=0.1, maxCohort=20, buffer=15){
  sdat <- sim(R0=R0, rho=rho, timeStep=timeStep, finTime=maxCohort+buffer)
  sfun <- approxfun(sdat$time, sdat$x, rule=2)
  cohorts <- with(sdat, time[time<=maxCohort])
  return(as.data.frame(t(
    sapply(cohorts, function(c) cCalc(sdat, sfun, cohort=c, bet=R0))
  )))
}

print(cohortStats(1.2))
print(cohortStats(4))
print(cohortStats(8))