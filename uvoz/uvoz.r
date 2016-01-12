
require(dplyr)
require(rvest)
require(gsubfn)

url<-'https://en.wikipedia.org/wiki/2014%E2%80%9315_NBA_season'

stran <- html_session(url) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[5]") %>% .[[1]] %>% html_table()

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



  