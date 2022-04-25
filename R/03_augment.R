# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------

clinical_data <- read_tsv(file = "data/02_clinical_data.tsv")
proteome <- read_tsv(file = "data/02_proteosome_data.tsv")


# Wrangle data ------------------------------------------------------------


# Transpose proteosome data
prot <- cbind("Complete TCGA ID" = names(proteome), t(proteome))

# Join proteosome and clinical data by "Complete TCGA ID"
data = clinical %>% left_join(prot, copy = T)



# Adding Age groups to data
clinical_data <- clinical_data %>% 
  mutate(Age_groups = case_when(
    30 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis`< 40 ~ "30-40",
    40 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 50 ~ "40-50",
    50 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 60 ~ "50-60",
    60 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 70 ~ "60-70",
    70 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 80 ~ "70-80",
    `Age at Initial Pathologic Diagnosis` >= 80 ~ "80+"))


# Augment data ---------------------------------------------------------



# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_aug,
          file = "data/03_my_data_clean_aug.tsv")