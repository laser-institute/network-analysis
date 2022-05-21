## ----setup, include=FALSE-------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ---- echo=FALSE----------------------------------------------------------
# then load all the relevant packages
pacman::p_load(pacman, knitr, tidyverse, readxl)


## ----xaringan-panelset, echo=FALSE----------------------------------------
xaringanExtra::use_panelset()


## ----xaringanExtra-clipboard, echo=FALSE----------------------------------
# these allow any code snippets to be copied to the clipboard so they 
# can be pasted easily
htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i>",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i>",
  ),
  rmarkdown::html_dependency_font_awesome()
)

## ----xaringan-extras, echo=FALSE------------------------------------------
xaringanExtra::use_tile_view()



## ----node-list, echo=FALSE, message=FALSE, warning=FALSE------------------
dlt1_nodes <- read_csv("data/dlt1-nodes.csv")

dlt1_nodes |>
  head() |>
  select(UID, role1, experience, region) |>
  kable()


## ----edge-list, echo=FALSE, message=FALSE, warning=FALSE------------------
dlt1_edges <- read_csv("data/dlt1-edges.csv")

dlt1_edges |>
  head() |>
  select(Sender, Receiver, Timestamp) |>
  kable()


## ----adjaency-matrix, echo=FALSE, message=FALSE, warning=FALSE------------

year_1_collaboration <- read_excel("data/year_1_collaboration.xlsx", 
                                   col_names = FALSE)

year_1_matrix <- as.matrix(year_1_collaboration)

rownames(year_1_matrix) <- 1:43

colnames(year_1_matrix) <- 1:43

year_1_matrix[1:8, 1:8]


## ----load-libraries, message=TRUE, echo=TRUE, message=FALSE---------------
library(readxl)
library(tidyverse)
library(tidygraph)
library(ggraph)


## ---- echo=FALSE, message=FALSE-------------------------------------------
library(igraph)


## ----load-igraph, echo=TRUE-----------------------------------------------
# YOUR CODE HERE




## ----import-data, echo=TRUE, message=FALSE--------------------------------
year_1_collaboration <- read_excel("data/year_1_collaboration.xlsx", 
                                   col_names = FALSE)


## ----inspect-data, echo=TRUE----------------------------------------------
# ADD CODE BELOW
#
#



## ----wrangle-data, echo=TRUE, message=FALSE, warning=FALSE----------------

year_1_matrix <- as.matrix(year_1_collaboration)

rownames(year_1_matrix) <- 1:43

colnames(year_1_matrix) <- 1:43


year_1_network <- as_tbl_graph(year_1_matrix, directed = TRUE)



## ----view-netwok, echo=TRUE-----------------------------------------------
# ADD CODE BELOW
#
#



## ----density, echo=TRUE---------------------------------------------------
edge_density(year_1_network)


## ----examine-density, strip.white=TRUE, echo=FALSE------------------------
autograph(year_1_network) +
  theme_graph()


## ----centrality, echo=TRUE------------------------------------------------
centr_degree(year_1_network, mode = "all")


## ----examine-centrality, strip.white=TRUE, echo=FALSE---------------------
autograph(year_1_network) +
  theme_graph()


## ----reciprocity, echo=TRUE-----------------------------------------------
reciprocity(year_1_network)

