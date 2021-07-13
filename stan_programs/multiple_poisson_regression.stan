// poisson multiple regression
// need to add the missing lines of code (see comments below)
data {
  int<lower=1> N;
  array[N] int<lower=0> complaints;
  vector<lower=0>[N] traps;
  
  // declare two new vectors 'live_in_super' and 'log_sq_foot'
}
parameters {
  real alpha;
  real beta;
  // declare coefficient on live_in_super (beta_super)
}
transformed parameters {
  // create variable eta for the linear predictor

}
model {
  complaints ~ poisson_log(eta);
  
  // priors
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
  // give beta_super a normal distribution with mean = -0.5 and sd = 1
}
generated quantities {
  array[N] int y_rep poisson_log_rng(eta);
}
