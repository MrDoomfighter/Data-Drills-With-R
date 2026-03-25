# load libraries
library(dplyr)
library(tidyr)

# read data
baseballPositions = read.csv("baseball_positions.csv")

# transpose data
baseballPositions_1 = baseballPositions |>
  rowwise() |>
  mutate(Position = list(strsplit(Position, '/'))[[1]]) |>
  unnest_longer(Position)

# aggregate data
baseballPositionsCount = baseballPositions_1 |>
  group_by(Position) |>
  count() |>
  arrange(desc(n))

# third most position
baseballPositionsCount[3,]
