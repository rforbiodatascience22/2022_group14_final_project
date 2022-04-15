# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
proteosome_data_raw <- read_csv(file = "data/_raw/77_cancer_proteomes_CPTAC_itraq.csv")
clinical_data_raw <- read_csv(file = "data/_raw/clinical_data_breast_cancer.csv")
PAMproteins_raw <- read_csv(file = "data/_raw/PAM50_proteins.csv")


# Wrangle data ------------------------------------------------------------



# Write data --------------------------------------------------------------
write_csv(x = clinical_data, #my_data,
          file = "data/01_clinical_data.csv") #tsv
write_csv(x = proteosome_data, #my_data,
          file = "data/01_proteosome_data.csv") #tsv