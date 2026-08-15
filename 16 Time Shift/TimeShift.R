# load libraries
library(readr)
library(dplyr)
library(lubridate)

# read data
tickets = read_csv("./16 Time Shift/tickets.csv")
users = read_csv("./16 Time Shift/users.csv")

# join data
userTickets = tickets |>
  left_join(
    users,
    by = join_by(user_id)
  )

# extract local hour
userTicketsLocal = userTickets |>
  rowwise() |>
  mutate(
    timezoneEtcGmt = sprintf('Etc/GMT%+d', (timezone |> substr(5, 7) |> as.numeric()) * -1),
    localHour = with_tz(submitted_at_utc |> as_datetime(), timezoneEtcGmt) |> hour()
  ) |>
  ungroup()

# count tickets by hour
userTicketsLocal |>
  summarise(
    tickets = n(),
    .by = localHour
  ) |>
  arrange(desc(tickets))
