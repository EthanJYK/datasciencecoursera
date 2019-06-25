#----------------------------------PART 1--------------------------------------#
#------------------------------------------------------------------------------#
# Set basic properties

set.seed(9) # set seed number for reproducibility
lambda <- 0.2 # set lambda 0.2
n <- 40
mean.theory <- 1 / lambda # calculate mean of exponential distribution
sd.theory <- 1 / lambda # calculate std.dev of exponential distribution
se.theory <- sd.theory / sqrt(n) # theoretical std.dev. of 
                                           # 40 sample means with C.L.T.
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Simulation
samples <- vector() 
for (i in 1:1000){
        samples <- c(samples, rexp(n, lambda))
        } # get 40 * 1000 exponentials  
sample.matrix <- matrix(samples, n, 1000) # transform into matrix(40, 1000)
mean.1000 <- apply(sample.matrix, 2, mean) # 1000 sample means
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# create tables for comparison
## sample-theory comparison
tab1 <- as.table(rbind(c(mean.theory, sd.theory), 
                       c(mean(samples), sd(samples))))
dimnames(tab1) <- list(c("Theory", "Samples"), c("Mean", "Std.Dev"))
tab1 # knitr::kable(tab1)

## sampling(sample means)-theory comparison
tab2 <- as.table(rbind(c(mean.theory, se.theory), 
                       c(mean(mean.1000), sd(mean.1000))))
dimnames(tab2) <- list(c("Theory", "Samplings"), c("Mean", "Std.Dev"))
tab2 # knitr::kable(tab2)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#

# {r, fig.height = 5, fig.width = 10}
# Create density plots
par(mfrow = c(1,2)) 

## plot 40 * 1000 samples
hist(samples, breaks = 50, col = "grey60", xlab = "Exponentials",
     main = "40 x 1000 Exponentials", prob = TRUE)
abline(v = mean(samples), lwd=2, lty=2)
text(5, 0.18, pos=4, labels=paste("Mean:", round(mean(samples),3)))
text(5, 0.17, pos=4, labels=paste("Std.Dev:", round(sd(samples),3)))
text(5, 0.15, pos=4, labels=paste("Theoretical Mean:", mean.theory))
text(5, 0.14, pos=4, labels=paste("Theoretical Std.Dev:", sd.theory))

## plot 1000 sample means
hist(mean.1000, breaks = 50, col = rgb(1,0,0,0.5), 
     xlab = "Sample Means of 40 Exponentials",
     main = "1000 Sample Means", prob = TRUE)
abline(v = mean(mean.1000), lwd=2, lty=2)
lines(density(mean.1000), col="red", lwd=3)
text(5, 0.6, pos=4, labels=paste("Mean:", round(mean(mean.1000),3)))
text(5, 0.57, pos=4, labels=paste("Std.Dev:", round(sd(mean.1000),3)))

### add a theoretical normal distribution line
x <- seq(min(mean.1000), max(mean.1000), length = 1000)
density <- dnorm(x, mean = mean.theory, sd = se.theory)
lines(x, density, lwd=3, col = "grey40") 
text(6.5, 0.18, pos=4, labels="* Normality Curve")
text(6.5, 0.15, pos=4, labels=" (Theoretical)")
text(6.5, 0.12, pos=4, labels=paste("  Mean:", mean.theory))
text(6.5, 0.09, pos=4, labels=paste("  Std.Dev:", round(se.theory,3)))
par(mfrow = c(1,1)) 
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# Normality Tests

# {r, fig.height = 5, fig.width = 5}
## QQplot
qqnorm(mean.1000, main="Normal Q-Q Plot of 1000 Sample Means")
qqline(mean.1000, lwd=3, col="khaki3")

## Shapiro-Wilk Normality Test
shapiro.test(mean.1000) # fails because of the flaws of the test mechanism
#------------------------------------------------------------------------------#


#----------------------------------PART 2--------------------------------------#
#------------------------------------------------------------------------------#
data("ToothGrowth") # load data

# overview of data
str(ToothGrowth)
summary(ToothGrowth)

# boxplot for overview
par(mfrow=c(1,2))
boxplot(len~dose, ToothGrowth[1:30,], main = "Vitamin C", ylim = c(0, 35),
        col="grey80")

boxplot(len~dose, ToothGrowth[31:60,], main = "Orange Juice", ylim=c(0, 35),
        col="grey40")
par(mfrow=c(1,1))

# Calculate mean and C.I. for each dose and supplement
tiny <- data.frame(ToothGrowth$len[1:10], ToothGrowth$len[11:20], 
                   ToothGrowth$len[21:30], ToothGrowth$len[31:40], 
                   ToothGrowth$len[41:50], ToothGrowth$len[51:60])

colnames(tiny) <- c("VC 0.5", "VC 1.0", "VC 2.0", "OJ 0.5", "OJ 1.0", "OJ 2.0")
means <- apply(tiny, 2, mean) # calculate means
sds <- apply(tiny, 2, sd) # calculate standard deviations

# calculate confidence intervals
ci.upper <- means + qt(.975, 9, lower.tail = TRUE) * sds/sqrt(10)
ci.lower <- means + qt(.025, 9, lower.tail = TRUE) * sds/sqrt(10)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# tabulate data
tab3 <- as.table(cbind(c(means[1],means[2],means[3],means[4],means[5],means[6]), 
                       c(sds[1], sds[2], sds[3], sds[4], sds[5], sds[6])))
dimnames(tab3) <- list("Types" = c("VC 0.5", "VC 1.0", "VC 2.0",
                                   "OJ 0.5", "OJ 1.0", "OJ 2.0"),
                       c("Mean", "Std.Dev"))
tab3 # knitr::kable(tab3)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# plot means
dotchart(means, pch=c(rep(19, 3), rep(17,3)), 
         xlim=c(0, 35), xlab = "length", 
         main = "Tooth Growth by Vitamin C Supplement Type / Dose")
abline(h=1:6, v=(c(0:7)*5), col="gray", lty=3)
# add confidence intervals
for(i in 1:6){lines(x=c(ci.lower[i], ci.upper[i]), y=c(i,i))}
lines(means[1:3], y=c(1:3), col="grey80", lwd=3)
lines(means[4:6], y=c(4:6), col="grey40", lwd=3)
points(means, y=c(1:6), pch=c(rep(19, 3), rep(17,3)), cex=1.2)
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# hypothesis test for each level of dose
## H0 : mean difference = 0
## H1 : mean difference != 0

# Test 1: 0.5 VC / OJ
mean.diff05 <- means[4] - means[1]
sd.diff05 <- sqrt(sds[1]^2/10 + sds[4]^2/10)
p.value05 <- pt(mean.diff05/sd.diff05, 18, lower.tail = FALSE) * 2 

# Test 2: 1.0 VC / OJ
mean.diff10 <- means[5] - means[2]
sd.diff10 <- sqrt(sds[2]^2/10 + sds[5]^2/10)
p.value10 <- pt(mean.diff10/sd.diff10, 18, lower.tail = FALSE) * 2

# Test 3: 2.0 VC / OJ
mean.diff20 <- means[6] - means[3]
sd.diff20 <- sqrt(sds[3]^2/10 + sds[6]^2/10)
p.value20 <- pt(mean.diff20/sd.diff20, 18, lower.tail = TRUE) * 2
#------------------------------------------------------------------------------#


#------------------------------------------------------------------------------#
# tabulate
row1 <- c(means[4], means[1], mean.diff05, mean.diff05/sd.diff05, 18, p.value05)
row2 <- c(means[5], means[2], mean.diff10, mean.diff10/sd.diff10, 18, p.value10)
row3 <- c(means[6], means[3], mean.diff20, mean.diff20/sd.diff20, 18, p.value20)
tab4 <- as.table(rbind(row1, row2, row3))
dimnames(tab4) <- list("dose"= c("0.5mg/day", "1.0mg/day", "2.0mg/day"), 
                       c("OJ mean", "VC mean", "difference", "t-stat",
                         "df", "p-value"))
tab4 <- round(tab4, 3)
tab4 # knitr::kable(tab4)
#------------------------------------------------------------------------------#