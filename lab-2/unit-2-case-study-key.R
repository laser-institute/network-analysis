## ----setup, include=FALSE----------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----load_libraries----------------------------------------------------------------------------------------------------
library(readxl)
library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)


## ----import_year_1-----------------------------------------------------------------------------------------------------

year_1_collaboration <- read_excel("data/year_1_collaboration.xlsx", 
                            col_names = FALSE)


## ----inspect_year_1----------------------------------------------------------------------------------------------------

year_1_collaboration



## ----import_year_3-----------------------------------------------------------------------------------------------------
#YOUR CODE HERE

year_3_collaboration <- read_excel("data/year_3_collaboration.xlsx", 
                                   col_names = FALSE)

year_3_collaboration



## ----assign_names------------------------------------------------------------------------------------------------------

rownames(year_1_collaboration) <- 1:43

colnames(year_1_collaboration) <- 1:43



## ----inspect_names-----------------------------------------------------------------------------------------------------
year_1_collaboration


## ----convert_to_matrix-------------------------------------------------------------------------------------------------

year_1_matrix <- as.matrix(year_1_collaboration )



## ----get_class---------------------------------------------------------------------------------------------------------

class(year_1_collaboration)

class(year_1_matrix)



## ----convert_to_graph--------------------------------------------------------------------------------------------------

year_1_network <- as_tbl_graph(year_1_matrix, directed = TRUE)



## ----inspect_network---------------------------------------------------------------------------------------------------

year_1_network



## ----wrangle_year_3----------------------------------------------------------------------------------------------------
#YOUR CODE HERE

rownames(year_3_collaboration) <- 1:43

colnames(year_3_collaboration) <- 1:43

year_3_matrix <- as.matrix(year_3_collaboration)
  
class(year_3_matrix)

year_3_network <- as_tbl_graph(year_3_matrix, directed = TRUE)

year_3_network




## ----plot_network------------------------------------------------------------------------------------------------------

plot(year_1_network)



## ----autograph_network-------------------------------------------------------------------------------------------------

autograph(year_1_network)



## ----year_1_sociogram--------------------------------------------------------------------------------------------------

ggraph(year_1_network) +
  geom_node_point() +
  geom_edge_link()



## ----modify_sociogram--------------------------------------------------------------------------------------------------

ggraph(year_1_network, layout = "fr") +
  geom_node_point(size = 3) +
  geom_edge_link(aes(colour = weight)) +
  theme_graph()
  



## ----year_3_sociogram--------------------------------------------------------------------------------------------------
#YOUR CODE HERE

ggraph(year_3_network, layout = "fr") +
  geom_node_point(size = 3) +
  geom_edge_link(aes(colour = weight)) +
  theme_graph()



## ----compute_size------------------------------------------------------------------------------------------------------

gorder(year_1_network)

gsize(year_1_network)



## ----compute_centrality------------------------------------------------------------------------------------------------
centr_degree(year_1_network, mode = "all")


## ----compute_degrees---------------------------------------------------------------------------------------------------
centr_degree(year_1_network, mode = "out")
centr_degree(year_1_network, mode = "in")


## ----compute_node_degree-----------------------------------------------------------------------------------------------
year_1_network <- year_1_network |>
  activate(nodes) |>
  mutate(degree = centrality_degree(mode = "all"))

year_1_network



## ----udpate_sociogram--------------------------------------------------------------------------------------------------
ggraph(year_1_network) +
  geom_node_point(aes(size = degree, color = degree)) +
  geom_edge_link(aes(color = weight)) +
  theme_graph()


## ----compute_density---------------------------------------------------------------------------------------------------

edge_density(year_1_network)

graph.density(year_1_network)


## ----compute_reciprocity-----------------------------------------------------------------------------------------------

reciprocity(year_1_network)


## ----flag_mutual_dyads-------------------------------------------------------------------------------------------------

year_1_network <- year_1_network |>
  activate(edges) |>
  mutate(reciprocated = edge_is_mutual())

year_1_network


## ----add_reciprocated_ties---------------------------------------------------------------------------------------------
ggraph(year_1_network) +
  geom_node_point(aes(size = degree)) +
  geom_edge_link(aes(color = reciprocated)) +
  theme_graph()


## ----compute_transitivity----------------------------------------------------------------------------------------------

transitivity(year_1_network)


## ----compute_diameter--------------------------------------------------------------------------------------------------

diameter(year_1_network)

mean_distance(year_1_network)



## ----analyze_year_3----------------------------------------------------------------------------------------------------
#YOUR CODE HERE

#size
gorder(year_3_network)
gsize(year_3_network)

#cetnralization 
centr_degree(year_3_network, mode = "all")

#density
edge_density(year_3_network)

#reciprocity
reciprocity(year_3_network)

#transitivity
transitivity(year_3_network)

#diameter & distance 
diameter(year_3_network)
mean_distance(year_3_network)


## ----create_data_product-----------------------------------------------------------------------------------------------
# YOUR CODE HERE

