
#loading data 

healthyProteomeDataLong <- read_tsv(file = "data/06_healthy_proteome_data_long.tsv")
pca_fit < read_tsv(file = "data/06_PCA_fit_rotation.tsv")

# Now time for K-means clustering

kmeans_data <- pca_fit %>%
  augment(healthyProteomeDataLong)

cluster1 <- kmeans_data %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = 5)

k_pca_aug1 <- cluster1 %>%
  augment(kmeans_data) %>%
  rename(Cluster1 = .cluster)

#K-means clustering round 2

cluster2 <- k_pca_aug1 %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = 5)

k_pca_aug2 <- cluster2 %>%
  augment(k_pca_aug1) %>%
  rename(Cluster2 = .cluster)


# Visualise K-means clustering data ----------------------------------------------------------


kplot1 <- k_pca_aug1 %>%
  ggplot(aes(x=.fittedPC1, y=.fittedPC2, color=Cluster1)) +
  geom_point() +
  theme(legend.position = "bottom")

kplot1

kplot2 <- k_pca_aug2 %>%
  ggplot(aes(x=.fittedPC1, y=.fittedPC2, color=Cluster2)) +
  geom_point() +
  theme(legend.position = "bottom")

kplot2
