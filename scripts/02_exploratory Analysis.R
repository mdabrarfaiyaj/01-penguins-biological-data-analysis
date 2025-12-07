# ==============================================================================
# PROJECT: Palmer Penguins Biological Data Analysis
# SCRIPT: 02 - Exploratory Data Analysis 
# AUTHOR: Md. Abrar Faiyaj
# DATE: 7th December 2025
# PURPOSE: Statistical analysis and hypothesis testing
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
library(broom)

# Load cleaned data (NOTE: Changed from ../data/ to data/)
penguins_clean <- read_csv("data/penguins_clean.csv")

# Convert to factors
penguins_clean$species <- factor(penguins_clean$species)
penguins_clean$island <- factor(penguins_clean$island)
penguins_clean$sex <- factor(penguins_clean$sex)

# ==============================================================================
# 1. SUMMARY STATISTICS BY SPECIES
# ==============================================================================

cat("=== Summary Statistics by Species ===\n\n")

summary_stats <- penguins_clean %>%
  group_by(species) %>%
  summarise(
    n = n(),
    mean_body_mass = mean(body_mass_g, na.rm = TRUE),
    sd_body_mass = sd(body_mass_g, na.rm = TRUE),
    mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE),
    sd_flipper_length = sd(flipper_length_mm, na.rm = TRUE),
    mean_bill_length = mean(bill_length_mm, na.rm = TRUE),
    sd_bill_length = sd(bill_length_mm, na.rm = TRUE),
    mean_bill_depth = mean(bill_depth_mm, na.rm = TRUE),
    sd_bill_depth = sd(bill_depth_mm, na.rm = TRUE)
  ) %>%
  mutate(across(where(is.numeric), ~round(., 1)))

print(summary_stats)

# Save (NOTE: Changed from ../results/ to results/)
write_csv(summary_stats, "results/summary_statistics.csv")

# ==============================================================================
# 2. STATISTICAL TESTING
# ==============================================================================

cat("\n=== Statistical Tests ===\n\n")

# ANOVA: Body mass differences between species
anova_body_mass <- aov(body_mass_g ~ species, data = penguins_clean)
anova_summary <- tidy(anova_body_mass)

cat("ANOVA: Body Mass by Species\n")
print(anova_summary)

# Post-hoc test
tukey_result <- TukeyHSD(anova_body_mass)
cat("\nPost-hoc Tukey HSD:\n")
print(tukey_result)

# ==============================================================================
# 3. CORRELATION ANALYSIS
# ==============================================================================

cat("\n=== Correlation Analysis ===\n\n")

numeric_vars <- penguins_clean %>%
  select(bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g)

correlation_matrix <- cor(numeric_vars, use = "complete.obs")
cat("Correlation Matrix:\n")
print(round(correlation_matrix, 2))

# ==============================================================================
# 4. SAVE STATISTICAL RESULTS
# ==============================================================================

statistical_results <- paste(
  "=== STATISTICAL ANALYSIS RESULTS ===\n",
  "\nANOVA: Body Mass by Species\n",
  paste(capture.output(print(anova_summary)), collapse = "\n"),
  "\n\nPost-hoc Tukey HSD:\n",
  paste(capture.output(print(tukey_result)), collapse = "\n"),
  "\n\nCorrelation Matrix:\n",
  paste(capture.output(print(round(correlation_matrix, 2))), collapse = "\n"),
  sep = "\n"
)

# Save (NOTE: Changed from ../results/ to results/)
writeLines(statistical_results, "results/statistical_tests.txt")

cat("\n✓ Exploratory analysis complete!\n")
cat("✓ Results saved to: results/\n")

# ==============================================================================
# END OF SCRIPT
# ==============================================================================