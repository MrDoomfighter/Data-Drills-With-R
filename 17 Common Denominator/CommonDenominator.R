# load libraries
library(readr)
library(dplyr)

# read data
campaignPerformance = read_csv("./17 Common Denominator/campaign_performance.csv")

# recalculate clicks
campaignPerformance_1 = campaignPerformance |>
  mutate(
    clicks = impressions * parse_number(ctr) / 100
  )

# calculate click through rate by channels
bind_rows(
  campaignPerformance_1 |>
    summarise(
      ctr = sum(clicks) / sum(impressions) * 100,
      .by = channel
    ) |>
      arrange(channel),
  campaignPerformance_1 |>
    summarise(
      ctr = sum(clicks) / sum(impressions) * 100
    )
)
