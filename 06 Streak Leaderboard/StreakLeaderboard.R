# load libraries
library(dplyr)

# load data
lessons = read.csv("./06 Streak Leaderboard/LessonStreaks.csv")

# calculate new columns
lessons_1 = lessons |>
  distinct(user_id, date) |>
  arrange(user_id, date) |>
  group_by(user_id) |>
  mutate(
    date = as.Date(date),
    daysSinceLastLesson = as.numeric(lag(date) - date),
    streak = cumsum(is.na(daysSinceLastLesson) | daysSinceLastLesson < -1)
  )

# aggregate data
lessonStreaks = lessons_1 |>
  group_by(user_id, streak) |>
  summarise(
    streakLength = n(),
    streakEnd = max(date)
  ) |>
  ungroup()

# longest active streak - Top 3
lessonStreaks |>
  filter(streakEnd == '2025-09-28') |>
  slice_max(
    order_by = streakLength,
    n = 3
  )
