# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)
library("dplyr")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")

# Load data ---------------------------------------------------------------
clean_joined_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") 
clean_proteome_data <- read_tsv(file = "data/03_proteome_clean_aug_data.tsv") 
clean_clinical_data <- read_tsv(file = "data/03_clinical_clean_aug_data.tsv") 
proteins <- read_tsv(file = "data/proteins.tsv")

# Take inspiration from litrature and look at these spoecific breast cancer genes
# TP53 = NP_000537
# PIK3CA
# GATA3 = NP_001002295
# ESR1
# PGR = NP_000917
# ERBB2 = NP_004439 ( her- 2)


