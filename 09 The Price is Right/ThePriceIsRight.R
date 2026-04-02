# load libraries
library(dplyr)

# read data
transactions = read.csv("./09 The Price is Right/transactions.csv")
products = read.csv("./09 The Price is Right/products.csv")
price_history = read.csv("./09 The Price is Right/price_history.csv")

# merge data
products_price_history = price_history |>
  left_join(products |> select(pizza_id, name))

transactions_price = transactions |>
  left_join(
    products_price_history,
    by = join_by(pizza_id == pizza_id, order_date >= effective_date),
    relationship = 'many-to-many'
  ) |>
  # join creates duplicates for each price effective on or after the order date
  arrange(order_id, order_detail_id, effective_date) |>
  group_by(order_id, order_detail_id) |>
  slice_tail(n = 1) # this retains one row per pizza order

# aggregate data
transactions_price |>
  ungroup() |>
  summarise(revenue = floor(sum(price * quantity)))
