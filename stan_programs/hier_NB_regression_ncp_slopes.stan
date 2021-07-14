// Negative binomial regression with varying intercepts and varying slopes
// Non-centered parameterization (NCP)
data {
  int<lower=1> N;                     
  array[N] int<lower=0> complaints;  
  vector<lower=0>[N] traps;          
  
  // 'exposure'
  vector[N] log_sq_foot;  
  
  // building-level data
  int<lower=1> J; // Number of buildings
  int<lower=1> K; // Number of building-level predictor variables
  array[N] int<lower=1, upper=J> building_idx;
  matrix[J,K] building_data;
}
parameters {
  real<lower=0> inv_phi;     // 1/phi (easier to think about prior for 1/phi instead of phi)
  
  // for varying intercepts
  vector[J] mu_raw;        // N(0,1) params for non-centered param of building-specific intercepts
  real<lower=0> sigma_mu;  // sd of buildings-specific intercepts
  real alpha;              // 'global' intercept
  vector[K] zeta;          // coefficients on building-level predictors in model for mu
  
  // for varying slopes
  vector[J] kappa_raw;       // N(0,1) params for non-centered param of building-specific slopes
  real<lower=0> sigma_kappa; // sd of buildings-specific slopes
  real beta;                 // 'global' slope on traps variable
  vector[K] gamma;           // coefficients on building-level predictors in model for kappa
}
transformed parameters {
  real phi = inv(inv_phi);
  vector[J] mu = (alpha + building_data * zeta) + sigma_mu * mu_raw;
  
  // To add: non-centered parameterization of building-specific slopes (kappa)
  vector[J] kappa = ??
  
  // To add: update eta now to include kappa too
  // hint: you may need elementwise multiplication operator '.*' instead of vector multiplication
  //       to multiple kappa by traps
  vector[N] eta = ?? 
}
model {
  complaints ~ neg_binomial_2_log(eta, phi);
  inv_phi ~ normal(0, 1);
  
  kappa_raw ~ normal(0,1);
  sigma_kappa ~ normal(0, 1);
  beta ~ normal(-0.25, 0.5);
  gamma ~ normal(0, 1);
  
  mu_raw ~ normal(0,1) ;
  sigma_mu ~ normal(0, 1);
  alpha ~ normal(log(7), 1);
  zeta ~ normal(0, 1);
} 
generated quantities {
  array[N] int y_rep = neg_binomial_2_log_rng(eta, phi);
}
