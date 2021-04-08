## Poststratification of stan models and accuracy comparison

## Set directory
setwd(dirname(rstudioapi::documentPath()))

## Libraries
library(rstan)
library(tidyverse)
library(reshape2)
source("00_Utility.R")


## Load poststratification frame
load("../Data/post.RData")

## Postrat and save for baseline model (no power priors)
mod <- readRDS("../Results/baseline_mod.rds")
result_export <- stan_poststrat(mod, post, iter =100)
save(result_export, file = "../Results/baseline_results.RData")


## Postrat and save for scaling constant 0.5 model
mod <- readRDS("../Results/mod_pp_0.5.rds")
result_export <- stan_poststrat(mod, post, iter =100)
save(result_export, file = "../Results/pp_0.5.RData")


## Postrat and save for scaling constant 0.25 model
mod <- readRDS("../Results/mod_pp_0.25.RDS")
result_export <- stan_poststrat(mod, post, iter =100)
save(result_export, file = "../Results/pp_0.25.RData")


## Postrat and save for scaling constant 0.1 model
mod <- readRDS("../Results/mod_pp_0.1.RDS")
result_export <- stan_poststrat(mod, post, iter =100)
save(result_export, file = "../Results/pp_0.1.RData")

####################### ENd #############################
