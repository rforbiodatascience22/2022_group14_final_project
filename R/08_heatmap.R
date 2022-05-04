rm(list = ls())
# Load libraries ----------------------------------------------------------
library(tidyverse)
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)
library(dplyr)
library(patchwork)

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
clean_joined_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") 
clean_proteome_data <- read_tsv(file = "data/03_proteome_clean_aug_data.tsv") 
clean_clinical_data <- read_tsv(file = "data/03_clinical_clean_aug_data.tsv") 

# Take inspiration from literature and look at these specific breast cancer genes
# PTEN = NP_000305 
# PIK3CA = NP_006209
# CHEK2 = NP_009125 
# GATA3 = NP_001002295
# PGR = NP_000917 
# ERBB2 = NP_004439

# Extracting the cancer genes
cancer_genes <- clean_joined_data %>% 
  select (`Complete TCGA ID`,
          `PAM50 mRNA`, 
          Tumor, 
          `AJCC Stage`, 
          NP_000305,
          NP_006209,
          NP_009125,
          NP_001002295, 
          NP_000917, 
          NP_004439) %>% 
  rename("PTEN" = NP_000305, 
         "PIK3CA" = NP_006209, 
         "CHEK2" = NP_009125,
         "GATA3" = NP_001002295,
         "PGR" = NP_000917, 
         "ERBB2" = NP_004439) %>% 
  pivot_longer(cols = c("PTEN", 
                        "PIK3CA",
                        "CHEK2",
                        "GATA3",
                        "PGR",
                        "ERBB2"), 
               names_to = "Gene", 
               values_to = "Expression level")


# Heatmap stratified on PAM50.
heatmap_pam50 <- cancer_genes %>% 
  ggplot(mapping = aes(x = Gene,
                       y = `Complete TCGA ID`,
                       fill = `Expression level`)) +
  geom_raster() + 
  scale_fill_gradient2(low = "navyblue",
                       mid = "white",
                       high = "firebrick",
                       name = "Expression (log2)") +
  facet_grid(`PAM50 mRNA`~., scales = "free") +
  theme_minimal(base_size = 3) +
  theme(axis.text.y = element_blank(),
        strip.text.y = element_text(size = 5),
        panel.spacing.y = unit(0.3, "cm")) +
  labs(title = "Heatmap of changes in protein expression level",
       subtitle = "Based on cancer genes, stratified on PAM50 tumor class",
       x = "Breast cancer related genes",
       y= "")


# Heatmap stratified on tumour amount
heatmap_tumor <- cancer_genes %>% 
  ggplot(mapping = aes(x = Gene,
                       y = `Complete TCGA ID`,
                       fill = `Expression level`)) +
  geom_raster() + 
  scale_fill_gradient2(low = "navyblue",
                       mid = "white",
                       high = "firebrick",
                       name = "Expression (log2)") +
  facet_grid(`Tumor` ~., scales = "free") +
  theme_minimal(base_size = 4) +
  theme(axis.text.y = element_blank(),
        strip.text.y = element_text(size = 8),
        panel.spacing.y = unit(0.3, "cm")) +
  labs(title = "Heatmap of changes in protein expression level",
       subtitle = "Based on common cancer genes, stratified on tumor numbers",
       x = "Breast cancer related genes",
       y= "")


# Write data --------------------------------------------------------------
ggsave(heatmap_pam50, path = "results", filename = "heatmapPAM50.png")
ggsave(heatmap_tumor, path = "results", filename = "heatmapTumor.png")
