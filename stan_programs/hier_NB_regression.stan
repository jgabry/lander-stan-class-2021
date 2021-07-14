// hierarchical model with centered parameterization of mu
data {
  int<lower=1> N;
  array[N] int<lower=0> complaints;
  vector<lower=0>[N] traps;
  vector[N] log_sq_foot;
  
  // To add:
  // Number of buildings, J
  // Number of building level predictors, K
  // integer array of building_idx (from 1 to J)
  // JxK matrix of building_data variables
}
parameters {
  real alpha;
  real beta;
  real<lower=0> inv_phi;
  
  // To add:
  // vector of coefficients on building_data variables
  // vector of building intercepts, mu
  // sd of building intercepts, sigma_mu
}
transformed parameters {
  vector[N] eta = mu[building_idx] + beta * traps + log_sq_foot;
  real phi = 1 / inv_phi;
}
model {
  complaints ~ neg_binomial_2_log(eta, phi);
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
  inv_phi ~ normal(0, 1);
  
  // To add:
  // normal distribution for mu with mean=alpha + building_data * zeta, sd = sigma_mu
  // normal(0,1) prior on zeta
  // normal(0,1) prior on sigma_mu
}
generated quantities {
  array[N] int y_rep = neg_binomial_2_log_rng(eta, phi);
}
