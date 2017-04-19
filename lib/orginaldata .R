require(gdata)
setwd("~/Documents/Columbia /2017 spring/ADS/project 5")
earning.data <- read.xls("06-17 Earnings release.xlsx")

# save(earning.data,file="alles.RData")

tesla <- earning.data[earning.data$Ticker=="TSLA US",]
nrowtesla <- nrow(tesla)
tesla15_17 <- tesla[(nrowtesla-7):nrowtesla,]
tesladate <- tesla15_17$Date
