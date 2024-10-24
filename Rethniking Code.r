#===========================================================
# 			  Statistical Rethinking - 2nd Ed.
#===========================================================

thematic::thematic_off()

library(rethinking)

# Kapitel 1 ================================================
# kein Code

# Kapitel 2 ================================================

## Grid Approximation - Example: Globe Tossing -------------

evidence <- 6 # six water observations
sample_size <- 9 # out of nine tosses of the globe 

### Define Grid
grid_size <- 100

p_grid <- seq(0, 1, length.out = grid_size)

### Define Prior
prior <- rep(1, grid_size)
prior <- ifelse(p_grid < 0.5, 0, 1)
prior <- exp( -5*abs( p_grid - 0.5 ) )

### Compute Likelihood at each value of grid
likelihood <- dbinom(evidence, size = sample_size, prob = p_grid)

### Compute product of likelihood and prior
posterior_unst <- prior * likelihood

### Standardize Posterior Distribution 
posterior <- posterior_unst / sum(posterior_unst)

plot(p_grid, posterior)


## Quadratic Approximation ---------------------------------

globe_quap <- quap(
	alist(
		W ~ dbinom(W+L, p) , 
		p ~ dunif(0,1)
		) , 
	data = list(W = 6, L = 3)
	)	

precis(globe_quap) # summary of quadratic approximation


## Analytical Calculation ----------------------------------
# Weil das Modell so simpel ist, kann das Ergebnis analytisch 
# berechnet werden, dies ist bei komplexeren Modellen nicht
# mehr möglich

W <- 6
L <- 3 
curve(dbeta(x, W+1, L+1), from = 0, to = 1)
curve(dnorm(x, 0.67, 0.16), lty = 2, add = TRUE)


# Kapitel 3 ================================================

## Grid Approximation (Globe Tossing)
W <- 6
L <- 3
grid_size <- 1000
p_grid <- seq(0, 1, length.out = grid_size)
prior <- rep(1, grid_size)
likelihood <- dbinom(W, W+L, p_grid)
posterior_unst <- likelihood * prior
posterior <- posterior_unst / sum(posterior_unst)
posterior

### Samples from the Posterior
posterior_samples <- sample(p_grid, prob = posterior, size = 1e4, replace = TRUE)

#### Verteilung der Stichproben
rethinking::dens(posterior_samples)

#### Intervalle definierter Grenzen
sum(posterior_samples < 0.5) / 1e4 # ~0.1703 -> ca. 17% prob, dass weniger als 50% Wasser auf Globus
sum(posterior_samples > 0.5 & posterior_samples < 0.75) / 1e4

#### Intervalle definierter Wahrscheinlichkeitsmassen
quantile(posterior_samples, 0.80) # untere 80% posteriore Wahrscheinlichkeit bis zu einem Wert von 0.762
quantile(posterior_samples, c(0.1, 0.9)) # Perzentil Intervalle (PI): mittlere 80% posteriore Wahrscheinlichkeit
rethinking::PI(posterior_samples, 0.5) # Funktion gibt die Grenzen für ZENTRALE 50% prob aus 
rethinking::HPDI(posterior_samples, 0.5) # Schmalst mögliches Intervall für 50%

#### Punktschätzungen 
rethinking::chainmode(posterior_samples, adj = 0.01) # MAP - maximum a-posteriori estimate
mean(posterior_samples)
median(posterior_samples)

## Loss Functions (use the posterior itself, not the samples)
### Absolute loss -> nominates Median as point estimate
loss <- purrr::map_dbl(p_grid, ~sum(posterior*abs(. - p_grid)))
p_grid[which.min(loss)]
### Quadratic loss -> nominates Mean as point estimate 
loss <- purrr::map_dbl(p_grid, ~sum(posterior*(abs(. - p_grid)^2)))
p_grid[which.min(loss)]


### Simulation - Beispiele
dbinom(0:2, 2, prob = 0.7) # prob für 0, 1 oder 2 "W" Beobachtungen bei zwei Wüfen des Globus
rbinom(10, size = 2, prob = 0.7) # 10 Stichproben für "zwei Würfe des Globus"
table(rbinom(1e4, size = 2, prob = 0.7))/1e4 # stimmt überein mit analytisch errechneten prob
rbinom(1e5, size = 9, prob = 0.7) |> rethinking::simplehist()

## Simulation - Posterior Predictive Disitribution
rbinom(1e4, 9, prob = posterior_samples) |> rethinking::simplehist()
# 10.000 Simulationen für jeweils 9 Globuswürfe mit versch. Werten für p
# da die Samples der Posterior für p verwendet werden, ist die Gewichtung gegeben 


# Kapitel 4 ================================================

library(rethinking)

## Height Data - Howell1
data(Howell1)
d <- Howell1
precis(d)
d2 <- d[ d$age >= 18, ]

## Prior Predictive Simulation 
sample_mu <- rnorm(1e4, 178, 20)
sample_sigma <- runif(1e4, 0, 50)
prior_h <- rnorm(1e4, sample_mu, sample_sigma)
dens(prior_h)


## Grid approximation --------------------------------------
## (as an example) for the height data -> explanation in endnote

mu.list <- seq( from=150, to=160 , length.out=100 )
sigma.list <- seq( from=7 , to=9 , length.out=100 )
post <- expand.grid( mu=mu.list , sigma=sigma.list ) # combination of all values
post$LL <- sapply( 1:nrow(post) , function(i) sum(dnorm( d2$height , post$mu[i] , post$sigma[i] , log=TRUE ) ) )
post$prod <- post$LL + dnorm( post$mu , 178 , 20 , TRUE ) + dunif( post$sigma , 0 , 50 , TRUE )
post$prob <- exp( post$prod - max(post$prod) )

## Visualize Posterior
contour_xyz( post$mu , post$sigma , post$prob )
image_xyz( post$mu , post$sigma , post$prob )

## Samples from the posterior
sample.rows <- sample( 1:nrow(post) , size=1e4 , replace=TRUE , prob=post$prob )
sample.mu <- post$mu[ sample.rows ]
sample.sigma <- post$sigma[ sample.rows ]
## Summary of samples
plot( sample.mu , sample.sigma , cex=0.5 , pch=16 , col=col.alpha(rangi2,0.1))
	# Again the sampled distribution is much broader
PI(sample.mu)
PI(sample.sigma)


## Quadratic Approximation ---------------------------------

d2
flist <- alist(
	height ~ dnorm(mu, sigma)
	, mu ~ dnorm(178, 20)
	, sigma ~ dunif(0, 50)
	)

m4.1 <- quap(flist, data = d2)

precis(m4.1)

## Posterior Verteilung 

### Variance-Covariance Matrix of the Posterior
	# helps to unterstand the relationships of parameters 
vcov(m4.1)
diag(vcov(m4.1)) # nur die Varianzen der Parameter -> sqrt()
cov2cor(vcov(m4.1)) # Korrelationsmatrix der Parameter 

### Sampling from the posterior 
post_samples <- extract.samples(m4.1, n = 1e4)
precis(post_samples)
plot(post_samples)


## Linear Model Prior Predictive Simulation / Visualization 

N <- 100
a <- rnorm(N, 178, 20)
b <- rnorm(N, 0, 10)
xbar <- mean(d2$weight)

plot(NULL, )