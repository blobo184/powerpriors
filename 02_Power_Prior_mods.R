## First test for power priors

## Set directory
setwd(dirname(rstudioapi::documentPath()))

## Libraries
library(rstan)
library(tidyverse)
library(reshape2)
source("00_Utility.R")

## Stan options
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

## Run model Scaling constant of 0.5
my_data <- data_prep(0.5) # Data preparation
mod <- stan(file = 'Stan/power_prior.stan', data = my_data, iter = 500, chains = 2) # Stan model
saveRDS(mod, file = "../Results/mod_pp_0.5.rds") # save


## Run model Scaling constant of 0.25
my_data <- data_prep(0.25) # Data preparation
mod <- stan(file = 'Stan/power_prior.stan', data = my_data, iter = 500, chains = 2) # Stan model
saveRDS(mod, file = "../Results/mod_pp_0.25.RDS") # save

## Run model Scaling constant of 0.1
my_data <- data_prep(0.1) # Data preparation
mod <- stan(file = 'Stan/power_prior.stan', data = my_data, iter = 500, chains = 2) # Stan model
saveRDS(mod, file = "../Results/mod_pp_0.1.RDS") # save
