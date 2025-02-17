# This is SIR_simulations

current: target
-include target.mk

# include makestuff/perl.def

vim_session:
	bash -cl "vmt README.md notes.md"

######################################################################

Sources += $(wildcard *.md)

Sources += $(wildcard *.R *.csv)

autopipeR = defined

## simulate.R has functions for simulating a simple epidemic
## burnout.plots.Rout: burnout.R
## newPlots.plots.Rout: newPlots.R

## finalSize.R uses uniroot to solve final size equation; might be clunky though
## finalSize.Rout: finalSize.R

%.sim.Rout: %.R simulate.rda finalSize.rda deSolve.R
	$(pipeRcall)

######################################################################

## Dropped lots of stuff into content.mk because most of it doesn't work and it made organization hard.

Sources += content.mk

######################################################################

## See notes in content.mk, and also rule for newplots

%.plots.Rout: plots.R %.sim.rda
	$(pipeR)

######################################################################

## Working now on simulating _backwards_; can we get things to match?
## Goal is to calculating infectious potential distributions for Roswell-Weitz heterogeneity
## This doesn't work as slick as I had hoped, and needs more math I think to be made to work at all.

## revtest.md
## revtest.rev.plots.Rout: revtest.R
## revtest.rev.sim.Rout: revtest.R revsim.R
%.rev.sim.Rout: %.R revsim.rda deSolve.R
	$(pipeR)

######################################################################

## Now try to do detailed sims that can be used for calculating means and variances of Rc. Forward version of Roswell-Weitz attack

## forward.sim.Rout: forward.R forward.md
conjecture.Rout: conjecture.R forward.sim.rda deSolve.R
	$(pipeRcall)

plotCohorts.Rout: plotCohorts.R forward.sim.rda deSolve.R
	$(pipeRcall)
### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk
-include makestuff/pipeR.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk

##################################################################
