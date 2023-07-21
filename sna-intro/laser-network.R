
library(tidyverse)
library(tidygraph)
library(ggraph)

scholar_edges <- read_csv("sna-intro/data/scholar-edges.csv")
scholar_nodes <- read_csv("sna-intro/data/scholar-nodes.csv")





scholar_network <- tbl_graph(edges = scholar_edges, # specifies edges
                             nodes = scholar_nodes,
                             directed = TRUE) # specifies directionality

scholar_network


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

