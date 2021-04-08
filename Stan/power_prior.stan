data {
  int<lower = 0> N; // Current N
  int<lower = 0> N0; // Historic N
  int<lower = 1, upper = 8> Age[N]; // Age groups
  int<lower = 1, upper = 8> Age0[N0]; // Age groups (historic)
  int<lower = 1, upper = 6> Education[N]; // Edu groups
  int<lower = 1, upper = 6> Education0[N0]; // Edu groups (historic)
  int<lower = 1, upper = 632> PCON_ID[N]; // Area groups 
  int<lower = 1, upper = 632> PCON_ID0[N0]; // Area groups (historic)
  int<lower = 0> y[N]; // Current y
  int<lower = 0> y0[N0]; // Historic y
  int<lower=0> K;
  matrix[N, K] x; // Area predictors
  matrix[N0, K] x0; // Area predictors (historic)
  real<lower=0,upper=1> a0; //discounting parameter
}

parameters {
  real alpha;
  real<lower = 0> sigma_beta;
  vector<multiplier = sigma_beta>[8] beta;
  real<lower = 0> sigma_gamma;
  vector<multiplier = sigma_gamma>[6] gamma;
  real<lower = 0> sigma_delta;
  vector<multiplier = sigma_delta>[632] delta;
  vector[K] b;
}

model {
  // priors
  alpha ~ normal(0, 5);
  beta ~ normal(0, sigma_beta);
  gamma ~ normal(0, sigma_gamma);
  delta ~ normal(0, sigma_delta);
  sigma_beta ~ normal(0, 5);
  sigma_gamma ~ normal(0, 5);
  sigma_delta ~ normal(0, 5);
  b ~ normal(0, 5);
  target += a0 * bernoulli_logit_glm_lpmf(y0|x0 , alpha + beta[Age0] + gamma[Education0] + delta[PCON_ID0], b);
  
  // likelihood
  target += bernoulli_logit_glm_lpmf(y|x , alpha + beta[Age] + gamma[Education] + delta[PCON_ID], b);
  
}
