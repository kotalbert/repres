# Reproducible Research
# Peer-graded Assignment: Course Project 2
# Pawe' Daniluk
# 2016-10-29

# Data analysis for the project, to be used in final report

# Downloading data and documentation if not present in working directory

if (!dir.exists("./data/")) {

    dir.create("./data/")

    surl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
    durl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf"
    furl <- "httpsgit st://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf"

    download.file(surl, "./data/storm.bz2", mode="wb")
    download.file(durl, "./data/data_doc.pdf", mode="wb")
    download.file(furl, "./data/data_faq.pdf", mode="wb")

    # Read compressed file into data frame
    # read.csv function will decompress bz2 archive

    storm <- read.csv("./data/storm.bz2")

    # Save decompressed data set to RDat. file for reuse.
    save(storm, file="./data/storm.RDat")
}

# Load storm data from RDat. file if not present in memory
if(!exists("storm")) 
    load("./data/storm.RDat")

# Target of the analysis
# 1. Across the United States, which types of events (as indicated in the EVTYPE 
# variable) are most harmful with respect to population health?

# Using dplyr for data transformation and agregation
library(dplyr)
storm <- tbl_df(storm)

# Calculation of casualty value as fatalities + 0.2*injuries (arbitrary)
storm_cas <- storm %>%
    mutate(casualties = FATALITIES + 0.2*INJURIES
           , casualties=ceiling(casualties)
           )

# Calculating casualty values by event type
cas_evtype <- storm_cas %>%
    group_by(EVTYPE) %>%
    summarise(cas_sum = sum(casualties)
              , fat_sum = sum(FATALITIES)
              , inj_sum = sum(INJURIES)
              , ev_n = n()
              , cas_per_event = cas_sum/n()) %>%
    arrange(desc(cas_sum)) 

# Printing top 20 events as html with with xtable
cas <- head(cas_evtype, 20)

# Transform data to horizontal format to produce barplot
cas2 <- head(cas_evtype)
library(tidyr)
cas_bar <- cas2 %>% 
  rename(Casualties=cas_sum, Fatalities=fat_sum, Injuries=inj_sum) %>%
  select(-c(ev_n, cas_per_event)) %>%
  gather(Label, value, -EVTYPE)
  
library(ggplot2)
ggplot(cas_bar, aes(x=EVTYPE, y=value,fill=Label)) +
  labs(x="Event type", y="Sum", title="Severity of event type (Public Health)") + 
  geom_bar(stat="identity", position="dodge")

# 2. Across the United States, which types of events have the greatest economic 
# consequences?

# Using dplyr for data transformation and agregation
library(dplyr)
storm <- tbl_df(storm)
storm_dmg <- storm %>% mutate(total_dmg = PROPDMG+CROPDMG)

dmg_evtype <- storm_dmg %>%
  group_by(EVTYPE) %>%
  summarise(total_dmg_sum = sum(total_dmg)
            , prop_dmg_sum = sum(PROPDMG)
            , crop_dmg_sum = sum(CROPDMG)
            , ev_n = n()
            , exp_dmg = total_dmg_sum/ev_n
            )

# Economic impact

dmg_prop <- arrange(dmg_evtype, desc(prop_dmg_sum))
dmg_crop <- arrange(dmg_evtype, desc(crop_dmg_sum))

top_prop <- head(dmg_prop, 10)
top_crop <- head(dmg_crop, 10)


nms <- c("Event type", "Total damage", "Property damage", "Crop damage"
                     , "Number of events", "Total damage per event")
  
names(top_prop) <- nms
names(top_crop) <- nms

library(knitr)

kable(top_prop,  digits=2, caption = "Top 10 event types causing most property damage")
kable(top_crop,  digits=2, caption = "Top 10 event types causing most crop damage")

library(ggplot2)
options(scipen=999)
ggplot(head(dmg_prop, 5), aes(x=EVTYPE, y=prop_dmg_sum, fill=EVTYPE)) + 
  labs(x="Event type", y="Value", title="Property damage") + 
  geom_bar(stat="identity", position="dodge") + 
  theme(axis.text.x=element_blank())

ggplot(head(dmg_crop, 5), aes(x=EVTYPE, y=crop_dmg_sum, fill=EVTYPE)) + 
  labs(x="Event type", y="Value", title="Crop damage") + 
  geom_bar(stat="identity", position="dodge") + 
  theme(axis.text.x=element_blank())



