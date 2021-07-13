// poisson simple regression
// need to add the missing lines of code
data {

}
parameters {

}
model {
  // poisson_log(x) is more efficient and stable alternative to poisson(exp(x))
  

  // also possible to loop over observations but the vectorized version above
  // is faster:
  // for (n in 1:N) complaints[n] ~ poisson_log(alpha + beta * traps[n]);

  // weakly informative priors:
  // we expect negative slope on traps and a positive intercept,
  // but we will allow ourselves to be wrong
  // in R: dnorm(alpha, mean = log(7), sd = 1, log=TRUE)
  // in R: dnorm(beta, mean = -0.25, sd = 0.5, log=TRUE)
}
generated quantities {
  // calculate predictions/replications y_rep
  // can vectorize it or do it in a loop
  
}
