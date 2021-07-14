// poisson multiple regression
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
}
transformed parameters {
  // create variable eta for the linear predictor
  vector[N] eta = alpha + beta * traps + beta_super * live_in_super + log_sq_foot;
}
model {
  complaints ~ poisson_log(eta);
  
  // priors
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
  beta_super ~ normal(-0.5, 1);
}
generated quantities {
  array[N] int y_rep poisson_log_rng(eta);
}
