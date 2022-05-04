# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
clean_joined_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") #tsv
clean_joined_data_healthy <- read_tsv(file = "data/03_clinical_clean_aug_data_healthy.tsv")
clean_proteosome_data <- read_tsv(file = "data/02_proteosome_data.tsv") #tsv
clean_clinical_data <- read_tsv(file = "data/02_clinical_data.tsv") #tsv

# Exploring the data ------------------------------------------------------
# Number of columns and rows
nrow(clean_joined_data) #77 observations
ncol(clean_joined_data) #12579 variables

# Amount of individuals in each age group
clean_joined_data %>% 
  group_by(Age_groups) %>% 
  count()

# Gender data
clean_joined_data %>%
  count(Gender)

# Survival rate
clean_joined_data %>% count(`OS event`)

# Visualise data ----------------------------------------------------------
p1 <- clean_joined_data %>%
          ggplot(aes(x = `Age at Initial Pathologic Diagnosis`,
                     y = `PAM50 mRNA`,
                     fill = `PAM50 mRNA`)) +
          geom_boxplot() +
          theme_bw(base_size = 8,
                   base_family = "") + 
          scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) + 
          labs(title = "Boxplot over classification of breast cancer subtypes", 
               subtitle = "by PAM50 classification system",
               fill = "PAM50 classes")

p2 <- clean_clinical_data %>%
          ggplot(aes(x = `AJCC Stage`,
                     fill = `AJCC Stage`)) +
          geom_bar() +
          theme_bw(base_size = 14,
                   base_family = "") +
          scale_x_discrete(guide = guide_axis(angle = 45))+
          #scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) + 
          labs(title = "Barplot over tumor stages", ,
               fill = "AJCC Stage",
               y = "Frequency")

p3 <- clean_clinical_data %>%
          ggplot(aes(x = `Age at Initial Pathologic Diagnosis`,
                     y = `PAM50 mRNA`,
                     fill = `PAM50 mRNA`)) +
          geom_bar(width = 1,
                   stat = "identity") +
          coord_polar("y",
                      start = 0) + 
          scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) +
          theme_bw() +
          labs(y = "",
               x = "")

p4 <- clean_joined_data %>% 
  ggplot(mapping = aes(x=reorder(Age_groups, Age_groups, function(x)-length(x)), fill = `PAM50 mRNA`)) +
  geom_bar() + 
  scale_fill_hue(c=45,l=80)+
  labs(title = "Barplot of cancer subtyped on PAM50 mRNA",
       y = "Frequency",
       x = "Age Group")
p4
p5 <- clean_joined_data %>% 
  ggplot(mapping = aes(x= `AJCC Stage`, fill = as.factor(Tumor))) +
  geom_bar() + 
  scale_fill_hue(c=45,l=80)+
  labs(title = "Barplot of Tumor amount in different AJCC stages",
       y = "Frequency",
       x = "AJCC stage",
       fill = "Tumor amount")

#checking relation between tumor amount and PAM50 mRNA
#and there dosn't seem to be a relation 
tumor_vs_pam50 <- clean_joined_data %>% 
  ggplot(mapping = aes(x= `PAM50 mRNA`, fill = as.factor(Tumor))) +
  geom_bar()

tumor_vs_pam50

p5


# Write data --------------------------------------------------------------
#write_tsv(...)
#ggsave(p1, path = "results", filename = "boxPlotPAM50.png")
# ggsave(p2, path = "results", filename = "barPlotTumorStage.png")
# ggsave(p3, path = "results", filename = "piePlotPAM50.png")
ggsave(p4, path = "results", filename = "barPlotcancersubtypedPAM50.png")
ggsave(p5, path = "results", filename = "barPlotAJCCTumorAmount.png")


# PCA ---------------------------------------------------------------------
# First transpose data
# bla = clean_proteosome_data %>%
#   pivot_longer(cols = -(`Complete TCGA ID`), 
#                names_to = "RefSeqProteinID", 
#                values_to = "Value")
# 
# pca_fit <- bla %>% 
#   select(where(is.numeric)) %>% # retain only numeric columns
#   drop_na() %>%
#   prcomp(scale=TRUE) # do PCA on scaled data




newnames <- clean_joined_data_healthy$`Complete TCGA ID`
clean_joined_data_healthy <- clean_joined_data_healthy %>%
  select(starts_with("NP_"))
clean_joined_data_healthy_t <- as_tibble(cbind(`RefSeqProteinID` = names(clean_joined_data_healthy), t(clean_joined_data_healthy)))

# Renaming columns
#oldnames <- names(clean_joined_data_healthy_t)
names(clean_joined_data_healthy_t) = c("RefSeqProteinID", newnames)
clean_joined_data_healthy_t <- clean_joined_data_healthy_t %>%
  select(!starts_with("Ref")) %>%
  mutate_if(is.character, as.numeric) 


write_tsv(x = clean_joined_data_healthy_t,
          file = "data/03_clean_joined_data_healthy_t.tsv")
  

  

## Now time for PCA

pca_fit <- clean_joined_data_healthy_t %>% 
  select(where(is.numeric)) %>% # retain only numeric columns
  drop_na() %>%
  prcomp(scale=TRUE) # do PCA on scaled data


pca_fit %>%
  augment(clean_joined_data_healthy_t) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2)) + 
  geom_point(size = 0.7) +
  # scale_color_manual(
  #   values = c(malignant = "#D55E00", benign = "#0072B2")
  # ) +
  theme_half_open(12) + background_grid()


# define arrow style for plotting
arrow_style <- arrow(
  angle = 17.5, ends = "first", type = "closed", length = grid::unit(6, "pt")
)

# plot rotation matrix
pcaArrowPlot <- pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = c(rep("#CD0606", 77), rep("#16A205", 3)), 
    size = 2.3
  ) +
  xlim(-0.3, 0.1) + ylim(-0.25, 0.25) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12)


pcaBarPlot <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#16A205", alpha = 0.8) +
  scale_x_continuous(breaks = 1:84) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  #theme_minimal_hgrid(12) +
  labs(title = "Variance explained by each PC",
       y = "Percent",
       x = "PC") +
  theme(axis.text.x = element_text(size = 5),
        axis.text.y = element_text(size = 5)) + 
  scale_fill_hue(c = 45,
                 l = 80)


ggsave(pcaArrowPlot, path = "results", filename = "pcaRotationMatrix.png")
ggsave(pcaBarPlot, path = "results", filename = "pcaFit.png")


# Save PCA fit for clustering
#write_tsv(x =  pca_fit %>%
 #           tidy(matrix = "rotation"),
  #        file = "data/04_PCA_fit_rotation.tsv")


# Now time for K-means clustering

kmeans_data <- pca_fit %>%
  augment(clean_joined_data_healthy_t)

cluster1 <- kmeans_data %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = 5)

k_pca_aug1 <- cluster1 %>%
  augment(kmeans_data) %>%
  rename(Cluster1 = .cluster)

colnames(k_pca_aug1)

#K-means clustering round 2

cluster2 <- k_pca_aug1 %>%
  select(.fittedPC1, .fittedPC2) %>%
  kmeans(centers = 5)

k_pca_aug2 <- cluster2 %>%
  augment(k_pca_aug1) %>%
  rename(Cluster2 = .cluster)

colnames(k_pca_aug2)

# Visualise K-means clustering data ----------------------------------------------------------
#my_data_clean_aug %>% ...
  
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
