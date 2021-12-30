##### CODE DETECTION DE RUPTURES
#pour executer une ligne, faire ctrl + entree

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


source(file = "fonctions_aux.R")

##Code
code_ruptures(xlsname="Mathieu")
