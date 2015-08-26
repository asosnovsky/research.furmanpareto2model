dpareto <- function(x, xm, alpha) ifelse(x > xm , alpha*xm**alpha/(x**(alpha+1)), 0)
ppareto <- function(q, xm, alpha) ifelse(q > xm , 1 - (xm/q)**alpha, 0 )
qpareto <- function(p, xm, alpha) ifelse(p < 0 | p > 1, NaN, xm*(1-p)**(-1/alpha))
rpareto <- function(n, xm, alpha) qpareto(runif(n), xm, alpha)

pareto.mle <- function(x)
{
  xm <- min(x)
  alpha <- length(x)/(sum(log(x))-length(x)*log(xm))
  return( list(xm = xm, alpha = alpha))
}

pareto.test <- function(x, B = 1e3)
{
  a <- pareto.mle(x)
  
  # KS statistic
  D <- ks.test(x, function(q) ppareto(q, a$xm, a$alpha))$statistic
  
  # estimating p value with parametric bootstrap
  B <- 1e5
  n <- length(x)
  emp.D <- numeric(B)
  for(b in 1:B)
  {
    xx <- rpareto(n, a$xm, a$alpha);
    aa <- pareto.mle(xx)
    emp.D[b] <- ks.test(xx, function(q) ppareto(q, aa$xm, aa$alpha))$statistic
  }
  
  return(list(xm = a$xm, alpha = a$alpha, D = D, p = sum(emp.D > D)/B))
}


barplot(log(data.flip$Alabama[4:5,]))
pareto.test(t(log(data.all$Alabama[,5])))
