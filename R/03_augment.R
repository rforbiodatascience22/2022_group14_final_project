# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------

clinical_data <- read_tsv(file = "data/02_clinical_data.tsv")
#proteome <- read_tsv(file = "data/02_proteosome_data.tsv")
proteome_data <- read_tsv(file = "data/02_proteome_data.tsv")



# Wrangle data ------------------------------------------------------------

# Transpose proteosome data
prot <- cbind("Complete TCGA ID" = names(proteome_data), t(proteome_data))

# Join proteosome and clinical data by "Complete TCGA ID"
data = clinical %>% left_join(prot, copy = T)



# Adding Age groups to data

# CLINICALS DATA 
# Binarize genders and HER2 stores, tumor, node and metastasis change to numeric
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
               `Metastasis-Coded`,
               `Vital Status`,
               `Days to Date of Last Contact`, 
               `Days to date of Death`)) 

# Add age groups to clinical data
clinical_data <- clinical_data %>% 
  mutate(Age_groups = case_when(
    30 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis`< 40 ~ "30-40",
    40 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 50 ~ "40-50",
    50 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 60 ~ "50-60",
    60 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 70 ~ "60-70",
    70 <= `Age at Initial Pathologic Diagnosis` & `Age at Initial Pathologic Diagnosis` < 80 ~ "70-80",
    `Age at Initial Pathologic Diagnosis` >= 80 ~ "80+"))



# Augment data ---------------------------------------------------------


# PROTEOMES DATA
# Transpose proteosome data
prot <- proteome_data %>% 
  pivot_longer(cols = -c("RefSeq_accession_number"), 
               names_to = "Complete TCGA ID", 
               values_to = "value")

prot <- prot %>% 
  pivot_wider(names_from ="RefSeq_accession_number", 
              values_from = "value" )

# Until here the number is 


# JOINED DATA 
# Join proteosome and clinical data by "Complete TCGA ID"
joined_data = clinical_data %>% left_join(prot, copy = T)


## Extract healthy rows
healthy_rows <- prot %>%
  slice_tail(n = 3)
  
## Add healthy data rows to joined data
joined_data_healthy <- joined_data %>%
  add_row(healthy_rows)



#view(joined_data)
#by row 
#all v-type colums 
#  if all == NA 
#    then rm 

data_coloumns <- joined_data %>% 
  select(matches("NP_\\d+")) %>%
  colnames()


#to check
temp <- joined_data %>% select(data_coloumns) %>% filter(.,rowSums(is.na(.)) !=ncol(.))


clean_joined_data <- joined_data %>% drop_na("NP_958782")
clean_joined_data_healthy <- joined_data_healthy %>% drop_na("NP_958782")

# Write data --------------------------------------------------------------
write_tsv(x = clean_joined_data,
          file = "data/03_joined_clean_aug_data.tsv")

write_tsv(x = clean_joined_data_healthy,
          file = "data/03_joined_clean_aug_data_healthy.tsv")




