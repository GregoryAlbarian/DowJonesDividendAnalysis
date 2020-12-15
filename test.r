list.of.packages <- c("ggplot2", "rvest", "data.table", "dplyr", "filesstrings")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
# If you don't have ggplot2 or rvest and it downloaded
# it for you then you should probably restart R

# using these libraries
library(ggplot2)
library(rvest)
library(data.table)
library(dplyr)
library(filesstrings)
 
test_data <- data.table(symbol = LETTERS[1:26],average_volume=seq(.1,2.6,by=.1),dividends = seq(.1,2.6,by=.1),ratio = seq(.1,2.6,by=.1))
test_data$ratio <- test_data$average_volume / test_data$dividends
test_data

graph<-ggplot(test_data, aes(x=test_data$dividends, y=test_data$average_volume))
graph_title <- "test"
graph <- graph + labs(title = graph_title, x = "dividend (%)", y = "average volume")
graph <- graph + geom_point(colour="blue")
graph <- graph + geom_smooth(method = "loess", color = "red", formula = y ~ x)
graph
cor(test_data$dividends, y=test_data$average_volume)

# I doubled checked manually that all the webscraping and
# changing file locations already work