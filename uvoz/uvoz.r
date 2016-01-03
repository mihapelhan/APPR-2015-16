
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

