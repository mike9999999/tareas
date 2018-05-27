\documentclass{article}

\begin{document}
\title{Tarea}
\author{Miguel Angel Espinoza Camacho}
\maketitle


Oligo permite la lectura de los archivos ".CEL".

<<>>=
library(oligo)
files=c("TAC_1.CEL","TAC_2.CEL","TAC_3.CEL","TAT_1.CEL","TAT_2.CEL","TAT_3.CEL")
hipo=read.celfiles(files)
@
Normaliza los datos. El algoritmo realizar? la 
esta de fondo, la cuantificaci?n y la normalización de cuantiles
<<>>=
hip.rma.probe=rma(hipo, target="core")
expresion<-exprs(hip.rma.probe)
@

Lima es un paquete que ofrece análisis multivariados. Se aplica para datos de secuenciación y datos de microarreglos, aplica estadística frecuentista y bayesiana. Este paquete me ofrece la posibilidad de contrastar la expresión genómica de 2 o más grupos. 

<<>>=
library(limma)
design=matrix(0,6,2)
	design[1:3,1]=1
	design[4:6,2]=1
	colnames(design)=c("Control","SM")
contraste="SM-Control"
cont.matrix=makeContrasts(contraste,levels=design)
fit=lmFit(hip.rma.probe, design)
fitC=contrasts.fit(fit, cont.matrix)
fitCB=eBayes(fitC)
TT=topTable(fitCB, coef=1, adjust="fdr",sort.by="logFC",number=nrow(hip.rma.probe),
  genelist=fit$genes)
head(TT)
@

\end{document}