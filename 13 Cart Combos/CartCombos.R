# load libraries
library(readr)
library(dplyr)

# read data
groceryTransactions = read_csv("./13 Cart Combos/grocery_transactions.csv")

# join products
groceryTransactionPairs = inner_join(
  x = groceryTransactions |> select(transaction_id, product_name),
  y = groceryTransactions |> select(transaction_id, product_name),
  by = join_by(transaction_id),
  relationship = 'many-to-many'
) |>
  filter(product_name.x != product_name.y) |>
  rowwise() |>
  mutate(
    pair = paste(c(product_name.x, product_name.y) |> sort(), collapse = ' + ')
  ) |>
  ungroup() |>
  distinct(transaction_id, pair)

# count transactions by pairs
groceryTransactionPairs |>
  summarise(
    transactions = n(),
    .by = pair
  ) |>
  arrange(desc(transactions))
