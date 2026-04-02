# load libraries
library(dplyr)

# read data
activity = read.csv("./05 Movie Metrics/activity.csv")
users = read.csv("./05 Movie Metrics/users.csv")

# merge data
users_activity = users |>
  rename(user_id = id) |>
  left_join(
    activity,
    by = join_by(user_id)
  )

# aggregate data
userMetrics = users_activity |>
  mutate(
    # Columns date and movie_name are only needed for finished movies
    date = ifelse(finished == 1, date, NA),
    movie_name = ifelse(finished == 1, movie_name, NA)
  ) |>
  arrange(user_id, date, id) |>
  group_by(user_id, created_at, country_code) |>
  summarise(
    firstMovieDate = first(date, na_rm = TRUE),
    firstMovie = first(movie_name, na_rm = TRUE),
    lastMovieDate = last(date, na_rm = TRUE),
    lastMovie = last(movie_name, na_rm = TRUE),
    moviesStarted = n(),
    moviesFinished = sum(finished)
  ) |>
  ungroup()

# users who have last seen Fight Club 
userMetrics |>
  filter(lastMovie == 'Fight Club') |>
  # group_by(lastMovie) |> # alternative
  count()
