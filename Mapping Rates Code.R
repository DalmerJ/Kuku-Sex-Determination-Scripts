# Load Required packages
library(dplyr)

## Read in Mapping Rates csv
Mapping_Rates <- read.csv("Map.csv", header = FALSE)

# Name the columns
colnames(Mapping_Rates) <- c("Sequence_IDs", "Sample_IDs", "No_Reads", "Percentage", "Depth")


# Remove section of Sequence IDs prior to numbers
Mapping_Rates <- Mapping_Rates %>%
  mutate(Sequence_IDs = str_replace(Sequence_IDs, "OG10267_", ""))     


# Highlighting data points based on sex - needs two male flags to also classify 12 as male
Mapping_Rates$Sex <- ifelse(Mapping_Rates$Sequence_IDs > 13, "Female",
                          ifelse(Mapping_Rates$Sequence_IDs <= 12, "Male", "Male"))

## Convert sex to a factor
Mapping_Rates$Sex <- as.factor(Mapping_Rates$Sex)

## Calculating average reads mapped
aggregate(No_Reads ~ Sex, data = Mapping_Rates, FUN = mean)

## Calculating Standard Deviation of reads mapped
aggregate(No_Reads ~ Sex, data = Mapping_Rates, FUN = sd)

## Running t-test to test for difference between mapping rates
t.test(No_Reads ~ Sex, data = Mapping_Rates)

## Calculating average percentage of reads mapped
aggregate(Percentage ~ Sex, data = Mapping_Rates, FUN = mean)

## Calculating average coverage
aggregate(Depth ~ Sex, data = Mapping_Rates, FUN = mean)

## Calculating Standard Deviation of coverage
aggregate(Depth ~ Sex, data = Mapping_Rates, FUN = sd)

## Running t-test to test for difference between coverage
t.test(Depth ~ Sex, data = Mapping_Rates)

## Calculating Overall Average Reads Mapped
mean(Mapping_Rates$No_Reads)

## Calculating Overall Standard Deviation of Reads Mapped
sd(Mapping_Rates$No_Reads)

## Calculating Overall Average Percentage of Reads Mapped
mean(Mapping_Rates$Percentage)

## Calculating Overall Average Depth
mean(Mapping_Rates$Depth)

## Calculating Overall Standard Deviation of Depth
sd(Mapping_Rates$Depth)
