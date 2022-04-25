# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
clinical <- read_tsv(file = "data/02_clinical_data.tsv")
proteome <- read_tsv(file = "data/02_proteosome_data.tsv")


# Wrangle data ------------------------------------------------------------


# Transpose proteosome data
prot <- cbind("Complete TCGA ID" = names(proteome), t(proteome))

# Join proteosome and clinical data by "Complete TCGA ID"
data = clinical %>% left_join(prot, copy = T)




# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean_aug,
          file = "data/03_my_data_clean_aug.tsv")