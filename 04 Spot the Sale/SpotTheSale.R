# load libraries
library(dplyr)

# read data
orders = read.csv("./04 Spot the Sale/orders.csv")
promotions = read.csv("./04 Spot the Sale/promotions.csv")

# merge data
orders_promotions = orders |>
  left_join(
    promotions,
    by = join_by(order_date >= start_date, order_date <= end_date)
  )

# order count by promo period
orders_promotions |>
  group_by(promo_name) |>
  count()
