# Shaun Kellogg
# SNA Lab 1 
# July 18, 2023 


# PREPARE #########################

library(readxl)

## Load Packages #### 

# YOUR CODE HERE
library(tidygraph)
library(ggraph)

student_nodes <- read_excel("lab-1/data/student-attributes.xlsx")
student_edges <- read_excel("lab-1/data/student-edgelist.xlsx")

# WRANGLE #######

# create a network object 

student_network <- tbl_graph(edges = student_edges,
                             nodes = student_nodes, 
                             directed = TRUE)

my_sum <-9 + 9


student_network


plot(student_network)

autograph(student_network)

autograph(student_network,
          node_label = id,
          node_colour = gender)


ggraph(student_network)


ggraph(student_network) + 
  geom_node_point()

ggraph(student_network) + 
  geom_node_point() + 
  geom_edge_link()


ggraph(student_network, layout = "stress") + 
  geom_edge_link(arrow = arrow(length = unit(1, 'mm')), 
                 end_cap = circle(3, 'mm'),
                 start_cap = circle(3, 'mm'),
                 alpha = .1) +
  geom_node_point(aes(size = local_size(),
                      color = gender)) +
  geom_node_text(aes(label = id),
                 repel=TRUE) +
  theme_graph()


