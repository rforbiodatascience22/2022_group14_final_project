# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
my_data <- read_tsv(file = "data/01_my_data.csv") #tsv


# Wrangle data ------------------------------------------------------------
my_data_clean <- 
  my_data %>% 
  drop_na() 
  


# Write data --------------------------------------------------------------
write_tsv(x = my_data_clean,
          file = "data/02_my_data_clean.tsv")