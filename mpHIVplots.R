library(macpan2)
library(ggplot2); theme_set(theme_bw())

library(shellpipes)
rpcall("mpHIVplots.Rout mpHIVplots.R mpHIV.rda")
loadEnvironments()

calPlot <- (ggplot()
	+ geom_line(aes(time, value/sample), colour = "red")
	+ geom_ribbon(
		aes(time , ymin = conf.low/sample, ymax = conf.high/sample)
		, alpha = 0.2, fill = "red"
	)
	+ geom_point(aes(time, value/sample), data = anc)
	+ ylab("Prevalence")
)

print(calPlot %+% (nohetCal |> mp_trajectory_sd(conf.int = TRUE))
	+ ggtitle("No heterogeneity")
)

print(calPlot %+% (granichCal |> mp_trajectory_sd(conf.int = TRUE))
	+ ggtitle("Granich heterogeneity")
)

print(calPlot %+% (zhaoCal |> mp_trajectory_sd(conf.int = TRUE))
	+ ggtitle("Zhao heterogeneity")
)
