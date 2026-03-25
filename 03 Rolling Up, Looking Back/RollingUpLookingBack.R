# load libraries
library(dplyr)

# load data
coffeeShopSales = read.csv("coffee_shop_sales.csv")

# aggregate data
coffeeShopSalesAggr = coffeeShopSales |>
  mutate(month = date |> as.Date() |> months(TRUE)) |>
  group_by(month, store) |>
  summarise(sales = sum(sales)) |>
  arrange(match(month, month.abb)) |>
  group_by(store) |>
  mutate(salesChange = sales - lag(sales))

# change in sales for Astoria in May
coffeeShopSalesAggr |>
  filter(month == 'May' & store == 'Astoria')
