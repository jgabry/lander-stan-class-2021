// hierarchical model with non-centered parameterization of mu
// need to add the missing lines of code (see comments below)
data {
  int<lower=1> N;
  array[N] int<lower=0> complaints;
  vector<lower=0>[N] traps;
  vector[N] log_sq_foot;
  
  int<lower=0> J; 
  int<lower=0> K; 
  array[N] int<lower=1, upper=J> building_idx;
  matrix[J,K] building_data;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> inv_phi;
  
  vector[J] mu_raw; // switched to mu_raw instead of mu
  vector[K] zeta;
  real<lower=0> sigma_mu;
}
transformed parameters {
  // To add:
  // calculate mu by scaling mu_raw by the standard deviation of mu and 
  // shifting it by the mean of mu
  
  vector[N] eta = mu[building_idx] + beta * traps + log_sq_foot;
  real phi = 1 / inv_phi;
}
model {
  complaints ~ neg_binomial_2_log(eta, phi);
  
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
  inv_phi ~ normal(0, 1);
  
  // To add: 
  // prior on mu_raw
  
  sigma_mu ~ normal(0,1);
  zeta ~ normal(0,1);
}
generated quantities {
  array[N] int y_rep = neg_binomial_2_log_rng(eta, phi);
}
