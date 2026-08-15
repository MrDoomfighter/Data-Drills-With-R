# load libraries
library(readr)
library(dplyr)

# read data
employeeSatisfactionSurvey = read_csv("./14 Final Form/employee_satisfaction_survey.csv")

# select latest survey per employee
employeeSatisfactionSurveyLatest = employeeSatisfactionSurvey |>
  slice_max(
    order_by = Timestamp,
    n = 1,
    by = Email
)

# count latest satisfaction scores
employeeSatisfactionSurveyLatest |>
  summarise(
    employees = n(),
    .by = Satisfaction
  ) |>
  arrange(Satisfaction)
