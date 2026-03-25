# load libraries
library(jsonlite)
library(dplyr)
library(tidyr)

# load data
salesOrdersRaw = read.csv("sales_orders.csv")

# parse json
salesOrders = salesOrdersRaw |>
  rowwise() |>
  mutate(line_items = list(parse_json(line_items))) |>
  unnest_longer(line_items) |>
  unnest_wider(line_items) |>
  unnest_wider(product)

# sum of online sales
salesOrders |>
  filter(fulfillment == 'Online') |>
  summarise(
    sales = sum(quantity),
    revenue = sum(quantity * product_price)
  )
