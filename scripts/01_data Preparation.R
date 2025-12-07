# ==============================================================================
# PROJECT: Palmer Penguins Biological Data Analysis
# SCRIPT: 01 - Data Preparation 
# AUTHOR: Md. Abrar Faiyaj
# DATE: 7th December 2025
# PURPOSE: Clean and prepare penguin morphometric data for analysis
# ==============================================================================

# ==============================================================================
# SETUP WORKING DIRECTORY (ADD THIS SECTION!)
# ==============================================================================

# Create project folder if it doesn't exist
project_path <- "C:/Users/HP/Documents/01-penguins-biological-data-analysis"
if (!dir.exists(project_path)) {
  dir.create(project_path, recursive = TRUE)
}

# Set working directory to project root
setwd(project_path)

# Verify location
cat("Working directory set to:", getwd(), "\n\n")

# Create subfolders
dir.create("data", showWarnings = FALSE)
dir.create("scripts", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)
dir.create("results", showWarnings = FALSE)
dir.create("docs", showWarnings = FALSE)

# ==============================================================================
# NOW CONTINUE WITH ORIGINAL CODE (but change paths!)
# ==============================================================================

# Load required libraries
library(tidyverse)
library(palmerpenguins)

# ==============================================================================
# 1. LOAD RAW DATA
# ==============================================================================

cat("Loading Palmer Penguins dataset...\n")

penguins_raw <- penguins

# Save raw data (NOTE: Changed from ../data/ to data/)
write_csv(penguins_raw, "data/penguins_raw.csv")

# Display basic information
cat("\n=== Dataset Overview ===\n")
cat("Total observations:", nrow(penguins_raw), "\n")
cat("Variables:", ncol(penguins_raw), "\n")
cat("Species:", paste(unique(penguins_raw$species), collapse = ", "), "\n")

# ==============================================================================
# 2. DATA INSPECTION
# ==============================================================================

cat("\n=== Missing Values ===\n")
missing_summary <- penguins_raw %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "n_missing") %>%
  filter(n_missing > 0)

print(missing_summary)

# ==============================================================================
# 3. DATA CLEANING
# ==============================================================================

cat("\n=== Cleaning Data ===\n")

penguins_clean <- penguins_raw %>%
  drop_na()

# Convert to factors
penguins_clean$species <- factor(penguins_clean$species)
penguins_clean$island <- factor(penguins_clean$island)
penguins_clean$sex <- factor(penguins_clean$sex)

cat("Observations after cleaning:", nrow(penguins_clean), "\n")
cat("Removed:", nrow(penguins_raw) - nrow(penguins_clean), "incomplete rows\n")

# ==============================================================================
# 4. DATA VALIDATION
# ==============================================================================

cat("\n=== Data Validation ===\n")

cat("Bill length (mm):", min(penguins_clean$bill_length_mm), "-", 
    max(penguins_clean$bill_length_mm), "\n")
cat("Bill depth (mm):", min(penguins_clean$bill_depth_mm), "-", 
    max(penguins_clean$bill_depth_mm), "\n")
cat("Flipper length (mm):", min(penguins_clean$flipper_length_mm), "-", 
    max(penguins_clean$flipper_length_mm), "\n")
cat("Body mass (g):", min(penguins_clean$body_mass_g), "-", 
    max(penguins_clean$body_mass_g), "\n")

# ==============================================================================
# 5. SAVE CLEANED DATA
# ==============================================================================

# Save (NOTE: Changed from ../data/ to data/)
write_csv(penguins_clean, "data/penguins_clean.csv")

cat("\n✓ Data preparation complete!\n")
cat("✓ Cleaned data saved to: data/penguins_clean.csv\n")

# ==============================================================================
# END OF SCRIPT
# ==============================================================================