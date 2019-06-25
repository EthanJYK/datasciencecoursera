# Q1
base <- c(140, 138, 150, 148, 135)
week2 <- c(132, 135, 151, 146, 130)
n <- length(base)
diff <- base - week2

# Hypothesis
# H0: population_mean(diff) = 0
# H1: population_mean(diff) != 0  
# equal or not equal problem: two tailed test
# p-value: Pr(observed_mean(diff)| H0 = true)

mean_obs <- mean(diff)
sd_obs <- sd(diff)

# test statistics and 95% confidence interval
mu <- mean_obs + c(-1, 1) * qt(0.025, n-1, lower.tail = TRUE) * sd_obs/sqrt(n)

# "the 95% c.i. given mu = 0"...
h0_ci <- c(-1, 1) * qt(0.025, n-1, lower.tail = TRUE) * sd_obs/sqrt(n)

# since the distribution of mu is standardized one, we need to calculate 
# the standardized value of observed mean 
# e.g.: to make the distribution centered at 0, we need to subtract X_bar
#       from the original distribution of expected mu, calculated from X_bar
#       and divide all by standard deviation of sample means.
#       then, X_bar becomes 0, and 0 becomes -X_bar, so we can calculate 
#       the new position of X_bar in the 0 centered distribution by dividing 
#       (0 - X_bar) by standard deviation of sample means.

test_stat <- -mean_obs/(sd_obs/sqrt(n)) # where observed mean lies in the 
                                        # H0 distribution
pt(test_stat, n-1) # pt <- cumulative density of one side
                   #       = the probability that we can observe more extreme
                   #         values than our observed data
                   #       -> we need to check not where observation lies, 
                   #          but how far the values like our observation are
                   #          from 0

# two tailed test
p_value <- pt(test_stat, n-1) * 2
#------------------------------------------------------------------------------#


# Q2
n=9
mean_obs <- 1100
sd_obs <- 30

ci <- mean_obs + c(-1, 1) * qt(0.025, n-1) * sd_obs/sqrt(n)
#------------------------------------------------------------------------------#


# Q3
# binomial distribution
# Basically...
# coke = 1
# pepsi = 0
# null probability of preferring coke = 1/2
# H0: Pr(coke) = 1/2
# H1: Pr(coke) > 1/2
# observed probability of preferring coke = 3/4
# n = 4

pr_obs <- 3/4
pr_null <- 1/2
n <- 4

# Given H0 is true...
# probability of getting values more than 2 out of 4 trials
# equals probability of getting 3 + probability of getting 4

choose(4, 3) * pr_null^3 * (1 - pr_null)^(4-3) +
        choose(4, 4) * pr_null^4 * (1- pr_null)^(4-4)

# or if you use pbinom, the probability equals 1 - cumulative probability upto 2

1 - pbinom(2, 4, pr_null)
#------------------------------------------------------------------------------#

# Q4
# poisson distribution
# benchmark = H0 -> pr_h0 = 1/100
# observation -> pr_obs = 10/1787
# n = number of trials = 1787
# x = numbers of results = 10
# Given H0 is true...
p <- 1/100
n <- 1787
lambda <- n*p


# what we need to know is the probability of getting 10 or less results
# out of 1787 event units when probability is 1/100
ppois(10, lambda)

# e.g.: pdf of poisson distribution
#       Pr(X=x; lambda) = (lambda^x * exp(-lambda))  / factorial(x)
#       cdf of poisson distribution = summation of probabilities
#       probabilities <- vector()
#       for(i in 0:x){
#                     pr <- (lambda^i * exp(-lambda)) / factorial(i)
#                     probabilities <- c(probabilities, pr)
#                    }
#       sum(probabilities)
probabilities <- vector()
for (i in 0:10){
        pr  <- (lambda^i * exp(-lambda)) / factorial(i)
        probabilities <- c(probabilities, pr)
}
sum(probabilities)

## binomial approximation
# it's possible because p is small (pr_h0 = 1/100) and n is large (n = 1787)
# cumulative probability of getting results of 10 or less out of 1787 trials 
# if H0 is true : p = pr_h0 = 1/100
pbinom(10, 1787, 1/100)

#------------------------------------------------------------------------------#


# Q5
n_ctrl <- 9 # number of obs in control group
n_trtd <- 9 # number of obs in treated group
mean_ctrl <- 1 # mean difference in control group
mean_trtd <- -3 # mean difference in treated group
sd_ctrl <- 1.8 # sd of difference in control group
sd_trtd <- 1.5 # sd of difference in treated group

# H0: difference between the mean of two groups = 0
# H1: difference between the mean of two groups != 0

mean_diff <- mean_trtd - mean_ctrl
sd_diff_p <- sqrt(((n_ctrl-1)*sd_ctrl^2 + (n_trtd-1)*sd_trtd^2)/(n_ctrl+n_trtd-2)) * sqrt(1/n_ctrl+1/n_trtd) # pooled
sd_diff <- sqrt(sd_ctrl^2/n_ctrl + sd_trtd^2/n_trtd) # not pooled

# test statistics
test_stat <- (mean_diff - 0)/sd_diff_p

p_value <- pt(test_stat, df = (n_ctrl + n_trtd - 2)) * 2
#------------------------------------------------------------------------------#


# Q6
n = 9
mean <- (1077 + 1123) / 2
sd <- sqrt(n) * (1123 - mean) / qt(0.05, n - 1, lower.tail = FALSE)

# H0: mu = 1078
# H1: mu != 1078

# hypothesis test given H0 is true
mean_h0 <- 1078

test.stat <- (mean - 1078) / (sd/sqrt(n))
p_value <- pt(test.stat, n-1, lower.tail = FALSE) * 2
#------------------------------------------------------------------------------#


# Q7
# power: 1 - beta(type 2 error rate) 
#        = probability of accepting H1 given H1 is true
# alpha: probability of rejecting H0 given H0 is true
# beta: probability of not rejecting H0 given H1 is true
# critical value: a possible value of E(X) where H1 is rejected given H0 is true
# Logic of beta: on the spectrum between mu_H0 and mu_H1 ... 
#                (1) if E(X) is closer to mu_H0 than critical value,
#                    Normally [we reject H1], and [take H0 to be true].
#                    But, what if H1 is true in reality?
#                    Then, it is that we are making a false inference of
#                    rejecting H1(accepting H0) when H1 is true -> type 2 error.
#                (2) So, beta = type 2 error rate is
#                    probability of E(X) to be closer to mu_H0 than critical 
#                    value given H1 is true.
# Logic of alpha: (1) if E(X) is farther from mu_H0 than critical value,
#                     Normally [we reject H0], and [take H1 to be true].
#                     But, what if H0 is true in reality?
#                     Then, it is taht we are making a false inference of
#                     rejecting H0 when H0 is true -> type 1 error.
#                 (2) So, alpha = type 1 error rate is
#                     probability of E(X) to be farther from mu_H0 than
#                     critical value given H0 is true.

mean_obs <- .01
sd_obs <- .04
n = 100
mean_h0 <- 0
#given H0 is true...
crit <- qnorm(.95, mean_h0, sd_obs/sqrt(n), lower.tail = TRUE)

#given H1 is true...
beta <- pnorm(crit, mean_obs, sd_obs/sqrt(n), lower.tail = TRUE)
power = 1 - beta
#------------------------------------------------------------------------------#


# Q8
# alpha = .05
# beta = .1
# n = ?
mean_obs <- .01
sd_obs <- .04
mean_h0 <- 0

# crit <- mean_h0 + qnorm(.95, lower.tail = TRUE) * sd_obs/sqrt(n) ... 
# (crit - mean_h0) / (sd_obs/sqrt(n)) = qnorm(.95, lower.tail = TRUE)
# crit / (sd_obs/sqrt(n)) = 1.644854
# crit * sqrt(n) = 1.644854 * sd_obs ................................Formula #1

# beta = 0.1 = pnorm(crit, mean_obs, sd_obs/sqrt(n))
# crit = qnorm(0.1, mean_obs, sd_obs/sqrt(n))
# qnorm(0.1) = (crit - mean_obs) / (sd_obs/sqrt(n))
# (crit - mean_obs) * sqrt(n) = -1.281552 * sd_obs ..................Formula #2

# crit * sqrt(n) = 0.06579415 
# (crit - 0.01) * sqrt(n) = -0.05126206
# 1.283486 * (crit - 0.01) + crit = 0
# 2.283486 * crit = 1.283486 * 0.01
# crit = (1.283486 * 0.01) / 2.283486
crit <- (1.283486 * 0.01) / 2.283486
# sqrt(n) = 0.06579415 / crit
n <- (0.06579415/crit)^2

# a simple way
power.t.test(power = .9, delta = mean_obs, sd = sd_obs, sig.level = 0.05, 
             type = "one.sample", alt = "one.sided")
