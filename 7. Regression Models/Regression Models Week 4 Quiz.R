#------------------------------------------------------------------------------#
# Q1
# setting
library(MASS)
data(shuttle)
str(shuttle)
shuttle$auto <- as.numeric(shuttle$use == "auto") #set "auto" == 1

# odds ratio calculation
head <- shuttle$auto[shuttle$wind=="head"]
tail <- shuttle$auto[shuttle$wind=="tail"]
odd.head <- (length(head[head==1])/length(head))/(length(head[head==0])/length(head))
odd.tail <- (length(tail[tail==1])/length(tail))/(length(tail[tail==0])/length(tail))
odds <- odd.head/odd.tail
log.odds <- log(odds)

# calculation from coefficients 

# NOTE:
# see and compare how values change by setting values of factors
# the odds ratio above is calculated assuming head = 1, tail = 0
# because head is regarded to be 'A', when tail is regarded to be 'A^c'

# case 1.1: head = 1, tail = 0
shuttle$head <- as.numeric(shuttle$wind == "head") # set head = 1, tail = 0
fit.c1.1 <- glm(auto~head, family=binomial(link=logit), data=shuttle)
summary(fit.c1.1)$coef

# case 1.2: head = 1, tail = 0, without intercept
fit.c1.2 <- glm(auto~head -1, family=binomial(link=logit), data=shuttle)
summary(fit.c1.2)$coef

# case 2.1: head = 0, tail = 1
shuttle$tail <- as.numeric(shuttle$wind == "tail") # set tail = 1, head = 0
fit.c2.1 <- glm(auto~tail, family=binomial(link=logit), data=shuttle)
summary(fit.c2.1)$coef

# case 2.2: head = 0, tail = 1, without intercept
fit.c2.2 <- glm(auto~tail -1, family=binomial(link=logit), data=shuttle)
summary(fit.c2.2)$coef

# case 0: leave factors as they are: head = 1, tail = 2
fit <- glm(auto~wind -1, family=binomial(link=logit), data=shuttle) #remove intercept
summary(fit)$coef
fit$coef[2] - fit$coef[1] # coef.tail - coef.head = 0.03181
                          # this means coef increases 0.03181 when the factor 
                          # level changes to 2 from 1
                          # and it's the same as the coefficient of case 2.1

fit$coef[1] - fit$coef[2] # coef.head - coef.tail = 0.03181
                          # this means coef decreases 0.03181 when the factor
                          # level changes to 1 from 2
                          # and it's the same as the coef of case 1.1

exp(fit$coef[1])/exp(fit$coef[2]) # cancel log calulation from the results of
                                  # log odds calculation 
                                  # = 0.9686888 = log.odds above

# what we can learn from these cases are ...
# 1. don't get confused by factor levels when you regress with factors 
#    as indepenent variables
# 2. when an intercept is, the coefficient of each factor is the difference 
#    of the factor coeficient from the intercept
# 3. the coefficient of a factor A means the result of log-odds of A 
#    log(Pr(A)/(1-Pr(A) # or Pr(A^c))) 
# 4. so if we want to know the odds ratio between factor A and B,
#    we need to get the true coefficient of each A and B (reg without intercept)
#    and cancel log calculation by using exp function,
#    then calculate the ratio by setting nominator/denominator  
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Q2
str(shuttle)
levels(shuttle$magn) # light=1, medium=2, out=3, strong=4
fit.q2 <- glm(auto~wind+magn-1, binomial(logit), shuttle) #head = 1, tail = 2
summary(fit.q2)$coef
exp(fit.q2$coef[1])/exp(fit.q2$coef[2])
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Q3
# since the values of a binary vector is 0 or 1,
# the values get reversed when we subtract the values from 1 (1 - vector)
# 1 - 0 = 1, 1 - 1 = 0
# therefore, the signs of possible regression coefficients also get reversed

fit.q3 <- glm(1 - auto~wind -1, binomial(logit), shuttle)
coef(fit.q3)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Q4
data("InsectSprays")
fit <- glm(count~spray-1, poisson(log), InsectSprays)
exp(coef(fit)[1])/exp(coef(fit)[2]) # or exp(coef(b)[1]-coef(b)[2])
                                    # since they are log values

#------------------------------------------------------------------------------#
# Q5
# What is an offset in regression?
# since a poisson regression result is log(lambda=probability * time counts) 
# not log(probability) itself, if you want to calculate probability not lambda,
# you need to calculate log(lambda/Pr) = B'_0 + B'_1X 
#            instead of log(lambda) = B_0 + B_1X.
# because the formula is log, log(lambda/Pr) = log(lambda) - log(Pr).
# then we can fix the formula as...
# log(lambda) = B_0 + B_1X
#             = log(Pr) + B'_0 + B'_1X
# here, log(Pr) is an offset.
# we need to use offset when we compare the counts 

# Answer
# when log(lambda) = B_0 + B_1X, t2 = 10 * t1,
#      log(lambda) - log(t1) = B'_0 + B'_1X
#      log(lambda) - log(t2) = log(lambda) - log(t1 * 10) = 
#      log(lambda) - log(t1) - log(10) = B"_0 + B"_1X
#      log(lambda) - log(t1) - log(10) + B"_0 + B"_1X = B'_0 + B'_1 X
# since log(10) has no correlation with X... (log10 is a constant!)
# the coefficient of X doesn't change -> B'_1 = B"_1
# and log(t1) is also a constant, since t1 is a constant,
# therefore, B'_1 = B_1
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Q6
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)

knot <- 0
splineTerms <- sapply(knot, function(knot)(x>knot)*(x-knot))
xmat <- cbind(1, x, splineTerms)
yhat <- predict(lm(y~xmat - 1))
plot(x, y, frame = FALSE, pch = 21, bg = "lightblue", cex = 2)
lines(x, yhat, col="red", lwd = 2)
a <- lm(y~xmat - 1)
summary(a)
coef(a)[2] + coef(a)[3]

# or
z <- (x > 0) * x
fit <- lm(y ~ x + z)
sum(coef(fit)[2:3])
#------------------------------------------------------------------------------#