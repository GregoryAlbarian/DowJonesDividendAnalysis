# line 2-4 I learned about on stack overflow
# it should upload ggplot2 if you don't have it already
list.of.packages <- c("ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
# If you don't have ggplot2 and it downloaded it for you then you should probably restart R

# same with rVest (a web scraping package)
list.of.packages <- c("rvest")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# using these libraries
library(ggplot2)
library(rvest)

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

# ticker symbols used
ticker_symbols <- dividend_table[,1]

# getting volumes for each stock


# graph


#put in README take out of script
# https://www.reinisfischer.com/dow-jones-companies-yield-2018
# https://www.kaggle.com/timoboz/stock-data-dow-jones?select=AAPL.csv
# https://www.tutorialspoint.com/r/r_data_frames.htm
# https://r.789695.n4.nabble.com/remove-last-char-of-a-text-string-td2254377.html