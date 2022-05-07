# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)

#Load data ---------------------------------------------------------------
healthyProteomeDataLong <- read_tsv(file = "data/06_healthy_proteome_data_long.tsv")
pca_fit < read_tsv(file = "data/06_PCA_fit_rotation.tsv")

# K-means clustering
kmeans_data <- pca_fit %>%
  augment(healthyProteomeDataLong)

cluster1 <- kmeans_data %>%
  select(.fittedPC1,
         .fittedPC2) %>%
  kmeans(centers = 3)


k_pca_aug1 <- cluster1 %>%
  augment(kmeans_data) %>%
  rename(Cluster1 = .cluster)

#K-means clustering round 2
cluster2 <- k_pca_aug1 %>%
  select(.fittedPC1,
         .fittedPC2) %>%
  kmeans(centers = 3)


k_pca_aug2 <- cluster2 %>%
  augment(k_pca_aug1) %>%
  rename(Cluster2 = .cluster)


# Visualise K-means clustering data ----------------------------------------------------------
kplot1 <- k_pca_aug1 %>%
  ggplot(aes(x = .fittedPC1, 
             y =.fittedPC2, 
             color=Cluster1)) +
    geom_point(size = 0.2) +
  xlab("PC1") + 
  ylab("PC2") +
  #coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12) + 
  guides(color = FALSE, 
         size = FALSE) +
  theme(axis.text.x = element_text(size = 7),
      axis.text.y = element_text(size = 7))  



kplot1

kplot2 <- k_pca_aug2 %>%
  ggplot(aes(x = .fittedPC1, 
             y =.fittedPC2, 
             color=Cluster2)) +
    geom_point(size = 0.1) +
  labs(y="PC2", x="PC1") +
    theme(legend.position = "None")

kplot2

ggsave(kplot1, path = "/cloud/project/results", filename = "kplot1.png")
ggsave(kplot2, path = "/cloud/project/results", filename = "kplot2.png")
