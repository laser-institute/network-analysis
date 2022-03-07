## ----setup, include=FALSE------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)


## ----load-libraries------------------------------------------------------------------------------------------
# YOUR CODE HERE
library(readxl)
library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)
library(skimr)
library(janitor)
library(statnet)


## ----import-nodes--------------------------------------------------------------------------------------------
leader_nodes <- read_excel("data/School Leaders Data Chapter 9_e.xlsx", 
                           col_types = c("text", "numeric", "numeric", "numeric", "numeric")) %>%
  clean_names()

leader_nodes


## ----import-matrix-------------------------------------------------------------------------------------------
#YOUR CODE HERE
leader_matrix <- read_excel("data/School Leaders Data Chapter 9_d.xlsx", 
                            col_names = FALSE)


## ----view-matrix---------------------------------------------------------------------------------------------
leader_matrix


## ----convert-matrix------------------------------------------------------------------------------------------
leader_matrix <- leader_matrix %>%
  as.matrix()

class(leader_matrix)


## ----dichotomize-matrix--------------------------------------------------------------------------------------
leader_matrix[leader_matrix <= 2] <- 0

leader_matrix[leader_matrix >= 3] <- 1


## ----add-names-----------------------------------------------------------------------------------------------
rownames(leader_matrix) <- leader_nodes$id

colnames(leader_matrix) <- leader_nodes$id

leader_matrix


## ----extract-edges-------------------------------------------------------------------------------------------
adjacency_matrix <- graph.adjacency(leader_matrix,
                                    diag = FALSE)

class(adjacency_matrix)

adjacency_matrix


## ----convert-edgelist----------------------------------------------------------------------------------------
leader_edges <- get.data.frame(adjacency_matrix) |>
  mutate(from = as.character(from)) |>
  mutate(to = as.character(to))


leader_edges


## ----create-network------------------------------------------------------------------------------------------
# YOUR CODE HERE
leader_graph <- tbl_graph(edges = leader_edges,
                          nodes = leader_nodes,
                          directed = TRUE)


leader_graph


## ----add-indegree--------------------------------------------------------------------------------------------
leader_measures <- leader_graph |>
  activate(nodes) |>
  mutate(in_degree = centrality_degree(mode = "in")) |>
  mutate(out_degree = centrality_degree(mode = "out"))

leader_measures


## ----add-degree----------------------------------------------------------------------------------------------
leader_measures <- leader_graph %>%
  activate(nodes) %>%
  mutate(degree = centrality_degree(mode = "all")) %>%
  mutate(in_degree = centrality_degree(mode = "in")) %>%
  mutate(out_degree = centrality_degree(mode = "out"))

leader_measures


## ----create-tibble-------------------------------------------------------------------------------------------
node_measures <- leader_measures |> 
  activate(nodes) |>
  as_tibble()

node_measures


## ----summarize-measures--------------------------------------------------------------------------------------
summary(node_measures)

skim(node_measures)


## ----group-stats---------------------------------------------------------------------------------------------
node_measures |>
  group_by(district_site) |>
  summarise(n = n(),
            mean = mean(in_degree), 
            sd = sd(in_degree)
            )


## ----replicate-findings--------------------------------------------------------------------------------------
node_measures %>%
  group_by(district_site) %>%
  summarise(n = n(),
            mean = mean(out_degree), 
            sd = sd(out_degree)
            )

node_measures %>%
  group_by(district_site) %>%
  summarise(n = n(),
            mean = mean(trust), 
            sd = sd(trust)
            )

node_measures %>%
  group_by(district_site) %>%
  summarise(n = n(),
            mean = mean(efficacy), 
            sd = sd(efficacy)
            )


## ----improve-sociogram---------------------------------------------------------------------------------------
#YOUR CODE HERE
leader_measures |>
ggraph(layout = "fr") + 
  geom_node_point() +
  geom_edge_link() + 
  theme_graph()


## ----as-network----------------------------------------------------------------------------------------------
leader_network <- as.network(leader_edges,
                             vertices = leader_nodes)

leader_network


## ----view-network--------------------------------------------------------------------------------------------
class(leader_network)


## ----summarize-mutual----------------------------------------------------------------------------------------
summary(leader_network ~ edges + mutual)


## ----ergm-1, message=FALSE-----------------------------------------------------------------------------------
set.seed(589)

ergm_mod_1 <-ergm(leader_network ~ edges + mutual)

summary(ergm_mod_1)


## ----summarize-transitive------------------------------------------------------------------------------------
summary(leader_network ~ edges + 
          mutual +
          transitive +
          gwesp(0.25, fixed=T))


## ----summarize-ergm-2, message=FALSE-------------------------------------------------------------------------
ergm_mod_2 <-ergm(leader_network ~ edges + 
                    mutual +
                    gwesp(0.25, fixed=T))

summary(ergm_mod_2)


## ----ergm-3, message=FALSE-----------------------------------------------------------------------------------
ergm_3 <- ergm(leader_network ~ edges +
                 mutual +
                 gwesp(0.25, fixed=T) +
                 nodefactor('male') +
                 nodecov('efficacy')
               )
  
  
summary(ergm_3)


## ----ergm-4, message=FALSE-----------------------------------------------------------------------------------
#YOUR CODE HERE
ergm_4 <- ergm(leader_network ~ edges +
                 mutual +
                 gwesp(0.25, fixed=T) +
                 nodematch('male') +
                 nodematch('district_site')
               )
  
  
summary(ergm_4)


## ----ergm-3-gof----------------------------------------------------------------------------------------------
ergm_3_gof <- gof(ergm_3)

plot(ergm_3_gof)


## ----diagnose-ergm-3-----------------------------------------------------------------------------------------
mcmc.diagnostics(ergm_3)


## ----check-ergm-4--------------------------------------------------------------------------------------------
#YOUR CODE HERE
ergm_4_gof <- gof(ergm_4)

plot(ergm_4_gof)

mcmc.diagnostics(ergm_4)


## ----create_data_product-------------------------------------------------------------------------------------
# YOUR CODE HERE



