## ----setup, include=FALSE------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ---- eval=FALSE---------------------------------------------------------------------------------------
## install.packages("tidyverse")
## install.packages("igraph")


## ----load_packages-------------------------------------------------------------------------------------
# YOUR CODE HERE



## ----read_edges----------------------------------------------------------------------------------------
dlt1_ties <- read_csv("data/dlt1-edges.csv", 
                      col_types = cols(Sender = col_character(), 
                                       Receiver = col_character(), 
                                       `Category Text` = col_skip(), 
                                       `Comment ID` = col_character(), 
                                       `Discussion ID` = col_character())) |>
  clean_names()

dlt1_ties


## ----read_nodes----------------------------------------------------------------------------------------
# YOUR CODE HERE



## ------------------------------------------------------------------------------------------------------
#YOUR CODE HERE



## ----function_help, eval=FALSE-------------------------------------------------------------------------
## ?tbl_graph


## ----create_network------------------------------------------------------------------------------------
dlt1_network <- tbl_graph(edges = dlt1_ties,
                          nodes = dlt1_actors,
                          node_key = "uid",
                          directed = TRUE)


## ----inspect_network-----------------------------------------------------------------------------------
#YOUR CODE HERE



## ----autograph-----------------------------------------------------------------------------------------
autograph(dlt1_network)


## ----components_weak-----------------------------------------------------------------------------------
components(dlt1_network, mode = c("weak"))


## ----components_strong---------------------------------------------------------------------------------
# YOUR CODE HERE

components(dlt1_network, mode = c("strong"))


## ----group_components----------------------------------------------------------------------------------
dlt1_network <- dlt1_network |>
  activate(nodes) |>
  mutate(strong_component = group_components(type = "strong"))


## ----as_tibble-----------------------------------------------------------------------------------------
as_tibble(dlt1_network)


## ----count_components----------------------------------------------------------------------------------
dlt1_network |>
  as_tibble() |>
  group_by(strong_component) |>
  summarise(count = n()) |>
  arrange(desc(count))


## ----filter_reciprocated-------------------------------------------------------------------------------
dlt1_network |>
  activate(edges) |>
  mutate( reciprocated = edge_is_mutual()) |> 
  filter(reciprocated == TRUE) |>
  autograph()


## ----filter_component----------------------------------------------------------------------------------
dlt1_network |>
  activate(nodes) |>
  filter(strong_component == 1) |>
  autograph()


## ----clique_number-------------------------------------------------------------------------------------
clique_num(dlt1_network)


## ----cliques-------------------------------------------------------------------------------------------
cliques(dlt1_network, min = 8, max = NULL)


## ----edge_betweenness----------------------------------------------------------------------------------
dlt1_network <- dlt1_network |>
  morph(to_undirected) |>
  activate(nodes) |>
  mutate(sub_group = group_edge_betweenness()) |>
  unmorph()

dlt1_network |>
  as_tibble()


## ----group_count---------------------------------------------------------------------------------------
dlt1_network |>
  activate(nodes) |>
  as_tibble() |>
  group_by(sub_group) |>
  summarise(count = n()) |>
  arrange(desc(count))


## ----to_undirected-------------------------------------------------------------------------------------
dlt1_undirected <-  to_undirected(dlt1_network)

dlt1_undirected


## ----group_nodes---------------------------------------------------------------------------------------
# YOUR CODE HERE



## ----local_size----------------------------------------------------------------------------------------
dlt1_network <- dlt1_network |>
  activate(nodes) |>
  mutate(size = local_size())

dlt1_network |> 
  as_tibble() |>
  arrange(desc(size)) |> 
  select(uid, facilitator, size)


## ----centrality_degree---------------------------------------------------------------------------------
dlt1_network <- dlt1_network |>
  activate(nodes) |>
  mutate(in_degree = centrality_degree(mode = "in"),
         out_degree = centrality_degree(mode = "out"))
  
dlt1_network |> 
  as_tibble()


## ----geom_histogram------------------------------------------------------------------------------------
dlt1_network |> 
  as_tibble() |>
  ggplot() +
  geom_histogram(aes(x = out_degree))


## ----skimr---------------------------------------------------------------------------------------------
dlt1_network |> 
  as_tibble() |>
  skim()


## ----size_role-----------------------------------------------------------------------------------------
dlt1_network |> 
  as_tibble() |>
  filter(country == "US") |>
  group_by(role1) |>
  select(size) |>
  skim()


## ----closeness_betweenness-----------------------------------------------------------------------------
# YOUR CODE HERE



## ----create_data_product-------------------------------------------------------------------------------
# YOUR CODE HERE

