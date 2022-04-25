# Load libraries ----------------------------------------------------------
library("tidyverse")
library("broom")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Wrangle data ------------------------------------------------------------



# Write data --------------------------------------------------------------
proteomes_raw <- read_csv(file = "data/_raw/77_cancer_proteomes_CPTAC_itraq.csv")
clinical_raw <- read_csv(file = "data/_raw/clinical_data_breast_cancer.csv")
proteins_raw <- read_csv(file = "data/_raw/PAM50_proteins.csv")


# Write data --------------------------------------------------------------
# Allie: I've just created some tsv files from the raw data and saved it in /data.
# wrangling is in the next step
# I'm not sure it the na = "NA" actually does anything here. 
write_tsv(x = proteomes_raw,
          file = "data/proteomes.tsv", na = "NA") #tsv
write_tsv(x = clinical_raw,
          file = "data/clinical.tsv", na = "NA") #tsv
write_tsv(x = proteins_raw,
          file = "data/proteins.tsv", na = "NA") #tsv

