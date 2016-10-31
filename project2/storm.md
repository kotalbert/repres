---
title: "Impact of severe weather conditions in the USA"
output:
  html_document:
    fig_caption: true
    css: styles.css
---

## Synopsis
This report summarizes analysis of impact of severe weather conditions on public
health and property damage caused by severe weather conditions. In particular, there are two research question to be adressed:


The analysis is based on U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database, as of 2007.

The dataset is available for [download](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2). 

Complete [documentation](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf) for the research dataset is published.

## Loading raw data
Compressed data set is downloaded and read into data frame object. For improved performance, data data is being prevented from downloading if already present in the working directory. Decompressed data is stored in working directory as RDat file, to be loaded into memory as needed. 

```r
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
```
## Data description
The analysis set contains severe weather events, recorded between the year 1950 and November 2011.  

## Research methodology and data transformations


## Impact of severe weather events on public health 

## Property damage  
