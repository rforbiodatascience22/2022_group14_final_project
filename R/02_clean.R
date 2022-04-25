# Load libraries ----------------------------------------------------------
library("tidyverse")
library("dplyr")


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
proteomes <- read_tsv(file = "data/proteomes.tsv")
clinical <- read_tsv(file = "data/clinical.tsv")
proteins <- read_tsv(file = "data/proteins.tsv")


# Cleaning Data ------------------------------------------------------------

### Proteosome Files
# Remove first 3 columns in proteosomes file 
proteosome_data <- proteomes %>%
  select(., -c(gene_symbol, 
               gene_name, 
               RefSeq_accession_number)) 

# Renaming columns 
colnames(proteosome_data) <- sub(pattern = ".\\d+TCGA", 
                                 replacement = "", 
                                 x = colnames(proteosome_data), 
                                 perl = TRUE)

### Clinical Data Files 
# Renaming column values
clinical_data <- clinical %>%
  mutate_at("Complete TCGA ID", 
            str_replace, 
            "TCGA-",
            "")

# Convert to numeric or binary
clinical_data <- clinical_data %>%
  mutate(Gender = if_else(Gender == "FEMALE", 1, 0),
         ER_Status_bin = if_else(`ER Status` == "Negative", 0, 1),
         `PR Status` = if_else(`PR Status` == "Negative", 0, 1),
         `HER2 Final Status` = if_else(`HER2 Final Status` == "Negative", 0, 1),
         Tumor = as.numeric(str_replace(Tumor, "T", "")),
         Node = as.numeric(str_replace(Node, "N", "")),
         Metastasis = as.numeric(str_replace(Metastasis, "M", ""))) %>%
  select(., -c(`Tumor--T1 Coded`, 
               `Node-Coded`, 
               `Metastasis-Coded`)) 

view(clinical_data)

# Transpose proteosome data
prot <- tibble(cbind(nms = names(proteosome_data), t(proteosome_data)))
colnames(prot) = "Complete TCGA ID"

# Join data
data = clinical_data %>% left_join(prot, by = "Complete TCGA ID")


# Write data --------------------------------------------------------------
write_tsv(x = clinical_data, #my_data,
          file = "data/02_clinical_data.tsv") #tsv
write_tsv(x = proteosome_data, #my_data,
          file = "data/02_proteosome_data.tsv") #tsv

# write_tsv(x = my_data_clean,
#           file = "data/02_my_data_clean.tsv")
# write_csv(x = clinical_data, #my_data,
#           file = "data/02_clinical_data.csv") #tsv
# write_csv(x = proteosome_data, #my_data,
#           file = "data/02_proteosome_data.csv") #tsv
