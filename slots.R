library(ggplot2)
library(rvest)
library(dplyr)
library(car)
library(leaflet)
library(fuzzyjoin)
library(readr)
library(ggmap)

# Read in the data, but skip the first three rows
###slots <- read_csv("vg1.csv", skip =3)
# Delete all the county rows
###slots[ grep("County", slots$Municipality, invert = TRUE) , ]


url <- "https://en.wikipedia.org/wiki/List_of_cities_in_Illinois"
ill <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/table[2]') %>%
  html_table()

ill <- ill[[1]]

ill$pop <- as.numeric(gsub(",", "", ill$Population))

slots <- read_csv("https://raw.githubusercontent.com/ryanburge/Slot_Machine/master/slots.csv")

slots <- slots %>% rename(Name = Municipality)

#merge <- merge(slots, ill, by=c("Name"))

joined <- slots %>%
  stringdist_right_join(ill, by = c("Name"), max_dist = 2)

joined <- joined %>% distinct(Municipality, .keep_all = TRUE)
joined$percapita <- joined$`Amount Played`/joined$pop

capita <- select(joined, Name.x, percapita)

capita %>% arrange(-percapita)

capita$state <- c("Illinois")

capita$citystate <- paste(capita$Name.x, capita$state, sep = ", ")




#coords <- geocode(capita$citystate)
map <- cbind(capita, coords)

map <- cbind(map, joined)

map %>% subset(., select=which(!duplicated(names(.))))


map$taxcap <- map$`Municipality Share`/map$pop
map$macpop <- map$pop/map$`VGT Count`

pop<-paste0("<b>City</b>: ",map$Name.x, "<br>",
            "<b>Population</b>: ", map$Population, "<br>",
            "<b>Gambling $ Per Capita</b>: ",round(map$percapita, 0), "<br>",
            "<b>Tax $ Per Capita</b>: ",round(map$taxcap, 0), "<br>",
            "<b>Residents Per Machine</b>: ",round(map$macpop, 0), "<br>",
            "<b>Number of Gambling Establishments</b>: ",map$`Establishment Count`, "<br>")

leaflet()%>%
  addProviderTiles(providers$Esri.NatGeoWorldMap)%>%
  addCircleMarkers(lng = map$lon, lat= map$lat, radius = map$percapita/100, popup = pop)