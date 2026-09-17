# load libraries
library(readr)
library(dplyr)
library(lubridate)

# read data
streamingSubscriptions = read_csv("./19 Cohort Curve/streaming_subscriptions.csv")

# calculate new columns
latestDate = streamingSubscriptions$canceled_date |> max(na.rm = TRUE) 
nextFirst = latestDate |> ceiling_date(unit = 'month')

streamingSubscriptions_1 = streamingSubscriptions |>
  mutate(
    createdYear = year(created_date),
    createdMonth = months(created_date) |> factor(levels = month.name),
    renewal = interval(created_date, coalesce(canceled_date, nextFirst) - 1) %/% months(1)
  )

# duplicate each row renewal+1 times
streamingSubscriptions_2 = streamingSubscriptions_1 |>
  slice(rep(row_number(), times = renewal + 1)) |>
  mutate(
    monthsSinceSignup = seq(0, n() - 1),
    .by = subscription_id
  )

# calculate retention rates by cohort and months since signup
retentionRates = streamingSubscriptions_2 |>
  arrange(createdYear, createdMonth, subscription_id, monthsSinceSignup) |>
  summarise(
    subscriptions = n(),
    .by = c(createdYear, createdMonth, monthsSinceSignup)
  ) |>
  mutate(
    retentionRate = floor(subscriptions / first(subscriptions) * 100),
    .by = c(createdYear, createdMonth)
  )

# retention rates for November 2025
retentionRates |>
  filter(createdYear == '2025' & createdMonth == 'November') |>
  select(monthsSinceSignup, retentionRate) |>
  slice(2:6)
