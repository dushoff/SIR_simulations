library(shellpipes)
loadEnvironments()

cx <- 1.7
par(cex=cx, cex.axis=1.2, cex.lab=cx, mar = c(5,6,4,1.5))

genTime <- 10

prev <- csvRead()
baseYear <- prev$year[[1]]

for (i in 0:length(R0)){
	top = ifelse(i>0, paste("R0 = ", sprintf("%4.2f", R0[[i]])), "")
	with(prev, plot(
		year, prev/100,
		xlab = "Year",
		ylab = "HIV prevalence", bty = 'n', pch = 19,
		main = top, yaxt='n'
	))
axis(2, seq(0,.3,b=.1), las = 2)
	if (i>0) with(simList[[i]], lines(baseYear+genTime*time, y, , lwd = 3))
}
