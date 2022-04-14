# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
proteomes <- read_tsv(file = "data/proteomes.tsv")
clinical <- read_tsv(file = "data/clinical.tsv")
proteins <- read_tsv(file = "data/proteins.tsv")


head(proteomes)
dim(proteomes)
# Wrangle data ------------------------------------------------------------
#Allie:
# Regex for the .TCGA [.]\d{2}TCGA"
# REgex for the names"[A-Z].-A[0-9A-Z]{3}")

my_data_clean <- 
  my_data %>% 
  drop_na() 
  


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean,
          file = "data/02_my_data_clean.tsv")