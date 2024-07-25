library(tidyverse)
library(tidygraph)
library(ggraph)

# Load the data
scholar_nodes <- read_csv("module-0/data/scholar-nodes-2024.csv")
scholar_edges <- read_csv("module-0/data/scholar-edges-2024.csv")


# Create a tidygraph object
scholar_network <- tbl_graph(nodes = scholar_nodes, 
                             edges = scholar_edges,
                             directed = TRUE)

# Plot the network
ggraph(scholar_network, layout = "stress") + 
  geom_edge_link(arrow = arrow(length = unit(1, 'mm')), 
                 end_cap = circle(3, 'mm'),
                 start_cap = circle(3, 'mm'),
                 alpha = .1) +
  geom_node_point(aes(size = local_size(),
                      color = attribute)) +
  geom_node_text(aes(label = name),
                 repel=TRUE) +
  theme_graph()
  


