# Reproducible Research
# Course Project 1
# Pawel Daniluk
# 2016-10-21

u <- "https://d3c33hcgiwev3.cloudfront.net/_e143dff6e844c7af8da2a4e71d7c054d_payments.csv?Expires=1477180800&Signature=FerKsA~fiNL7YI-YScfou24QrezGrAg88Owl8dGcKpcmYH7eAkxDMA2Q6mUyhNiY53pvL08gpVfBjxgW1bUkDnN002ARL1S8eOpwOxdJoWkSrh7BAGNWNtJM5rU4ZBKyPlu8GlK6Fh2oZNURy4xe0-hcVTBZAxm8H2cocdgYy3c_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"
download.file(u, "./payments.csv")
# Read the data from csv file, downloaded to working directory
pay <- read.csv('./payments.csv')

# Relationship  between mean covered charges (Average.Covered.Charges) and 
# mean total payments (Average.Total.Payments)

library(ggplot2)

# calculate r^2 of linear model to be drawn on the plot
mod <- lm(Average.Covered.Charges ~  Average.Total.Payments, data=pay)
r2 <- summary(mod)$r.squared

pdf('./plot1.pdf')
ggplot(data=pay, aes(x=Average.Total.Payments, y=Average.Covered.Charges)) + 
  geom_point(color="skyblue", alpha=0.4) + 
  geom_smooth(method="lm") +
  ggtitle("Relation of Average Total Payments to Average Covered Charge") +
  labs(x = "Average Total Payments", y="Average Covered Charges") +
  annotate("text", x= 3.5e4, y=1.5e5, label="~R^{2}==0.4", parse=T, size=5) + 
  theme_bw()
dev.off()

## How does the relationship between mean covered charges (Average.Covered.Charges) 
## and mean total payments (Average.Total.Payments) vary by medical condition (DRG.Definition) 
## and the state in which care was received (Provider.State)?

## Recode long medical condition names to just the number
shrt <- function(txt) {
    return(strsplit(as.character(txt), " ")[[1]][1])

}

## add factor of medical condition codes to data frame for plotting
pay$drg_short <- factor(sapply(pay$DRG.Definition, shrt))

## Draw a plot with DRG color coded points and State facets
pdf("./plot2.pdf") 
ggplot(data=pay, 
             aes(x=Average.Total.Payments, 
                 y=Average.Covered.Charges, 
                 color=drg_short)) +
  facet_grid(Provider.State~.) + 
  theme_bw() + 
  ggtitle("Avg. Total Payments to Avg. Covered Charge") + 
  labs(x = "Average Total Payments", y="Average Covered Charges") +
  theme(legend.position="bottom") + 
  geom_point(alpha=0.4)
dev.off()
