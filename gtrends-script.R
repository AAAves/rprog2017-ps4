#library all needed packages.
library(gtrendsR)
library(ggplot2)
library(tidyverse)

#select the data and load them in 'bitcoin.trend'
bitcoin.trend <- gtrends(c("bitcoin"), gprop = "web", time = "all")[[1]]
class(bitcoin.trend)
head(bitcoin.trend)

#The class of the column 'date' is date
class(bitcoin.trend$date)

#The changes of hits according to time.
ggplot(data = bitcoin.trend) + geom_line(mapping = aes(x= date, y = hits))
#gtrends is used to catch the google trends query.
?gtrends

#Only reserve the data after 2009-01-01
bitcoin.trend <- bitcoin.trend %>% filter(date >= as.Date("2009-01-01"))
#You can see the changes on hits after Trump inauguration using the red line.
ggplot(data = bitcoin.trend) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red") #trump inauguration
  

library(Quandl)
bitcoin.price <- Quandl("BCHARTS/BITSTAMPUSD")
#Only reseve the same time data as bitcion.trends, and select two columns: Date, close.
bitcoin.price <- bitcoin.price %>% filter(Date %in% bitcoin.trend$date) %>% select(Date, Close) %>% rename(date = Date, price = Close) %>% mutate(price = price*100/max(price))

#add the prcie to bitcoin.trends
bitcoin <- left_join(x = bitcoin.trend, y= bitcoin.price, by = "date")
head(bitcoin)

#Plot the hits and the price together, you can see they have similar shape.
ggplot(data = bitcoin) + 
  geom_line(mapping = aes(x= date, y = hits)) +
  geom_line(mapping = aes(x= date, y = price), color = "gray") + 
  geom_vline(xintercept = as.Date("2017-01-20"), color = "red")

