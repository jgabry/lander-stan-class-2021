// Varying intercepts, varying slopes, latent time trend
// Non-centered parameterization
data {
  int<lower=1> N;                     
  array[N] int<lower=0> complaints;
  vector<lower=0>[N] traps;                
  
  vector[N] log_sq_foot;  
  
  int<lower=1> K;
  int<lower=1> J;
  array[N] int<lower=1,upper=J> building_idx;
  matrix[J,K] building_data;
  
  // To add:
  // number of months M
  // integer array of month indexes, mo_idx
}
parameters {
  real<lower=0> inv_phi;  
  
  vector[J] mu_raw;
  real<lower=0> sigma_mu; 
  real alpha;  
  vector[K] zeta; 
  
  vector[J] kappa_raw;    
  real<lower=0> sigma_kappa; 
  real beta;           
  vector[K] gamma;
  
  // To add:
  // rho_raw
  // mo_raw
  // sigma_mo
}
transformed parameters {
  real phi = inv(inv_phi);
  
  vector[J] mu = alpha + building_data * zeta + sigma_mu * mu_raw;
  vector[J] kappa = beta + building_data * gamma + sigma_kappa * kappa_raw;
  
  // To add:
  // non-centered parameterization of AR(1) process priors
  // compute rho from rho_raw
  // compute mo from mo_raw, sigma_mo, and rho
  
  // To add: add mo to eta
  vector[N] eta = mu[building_idx] + kappa[building_idx] .* traps + log_sq_foot;
}
model {
  complaints ~ neg_binomial_2_log(eta, phi);
    
  inv_phi ~ normal(0, 1);
  
  kappa_raw ~ normal(0,1) ;
  sigma_kappa ~ normal(0, 1);
  beta ~ normal(-0.25, 0.5);
  gamma ~ normal(0, 1);
  
  mu_raw ~ normal(0,1) ;
  sigma_mu ~ normal(0, 1);
  alpha ~ normal(log(7), 1);
  zeta ~ normal(0, 1);
  
  // priors on the AR stuff (we've added these in for you already)
  rho_raw ~ beta(10, 5);
  mo_raw ~ normal(0,1);
  sigma_mo ~ normal(0,1);
}
generated quantities {
  array[N] int y_rep = neg_binomial_2_log_rng(eta, phi);
}
