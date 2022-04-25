# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------

clinical_data <- read_tsv(file = "data/02_clinical_data.tsv")
proteome_data <- read_tsv(file = "data/02_proteosome_data.tsv")


# Wrangle data ------------------------------------------------------------

# CLINICALS DATA 
#Binarize genders and HER2 stores, tumor, node and metastasis change to numeric
clinical_data <- clinical_data %>%
  mutate(Gender = case_when(Gender == "FEMALE" ~1, 
                            Gender == "MALE" ~ 0),
         HER2_binary = case_when(`HER2 Final Status` == "Negative" ~ 0,
                                 `HER2 Final Status` == "Positive" ~ 1), #This adds NA for equivocal
         Tumor = as.numeric(str_replace(Tumor, "T", "")),
         Node = as.numeric(str_replace(Node, "N", "")),
         Metastasis = as.numeric(str_replace(Metastasis, "M", ""))) %>%
  select(., -c(`Tumor--T1 Coded`, 
               `Node-Coded`, 
               `Metastasis-Coded`)) 

# Add age groups to clinical data
clinical_data <- clinical_data %>% 
  mutate(Age_groups = case_when(
    30 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis`< 40 ~ "30-40",
    40 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 50 ~ "40-50",
    50 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 60 ~ "50-60",
    60 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 70 ~ "60-70",
    70 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 80 ~ "70-80",
    `Age at Initial Pathologic Diagnosis` >= 80 ~ "80+"))



# PROTEOMES DATA

# Transpose proteosome data
prot <- (cbind("Complete TCGA ID" = names(proteome_data), t(proteome_data)))
view(prot)


# JOINED DATA 
# Join proteosome and clinical data by "Complete TCGA ID"
joined_data = clinical_data %>% left_join(prot, copy = T)

#view(joined_data)
#by row 
#all v-type colums 
#  if all == NA 
#    then rm 

#data_coloumns <- joined_data %>% 
#  select(matches("V\\d+")) %>%
#  colnames()

#here we need to fix that V3 dosn't represent all the genes
#and alone decides if the row goes out 
cleaned_joined_data <- joined_data %>% drop_na("V3")

    
# Adding Age groups to data

# Augment data ---------------------------------------------------------



# Write data --------------------------------------------------------------
write_tsv(x = cleaned_joined_data,
          file = "data/03_joined_clean_aug_data.tsv")
