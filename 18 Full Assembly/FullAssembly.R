# load libraries
library(readr)
library(dplyr)
library(data.tree)
library(DiagrammeR)

# read data
bikeOrders = read_csv("./18 Full Assembly/bike_orders.csv")
bikeBom = read_csv("./18 Full Assembly/bike_bom.csv")

# construct tree
bikeBomTree = bikeBom |>
  bind_rows(
    bikeBom |>
      distinct(parent_item) |>
      rename(child_item = parent_item) |>
      mutate(
        parent_item = 'items',
        quantity_per = 1
      )
  ) |>
  FromDataFrameNetwork()

# only keep bike models on first level after root
bikes = bikeOrders$bike_model |> unique() 
Prune(
  bikeBomTree,
  function(node) {
    node$parent$isRoot & node$name %in% bikes | !node$parent$isRoot
  }
)

# multiply quantities within tree
Do(
  bikeBomTree |> Traverse(),
  function(node) {
    node$quantity_total = ifelse(node$parent$isRoot, 1, node$parent$quantity_total * node$quantity_per)
    node$bike = ifelse(node$parent$isRoot, node$name, node$parent$bike)
  }
)

# visualise hierarchy for Metro Commuter
SetNodeStyle(
  bikeBomTree,
  label = function(node) {
    if(node$parent$isRoot) {
      node$name
    } else if(isLeaf(node)) {
      paste0(node$name, '\nquantity: ', node$quantity_per, '\ntotal quantity: ', node$quantity_total)
    } else {
      paste0(node$name, '\nquantity: ', node$quantity_per)
    }
  }
)

bikeBomTree$`Metro Commuter` |>
  ToDiagrammeRGraph() |>
  export_graph("./18 Full Assembly/MetroCommuterHierarchy.svg")

# extract leaves with quantites
bikeBomBottom = bikeBomTree$leaves |>
  lapply(
    function(leaf) {
      list(
        path = paste0(leaf[['path']], collapse = ' / '),
        item = leaf[['name']],
        bike = leaf[['bike']],
        quantity_total = leaf[['quantity_total']]
      )
    }
  ) |>
  bind_rows()

bikeBomQuantities = bikeBomBottom |>
  summarise(
    quantity_total = sum(quantity_total),
    .by = c(bike, item)
  )

# merge data
bikeOrdersBom = bikeOrders |>
  left_join(
    bikeBomQuantities,
    by = join_by(bike_model == bike),
    relationship = 'many-to-many'
  )

# aggregate data
bikeOrdersBom |>
  summarise(
    quantity_total = sum(quantity * quantity_total),
    .by = item
  ) |>
  arrange(item)
