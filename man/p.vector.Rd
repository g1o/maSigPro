\name{p.vector}
\alias{p.vector}

\title{Make regression fit for time series gene expression experiments}
\description{
     \code{p.vector} performs a regression fit for each gene taking all variables present in the model given by a regression matrix
     and returns a list of FDR corrected significant genes.
}
\usage{
p.vector(data, design = NULL, Q = 0.05, MT.adjust = "BH", min.obs = 3, counts=FALSE, family=NULL, theta=10, epsilon=0.00001)
}

\arguments{
  \item{data}{matrix containing normalized gene expression data. Genes must be in rows and arrays in columns}
  \item{design}{design matrix for the regression fit such as that generated by the \code{\link{make.design.matrix}} function}
  \item{Q}{significance level}
  \item{MT.adjust}{argument to pass to \code{p.adjust} function indicating the method for multiple testing adjustment of p.value}
  \item{min.obs}{genes with less than this number of true numerical values will be excluded from the analysis. Default is  3 (minimun value for a quadratic fit) }
  \item{counts}{a logical indicating whether your data are counts}
  \item{family}{the distribution function to be used in the glm model. It must be specified as a function: gaussian(), poisson(), negative.binomial(theta)...
		If NULL family will be negative.binomial(theta) when counts=TRUE or gaussian() when counts=FALSE }
  \item{theta}{theta parameter for negative.binomial family} 
 \item{epsilon}{argument to pass to \code{glm.control}, convergence tolerance in the iterative process to estimate de glm model}
}

\details{
\code{rownames(design)} and \code{colnames(data)} must be identical vectors
and indicate array naming.

 \code{rownames(data)} should contain unique gene IDs.

 \code{colnames(design)} are the given names for the variables in the regression model.
}
\value{
  \item{SELEC}{matrix containing the expression values for significant genes}
  \item{p.vector}{vector containing the computed p-values}
  \item{G}{total number of input genes}
  \item{g}{number of genes taken in the regression fit}
  \item{FDR}{p-value at FDR \code{ Q} control when Benajamini & Holderberg (BH) correction is used}
  \item{i}{number of significant genes}
  \item{dis}{design matrix used in the regression fit}
  \item{dat}{matrix of expression value data used in the regression fit}
  \item{...}{additional values from input parameters}  
}
\references{Conesa, A., Nueda M.J., Alberto Ferrer, A., Talon, T. 2006.
maSigPro: a Method to Identify Significant Differential Expression Profiles in Time-Course Microarray Experiments. 
Bioinformatics 22, 1096-1102
}
\author{Ana Conesa, \email{aconesa@cipf.es}; Maria Jose Nueda,
\email{mj.nueda@ua.es}} 

\seealso{ \code{\link{T.fit}}, \code{\link{lm}}}
\examples{
#### GENERATE TIME COURSE DATA
## generates n random gene expression profiles of a data set with 
## one control plus 3 treatments, 3 time points and r replicates per time point.

tc.GENE <- function(n, r,
             var11 = 0.01, var12 = 0.01,var13 = 0.01,
             var21 = 0.01, var22 = 0.01, var23 =0.01,
             var31 = 0.01, var32 = 0.01, var33 = 0.01,
             var41 = 0.01, var42 = 0.01, var43 = 0.01,
             a1 = 0, a2 = 0, a3 = 0, a4 = 0,
             b1 = 0, b2 = 0, b3 = 0, b4 = 0,
             c1 = 0, c2 = 0, c3 = 0, c4 = 0)
{

  tc.dat <- NULL
  for (i in 1:n) {
    Ctl <- c(rnorm(r, a1, var11), rnorm(r, b1, var12), rnorm(r, c1, var13))  # Ctl group
    Tr1 <- c(rnorm(r, a2, var21), rnorm(r, b2, var22), rnorm(r, c2, var23))  # Tr1 group
    Tr2 <- c(rnorm(r, a3, var31), rnorm(r, b3, var32), rnorm(r, c3, var33))  # Tr2 group
    Tr3 <- c(rnorm(r, a4, var41), rnorm(r, b4, var42), rnorm(r, c4, var43))  # Tr3 group
    gene <- c(Ctl, Tr1, Tr2, Tr3)
    tc.dat <- rbind(tc.dat, gene)
  }
  tc.dat
}

## Create 270 flat profiles
flat <- tc.GENE(n = 270, r = 3)
## Create 10 genes with profile differences between Ctl and Tr1 groups
twodiff <- tc.GENE (n = 10, r = 3, b2 = 0.5, c2 = 1.3)
## Create 10 genes with profile differences between Ctl, Tr2, and Tr3 groups
threediff <- tc.GENE(n = 10, r = 3, b3 = 0.8, c3 = -1, a4 = -0.1, b4 = -0.8, c4 = -1.2)
## Create 10 genes with profile differences between Ctl and Tr2 and different variance
vardiff <- tc.GENE(n = 10, r = 3, a3 = 0.7, b3 = 1, c2 = 1.3, var32 = 0.03, var33 = 0.03)
## Create dataset
tc.DATA <- rbind(flat, twodiff, threediff, vardiff)
rownames(tc.DATA) <- paste("feature", c(1:300), sep = "")
colnames(tc.DATA) <- paste("Array", c(1:36), sep = "")
tc.DATA [sample(c(1:(300*36)), 300)] <- NA  # introduce missing values

#### CREATE EXPERIMENTAL DESIGN
Time <- rep(c(rep(c(1:3), each = 3)), 4)
Replicates <- rep(c(1:12), each = 3)
Control <- c(rep(1, 9), rep(0, 27))
Treat1 <- c(rep(0, 9), rep(1, 9), rep(0, 18))
Treat2 <- c(rep(0, 18), rep(1, 9), rep(0,9))
Treat3 <- c(rep(0, 27), rep(1, 9))
edesign <- cbind(Time, Replicates, Control, Treat1, Treat2, Treat3)
rownames(edesign) <- paste("Array", c(1:36), sep = "")

tc.p <- p.vector(tc.DATA, design = make.design.matrix(edesign), Q = 0.05)
tc.p$i # number of significant genes
tc.p$SELEC # expression value of signficant genes
tc.p$FDR # p.value at FDR control
tc.p$p.adjusted# adjusted p.values

}
\keyword{ regression }
