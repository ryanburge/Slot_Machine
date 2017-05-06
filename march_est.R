library(ggplot2)
library(rvest)
library(dplyr)
library(car)
library(leaflet)
library(fuzzyjoin)
library(readr)
library(ggmap)

## January
slots <- read_csv("est_jan.csv", skip =3)

slots <- slots %>% filter(`VGT Count` > 0) %>% 
  rename(fundsin = `Funds In`, fundsout = `Funds Out`) %>%
  mutate(profit = fundsin - fundsout)


t1 <- slots %>% select(Establishment, Municipality, fundsin, fundsout, profit) 

t1$est <- paste(t1$Establishment, t1$Municipality, sep = ", ")

ggplot(t1 %>% filter(profit <0), aes(x=reorder(est, -profit), y=profit)) + geom_col() + coord_flip()


## February
slots <- read_csv("est_feb.csv", skip =3)

slots <- slots %>% filter(`VGT Count` > 0) %>% 
  rename(fundsin = `Funds In`, fundsout = `Funds Out`) %>%
  mutate(profit = fundsin - fundsout)


t1 <- slots %>% select(Establishment, Municipality, fundsin, fundsout, profit) 

t1$est <- paste(t1$Establishment, t1$Municipality, sep = ", ")

ggplot(t1 %>% filter(profit <0), aes(x=reorder(est, -profit), y=profit)) + geom_col() + coord_flip()


## March 
slots <- read_csv("est_march.csv", skip =3)

slots <- slots %>% filter(`VGT Count` > 0) %>% 
  rename(fundsin = `Funds In`, fundsout = `Funds Out`) %>%
  mutate(profit = fundsin - fundsout)


t1 <- slots %>% select(Establishment, Municipality, fundsin, fundsout, profit) 

t1$est <- paste(t1$Establishment, t1$Municipality, sep = ", ")

ggplot(t1 %>% filter(profit <0), aes(x=reorder(est, -profit), y=profit)) + geom_col() + coord_flip()


