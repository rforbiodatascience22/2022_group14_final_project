# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
clinical_data <- read_tsv(file = "data/02_clinical_data.tsv")
proteome_data <- read_tsv(file = "data/02_proteome_data.tsv")

# Wrangle data ------------------------------------------------------------

# CLINICAL 
# Binarize genders, change tumor, node and metastasis numeric
clinical_data <- clinical_data %>%
  mutate(Gender = case_when(Gender == "FEMALE" ~1, 
                            Gender == "MALE" ~ 0),
         Tumor = as.numeric(str_replace(Tumor, "T", "")),
         Node = as.numeric(str_replace(Node, "N", "")),
         Metastasis = as.numeric(str_replace(Metastasis, "M", ""))) %>%
  select(., -c(`Tumor--T1 Coded`, 
               `Node-Coded`, 
               `Metastasis-Coded`,
               `Vital Status`,
               `Days to Date of Last Contact`, 
               `Days to date of Death`)) 

# Add age groups to clinical data
clinical_data <- clinical_data %>% 
  mutate(Age_groups = case_when(
    30 <= `Age at Initial Pathologic Diagnosis` &
      `Age at Initial Pathologic Diagnosis`< 40 ~ "30-40",
    40 <= `Age at Initial Pathologic Diagnosis` &
      `Age at Initial Pathologic Diagnosis` < 50 ~ "40-50",
    50 <= `Age at Initial Pathologic Diagnosis` &
      `Age at Initial Pathologic Diagnosis` < 60 ~ "50-60",
    60 <= `Age at Initial Pathologic Diagnosis` &
      `Age at Initial Pathologic Diagnosis` < 70 ~ "60-70",
    70 <= `Age at Initial Pathologic Diagnosis` &
      `Age at Initial Pathologic Diagnosis` < 80 ~ "70-80",
    `Age at Initial Pathologic Diagnosis` >= 80 ~ "80+"))


# PROTEOME
# Removing non-complete observations and create long version
prot_long_no_na <- proteome_data %>% 
  drop_na() %>% 
  pivot_longer(cols = -(`RefSeq_accession_number`), 
               names_to = "Complete TCGA ID", 
               values_to = "value")

# Pivot to wide version
prot_wide_no_na <- prot_long_no_na %>% 
  pivot_wider(names_from =`RefSeq_accession_number`, 
              values_from = "value" )

# JOIN
# Join proteome and clinical by TCGA ID, remove rows with NA
joined_data <- clinical_data %>% 
  left_join(prot_wide_no_na, 
            copy = T) %>%
  drop_na() 

# Write data --------------------------------------------------------------
write_tsv(x = joined_data,
          file = "data/03_joined_clean_aug_data.tsv")
write_tsv(x = prot_wide_no_na, 
          file = "data/03_proteome_clean_aug_data.tsv")
write_tsv(x = clinical_data, 
          file = "data/03_clinical_clean_aug_data.tsv")
