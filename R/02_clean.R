# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
proteomes <- read_tsv(file = "data/proteomes.tsv")
clinical <- read_tsv(file = "data/clinical.tsv")
proteins <- read_tsv(file = "data/proteins.tsv")

# Cleaning Data ------------------------------------------------------------

# PROTEOMES FILE
# Remove first 3 columns, rename the columns and remove duplicate columns
proteome_data <- proteomes %>% #We remove the names cause this just doesn't fit with our shit
  select(-c("AO-A12D.05TCGA", #Duplicate names
            "C8-A131.32TCGA",
            "AO-A12B.34TCGA")) %>%
  rename_with( ~ str_replace_all(.,"\\..{6}","")) %>% 
  select(., -c(gene_symbol, 
               gene_name))

# CLINICALS FILE 
# Renaming column values
clinical_data <- clinical %>%
  mutate_at("Complete TCGA ID", 
            str_replace, "TCGA-","")


# Write data --------------------------------------------------------------
write_tsv(x = clinical_data, 
          file = "data/02_clinical_data.tsv")
write_tsv(x = proteome_data,
          file = "data/02_proteome_data.tsv")
