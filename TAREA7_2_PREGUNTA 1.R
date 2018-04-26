
### determinar Work directory 
setwd("~/BioinfinvRepro-master/Unidad7/Prac_Uni7/maices/meta")

##### RESP 1    Leer y cargar datos 

fullmat<-read.delim("maizteocintle_SNP50k_meta_extended.txt")

##### TRESP 2      ipo de objeto ###
}
class(fullmat)
[1] "data.frame"

##### RESP 3    Lineas 1:6 ###

head(fullmat[1:6,])

dim(head(fullmat[1:6,]))
[1]  6 22



##### RESP 4   Cuantas muestras

dim(fullmat)
[1] 165  22

##### RESP 5    numero de estados ####

estados<-as.factor(fullmat$Estado)
numestad<-summary(estados)
estad<-as.matrix(numestad)
dim(estad)
[1] 19  1


##### RESP 6 muestras en 1980

año<-(fullmat$AÌ.o._de_colecta)
summary(año ==1980)

#Mode   FALSE    NA's 
#logical     160       5 


######## RES 7  MUESTRAS POR RAZA  de raza 

Raze<-as.factor(fullmat$Raza)
raz<-summary(raze)
racian<-as.matrix(raz)
dim(racian)
[1] 48  1
print(racian)

###### RESP 8 Promedio de Altitud

mean(fullmat$Altitud)
[1] 1519.242


##### RESP 9 Valores maximos y minimos

summary(fullmat$Altitud)
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
      5     654    1750    1519    2159    2769

##### RESP 10   dataframe con Olotillos

 fullmat[c(68,72,75,79,123),]

###### RESP 11     dAta frame Reventador, Jala y Ancho

fullmat[c(103,154,30,43,119,135,16,37,57),]

####  RESP 12Crear Crear "CSV"

submat<-fullmat[c(103,154,30,43,119,135,16,37,57),]
write.csv(submat,"submat.csv")
getwd()
dir()