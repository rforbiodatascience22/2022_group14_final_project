# Load libraries ----------------------------------------------------------
library("tidyverse")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
proteosome_data <- read_csv(file = "data/01_proteosome_data.csv") #tsv
clinical_data <- read_csv(file = "data/01_clinical_data.csv") #tsv


# Wrangle data ------------------------------------------------------------
# my_data_clean <- 
#   my_data %>% 
#   drop_na() 
#my_data <- cancerProteosom_raw # %>% ...
proteosome_data <- proteosome_data %>%
  select(., -c(gene_symbol, gene_name, RefSeq_accession_number)) #%>%
#mutate(col = str_remove(col, ".\\d+TCGA"))

# Renaming
clinical_data <- clinical_data_raw %>%
  mutate_at("Complete TCGA ID", 
            str_replace, 
            "TCGA-",
            "")

colnames(proteosome_data) <- sub(pattern = ".\\d+TCGA", 
                                 replacement = "", 
                                 x = colnames(proteosome_data), 
                                 perl = TRUE)

# Convert to numeric or binary
clinical_data <- clinical_data %>%
  mutate(Gender_bin = ifelse(Gender == "FEMALE", 1, 0),
         ER_Status_bin = ifelse(`ER Status` == "Negative", 0, 1),
         PR_Status_bin = ifelse(`PR Status` == "Negative", 0, 1),
         HER2_Final_Status_bin = ifelse(`HER2 Final Status` == "Negative", 0, 1),
         Tumor_num = as.numeric(str_replace(Tumor, "T", "")),
         Node_num = as.numeric(str_replace(Node, "N", "")),
         Metastasis_num = as.numeric(str_replace(Metastasis, "M", ""))) %>%
  select(., 
         -c(`Tumor--T1 Coded`, `Node-Coded`, `Metastasis-Coded`)) 


# Transpose proteosome data
prot <- tibble(cbind(nms = names(proteosome_data), t(proteosome_data)))
colnames(prot) = "Complete TCGA ID"

# Join data
data = clinical_data %>% left_join(prot, by = "Complete TCGA ID")
  


# Write data --------------------------------------------------------------
# write_tsv(x = my_data_clean,
#           file = "data/02_my_data_clean.tsv")
write_csv(x = clinical_data, #my_data,
          file = "data/02_clinical_data.csv") #tsv
write_csv(x = proteosome_data, #my_data,
          file = "data/02_proteosome_data.csv") #tsv