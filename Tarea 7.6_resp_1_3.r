



library(maps)
library(ape)
library(devtools)
library(phytools)
arbol<-read.nexus("All_Pmac_Unique_hap_seqs_strict_100M.trees")
arbol

#respuesta 1
10001 phylogenetic trees
###############################
#Resp 2
set.seed(1058)
plot(arbol, edge.width=2)
###############################
#Respuesta 3
concenso<-averageTree(arbol,method="symmetric.difference")

###############################
Respuesta 4
read.delim("../meta/P_macro.csv")
females <- subset(data, SEX == "F")
nrow(females)
males<- subset(data, SEX == "M")
nrow(males)
###############################
#respuesta 5
No encontre los datos de descarga

#################################