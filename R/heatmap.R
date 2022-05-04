# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)
library("dplyr")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
clean_joined_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") 
clean_proteome_data <- read_tsv(file = "data/03_proteome_clean_aug_data.tsv") 
clean_clinical_data <- read_tsv(file = "data/03_clinical_clean_aug_data.tsv") 
proteins <- read_tsv(file = "data/proteins.tsv")
view(clean_joined_data)

# Take inspiration from litrature and look at these spoecific breast cancer genes
# PTEN = NP_000305 exist
# PIK3CA = NP_006209 exist
# CHEK2 = NP_009125 exist
# GATA3 = NP_001002295 exist
# PGR = NP_000917 exist
# ERBB2 = NP_004439 ( her- 2) exist


cancer_genes <- clean_joined_data %>% 
  select (`Complete TCGA ID`,
          `PAM50 mRNA`, 
          Tumor, 
          NP_000305,
          NP_006209,
          NP_009125,
          NP_001002295, 
          NP_000917 , 
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


cancer_genes %>% 
  ggplot(mapping = aes(x = Gene,
                       y = `Complete TCGA ID`,
                       fill = `Expression level`)) +
  geom_raster() +
  scale_fill_gradient2(low = "#075AFF", mid = "white", high = "#FF0000", ) +
  facet_grid(`PAM50 mRNA`~., scales = "free") +
  theme_minimal() +
  theme(axis.text = element_blank())


