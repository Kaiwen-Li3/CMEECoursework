#ggplot2 for graphs
library(ggplot2)
library(minpack.lm)



setwd("~/GitHub/CMEECoursework/MiniProject/Code")
dataMod <- read.csv("../Data/LogisticGrowthDataMod.csv")


#summary(dataMod$PopBio)
#dataMod$log_PopBio <- log(dataMod$PopBio)

#===========================================================================================================

#apply linear model to each popbio unit
lm_models <- lapply(split(dataMod, dataMod$PopBio_units), function(subset) {
  lm(log_PopBio ~ Time, data = subset)
})


summary(lm_models[["CFU"]])
#r ~ 0.004963
summary(lm_models[["DryWeight"]])
#r ~ 0.0022569
summary(lm_models[["N"]])
#r ~ -2.871e-04
summary(lm_models[["OD_595"]])
#r ~ 0.0009739



#AIC, BIC, r2
aic_values <- sapply(lm_models, AIC) 
bic_values <- sapply(lm_models, BIC)
r2_values <- sapply(lm_models, function(model) summary(model)$r.squared)


aic_values
# CFU  DryWeight          N     OD_595 
# 5585.41193   11.58092 7600.53977 6958.07674

bic_values
# CFU  DryWeight          N     OD_595 
# 5600.60877   17.54787 7616.01064 6974.65042 

r2_values

# CFU   DryWeight           N      OD_595 
# 0.080696804 0.678478006 0.006623989 0.013931593 
#dry weight has highest r2, linear model explains ~68%





#===========================================================================================================

gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   

dataCFU <- subset(dataMod, PopBio_units == "CFU")

N_0_start <- min(dataCFU$log_PopBio)
K_start <- max(dataCFU$log_PopBio)
r_max_start <- coef(lm_models[["CFU"]])["Time"]
t_lag_start <- min(dataCFU$Time)



fit_gompertz <- nlsLM(log_PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), 
                      data = dataCFU,
                      start = list(t_lag = t_lag_start, r_max = r_max_start, N_0 = N_0_start, K = K_start),
                      control = nls.lm.control(maxiter = 100)) 

summary(fit_gompertz)

##lower AIC is better
AIC(fit_gompertz)
#5434.616




