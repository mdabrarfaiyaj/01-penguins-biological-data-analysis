# ==============================================================================
# PROJECT: Palmer Penguins Biological Data Analysis
# SCRIPT: 03 - Data Visualizations 
# AUTHOR: Md. Abrar Faiyaj
# DATE: 7th December 2025
# PURPOSE: Create publication-quality figures
# ==============================================================================

# ==============================================================================
# SETUP WORKING DIRECTORY (ADD THIS SECTION!)
# ==============================================================================

# Set working directory to project root
project_path <- "C:/Users/HP/Documents/01-penguins-biological-data-analysis"
setwd(project_path)

# Verify location
cat("Working directory:", getwd(), "\n\n")

# ==============================================================================
# CONTINUE WITH ORIGINAL CODE (but change paths!)
# ==============================================================================

library(tidyverse)
library(corrplot)

# Load cleaned data (NOTE: Changed from ../data/ to data/)
penguins_clean <- read_csv("data/penguins_clean.csv")

# Convert to factors
penguins_clean$species <- factor(penguins_clean$species)
penguins_clean$island <- factor(penguins_clean$island)
penguins_clean$sex <- factor(penguins_clean$sex)

# Set theme
theme_set(theme_minimal(base_size = 12))

# Colors
species_colors <- c("Adelie" = "#FF6B35", "Chinstrap" = "#004E89", "Gentoo" = "#4ECDC4")

# ==============================================================================
# FIGURE 1: Species Comparison - Bill Dimensions
# ==============================================================================

fig1 <- ggplot(penguins_clean, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(size = 3, alpha = 0.7) +
  scale_color_manual(values = species_colors) +
  labs(
    title = "Bill Morphology Varies Across Penguin Species",
    subtitle = "Palmer Archipelago, Antarctica (2007-2009)",
    x = "Bill Length (mm)",
    y = "Bill Depth (mm)",
    color = "Species"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

# Save (NOTE: Changed from ../figures/ to figures/)
ggsave("figures/01_species_comparison_scatter.png", fig1, 
       width = 8, height = 6, dpi = 300)

cat("✓ Figure 1 saved: figures/01_species_comparison_scatter.png\n")

# ==============================================================================
# FIGURE 2: Body Mass Distribution by Species
# ==============================================================================

fig2 <- ggplot(penguins_clean, aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.7, outlier.shape = 21) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1) +
  scale_fill_manual(values = species_colors) +
  labs(
    title = "Gentoo Penguins Show Significantly Greater Body Mass",
    subtitle = paste("n =", nrow(penguins_clean), "individuals"),
    x = "Species",
    y = "Body Mass (g)"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "none"
  )

ggsave("figures/02_body_mass_distribution.png", fig2, 
       width = 8, height = 6, dpi = 300)

cat("✓ Figure 2 saved: figures/02_body_mass_distribution.png\n")

# ==============================================================================
# FIGURE 3: Correlation Matrix
# ==============================================================================

numeric_vars <- penguins_clean %>%
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g)

corr_matrix <- cor(numeric_vars, use = "complete.obs")

png("figures/03_correlation_matrix.png", width = 800, height = 800, res = 150)
corrplot(corr_matrix, 
         method = "color", 
         type = "upper",
         tl.col = "black",
         tl.srt = 45,
         addCoef.col = "black",
         number.cex = 0.8,
         col = colorRampPalette(c("#6D9EC1", "white", "#E46726"))(200),
         title = "Correlation Matrix: Penguin Morphometrics",
         mar = c(0,0,2,0))
dev.off()

cat("✓ Figure 3 saved: figures/03_correlation_matrix.png\n")

# ==============================================================================
# FIGURE 4: Morphometric Relationships
# ==============================================================================

fig4 <- ggplot(penguins_clean, aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size = 2.5, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.2) +
  scale_color_manual(values = species_colors) +
  labs(
    title = "Strong Positive Correlation: Flipper Length vs Body Mass",
    subtitle = "Linear regression by species",
    x = "Flipper Length (mm)",
    y = "Body Mass (g)",
    color = "Species"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

ggsave("figures/04_morphometric_relationships.png", fig4, 
       width = 8, height = 6, dpi = 300)

cat("✓ Figure 4 saved: figures/04_morphometric_relationships.png\n")

# ==============================================================================
# COMPLETION MESSAGE
# ==============================================================================

cat("\n✓ All visualizations complete!\n")
cat("✓ Figures saved to: figures/\n")
cat("\nGenerated figures:\n")
cat("  1. Species comparison scatter plot\n")
cat("  2. Body mass distribution boxplot\n")
cat("  3. Correlation matrix heatmap\n")
cat("  4. Morphometric relationships plot\n")

# Verify files were created
cat("\n=== Files in figures/ folder ===\n")
print(list.files("figures/"))

# ==============================================================================
# END OF SCRIPT
# ==============================================================================