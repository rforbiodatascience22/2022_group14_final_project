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
               gene_name, 
               RefSeq_accession_number))


# CLINICALS FILE 
# Renaming column values
clinical_data <- clinical %>%
  mutate_at("Complete TCGA ID", 
            str_replace, 
            "TCGA-",
            "")

# Convert to numeric or binary
clinical_data <- clinical_data %>%
  mutate(Gender = case_when(Gender == "FEMALE" ~1, #Binarize
                            Gender == "MALE" ~ 0),
         HER2_binary = case_when(`HER2 Final Status` == "Negative" ~ 0,
                                 `HER2 Final Status` == "Positive" ~ 1), #This adds NA for equivocal
         Tumor = as.numeric(str_replace(Tumor, "T", "")),
         Node = as.numeric(str_replace(Node, "N", "")),
         Metastasis = as.numeric(str_replace(Metastasis, "M", ""))) %>%
  select(., -c(`Tumor--T1 Coded`, 
               `Node-Coded`, 
               `Metastasis-Coded`)) 

view(clinical_data)


# Write data --------------------------------------------------------------
write_tsv(x = clinical_data, #my_data,
          file = "data/02_clinical_data.tsv") #tsv
write_tsv(x = proteosome_data, #my_data,
          file = "data/02_proteosome_data.tsv") #tsv
