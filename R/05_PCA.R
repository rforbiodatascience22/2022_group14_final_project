# Load libraries ----------------------------------------------------------
library("tidyverse")
library(ggplot2)
library(scales)
library(broom)  
library(cowplot)

# Load data ---------------------------------------------------------------
clean_joined_data_healthy <- read_tsv(file = "data/03_clinical_clean_aug_data_healthy.tsv")

# Preparing PCA data ------------------------------------------------------
# Pull names from clean joined data
newnames <- clean_joined_data_healthy %>%
  pull(`Complete TCGA ID`)

# Select NP_ columns
slice_of_joined_data <- clean_joined_data_healthy %>%
  select(starts_with("NP_"))

# Transpose dataframe
healthyProteomeDataLong <- as_tibble(cbind(`RefSeqProteinID` = names(slice_of_joined_data),
                                           t(slice_of_joined_data)))

newnames <- c("RefSeqProteinID", newnames)

healthyProteomeDataLong <- healthyProteomeDataLong %>%
  rename_with(~ newnames, 
              starts_with(c("RefSeqProteinID", 
                            'V')))

healthyProteomeDataLong <- healthyProteomeDataLong %>% 
  mutate_at(c(2:81), 
            as.numeric)


#save healthy patients proteome data file 
write_tsv(x = healthyProteomeDataLong,
          file = "data/06_healthy_proteome_data_long.tsv")


# PCA Analysis ---------------------------------------------------------------
pca_fit <- healthyProteomeDataLong %>% 
  select(where(is.numeric)) %>% 
  drop_na() %>%
  prcomp(scale=TRUE)


pca_fit %>%
  augment(healthyProteomeDataLong) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2)) + 
  geom_point(size = 0.7) +
  # scale_color_manual(
  #   values = c(malignant = "#D55E00", benign = "#0072B2")
  # ) +
  theme_half_open(12) + background_grid()


# define arrow style for plotting
arrow_style <- arrow(
  angle = 17.5, ends = "first", type = "closed", length = grid::unit(6, "pt"))

# plot rotation matrix
pcaArrowPlot <- pca_fit %>%
  tidy(matrix = "rotation") %>%
  pivot_wider(names_from = "PC", names_prefix = "PC", values_from = "value") %>%
  ggplot(aes(PC1, PC2)) +
  geom_segment(xend = 0, yend = 0, arrow = arrow_style) +
  geom_text(
    aes(label = column),
    hjust = 1, nudge_x = -0.02, 
    color = c(rep("#CD0606", 77), rep("#16A205", 3)), 
    size = 2.3
  ) +
  theme(axis.text.x = element_text(size = 5),
        axis.text.y = element_text(size = 5)) + 
  xlab("PC1 (15.9 %)") + 
  ylab("PC2 (10.2 %)") +
  xlim(-0.3, 0.1) + ylim(-0.25, 0.25) +
  coord_fixed() + # fix aspect ratio to 1:1
  theme_minimal_grid(12)


pcaBarPlot <- pca_fit %>%
  tidy(matrix = "eigenvalues") %>%
  ggplot(aes(PC, percent)) +
  geom_col(fill = "#16A205", alpha = 0.8) +
  scale_x_continuous(breaks = 1:84) +
  scale_y_continuous(
    labels = scales::percent_format(),
    expand = expansion(mult = c(0, 0.01))
  ) +
  #theme_minimal_hgrid(12) +
  labs(title = "Variance explained by each PC",
       y = "Percent",
       x = "PC") +
  theme(axis.text.x = element_text(size = 5),
        axis.text.y = element_text(size = 5)) + 
  scale_fill_hue(c = 45,
                 l = 80)

# Write data ---------------------------------------------------------------
ggsave(pcaArrowPlot, 
       path = "results", 
       filename = "pcaRotationMatrix.png")
ggsave(pcaBarPlot, 
       path = "results", 
       filename = "pcaFit.png")

# Save PCA fit for clustering
write_tsv(x =  pca_fit %>%
            tidy(matrix = "rotation"),
          file = "data/06_PCA_fit_rotation.tsv")
