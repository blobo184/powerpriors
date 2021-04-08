## Collating results and comparing accuracy

## Set directory
setwd(dirname(rstudioapi::documentPath()))

## Libraries
library(tidyverse)

## Load models and merge into one frame

load("../Results/baseline_results.RData")
results_1 <- result_export %>%
  mutate(model = "Baseline")
rm(result_export)

load("../Results/pp_0.5.RData")
results_2 <- result_export %>%
  mutate(model = "pp_0.5")
rm(result_export)

load("../Results/pp_0.25.RData")
results_3 <- result_export %>%
  mutate(model = "pp_0.25")
rm(result_export)

load("../Results/pp_0.1.RData")
results_4 <- result_export %>%
  mutate(model = "pp_0.1")
rm(result_export)

combined_results <- do.call("rbind", list(results_1, results_2, results_3, results_4))
save(combined_results, file = "../Results/Combined_Results.RData")

## headline Accuracy comparison
combined_results %>%
  group_by(model) %>%
  summarise(MAE = round(mean(MAE),3),
            RMSE = round(mean(RMSE),3))

combined_results %>%
  group_by(model) %>%
  summarise(mae = round(mean(MAE),4),
            rmse = round(mean(RMSE),4),)
