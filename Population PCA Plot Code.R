# Install Factoextra Package
install.packages("factoextra")
install.packages("ggpubr")

# Load Required packages
library(dplyr)
library(stringr)
library(factoextra)
library(readr)
library("ggpubr")


# Read in the PLINK2 PCA results
Default_pca <- read.table(
  "Kuku_Pop_pca.eigenvec",
  header = FALSE
)

# Name the columns
colnames(Default_pca) <- c("Sample_IDs", "PCA1", "PCA2", "PCA3", "PCA4", "PCA5", "PCA6", "PCA7",
"PCA8", "PCA9", "PCA10")

# Remove section of Sample IDs prior to numbers - 222K32LNX-10267-
Default_pca <- Default_pca %>%
  mutate(Sample_IDs = str_replace(Sample_IDs, "222K32LNX-10267-", ""))     

# Remove section of Sample IDs after numbers
Default_pca <- Default_pca %>%
  mutate(Sample_IDs = str_sub(Sample_IDs, start = 1, end = 2))


# Highlighting data points based on sex - needs two male flags to also classify 12 as male
Default_pca$Sex <- ifelse(Default_pca$Sample_IDs > 12, "Female",
                           ifelse(Default_pca$Sample_IDs < 12, "Male", "Male"))

# Create csv for family annotation
write.csv(Default_pca, "Kuku_Population_Samples")

# Adding eigenvalue contributions
PCA_Default_Eigenvalues <- read.table("Kuku_Pop_pca.eigenval", header = FALSE)

# Name the columns
colnames(PCA_Default_Eigenvalues) <- c("Eigenvalue")

# Calculating Eigenvalue contribution percentages
var_explained <- PCA_Default_Eigenvalues$Eigenvalue / sum(PCA_Default_Eigenvalues$Eigenvalue) * 100
print(round(var_explained, 2))

# Plot using ggplot2
ggplot(Default_pca, aes(x = PCA1, y = PCA2, color = Sex)) +
  geom_point(size = 3) +
  scale_color_manual(values = c("Female" = "red", "Male" = "blue")) +
  labs(x = "PC1 (11.01%)", y = "PC2 (10.86%)") +
  theme_minimal()


# With Points labelled for identifying families
ggplot(Default_pca, aes(x = PCA1, y = PCA2, color = Sex)) +
  geom_point(size = 3) +
  scale_color_manual(values = c("Female" = "red", "Male" = "blue")) +
  geom_text(aes(label = Sample_IDs), vjust = -2, hjust = -1, size = 2) + # vjust pushes text above point
  theme_minimal()