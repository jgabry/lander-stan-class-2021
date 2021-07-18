// y ~ N(alpha + beta * x, sigma_y)
// x ~ N(mu_x, sigma_x)
functions {
  matrix vec_to_mat(vector a, vector b) {
    matrix[rows(a) + rows(b), 1] x;
    x[,1] = append_row(a, b);
    return x;
  }
}
data {
  int<lower=0> N_obs;
  vector[N_obs] x_obs;
  vector[N_obs] y_obs;
  
  int<lower=0> N_miss;
  vector[N_miss] y_miss;
}
transformed data {
  int N = N_obs + N_miss;
}
parameters {
  real mu_x;
  real<lower=0> sigma_x;
  vector[1] beta;
  real mu_y;
  real<lower=0> sigma_y;
  vector[N_miss] x_miss;
}
model {
  vector[N] y = append_row(y_obs, y_miss);
  matrix[N, 1] x = vec_to_mat(x_obs, x_miss);
  mu_x ~ normal(0, 2);
  mu_y ~ normal(0, 2);
  beta ~ normal(0, 2);
  sigma_x ~ normal(0, 2);
  sigma_y ~ normal(0, 2);
  x[,1] ~ normal(mu_x, sigma_x);
  // y ~ Normal(mu_y + beta * x, sigma_y);
  y ~ normal_id_glm(x, mu_y, beta, sigma_y); 
}

