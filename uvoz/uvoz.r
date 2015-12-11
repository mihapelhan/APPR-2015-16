require(dplyr)
require(rvest)
require(gsubfn)

url<-'https://en.wikipedia.org/wiki/2014%E2%80%9315_NBA_season'

stran <- html_session(url) %>% read_html(encoding = "UTF-8")
tabela <- stran %>% html_nodes(xpath ="//table[5]") %>% .[[1]] %>% html_table()

podatki<-read.csv("podatki.csv", header=TRUE, sep=",", dec=".", stringsAsFactors = FALSE, na.strings = ".")
podatki[,6:30]<-as.numeric(podatki[,6:30])
a<-6:30
podatki[a]<-lapply(podatki[a], as.numeric)
data<-podatki[!is.na(podatki$PTS),]
data$Rk<-NULL
