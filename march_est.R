library(ggplot2)
library(rvest)
library(dplyr)
library(car)
library(leaflet)
library(fuzzyjoin)
library(readr)
library(ggmap)


slots <- read_csv("est_march.csv", skip =3)

slots$fundsin <- abs(slots$`Funds In`)
slots$fundsout <- abs(slots$`Funds Out`)

slots$profit <- slots$fundsin - slots$fundsout



t1 <- slots %>% select(Establishment, Municipality, fundsin, fundsout, profit) 

t1$est <- paste(t1$Establishment, t1$Municipality, sep = ", ")

ggplot(t1 %>% filter(profit <0), aes(x=reorder(est, -profit), y=profit)) + geom_col() + coord_flip()

