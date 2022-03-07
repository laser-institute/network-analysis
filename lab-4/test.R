library(tidyverse)
library(tidygraph)
library(igraph)
library(readxl)
library(statnet)
library(ggraph)

# WRANGLE #####


# Import Data ####

leader_nodes <- 
  read_excel("unit-3/data/School Leaders Data Chapter 9_e.xlsx", 
             col_types = c("text", "numeric", "numeric", "numeric", "numeric"))

leader_matrix <- 
  read_excel("unit-3/data/School Leaders Data Chapter 9_d.xlsx", 
             col_names = FALSE)


## Convert to Matrix ####

leader_matrix <- leader_matrix %>%
  as.matrix()

class(leader_matrix)

## Dichotomize matrix ####

leader_matrix[leader_matrix <= 2] <- 0

leader_matrix[leader_matrix >= 3] <- 1

leader_matrix

#add names to matrix object
rownames(leader_matrix) <- leader_nodes$ID
colnames(leader_matrix) <- leader_nodes$ID

## Convert Adjacent Matrix #### 

adjacency_matrix <- graph.adjacency(leader_matrix,
                                    diag = FALSE)

class(adjacency_matrix)

## Convert to edge list ####

leader_edges <- get.data.frame(adjacency_matrix)


leader_edges

## Create Network Object #### 

leader_graph <- tbl_graph(edges = leader_edges,
                     nodes = node_list,
                     directed = TRUE)


leader_graph

plot(leader_graph) 


# EXPLORE ####

# Degree ####

network_measures <- leader_graph %>%
  activate(nodes) %>%
  mutate(degree = centrality_degree(mode = "all")) %>%
  mutate(in_degree = centrality_degree(mode = "in")) %>%
  mutate(out_degree = centrality_degree(mode = "out"))

network_measures

node_measures <- network_measures %>% 
  activate(nodes) %>%
  data.frame()

summary(node_measures)


# Plot

ggraph(network_measures, layout = "fr") + 
  geom_node_point(aes(size = in_degree, 
                      alpha = out_degree, 
                      colour = degree)) +
  geom_node_text(aes(label = ID, 
                     size = degree/2,
                     alpha = degree), 
                 repel=TRUE) +
  geom_edge_link(arrow = arrow(length = unit(1, 'mm')), 
                 end_cap = circle(3, 'mm'),
                 alpha = .3) + 
  theme_graph()


# MODEL ####

## Convert to network object ####


leader_network <- as.network(leader_edges,
                             vertices = leader_nodes)

class(leader_network)

leader_network

list.vertex.attributes(leader_network)


plot(leader_network)

ergm_1 <- ergm(leader_network ~ edges) 

summary(ergm_1)

ergm_2 <- ergm(leader_network ~ edges + 
                 mutual +
                 gwesp(0.25, fixed=T))

summary(ergm_2)

ergm_3 <- ergm(leader_network ~ edges +
                 mutual +
                 gwesp(0.25, fixed=T) +
                 nodecov('MALE'))
  

summary(ergm_3)

ergm_4 <- ergm(leader_network ~ edges +
                 mutual +
                 gwesp(0.25, fixed=T) +
                 nodefactor('MALE') +
                 nodecov('EFFICACY')
               )
  
  
summary(ergm_4)

ergm_5 <- ergm(leader_network ~ edges +
                 mutual +
                 gwesp(0.25, fixed=T) +
                 nodecov('MALE') +
                 nodecov('EFFICACY') +
                 nodecov('TRUST')
)


summary(ergm_5)

ergm_6 <- ergm(leader_network ~ edges +
                 mutual +
                 gwesp(0.25, fixed=T) +
                 gwesp(0.25, fixed=T) +
                 nodematch('MALE') +
                 nodematch('DISTRICT/SITE') +
                 absdiff('EFFICACY') +
                 absdiff('TRUST')
)


summary(ergm_6)

# Goodness of fit

ergm_6_gof <- gof(leader_network ~ edges +
                    mutual +
                    gwesp(0.25, fixed=T) +
                    nodematch('MALE') +
                    nodematch('DISTRICT/SITE') +
                    absdiff('EFFICACY') +
                    absdiff('TRUST'))

plot(ergm_6_gof)

