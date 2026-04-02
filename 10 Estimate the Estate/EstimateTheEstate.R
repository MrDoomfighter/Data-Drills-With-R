# load libraries
library(dplyr)

# read data
manhattan_property_sales = read.csv("./10 Estimate the Estate/manhattan_property_sales.csv")

# impute market value for properties without price
manhatten_property_sales_imputed = manhattan_property_sales |>
  mutate(
    SALE_PRICE = na_if(SALE_PRICE, 0),
    pricePerSqFt = SALE_PRICE / SQUARE_FEET
  ) |>
  group_by(ZIP_CODE, BUILDING_CLASS) |>
  mutate(
    pricePerSqFtImputed = coalesce(pricePerSqFt, mean(pricePerSqFt, na.rm = TRUE)),
    marketValue = coalesce(SALE_PRICE, pricePerSqFtImputed * SQUARE_FEET)
  ) |>
  ungroup()

# count of properties above 15 Mil. market value
manhatten_property_sales_imputed |>
  filter(marketValue > 15e6) |>
  count()
