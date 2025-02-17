library(shellpipes)
rpcall("plotCohorts.Rout plotCohorts.R forward.sim.rda deSolve.R")
loadEnvironments()
sourceFiles()
startGraphics(height = 4, width = 7)
library(ggplot2)
library(dplyr)
library(purrr)
library(patchwork)

cohorts <- map_dfr(c(1.2, 1.5, 2, 4, 8), function(R0){
  return(data.frame(sapply(cohortStats(R0), unlist), R0 = R0))
}
)

rc <- cohorts |> ggplot(aes(cohort, Rc, color = as.factor(R0))) +
  geom_hline(yintercept = 1) +
  geom_line(linewidth = 1, alpha = 0.8) +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  # ylim(c(0, 8)) +
  # scale_y_log10() +
  guides(color = "none")

# vc <- cohorts |>
#   ggplot(aes(cohort, varRc, color = as.factor(R0))) +
#   geom_line(linewidth = 1) +
#   theme_classic() +
#   scale_color_viridis_d(name = "R_0") +
#   ylim(c(0, 8)) +
#   theme(legend.position = "none"
#         # , legend.position.inside = c(0.75, 0.4)
#         )


kc <- cohorts |>
  mutate(kappa_c = varRc/Rc^2) |>
  ggplot(aes(cohort, kappa_c, color = as.factor(R0))) +
  geom_line(linewidth = 1, alpha = 0.8) +
  theme_classic() +
  scale_color_viridis_d(name = "R_0") +
  theme(legend.position = "inside"
        , legend.position.inside = c(0.75, 0.4))


rc + kc
