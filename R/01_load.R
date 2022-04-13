# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
cancerProteosom_raw <- read_tsv(file = "data/_raw/77_cancer_proteomes_CPTAC_itraq.csv")
clinicalData_raw <- read_tsv(file = "data/_raw/clinical_data_breast_cancer.csv")
PAMproteins_raw <- read_tsv(file = "data/_raw/PAM50_proteins.csv")


# Wrangle data ------------------------------------------------------------
my_data <- my_data_raw # %>% ...


# Write data --------------------------------------------------------------
write_tsv(x = my_data,
          file = "data/01_my_data.tsv")