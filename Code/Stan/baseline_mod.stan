data {
  int<lower = 0> N;
  int<lower = 1, upper = 8> Age[N];
  int<lower = 1, upper = 6> Education[N];
  int<lower = 1, upper = 632> PCON_ID[N];
  int<lower = 0> y[N];
  int<lower=0> K;
  matrix[N, K] x;
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
  
  // likelihood
  target += bernoulli_logit_glm_lpmf(y|x, alpha + beta[Age] + gamma[Education] + delta[PCON_ID], b);
}
