#' Simulated data to use in testing and vignettes in the coloc package
#'
#' @docType data
#'
#' @usage data(coloc_test_data)
#'
#' @format A four of two coloc-style datasets. Elements D1 and D2 have a single
#'   shared causal variant, and 50 SNPs. Elements D3 and D4 have 100 SNPs, one
#'   shared causal variant, and one variant unique to D3. Use these as examples
#'   of what a coloc-style dataset for a quantitative trait should look like.
#'
#' @keywords datasets
#' @examples
#' data(coloc_test_data)
#' names(coloc_test_data)
#' str(coloc_test_data$D1)
#' check.dataset(coloc_test_data$D1) # should return NULL if data structure is ok
"coloc_test_data"


## library(mvtnorm)
## simx <- function(nsnps,nsamples,S,maf=0.1) {
##     mu <- rep(0,nsnps)
##     rawvars <- rmvnorm(n=nsamples, mean=mu, sigma=S)
##     pvars <- pnorm(rawvars)
##     x <- qbinom(1-pvars, 2, maf)
## }


## sim.data <- function(nsnps=50,nsamples=200,causals=floor(nsnps/2),nsim=1) {
##   cat("Generate",nsim,"small sets of data\n")
##   ntotal <- nsnps * nsamples * nsim
##   S <- (1 - (abs(outer(1:nsnps,1:nsnps,`-`))/nsnps))^4
##   X1 <- simx(nsnps,ntotal,S)
##   X2 <- simx(nsnps,ntotal,S)
##   Y1 <- rnorm(ntotal,rowSums(X1[,causals,drop=FALSE]/2),1.5)
##   Y2 <- rnorm(ntotal,rowSums(X2[,causals,drop=FALSE]/2),1.5)
##   colnames(X1) <- colnames(X2) <- paste("s",1:nsnps,sep="")
##   df1 <- cbind(Y=Y1,X1)
##   df2 <- cbind(Y=Y2,X2)
##   if(nsim==1) {
##     return(list(#new("simdata",
##       df1=as.data.frame(df1),
##       df2=as.data.frame(df2)))
##   } else {
##     index <- split(1:(nsamples * nsim), rep(1:nsim, nsamples))
##     objects <- lapply(index, function(i) list(#new("simdata",
##                                            df1=as.data.frame(df1[i,]),
##                                            df2=as.data.frame(df2[i,])))
##     return(objects)
##   }
## }

## set.seed(46411)
## data=sim.data()
## Y1 <- data$df1$Y
## Y2 <- data$df2$Y
## Y3 <- sample(data$df2$Y) # Y3 is unassociated with anything in X2

## X1 <- as.matrix(data$df1[,-1])
## X2 <- as.matrix(data$df2[,-1])

## tests1 <- lapply(1:ncol(X1), function(i) summary(lm(Y1 ~ X1[,i]))$coefficients[2,])
## tests2 <- lapply(1:ncol(X2), function(i) summary(lm(Y2 ~ X2[,i]))$coefficients[2,])
## tests3 <- lapply(1:ncol(X2), function(i) summary(lm(Y3 ~ X2[,i]))$coefficients[2,])

## p1 <- sapply(tests1,"[",4)
## p2 <- sapply(tests2,"[",4)
## p3 <- sapply(tests3,"[",4)

## # we are going to double the number of SNPs so that Y1 has a causal
## # variant in each block (tests1, duplicated) and Y2 has a shared
## # causal variant in block 1 only (tests2) and not block 2 (tests3)

## snpnames=make.unique(rep(colnames(X2),2))
## maf <- rep(colMeans(X2)/2,2)
## names(maf) <- snpnames
## LD0 <- LD1 <- cor(X2)
## nsnp=ncol(X2)
## dimnames(LD1)=list(snpnames[-c(1:nsnp)],snpnames[-c(1:nsnp)])
## LD01=matrix(0,nsnp,nsnp,dimnames=list(snpnames[1:nsnp],snpnames[-c(1:nsnp)]))
## LD10=matrix(0,nsnp,nsnp,dimnames=list(snpnames[-c(1:nsnp)],snpnames[1:nsnp]))

## LD <- rbind(cbind(LD0,LD01), cbind(LD10, LD1))

## get.beta <- function(x,nm) {
##    beta <- sapply(x,"[",1)
##    varbeta <- sapply(x, "[", 2)^2
##    names(beta) <- names(varbeta) <- colnames(LD)
##    return(list(beta=beta,varbeta=varbeta))
## }
## b1 <- get.beta(c(tests1,tests1),colnames(LD))
## b2 <- get.beta(c(tests2,tests3),colnames(LD))

## D1 <- list(beta=b1$beta[1:nsnp],
##     varbeta=b1$varbeta[1:nsnp],
##     N=nrow(X1),
##     sdY=sd(Y1),
##     type="quant",
##     MAF=maf[1:nsnp],
##     LD=LD[1:nsnp,1:nsnp],
##     snp=names(b1$beta)[1:nsnp],
##     position=1:nsnp)
## D2 <- list(beta=b2$beta[1:nsnp],
##     varbeta=b2$varbeta[1:nsnp],
##     N=nrow(X2),
##     sdY=sd(Y2),
##     type="quant",
##     MAF=maf[1:nsnp],
##     LD=LD[1:nsnp,1:nsnp],
##     snp=names(b2$beta)[1:nsnp],
##     position=1:nsnp)
## D3 <- list(beta=b1$beta,
##     varbeta=b1$varbeta,
##     N=nrow(X1),
##     sdY=sd(Y1),
##     type="quant",
##     MAF=maf
##     LD=LD,
##     snp=names(b1$beta),
##     position=1:length(b1$beta))
## D4 <- list(beta=b2$beta,
##     varbeta=b2$varbeta,
##     N=nrow(X2),
##     sdY=sd(Y2),
##     type="quant",
##     MAF=maf,
##     LD=LD,
##     snp=names(b2$beta),
##     position=1:length(b1$beta))

## coloc_test_data=list(D1=D1,D2=D2,D3=D3,D4=D4)
## save(coloc_test_data, file="data/coloc_test_data.rda", version=2)
