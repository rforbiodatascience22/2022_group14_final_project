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
clean_proteosome_data <- read_tsv(file = "data/02_proteosome_data.tsv") #tsv
clean_clinical_data <- read_tsv(file = "data/02_clinical_data.tsv") #tsv


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
          labs(title = "Boxplot over classification of breast cancer subtypes", 
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
#write_tsv(...)
#ggsave(p1, path = "results", filename = "boxPlotPAM50.png")
# ggsave(p2, path = "results", filename = "barPlotTumorStage.png")
# ggsave(p3, path = "results", filename = "piePlotPAM50.png")



# PCA ---------------------------------------------------------------------

pca_fit <- clean_proteosome_data %>% 
  select(where(is.numeric)) %>% # retain only numeric columns
  drop_na() %>%
  prcomp(scale=TRUE) # do PCA on scaled data

clean_proteosome_data <- clean_proteosome_data %>%
  drop_na()

pca_fit %>%
  augment(clean_proteosome_data) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2)) + 
  geom_point(size = 0.7) +
  # scale_color_manual(
  #   values = c(malignant = "#D55E00", benign = "#0072B2")
  # ) +
  theme_half_open(12) + background_grid()


# define arrow style for plotting
arrow_style <- arrow(
  angle = 20, ends = "first", type = "closed", length = grid::unit(8, "pt")
)

# plot rotation matrix
pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = "#904C2F", 
    size = 2.5
  ) +
  xlim(-0.3, 0.05) + ylim(-0.25, 0.25) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12)


pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#56B4E9", alpha = 0.8) +
  scale_x_continuous(breaks = 1:84) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  theme_minimal_hgrid(12)
