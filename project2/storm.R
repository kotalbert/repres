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
    furl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf"

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

# 2. Across the United States, which types of events have the greatest economic 
# consequences?

# Using dplyr for data transformation and agregation
library(dplyr)
storm <- tbl_df(storm)

storm_fat <- storm %>%
    mutate(casualties = FATALITIES + INJURIES) %>%
    group_by(EVTYPE) %>%
    summarise(cas_sum = sum(casualties)
              , fat_sum = sum(FATALITIES)
              , inj_sum = sum(INJURIES)
              ) %>%
    arrange(desc(cas_sum)) 

# Listing top 10 / top 20 events
top10 <- slice(storm_fat, 2:10) 
top20 <- slice(storm_fat, 2:20)

library(xtable)
print(xtable(top20),type="html") 

library(ggplot2)
ggplot(top10, aes(y=cas_sum, x=EVTYPE, fill=EVTYPE)) +
    theme(legend.position="bottom"
          , axis.text.x = element_blank()
          ) + 
    labs(title="Top 10 events by total casualty count"
         , x = "Event Type"
         , y = "Total casualties" ) + 
    scale_fill_brewer(palette="Blues") + 
    geom_bar(stat="identity")

ggplot(top20, aes(x=inj_sum, y=fat_sum, color=EVTYPE)) + 
    scale_fill_brewer(palette="Blues") + 
    geom_point()
