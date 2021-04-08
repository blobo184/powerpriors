## Utility script for power priors

## poststrat function with 100 iters 
## Function takes stan model and predicts with new data
## Output is small area estimates, along with MAE and RMSE.
stan_poststrat <- function(mod, post, iters) {
  
  ## Extract coefs
  coefs <- rstan::extract(mod)
  
  ## Prepare poststrat table for stan model
  post$PCON_ID <- as.numeric(as.factor(post$PCON_ID))
  post$Age <- as.numeric(as.factor(post$Age))
  post$Education <- as.numeric(as.factor(post$Education))
  
  post <- post %>%
    dplyr::select(PCON_ID, Age, Education, Con15, Population_density, weight, Con17, Turnout17)
  
  holder <- list()
  for (i in 1:nrow(post)){
    alpha <- sample(coefs$alpha, iters) ## Alpha
    Age <- sample(coefs$beta[,pull(post[i,2])], iters) # Age
    Education <- sample(coefs$gamma[,pull(post[i,3])], iters) # Education
    PCON_ID <- sample(coefs$delta[,pull(post[i,1])], iters) # Small area
    x1 <- sample(coefs$b[,1], iters) * pull(post[i,4]) # Fixed effect of past Conservative vote
    x2 <- sample(coefs$b[,2], iters) * pull(post[i,5]) # Fixed effect of pop density
    lp <- alpha + Age + Education + PCON_ID + x1 + x2
    holder[[i]] <- exp(lp) / (exp(lp)+1)
  }
  
  out <- melt(holder, varnames = "iter") %>%
    rename(post_row = L1)
  out$weight <- post$weight[out$post_row] ## Append small area population weights
  out$PCON_ID <- post$PCON_ID[out$post_row] ## Append small area code
  out$Turnout <- post$Turnout17[out$post_row] ## Append past turnout
  out$Con17 <- post$Con17[out$post_row] ## Append past vote
  
  ## Calculate estimates for each small area and iter
  results <- out %>%
    group_by(PCON_ID, iter) %>%
    summarise(temp.Pred = sum((value*Turnout)*weight), ## Weights estimates
              Con17 = unique(Con17),
              err = (temp.Pred - Con17)) # Error compared to real past vote
  
  ## Calculate estimates and CI for each small area
  result.export <- results %>%
    group_by(PCON_ID) %>%
    summarise(Pred = mean(temp.Pred),
              Pred_lo = quantile(temp.Pred, 0.05),
              Pred_hi = quantile(temp.Pred, 0.95),
              MAE = mean(abs(err)),
              RMSE = sqrt(mean(err^2)))
  result.export
}

## Function to prepare the data for stan power priors model
data_prep <- function(scaling_constant) { 
  load("../Data/bes_2017.rdata")
  load("../Data/bes_2015.rdata")
  
  my_data = list(
    N = nrow(bes_2017), # Rows of current data
    Age = as.numeric(bes_2017$Age), ## Age var
    Education = as.numeric(as.factor(bes_2017$Education)),  # Education var
    PCON_ID = as.numeric(as.factor(bes_2017$PCON_ID)), # Area code
    y = bes_2017$Con, # y - Vote for Conservative Party
    x = cbind(bes_2017$Con15, bes_2017$Population_density), # fixed-effect vars, past vote & pop density
    N0 = nrow(bes_2015), # Rows historic
    Age0 = as.numeric(bes_2015$Age), # Age historic
    Education0 = as.numeric(as.factor(bes_2015$Education)), # Education historic
    PCON_ID0 = as.numeric(as.factor(bes_2015$PCON_ID)), # Area code historic
    y0 = bes_2015$Con, # Y - historic
    x0 = cbind(bes_2015$Con10, bes_2015$Population_density), # Fixed effect vars historic
    K = 2,
    a0 = scaling_constant # scaline contant
  )
  my_data
}
