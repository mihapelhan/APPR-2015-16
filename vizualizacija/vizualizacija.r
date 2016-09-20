require(dplyr)
require(rvest)
require(gsubfn)

map <- ggplot() + geom_polygon(data = usa.cont, color='navajowhite3', aes(x = long, y = lat, group=group),fill="navajowhite")
require(ggrepel)
map1 <- map + geom_point(data = ztabela, color = "green4", aes(x = Long, y = Lat, size = Players)) + geom_text_repel(data = ztabela, color='black', aes(x = Long, y = Lat, label = City), size=5)
map1

map2<-map+geom_point(data=ekipe,color='red',size=2,aes(x=LONG,y=LAT)) + geom_text_repel(data=ekipe,color='black',aes(x=LONG,y=LAT,label=Team),size=3)
map2

datagraf1 <- celatabela[which(celatabela$Points > 1500), ]
graf1 <- qplot(datagraf1$Points,datagraf1$Salary,color=datagraf1$Team,size=(datagraf1$Minutes),xlab = "Points",ylab = "Salary",main = "Points achieved per dollar") + geom_text_repel(aes(label=datagraf1$Player),size=5, color="black")

dataSG <- celatabela[which(celatabela$Position=="SG"), ]
dataSG1 <- dataSG[which(dataSG$Points > mean(dataSG$Points)), ]
grafSG <- barplot(dataSG1$Points,xlab = "Points", horiz=TRUE, names.arg = dataSG1$Player, las=1,cex.names = 0.5, main = "Branilci")# + geom_vline(xintercept = mean(dataSG1$Points), color="red")

dataC <- celatabela[which(celatabela$Position == "C"), ]
dataC1 <- dataC[which(dataC$Points > mean(dataC$Points)), ]
grafC <- barplot(dataC1$Points,xlab = "Points",horiz=TRUE, names.arg = dataC1$Player,las=1,cex.names=0.5, main= "Centri")# + geom_vline(xintercept = mean(dataC1$Points), color="red")

dataPG <- celatabela[which(celatabela$Position == "PG"), ]
dataPG1 <- dataPG[which(dataPG$Points > mean(dataPG$Points)), ]
grafPG <- barplot(dataPG1$Points,xlab = "Points",horiz=TRUE, names.arg = dataPG1$Player,las=1,cex.names=0.5, main = "Organizatorji")# + geom_vline(xintercept = mean(dataPG1$Points), color="red")

dataSF <- celatabela[which(celatabela$Position=="SF"), ]
dataSF1 <- dataSF[which(dataSF$Points > mean(dataSF$Points)), ]
grafSF <- barplot(dataSF1$Points,xlab = "Points",horiz=TRUE, names.arg = dataSF1$Player,las=1,cex.names=0.5, main="Krila")# + geom_vline(xintercept = mean(dataSF1$Points), color="red")

dataPF <- celatabela[which(celatabela$Position=="PF"), ]
dataPF1 <- dataPF[which(dataPF$Points > mean(dataPF$Points)), ]
grafPF <- barplot(dataPF1$Points,xlab = "Points",horiz=TRUE, names.arg = dataPF1$Player,las=1,cex.names=0.5, main="Krilni centri")# + geom_vline(xintercept = mean(dataPF1$Points), color="red")