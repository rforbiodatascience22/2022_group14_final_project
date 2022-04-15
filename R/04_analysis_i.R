# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)


# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
#my_data_clean_aug <- read_tsv(file = "data/03_my_data_clean_aug.tsv")
clean_proteosome_data <- read_csv(file = "data/02_proteosome_data.csv") #tsv
clean_clinical_data <- read_csv(file = "data/02_clinical_data.csv") #tsv


# Wrangle data ------------------------------------------------------------
#my_data_clean_aug %>% ...


# Model data
#my_data_clean_aug %>% ...


# Visualise data ----------------------------------------------------------
#my_data_clean_aug %>% ...
p1 <- clean_clinical_data %>%
          ggplot(aes(x = `Age at Initial Pathologic Diagnosis`,
                     y = `PAM50 mRNA`,
                     fill = `PAM50 mRNA`)) +
          geom_boxplot() +
          theme_bw(base_size = 8,
                   base_family = "") + 
          scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) + 
          labs(title = "Boxplot over classifical of breast cancer subtypes", 
               subtitle = "by PAM50 classification system",
               fill = "PAM50 classes")

p2 <- clean_clinical_data %>%
          ggplot(aes(x = `AJCC Stage`,
                     fill = `AJCC Stage`)) +
          geom_bar() +
          theme_bw(base_size = 7,
                   base_family = "") + 
          #scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) + 
          labs(title = "Boxplot over tumor stages", ,
               fill = "AJCC Stage",
               y = "Frequency")


p3 <- clean_clinical_data %>%
          ggplot(aes(x = `Age at Initial Pathologic Diagnosis`,
                     y = `PAM50 mRNA`,
                     fill = `PAM50 mRNA`)) +
          geom_bar(width = 1,
                   stat = "identity") +
          coord_polar("y",
                      start = 0) + 
          scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) +
          theme_bw() +
          labs(y = "",
               x = "")


# Write data --------------------------------------------------------------
write_tsv(...)
ggsave(p1, path = "results", filename = "boxPlotPAM50.png")
ggsave(p2, path = "results", filename = "barPlotTumorStage.png")
ggsave(p3, path = "results", filename = "piePlotPAM50.png")
