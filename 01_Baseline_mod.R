## Baseline stan model

## Setwd
setwd(dirname(rstudioapi::documentPath()))

## Libraries
library(rstan)

## Stan options
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

## Prepare data for stan model
load("../Data/bes_2017.rdata")
my_data = list(
  N = nrow(bes_2017),
  Age = as.numeric(bes_2017$Age),
  Education = as.numeric(as.factor(bes_2017$Education)), 
  PCON_ID = as.numeric(as.factor(bes_2017$PCON_ID)),
  y = bes_2017$Con,
  x = cbind(bes_2017$Con15, bes_2017$Population_density),
  K = 2
)

mod = stan(file = 'Stan/baseline_mod.stan', data = my_data, iter = 500, chains = 2)
saveRDS(mod, "../Results/baseline_mod.rds")

############################ End ###########################