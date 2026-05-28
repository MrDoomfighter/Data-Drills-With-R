# load libraries
library(readr)
library(dplyr)

# load data
marathonData = read_csv("./12 Making the Cut/marathon-data.csv")

# recode variables
marathonData_1 = marathonData |>
  mutate(
    finishBand = cut(
      final |> as.numeric() / 3600,
      breaks = c(0, 3, 3.5, 4, 4.5, 5, 5.5, 6, Inf),
      labels = c(
        'Sub 3:00',
        '3:00 - 3:30',
        '3:30 - 4:00',
        '4:00 - 4:30',
        '4:30 - 5:00',
        '5:00 - 5:30',
        '5:30 - 6:00',
        '6:00+'
      ),
      right = FALSE
    )
  )

# aggregate data
marathonData_1 |>
  summarise(
    runners = n(),
    .by = finishBand
  ) |>
  mutate(rate = floor(runners / sum(runners) * 100))
