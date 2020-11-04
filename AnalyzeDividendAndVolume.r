# line 3 to 11 I learned about on stack overflow
# it should upload ggplot2 if you don't have it already

list.of.packages <- c("ggplot2", "rvest")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
# If you don't have ggplot2 or rvest and it downloaded
# it for you then you should probably restart R

# using these libraries
library(ggplot2)
library(rvest)
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
conjoined_data <- data.frame(symbols = c(), volumes = c(), dividends = c())
file_names <- paste("stock_volumes/",ticker_symbols,".csv",sep = "")

iteration_amount <- seq(1:30)
for (iteration in iteration_amount) {
  stock <-read.csv(file_names[iteration])
  
  # grabbing just 2018 data
  #stop hardoding this part****************************************
  volume <- stock[974:1224, 6]
  average_volume <- mean(volume)
  #************************************get rid of rbind pre allocate memory instead
  temp_data <- data.frame(ticker_symbols[iteration], average_volume, dividend_table$Yield[iteration])
  conjoined_data <- rbind(conjoined_data, temp_data)
}

colnames(conjoined_data) <- c("symbol", "average_volume", "dividends")
# ratio look at the similarity between volume and dividend
conjoined_data$ratio <- conjoined_data$average_volume / conjoined_data$dividends
conjoined_data

# graph
graph<-ggplot(conjoined_data, aes(x=average_volume, y=dividends))
graph_title <- "      dividends vs. average stock volume in the DOW"
graph <- graph + labs(title = graph_title, x = "dividend (%)", y = "average volume")
graph <- graph + geom_point(colour="blue")
graph <- graph + geom_smooth(model="lm", method = "loess", color = "red", formula = y~x)
graph
