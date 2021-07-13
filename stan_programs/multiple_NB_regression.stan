// negative binomial multiple regression
// need to add the missing lines of code (see comments below)
data {
  int<lower=1> N;
  array[N] int<lower=0> complaints;
  vector<lower=0>[N] traps;
  vector<lower=0,upper=1>[N] live_in_super;
  vector[N] log_sq_foot;
}
parameters {
  real alpha;
  real beta;
  real beta_super;
  // declare inv_phi, which is constrained to be positive 
  // (easier to think about prior for 1/phi instead of phi)
}
transformed parameters {
  vector[N] eta = alpha + beta * traps + beta_super * live_in_super + log_sq_foot;
  // calculate phi from inv_phi 
}
model {
  // use neg_binomial_2_log instead of poisson_log as distribution for complaints
  
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
  beta_super ~ normal(-0.5, 1);
  // give inv_phi a normal(0,1) prior 
}
generated quantities {
  array[N] int y_rep = neg_binomial_2_log_rng(eta, phi);
}
