
require(dplyr)
require(rvest)
require(gsubfn)

url<-'https://en.wikipedia.org/wiki/2014%E2%80%9315_NBA_season'
stran <- html_session(url) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[4]") %>% .[[1]] %>% html_table()

podatki<-read.csv("podatki.csv", header=TRUE, sep=",", dec=".", stringsAsFactors = FALSE, na.strings = ".")
podatki$Rk<-NULL
podatki$eFG.<-NULL
a<-c(6:28)
suppressWarnings(podatki[a]<-lapply(podatki[a], as.numeric))
podatki<-podatki[!is.na(podatki$PTS),]
#podatki<-na.omit(podatki)
colnames(podatki)[28]<-"PTS"
podatki<-podatki[order(podatki[,28], decreasing = TRUE),]

link<-'http://www.spotrac.com/widget/sport/nba/current-year/rankings-cap/"'
site<-html_session(link) %>% read_html(encoding = "UTF-8")
salaries<-site %>% html_nodes(xpath ="//table") %>% .[[1]] %>% html_table()
place<-site %>% html_nodes(xpath ="//table") %>% .[[1]] %>% html_table()
place<-place[-1]
salaries<-salaries[-1]
salaries$Pos.<-NULL

celatabela<-inner_join(podatki, salaries, by = "Player")
colnames(celatabela)<-c("Player","Position" ,"Age","Team","Games","Started","Minutes","FG Made", "FG Att","FG %","3Pt Made", "3Pt Att", "3Pt %", "2Pt Made", "2Pt Att", "2Pt %", "FT Made", "FT Att", "FT %", "Off. Reb", "Def. Reb", "Tot. Reb", "Assists", "Steals", "Blocks", "Turnovers", "Fouls", "Points", "Salary")
celatabela$Salary<-as.factor(celatabela$Salary)
celatabela$Salary<-gsub("\\$", "", celatabela$Salary)
celatabela$Salary<-gsub("\\,", "", celatabela$Salary)
celatabela$Salary<-as.numeric(celatabela$Salary)

strelci<-data.frame(Player=celatabela$Player, Points=celatabela$Points)

zlink<-'http://hoopshype.com/2015/02/24/where-are-nba-players-born/'
zstran <- html_session(zlink) %>% read_html(encoding = "UTF-8")
ztabela <- zstran %>% html_nodes(xpath ="//table[2]") %>% .[[1]]  %>% html_table()
ztabela<-na.omit(ztabela)
ztabela<-ztabela[-1,-3]
colnames(ztabela)<-c('City','Players')
ztabela$City<-as.factor(ztabela$City)
ztabela$Players<-as.numeric(ztabela$Players)
ztabela$City<-gsub('[[:digit:]]+', '', ztabela$City)
ztabela$City<-gsub('\\.', '', ztabela$City)
ztabela<-ztabela[-11,]
ztabela1<-ztabela
ztabela$Lat<-c('34.052235', '40.792240', '41.881832', '40.002785', '32.736259', '39.790942', '47.608013', '30.471165', '35.040031', '39.299236', '29.761993', '33.753746', '38.889931', '33.792461', '38.627003')
ztabela$Long<-c('-118.243683', '-73.138260', '-87.623177', '-75.183739', '-96.864586', '-86.147685', '-122.335167', '-91.147385', '-89.981873', '-76.609383', '-95.366302', '-84.386330', '-77.009003', '-118.185005', '-90.199402')
ztabela$STATE_NAME<-c('California', 'New York', 'Illinois', 'Pennsylvania', 'Texas', 'Indiana', 'Washington', 'Louisiana', 'Tennessee', 'Maryland', 'Texas', 'Georgia', 'District of Columbia', 'California', 'Missouri')
ztabela$Lat<-as.numeric(ztabela$Lat)
ztabela$Long<-as.numeric(ztabela$Long)
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")
library(ggplot2)

pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}

zda <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/states_21basic.zip", "states")
ztabela <- preuredi(ztabela, zda, "STATE_NAME")
usa<-pretvori.zemljevid(zda)
usa.cont <- usa %>% filter(! STATE_NAME %in% c("Alaska", "Hawaii"))

ekipe<-read.csv('teams__active.csv')
ekipe$Lg<-NULL
ekipe$To<-NULL
ekipe$Yrs<-NULL
ekipe$W.L.<-NULL
colnames(ekipe)<-c('Team', 'Founded', 'Games', 'Won', 'Lost', 'Playoffs', 'Div. titles', 'Conf. titles', 'Championships')
ekipe1<-ekipe
ekipe<-ekipe[-28,]
ekipe$STATE_NAME<-c('Georgia', 'Massachusetts', 'New York', 'North Carolina', 'Illinois', 'Ohio','Texas','Colorado','Michigan','California','Texas','Indiana','California','California','Tennessee','Florida','Wisconsin','Minnesota','Louisianna','New York','Oklahoma','Florida','Pennsylvania','Arizona','Oregon','California','Texas','Utah','District of Columbia')
ekipe$LAT<-c('33.75375', '42.35843', '40.35000','35.227085', '41.881832','41.505493','32.73626','39.742043','42.331429','	37.801239','29.682720','39.769653','34.052235','34.052235','35.040031',	'25.778135','43.038902','44.986656','29.951065','40.79224','35.481918','28.538336','40.00279','33.453388','45.512794','38.575764','29.424349','40.758701','38.88993')
ekipe$LONG<-c('-84.38633', '-71.05977', '-73.949997', '-80.843124','-87.623177','	-81.681290','-96.86459','	-104.991531','	-83.045753','-122.258301','-95.593239','-86.157143','-118.243683','-118.243683','-89.981873','-80.179100','-87.906471','-93.258133','-90.071533','-73.13826','-97.508469','-81.379234','-75.18374','-112.074623','-122.679565','-121.478851','-98.491142','-111.876183','-77.00900')
ekipe$LAT<-as.numeric(ekipe$LAT)
ekipe$LONG<-as.numeric(ekipe$LONG)
ekipe<-preuredi(ekipe,zda,'STATE_NAME')