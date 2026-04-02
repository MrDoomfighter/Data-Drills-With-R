# load libraries
library(dplyr)
library(tibbletime)

# read data
SPY_close_price_5Y = read.csv("./07 Turning Bullish/SPY_close_price_5Y.csv",
                              colClasses = c('Date', 'numeric'))

# calculate new columns
SPY_close_price_5Y_1 = SPY_close_price_5Y |>
  mutate(
    MA_50 = rollify(mean, 50)(Close),
    MA_200 = rollify(mean, 200)(Close),
    GoldenCross = MA_50 > MA_200 & lag(MA_50) <= lag(MA_200)
  )

# golden crosses
SPY_close_price_5Y_1 |>
  filter(GoldenCross)

# visualise
plot(SPY_close_price_5Y_1$Date, SPY_close_price_5Y_1$Close, type = 'l', xlab = 'Date', ylab = 'Price')
lines(SPY_close_price_5Y_1$Date, SPY_close_price_5Y_1$MA_50, col = 'gold', lwd = 2)
lines(SPY_close_price_5Y_1$Date, SPY_close_price_5Y_1$MA_200, col = 'red', lwd = 2)
lines(SPY_close_price_5Y_1$Date, SPY_close_price_5Y_1$GoldenCross)
title(main = sprintf('SPY closing prices %s till %s', min(SPY_close_price_5Y_1$Date), max(SPY_close_price_5Y_1$Date)))
legend(
  'bottomright',
  legend = c('Closing price', '50-day moving average', '200-day moving average'),
  col = c('black', 'gold', 'red'),
  lty = 1
)
