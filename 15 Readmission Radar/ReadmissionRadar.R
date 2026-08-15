# load libraries
library(readr)
library(dplyr)

# read data
inpatienAdmissions = read_csv("./13 Readmission Radar/inpatient_admissions.csv")

# recode variables
inpatienAdmissions_1 = inpatienAdmissions |>
  arrange(patient_id, admission_date) |>
  mutate(
    readmission = admission_date <= lag(discharge_date) + 30,
    .by = patient_id
  )

# calculate readmission rate
inpatienAdmissions_1 |>
  summarise(
    hospitalisations = n(),
    readmissions = sum(readmission, na.rm = TRUE),
    readmissionRate = floor(readmissions / hospitalisations * 100)
  )
