#pour executer une ligne, faire ctrl + entree

rm(list=ls())
library(readxl)
library(ggplot2)
library(ggpubr)
library(stringr)

path<-"donnees_exemple.xlsx"


graphe<-function(){
  print("Entrer le nom du fichier")
  file<-readline()
  path<-paste(file,".xlsx",sep='')
  data<- read_excel(path=path, col_names = FALSE, skip = 0, n_max = 3)
  data<-as.matrix(data)
  data<-t(data)
  data<-as.data.frame(data)
  colnames(data)<-c("type","rouge","bleu")
  lignes<-which(str_detect(data$type,"Gap"))
  data<-data[-lignes,]
  data<-data[-1,]
  rouge<-data[,2]
  rouge<-as.numeric(rouge)
  bleu<-data[,3]
  bleu<-as.numeric(bleu)
  temps_fin<-which(is.na(rouge))[1]-1 
  rouge<-rouge[1:temps_fin]
  temps_fin<-which(is.na(bleu))[1]-1 
  bleu<-bleu[1:temps_fin]
  data_comparaison<-data.frame(c(cumsum(rouge),cumsum(bleu)),c(rouge,bleu),c(rep("carre rouge",length(rouge)),rep("E bleu",length(bleu))))
  colnames(data_comparaison)<-c("x","y","test") 
  plot_comparaison<-ggplot(data=data_comparaison,aes(x=x,y=y,color=test)) 
  plot_comparaison<-plot_comparaison+theme_transparent() 
  plot_comparaison<-plot_comparaison+geom_line() 
  plot_comparaison<-plot_comparaison+ scale_color_manual(values=c('#ff5800','#6ce5e8')) 
  plot_comparaison<-plot_comparaison+xlab("Temps (s)") +ylab("Temps de réaction (s)") + ggtitle("Evolution du temps de réaction au cours de l'exercice")
  plot_comparaison<-plot_comparaison + theme(plot.title = element_text(colour='white',hjust = 0.5)) 
  plot_comparaison<-plot_comparaison + theme(axis.title.x  = element_text(colour='white'))
  plot_comparaison<-plot_comparaison + theme(axis.title.y  = element_text(colour='white')) 
  plot_comparaison<-plot_comparaison + theme(axis.line = element_line(colour = "white")) 
  plot_comparaison<-plot_comparaison + theme(legend.title = element_text(colour="white")) 
  plot_comparaison<-plot_comparaison + theme(legend.text = element_text(colour="white")) 
  plot_comparaison<-plot_comparaison  + theme(axis.text.y = element_text(colour='white')) 
  plot_comparaison<-plot_comparaison  + theme(axis.text.x = element_text(colour='white')) 
  ggsave(filename = "graphe.png",plot = plot_comparaison,bg = "transparent",width = 7,height = 3.5)
  }


plot_comparaison1<-ggplot(data=data_comparaison,aes(x=x,y=y,color=test))
plot_comparaison1<-plot_comparaison1+geom_line()
