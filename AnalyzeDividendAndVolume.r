# DowJonesDividendAnalysis.r
# line 4 through 6 I learned about on stack overflow
# it should upload ggplot2 if you don't have it already

list.of.packages <- c("ggplot2", "rvest", "data.table", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
# If you don't have ggplot2 or rvest and it downloaded
# it for you then you should probably restart R

# using these libraries
library(ggplot2)
library(rvest)
library(data.table)
library(dplyr)
# this program also requires a stable internet
# connection to work and scrape appropriate data

# importing in my data

# I am putting in the average dividend from scraping the internet
url <- "https://www.reinisfischer.com/dow-jones-companies-yield-2018"
dividend_table <- html_table(read_html(url))[[1]]
dividend_table <- dividend_table[c(2,4)]

# cleaning the table header
colnames(dividend_table) <- dividend_table[1, ]
dividend_table <- dividend_table[-1 , ]
row.names(dividend_table) <- 1:nrow(dividend_table)

#type casting the percentages into numbers and decimals
# taking off percentage signs
dividend_table$Yield <- substr(dividend_table$Yield,1,nchar(dividend_table$Yield)-1)
dividend_table$Yield <- as.numeric(dividend_table$Yield)
# yield is still stored as a percentage for later calculations

# ticker symbols used maybe need
ticker_symbols <- dividend_table[,1]

# getting volumes for each stock

# congjoined data will be filled up late in the for loop
file_names <- paste("stock_volumes/",ticker_symbols,".csv",sep = "")

# preallocating memory for a dataframe
conjoined_data <- data.table(symbol = LETTERS[1:30],average_volume=seq(.1,3,by=.1),dividends = seq(.1,3,by=.1),ratio = seq(.1,3,by=.1))
for (iteration in seq(1:30)) {
  
  stock <- fread(file_names[iteration])
  # grabbing just 2018 data
  stock <- filter(stock, grepl("2018", date))
  volume <- select(stock, volume)

  average_volume <- mean(volume[[1]])
  conjoined_data[iteration,1] <- ticker_symbols[iteration]
  conjoined_data[iteration,2] <- average_volume
  conjoined_data[iteration,3] <- dividend_table$Yield[iteration]
  
}

# ratio look at the similarity between volume and dividend
conjoined_data$ratio <- conjoined_data$average_volume / dividend_table$Yield

# graph
graph<-ggplot(conjoined_data, aes(x=dividends, y=average_volume))
graph_title <- "average stock volume vs. dividends in the DOW"
graph <- graph + labs(title = graph_title, x = "dividend (%)", y = "average volume")
graph <- graph + geom_point(colour="blue")
graph <- graph + geom_smooth(method = "loess", color = "red", formula = y~x)
graph
pdf("dividends vs. average stock volume in the DOW.pdf")
print(graph)
dev.off()
conjoined_data
