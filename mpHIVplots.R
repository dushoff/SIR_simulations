library(macpan2)
library(ggplot2); theme_set(theme_bw())

library(shellpipes)
rpcall("mpHIVplots.Rout mpHIVplots.R mpHIV.rda")
loadEnvironments()

datPlot <- (ggplot()
	+ geom_point(aes(time, value/sample), data = anc)
	+ ylab("Prevalence")
)

calPlot <- (datPlot
	+ geom_line(aes(time, value/sample), colour = "red")
	+ geom_ribbon(
		aes(time , ymin = conf.low/sample, ymax = conf.high/sample)
		, alpha = 0.2, fill = "red"
	)
	+ ylim(c(0, 0.35))
)

print(datPlot)

nohetFit <- nohetCal |> mp_trajectory_sd(conf.int = TRUE)
granichFit <- granichCal |> mp_trajectory_sd(conf.int = TRUE)
zhaoFit <- zhaoCal |> mp_trajectory_sd(conf.int = TRUE)

print(calPlot %+% nohetFit
	+ ggtitle("No heterogeneity")
)

print(calPlot %+% granichFit
	+ ggtitle("Granich heterogeneity")
)

print(calPlot %+% zhaoFit
	+ ggtitle("Zhao heterogeneity")
)

startGraphics(desc="pitch", width=3, height=4)

print(calPlot
	%+% zhaoFit
	+ geom_line(aes(time, value/sample), colour = "red", data=nohetFit)
	+ geom_ribbon(
		aes(time , ymin = conf.low/sample, ymax = conf.high/sample)
		, alpha = 0.2, fill = "blue"
		, data = nohetFit
	)
)

