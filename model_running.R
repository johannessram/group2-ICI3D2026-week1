# install.packages("deSolve")
library(deSolve)

#########################################
# SIRD MODEL
########################################

sird_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    
    dS <- -beta * S * I / N
    dI <- beta * S * I / N - gamma * I - mu * I
    dR <- gamma * I
    dD <- mu * I
    
    return(list(c(dS, dI, dR, dD)))
  })
}

run_sird <- function(N, I0, beta, gamma, mu, days = 100) {
  
  state <- c(
    S = N - I0,
    I = I0,
    R = 0,
    D = 0
  )
  
  parameters <- c(
    beta = beta,
    gamma = gamma,
    mu = mu,
    N = N
  )
  
  times <- seq(0, days, by = 1)
  
  output <- ode(
    y = state,
    times = times,
    func = sird_model,
    parms = parameters
  )
  
  return(as.data.frame(output))
}

#################################################
# POPULATIONS
##############################################

N_paarl_other <- 8921
N_paarl_white <- 2371

N_kuruman_other <- 11782
N_kuruman_white <- 5293

#########################################
# INEQUALITY SCENARIO
##########################################

paarl_white_ineq <- run_sird(
  N_paarl_white,
  I0 = 10,
  beta = 0.55,
  gamma = 0.20,
  mu = 0.02
)

paarl_other_ineq <- run_sird(
  N_paarl_other,
  I0 = 10,
  beta = 0.55,
  gamma = 0.15,
  mu = 0.05
)

kuruman_white_ineq <- run_sird(
  N_kuruman_white,
  I0 = 10,
  beta = 0.55,
  gamma = 0.20,
  mu = 0.02
)

kuruman_other_ineq <- run_sird(
  N_kuruman_other,
  I0 = 10,
  beta = 0.55,
  gamma = 0.15,
  mu = 0.05
)

######################################
# EQUALITY SCENARIO
#######################################

paarl_white_equal <- run_sird(
  N_paarl_white,
  I0 = 10,
  beta = 0.55,
  gamma = 0.20,
  mu = 0.02
)

paarl_other_equal <- run_sird(
  N_paarl_other,
  I0 = 10,
  beta = 0.55,
  gamma = 0.20,
  mu = 0.02
)

kuruman_white_equal <- run_sird(
  N_kuruman_white,
  I0 = 10,
  beta = 0.55,
  gamma = 0.20,
  mu = 0.02
)

kuruman_other_equal <- run_sird(
  N_kuruman_other,
  I0 = 10,
  beta = 0.55,
  gamma = 0.20,
  mu = 0.02
)

#########################################
# RESULTS TABLE
##########################################

final_results <- data.frame(
  District = c(
    "Paarl","Paarl",
    "Kuruman","Kuruman",
    "Paarl","Paarl",
    "Kuruman","Kuruman"
  ),
  
  Group = c(
    "White","Other",
    "White","Other",
    "White","Other",
    "White","Other"
  ),
  
  Scenario = c(
    "Inequality","Inequality",
    "Inequality","Inequality",
    "Equality","Equality",
    "Equality","Equality"
  ),
  
  Final_Deaths = c(
    tail(paarl_white_ineq$D,1),
    tail(paarl_other_ineq$D,1),
    tail(kuruman_white_ineq$D,1),
    tail(kuruman_other_ineq$D,1),
    tail(paarl_white_equal$D,1),
    tail(paarl_other_equal$D,1),
    tail(kuruman_white_equal$D,1),
    tail(kuruman_other_equal$D,1)
  ),
  
  Population = c(
    N_paarl_white,
    N_paarl_other,
    N_kuruman_white,
    N_kuruman_other,
    N_paarl_white,
    N_paarl_other,
    N_kuruman_white,
    N_kuruman_other
  )
)

final_results$Mortality_Rate <- final_results$Final_Deaths / final_results$Population
final_results$Mortality_Rate_Percent <- final_results$Mortality_Rate * 100

print(final_results)

############################################
# GRAPH FUNCTION
###########################################

plot_mortality_rate <- function(
    time,
    other_rate,
    white_rate,
    title_text
) {
  
  ymax <- max(other_rate, white_rate) * 100
  
  plot(
    time,
    other_rate * 100,
    type = "l",
    lwd = 3,
    col = "red",
    xlab = "Days",
    ylab = "Mortality Rate (%)",
    main = title_text,
    ylim = c(0, ymax),
    las = 1
  )
  
  lines(
    time,
    white_rate * 100,
    lwd = 3,
    col = "blue"
  )
  
  grid()
  
  legend(
    "topleft",
    legend = c("Other", "White"),
    col = c("red", "blue"),
    lwd = 3,
    bty = "n"
  )
}




#############################################################
# COMBINED KURUMAN GRAPH
# Inequality vs Equality
###############################################################

time <- kuruman_other_ineq$time

other_ineq_rate <- kuruman_other_ineq$D / N_kuruman_other * 100
white_ineq_rate <- kuruman_white_ineq$D / N_kuruman_white * 100
equality_rate <- kuruman_other_equal$D / N_kuruman_other * 100

plot(
  time,
  other_ineq_rate,
  type = "n",
  ylim = c(0, 25),
  xlab = "Days",
  ylab = "Cumulative Mortality Rate (%)",
  main = "Kuruman:Mortality Rate under Equality and Inequality of HealthCare access",
  adj = 0.75,
  las = 1,
  cex.main = 1.2,
  cex.lab = 1.2,
  cex.axis = 1.5
)


polygon(
  c(time, rev(time)),
  c(other_ineq_rate, rev(equality_rate)),
  col = rgb(1, 0, 0, 0.15),
  border = NA
)


grid(col = "lightgray", lty = "dotted")


lines(
  time,
  other_ineq_rate,
  col = "red",
  lwd = 3
)


lines(
  time,
  white_ineq_rate,
  col = "blue",
  lwd = 2.5
)


lines(
  time,
  equality_rate,
  col = "black",
  lwd = 3,
  lty = 2
)

legend(
  "topleft",
  legend = c(
    "Other (Inequality)",
    "White (Both)",
    "Other (Equality)"
  ),
  col = c("red", "blue", "black"),
  lty = c(1, 1, 2),
  lwd = c(3, 2.5, 3),
  bty = "n",
  cex = 1.2
)
#################################################
# PAARL SUMMARY GRAPH
#################################################

time <- paarl_other_ineq$time

other_ineq_rate <- paarl_other_ineq$D / N_paarl_other * 100
white_ineq_rate <- paarl_white_ineq$D / N_paarl_white * 100
equality_rate <- paarl_other_equal$D / N_paarl_other * 100

plot(
  time,
  other_ineq_rate,
  type = "n",
  ylim = c(0, 25),
  xlab = "Days",
  ylab = "Cumulative Mortality Rate (%)",
  main = "Paarl: Mortality Rate under Equality and Inequality of HealthCare access",
  las = 1,
  cex.main = 1.3,
  adj = 0.75,
  cex.lab = 1.2,
  cex.axis = 1.5
)


polygon(
  c(time, rev(time)),
  c(other_ineq_rate, rev(equality_rate)),
  col = rgb(1, 0, 0, 0.15),
  border = NA
)


grid(col = "lightgray", lty = "dotted")


lines(
  time,
  other_ineq_rate,
  col = "red",
  lwd = 3
)


lines(
  time,
  white_ineq_rate,
  col = "blue",
  lwd = 2.5
)


lines(
  time,
  equality_rate,
  col = "black",
  lwd = 3,
  lty = 2
)

legend(
  "topleft",
  legend = c(
    "Other (Inequality)",
    "White (Both)",
    "Other (Equality)"
  ),
  col = c("red", "blue", "black"),
  lty = c(1, 1, 2),
  lwd = c(3, 2.5, 3),
  bty = "n",
  cex = 1.2
)

