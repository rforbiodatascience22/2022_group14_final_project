# Load libraries ----------------------------------------------------------
library("tidyverse")
library("cluster")
library("tidymodels")

set.seed(27)


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")
pca_fit <- read_tsv(file = "data/04_PCA_fit_rotation.tsv") #tsv


# Load data ---------------------------------------------------------------
#my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")
joined_aug_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") #tsv
clean_proteosome_data <- read_tsv(file = "data/03_proteome_clean_aug_data.tsv") #tsv
clean_clinical_data <- read_tsv(file = "data/03_clinical_clean_aug_data.tsv") #tsv

clean_joined_data_healthy_t <- read_tsv(file = "data/03_clean_joined_data_healthy_t.tsv") #tsv



head(clean_proteosome_data)

# Wrangle data ------------------------------------------------------------
#my_data_clean_aug %>% ...

# Model data --------------------------------------------------------------
#K-means clustering round 1

pca_aug <- pca_fit %>%
  augment(clean_proteosome_data)

View(pca_aug)


km = kmeans(pca_fit$value, centers = 6)
plot(pca_fit$value, col = km$cluster)
points(km$centers, col = 1:2, pch = 8, cex = 2)

km = kmeans(clean_joined_data_healthy_t[1:20], centers = 4)
plot(clean_joined_data_healthy_t[1:20], col = km$cluster)
points(km$centers, col = 1:2, pch = 8, cex = 2)



cluster1 <- pca_fit %>%
  select(contains("PC")) %>%
  kmeans(centers = 3)

#K-means clustering round 2

k_pca_aug1 <- cluster1 %>%
  augment(pca_fit) %>%
  rename(.cluster1 = .cluster)

cluster2 <- k_pca_aug1 %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = 3)

k_pca_aug2 <- cluster2 %>%
  augment(k_pca_aug1) %>%
  rename(.cluster2 = .cluster)

View(k_pca_aug2)

# Visualise data ----------------------------------------------------------
#my_data_clean_aug %>% ...
pca_fit %>%
  augment(clean_joined_data_healthy_t) %>% 
  
kplot1 <- k_pca_aug1 %>%
  ggplot(aes(x=.fittedPC1, y=.fittedPC2, color=.cluster1)) +
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