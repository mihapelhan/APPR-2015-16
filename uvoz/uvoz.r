
require(dplyr)
require(rvest)
require(gsubfn)

url<-'https://en.wikipedia.org/wiki/2014%E2%80%9315_NBA_season'

stran <- html_session(url) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[5]") %>% .[[1]] %>% html_table()

podatki<-read.csv("podatki.csv", header=TRUE, sep=",", dec=".", stringsAsFactors = FALSE, na.strings = ".")
a<-6:30
podatki[a]<-lapply(podatki[a], as.numeric)
podatki<-podatki[!is.na(podatki$PTS),]
podatki$Rk<-NULL
podatki$eFG.<-NULL
colnames(podatki)[29]<-"PTS"
podatki<-podatki[order(podatki[,29], decreasing = TRUE),]

link<-'http://www.spotrac.com/widget/sport/nba/current-year/rankings-cap/"'
site<-html_session(link) %>% read_html(encoding = "UTF-8")
salaries<-site %>% html_nodes(xpath ="//table") %>% .[[1]] %>% html_table()
salaries$`Â `<-NULL
salaries$Pos.<-NULL


celatabela<-inner_join(podatki, salaries, by = "Player")
celatabela$eFG.<-NULL
colnames(celatabela)<-c("Player","Position" ,"Age","Team","Games","Started","Minutes","FG Made", "FG Att","FG %","3Pt Made", "3Pt Att", "3Pt %", "2Pt Made", "2Pt Att", "2Pt %", "FT Made", "FT Att", "FT %", "Off. Reb", "Def. Reb", "Tot. Reb", "Assists", "Steals", "Blocks", "Turnovers", "Fouls", "Points", "Salary")
celatabela$Salary<-as.factor(celatabela$Salary)
celatabela$Salary<-gsub("$","",as.character(celatabela$Salary))

require(ggplot2)

graf<-ggplot(data=celatabela %>% filter(Points>1000), aes(x=Points, y=Salary, color=Player, size=(Salary)/(100*Points) )) + guides(color=guide_legend(ncol=2)) + geom_point()
