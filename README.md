# Analiza podatkov s programom R, 2015/16

Avtor: Miha Pelhan

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2015/16.

## ANALIZA STATISTIKE LIGE NBA

Ameriška košarkarska liga NBA (National Basketball Association) je najbolj priljubljena košarkarska liga na svetu. Posledično je tudi najbolj spremljana in njena statistika je najbolj obsežna. Sam sem se odločil za analizo igralcev v sezoni 2014/2015. Podatki bodo urejeni po mnogih prvinah košarke (št. doseženih točk, odstotek zadetih metov, dobljeni skoki, itd.). 

Podatke bom pridobil na straneh:
* http://www.basketball-reference.com/leagues/NBA_2015_totals.html?lid=header_seasons
* http://espn.go.com/nba/statistics/player/_/stat/scoring-per-game/sort/avgPoints/year/2015/count/41



## Cilj:

Cilj naloge je narediti podrobno analizo statistike, torej poiskati najboljšega igralca v vsaki izmed kategorij, ugotoviti povprečje izmed vsakih kategorij, primerjati igralce med seboj, itd.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Spletni vmesnik

Spletni vmesnik se nahaja v datotekah v mapi `shiny/`. Poženemo ga tako, da v
RStudiu odpremo datoteko `server.R` ali `ui.R` ter kliknemo na gumb *Run App*.
Alternativno ga lahko poženemo tudi tako, da poženemo program `shiny.r`.

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `httr` - za pobiranje spletnih strani
* `XML` - za branje spletnih strani
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
