# load libraries
library(dplyr)

# read data
OfficeSpace = read.csv("OfficeSpace.csv")

# lookup hierarchy
OfficeSpaceHierarchy = OfficeSpace |>
  mutate(reportingHierarchy = Employee.Name)

finished = FALSE
while(finished == FALSE) {

  OfficeSpaceHierarchy = OfficeSpaceHierarchy |>
  mutate(
    reportingHierarchy = ifelse(
      is.na(Manager.Name) | Manager.Name == '',
      reportingHierarchy,
      paste(Manager.Name, reportingHierarchy, sep = ' > ')
    )
  ) |>
  left_join(
    OfficeSpace,
    by = join_by(Manager.Name == Employee.Name)
  ) |>
  mutate(Manager.Name = Manager.Name.y) |>
  select(-Manager.Name.y)

  if (sum(!is.na(OfficeSpaceHierarchy$Manager.Name)) == 0) finished = TRUE
  
}

OfficeSpaceHierarchy$Manager.Name = NULL

# aggregate data
OfficeSpaceAggr = OfficeSpace |>
  left_join(
    OfficeSpaceHierarchy
  ) |>
  rowwise() |>
  mutate(
    directReports = sum(OfficeSpace$Manager.Name == Employee.Name),
    totalReports = sum(startsWith(OfficeSpaceHierarchy$reportingHierarchy, reportingHierarchy)) - 1
  ) |>
  ungroup()

# total reports sum
OfficeSpaceAggr |>
  summarise(totalReportsSum = sum(totalReports))
