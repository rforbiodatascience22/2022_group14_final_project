# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)



# Load data ---------------------------------------------------------------
clean_joined_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") #tsv
clean_joined_data_healthy <- read_tsv(file = "data/03_clinical_clean_aug_data_healthy.tsv")
clean_proteosome_data <- read_tsv(file = "data/02_proteosome_data.tsv") #tsv
clean_clinical_data <- read_tsv(file = "data/02_clinical_data.tsv") #tsv

# Exploring the data ------------------------------------------------------
# Number of columns and rows
nrow(clean_joined_data) #77 observations
ncol(clean_joined_data) #12579 variables

# Amount of individuals in each age group
clean_joined_data %>% 
  group_by(Age_groups) %>% 
  count()

# Gender data
clean_joined_data %>%
  count(Gender)

# Survival rate
clean_joined_data %>% count(`OS event`)

# Visualise data ----------------------------------------------------------


age_subtype_plot <- clean_joined_data %>% 
  ggplot(mapping = aes(x=reorder(Age_groups, Age_groups, function(x)-length(x)), fill = `PAM50 mRNA`)) +
  geom_bar() + 
  scale_fill_hue(c=45,l=80)+
  labs(title = "Barplot of cancer subtyped on PAM50 mRNA",
       y = "Frequency",
       x = "Age Group")

tumor_amount_stage_plot <- clean_joined_data %>% 
  ggplot(mapping = aes(x= `AJCC Stage`, fill = as.factor(Tumor))) +
  geom_bar() + 
  scale_fill_hue(c=45,l=80)+
  labs(title = "Barplot of Tumor amount in different AJCC stages",
       y = "Frequency",
       x = "AJCC stage",
       fill = "Tumor amount")

#checking relation between tumor amount and PAM50 mRNA
#and there dosn't seem to be a relation 
tumor_vs_pam50 <- clean_joined_data %>% 
  ggplot(mapping = aes(x= `PAM50 mRNA`, fill = as.factor(Tumor))) +
  geom_bar()




# Write data --------------------------------------------------------------

#ggsave(age_subtype_plot, path = "results", filename = "barPlotcancersubtypedPAM50.png")
#ggsave(tumor_amount_stage_plot, path = "results", filename = "barPlotAJCCTumorAmount.png")




