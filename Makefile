# This is SIR_simulations; it has outdated stuff for talks, and superseded stuff for the Roswell conjecture. See Roswell's fork of this repo

current: target
-include target.mk

# include makestuff/perl.def

vim_session:
	bash -cl "vmt README.md notes.md"

######################################################################

## Now building some macpan fitting here for NSERC, because it is where I have the HIV prevalence data?

Ignore += .macpan

## Going with very simple model for now 2025 Aug 05 (Tue)
mpHIV.Rout: mpHIV.R za.csv nserc.md
mpHIVplots.Rout: mpHIVplots.R mpHIV.rda
	$(pipeRcall)

Ignore += mpHIVplots.pitch.pdf
## mpHIVplots.pitch.pdf: mpHIVplots.R
mpHIVplots.pitch.pdf: mpHIVplots.Rout ;

## The prepackaged version has treatment, which we don't want for our simple example.
granich.Rout: granich.R

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
## Backwards trick worked super-cool for simple things, but could not be easily extended to do the job that actually needed to be done

## revtest.md
## revtest.rev.plots.Rout: revtest.R
## revtest.rev.sim.Rout: revtest.R revsim.R
%.rev.sim.Rout: %.R revsim.rda deSolve.R
	$(pipeR)

## Deleting other Roswell conjecture stuff from here so it can be active in the forks.

######################################################################

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
-include makestuff/pdfpages.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk

##################################################################
