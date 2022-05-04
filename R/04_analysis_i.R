# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)

# Define functions --------------------------------------------------------
source(file = "R/99_project_functions.R")


# Load data ---------------------------------------------------------------
clean_joined_data <- read_tsv(file = "data/03_joined_clean_aug_data.tsv") #tsv
clean_proteosome_data <- read_tsv(file = "data/02_proteome_data.tsv") #tsv
clean_clinical_data <- read_tsv(file = "data/02_clinical_data.tsv") #tsv

clean_joined_data_heathy <- read_tsv(file = "data/03_joined_clean_aug_data_healthy.tsv")

# Visualise data ----------------------------------------------------------
p1 <- clean_joined_data %>%
          ggplot(aes(x = `Age at Initial Pathologic Diagnosis`,
                     y = `PAM50 mRNA`,
                     fill = `PAM50 mRNA`)) +
          geom_boxplot() +
          theme_bw(base_size = 8,
                   base_family = "") + 
          scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) + 
          labs(title = "Boxplot over classification of breast cancer subtypes", 
               subtitle = "by PAM50 classification system",
               fill = "PAM50 classes")
p1

p2 <- clean_clinical_data %>%
          ggplot(aes(x = `AJCC Stage`,
                     fill = `AJCC Stage`)) +
          geom_bar() +
          theme_bw(base_size = 7,
                   base_family = "") + 
          #scale_fill_manual(values = c("darkred", "red", "orange", "yellow")) + 
          labs(title = "Boxplot over tumor stages",
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
  scale_fill_manual(values = c("darkred", 
                               "red", 
                               "orange", 
                               "yellow")) +
  labs(y = "",
       x = "")


p4 <- clean_joined_data %>% 
  ggplot(aes(x = reorder(Age_groups, 
                         Age_groups, 
                         function(x)-length(x)), 
             fill = `PAM50 mRNA`)) +
  geom_bar() + 
  scale_fill_hue(c=45,
                 l=80) +
  labs(title = "Cancer subtyped on PAM50 mRNA",
       y = "Frequency",
       x = "Age Group") + 
  theme(axis.text.x = element_text(size = 7),
        axis.text.y = element_text(size = 7))
p4



p5 <- clean_joined_data %>% 
  ggplot(aes(x = `AJCC Stage`, 
             fill = as.factor(Tumor))) +
  geom_bar() + 
  scale_fill_hue(c = 45,
                 l = 80) +
  theme(axis.text.x = element_text(size = 7),
        axis.text.y = element_text(size = 7)) + 
  scale_fill_hue(c = 45,
                 l = 80) +
  labs(title = "Number of tumors in different AJCC stages",
       y = "Frequency",
       x = "AJCC stage",
       fill = "No. of tumors")
p5



# Save plots --------------------------------------------------------------
ggsave(p1, path = "results", filename = "boxPlotPAM50.png")
ggsave(p2, path = "results", filename = "barPlotTumorStage.png")
ggsave(p3, path = "results", filename = "piePlotPAM50.png")
ggsave(p4, path = "results", filename = "barPlotAgeGroupPAM50.png")
ggsave(p5, path = "results", filename = "barPlotAJJCTumor.png")




# PCA ---------------------------------------------------------------------

# Take data set - make it long (pivot_longer)
# group by the columns names "NP_"
# Take fraction of NA in each groups
#   Look at the fraction
#   Pull the groups that has a specific fraction/criteria
#   Get the names of these
# 
#   Pull those columns from the original data set
#   drop NA from these


#a test adding the healthy individuals 
  
pca_healthy_fit <- clean_joined_data_heathy %>% 
  select(starts_with("NP_")) %>% 
  drop_na() %>%
  prcomp(scale=TRUE) # do PCA on scaled data


pca_fit <- clean_proteosome_data %>% 
  select(where(is.numeric)) %>% # retain only numeric columns
  #select(1:20) %>%
  drop_na() %>%
  prcomp(scale=TRUE) # do PCA on scaled data


# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# plot rotation matrix
pcaArrowPlot <- pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "#904C2F", 
    size = 2.25
  ) +
  xlim(-0.3, 0.05) + ylim(-0.25, 0.25) +
  coord_fixed()# + # fix aspect ratio to 1:1
  #theme_minimal_grid(12)
pcaArrowPlot


pcaFit <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#56B4E9", alpha = 0.8) +
  scale_x_continuous(breaks = 1:length(pca_fit$sdev)) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  labs(title = "Variance explained by each PC",
       y = "Percent",
       x = "PC") +
  theme(axis.text.x = element_text(size = 5),
        axis.text.y = element_text(size = 5)) + 
  scale_fill_hue(c = 45,
                 l = 80) 
pcaFit

# Save plots --------------------------------------------------------------
ggsave(pcaArrowPlot, path = "results", filename = "pcaRotationMatrix.png")
ggsave(pcaFit, path = "results", filename = "pcaFit.png")





# clean_proteosome_data <- clean_proteosome_data %>%
#   drop_na()
# 
# pca_fit %>%
#   augment(proteome_data) %>% # add original dataset back in
#   ggplot(aes(.fittedPC1, .fittedPC2)) + 
#   geom_point(size = 0.7) +
#   # scale_color_manual(
#   #   values = c(malignant = "#D55E00", benign = "#0072B2")
#   # ) +
#   theme_half_open(12) + background_grid()