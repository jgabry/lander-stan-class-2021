# lander-stan-class-2021

### Install needed software

```r
# install R packages
install.packages(c("dplyr", "lubridate", "ggplot2", "bayesplot", "fs", "stringr", "remotes"))
remotes::install_github("stan-dev/posterior")
remotes::install_github("stan-dev/cmdstanr")

# install cmdstan
# please post on discourse.mc-stan.org if you run into errors
cmdstanr::install_cmdstan(cores = 2)

# check if cmdstan installation works properly
# please post on discourse.mc-stan.org if you run into errors
cmdstanr::cmdstanr_example()

# optionally install rstan 
# we won't _need_ this but it has some extra features we can use if you have it installed
# if it fails to install don't worry about it
install.packages("rstan")
```

### Interactive MCMC demo

We'll use this on day 2 or 3: 

https://chi-feng.github.io/mcmc-demo/app.html


### Tentative Agenda

Day 1 Morning

- Intro Bayesian workflow and Stan
- Intro to the running example we'll use throughout the class

Day 1 Afternoon

- Write first Stan program 

Day 2 Morning 

- Expand our Stan program and check for improved model fit

Day 2 Afternoon

- Hierarchical models with varying intercepts
- non-centered parameterization
- How does Stan's MCMC algorithm work?

Day 3 Morning 

- Finish Day 2 content
- Varying slopes model

Day 3 Afternoon

- Time varying parameters
- Forecasting



