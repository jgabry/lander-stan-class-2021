// hierarchical model with non-centered parameterization of mu
data {
  int<lower=1> N;
  array[N] int<lower=0> complaints;
  vector<lower=0>[N] traps;
  vector[N] log_sq_foot;
  
  int<lower=0> J; //Number of buildings
  int<lower=0> K; //Number of building level predictors
  array[N] int<lower=1, upper=J> building_idx;
  matrix[J,K] building_data;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> inv_phi;
  vector[J] mu_raw;
  vector[K] zeta;
  real<lower=0> sigma_mu;
}
transformed parameters {
  // shift mu_raw by the mean of mu and scale it by the standard deviation
  vector[J] mu = (alpha + building_data * zeta) + sigma_mu * mu_raw; 
  vector[N] eta = mu[building_idx] + beta * traps + log_sq_foot;
  real phi = 1 / inv_phi;
}
model {
  complaints ~ neg_binomial_2_log(eta, phi);
  
  mu_raw ~ normal(0, 1); // implies mu ~ normal(alpha + building_data * zeta, sigma_mu);
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
  inv_phi ~ normal(0, 1);
  zeta ~ normal(0,1);
  sigma_mu ~ normal(0,1);
}
generated quantities {
  array[N] int y_rep = neg_binomial_2_log_rng(eta, phi);
}
