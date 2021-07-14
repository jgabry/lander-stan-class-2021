// poisson simple regression
// need to add the missing lines of code
data {
  int<lower=1> N;
  vector<lower=0>[N] traps;  // vector implies real numbers
  array[N] int<lower=0> complaints; 
  
 /*
  A few examples of array syntax: 
  
  array[30] vector[2] v;  // array 'v' of 30 vectors, each of size 2 (v[j] is a 2-vector)
  array[100] matrix[2,2] m; // array 'm' of 100 matrices, each 2x2 (m[j] is a 2x2 matrix)
  
  in the old syntax: 
  vector[2] v[30];    
  matrix[2,2] m[100]; 
  */  
}
parameters {
  real alpha;
  real beta;
}
model {
  // poisson_log(x) is more efficient and stable alternative to poisson(exp(x))
  complaints ~ poisson_log(alpha + beta * traps);

  // also possible to loop over observations but the vectorized version above
  // is faster:
  // for (n in 1:N) complaints[n] ~ poisson_log(alpha + beta * traps[n]);

  // weakly informative priors:
  // we expect negative slope on traps and a positive intercept,
  // but we will allow ourselves to be wrong
  // in R: dnorm(alpha, mean = log(7), sd = 1, log=TRUE)
  // in R: dnorm(beta, mean = -0.25, sd = 0.5, log=TRUE)
  alpha ~ normal(log(7), 1);
  beta ~ normal(-0.25, 0.5);
}
generated quantities {
  // calculate predictions/replications y_rep
  // can vectorize it or do it in a loop
  array[N] int y_rep = poisson_log_rng(alpha + beta * traps);
}
  
