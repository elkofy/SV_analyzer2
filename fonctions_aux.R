###fonctions auxiliaires
rm(list=ls())

##Installation des packages
#install.packages("segmented")
#install.packages("xlsx")
#install.packages("ggplot2")
#install.packages("readxl")
#install.packages("stringr")
library(readxl)
library(stringr)
library(segmented)
library(xlsx)
library(ggplot2)
# nom_fichier<-"Pierre Barbe.xlsx"

select<-function(mot){
  return(paste(paste(substring(mot,3,4),'.'),substring(mot,6,7)))
}
sans_espace<-function(mot){
  return(str_replace_all(string=mot, pattern=" ", repl=""))
}


transformation_fichier<-function(nom_fichier){
  VE_VO2max<-read_excel(nom_fichier,skip = 111,n_max = 1)
  VE_VO2max<-VE_VO2max[,12]
  VE_VO2max<-VE_VO2max[[1]]
  VE_VO2max<-str_replace(VE_VO2max,",",".")
  VE_VO2max<-as.numeric(VE_VO2max)
  data<-read_excel(nom_fichier,skip = 118, n_max = 2000)
  data<-data[-1,]
  t<-as.data.frame(data$t)
  t<-sapply(t,select)
  t<-sapply(t,sans_espace)
  t<-as.numeric(t)
  min<-trunc(t)
  t<-min + (t-min)*100/60
  data$t<-t
  data[,-c(2,3,8)] <- as.data.frame(sapply(data[,-c(2,3,8)], function(x) as.numeric(x)))
  ind_debut<-which(data$Phase=='Exercice')[1]
  tps_debut<-t[ind_debut]
  length<-length(which(data$Phase=='Exercice'))
  ind_fin<-ind_debut+length-1
  tps_fin<-t[ind_fin]
  data<-data[which(data$t>tps_debut & data$t<tps_fin),]
  return(list(data,VE_VO2max))
}

detection_rupture_VO2_bis<-function(data,nruptures){
  x<-data$t
  y<-data$`V'E/V'O2`
  linear_model<-lm(y ~ x)
  segmented.mod <- segmented(linear_model, seg.Z = ~x,npsi=nruptures)
  indices_segments<-3:(nruptures-1+3)
  slopes<-coef.segmented(segmented.mod)[indices_segments]
  indices_rupt<-1:nruptures
  ind_rupt_pos<-indices_rupt[which(slopes>0)]
  if(length(ind_rupt_pos)>=2){
    max1<-which.max(slopes[ind_rupt_pos])
    temp<-slopes[ind_rupt_pos]
    temp[max1]<-0
    max2<-which.max(temp)
    pos1<-min(max1,max2)
    pos2<-max(max1,max2)
    res<-c(as.numeric(segmented.mod$psi[ind_rupt_pos[pos1],2]),as.numeric(segmented.mod$psi[ind_rupt_pos[pos2],2]),broken.line(segmented.mod)$fit)
  }
  else{res<-detection_rupture_VO2_bis(data,nruptures+1)}
  return(res)
}

graphe_ruptures_VO2<-function(data,nruptures){
  res<-detection_rupture_VO2_bis(data,nruptures)
  xx<-data$t
  yy<-data$`V'E/V'O2`
  zz<-res[3:(length(res))]
  dati<-data.frame(x=xx,y=yy)
  data2<-data.frame(x=xx,y=zz)
  plot<-ggplot(data = dati,aes(x=xx,y=yy)) + geom_line() + geom_line(data=data2,aes(x=xx,y=zz),color='blue',size=1.4) + xlab("Time in minutes") + ylab("VE / VO2") + ggtitle("Evolution of VE/VO2 as a function of the time")
  plot<-plot + geom_vline(xintercept = res[1],size=1.2,color='red')
  plot<-plot + geom_vline(xintercept = res[2],size=1.2,color='red')
  print(paste("SV1 :",as.character(res[1])))
  print(paste("SV2 :",as.character(res[2])))
  return(plot)
}

code_ruptures<-function(xlsname){
  print("Entrer le nom du fichier excel (sans le '.xlsx')")
  file<-xlsname
  path<-paste(file,".xlsx",sep='')
  res<-transformation_fichier(path)
  VE_VO2max<-res[[2]]
  data<-res[[1]]
  plot<-graphe_ruptures_VO2(data,2)
  plot<-plot+geom_hline(yintercept = VE_VO2max,size=1.2)
  ggsave(filename = "graphe.png",plot = plot,width = 7,height = 3.5)
}