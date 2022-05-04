# Load libraries ----------------------------------------------------------
library("tidyverse")
library("cluster")
library("tidymodels")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
pca_fit

# Load data ---------------------------------------------------------------
#my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")
joined_aug_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") #tsv
clean_joined_data_healthy_t <- read_tsv(file = "data/03_clean_joined_data_healthy_t.tsv") #tsv

# Wrangle data ------------------------------------------------------------
#my_data_clean_aug %>% ...

# Model data --------------------------------------------------------------
#K-means clustering round 1

head(pca_fit)

cluster1 <- pca_fit %>%
  select(contains("PC")) %>%
  kmeans(centers = 5)

View(pca_fit)

k_pca_aug1 <- cluster1 %>%
  augment(pca_fit) %>%
  rename(Cluster1 = .cluster)

pca_fit

#K-means clustering round 2

cluster2 <- k_pca_aug1 %>%
  select(PC) %>%
  kmeans(centers = 5)

k_pca_aug2 <- cluster2 %>%
  augment(k_pca_aug1) %>%
  rename(Cluster2 = .cluster)

View(k_pca_aug2)

# Visualise data ----------------------------------------------------------
#my_data_clean_aug %>% ...
pca_fit_data %>%
  augment(clean_joined_data_healthy_t) %>% 
  
kplot1 <- k_pca_aug1 %>%
  ggplot(aes(x=value, y= color=.cluster1)) +
  geom_point() +
  theme(legend.position = "bottom")

kplot1

kplot2 <- k_pca_aug2 %>%
  ggplot(aes(x=.fittedPC1, y=.fittedPC2, color=.cluster2)) +
  geom_point() +
  theme(legend.position = "bottom")

kplot2

# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(...)