
### Load required packages
library(dplyr)
library(stringr)
library(ggplot2)
library(CMplot)

### Read in the SNP-FST Data
SNP_FST_Default <- read.table("Kuku-MvF-SNP_FST-Default.weir.fst", header = TRUE)

### Run some checks on the file
head(SNP_FST_Default)

###Add numbers to identify SNPs
length_ <- dim(SNP_FST_Default)[1]
length_
SNP_FST_Default$SNP <- paste('SNP',1:length_)

### Check that worked
head(SNP_FST_Default)
tail(SNP_FST_Default)

### Remove aspects of chromosome labels which aren't needed

### Remove Scaffold_ section of CHROM labels
SNP_FST_DC <- SNP_FST_Default %>%
  mutate(CHROM = str_replace(CHROM, "Scaffold_", "")) 

### Remove end sequence of CHROM labels
SNP_FST_DC <- SNP_FST_DC %>%
  mutate(CHROM = str_sub(CHROM, start = 1, end = 2))

## Remove underscore from single digit CHROM labels
SNP_FST_DC$CHROM <- gsub("_", "", SNP_FST_DC$CHROM)

### Convert to be numeric
SNP_FST_DC$CHROM <- as.numeric(as.character(SNP_FST_DC$CHROM))

### Remove NAs
summary(SNP_FST_DC$WEIR_AND_COCKERHAM_FST)
SNP_FST_DC_FINAL <- subset(SNP_FST_DC, !is.na(WEIR_AND_COCKERHAM_FST))

### Remove SNPs with less than 0.2 FST
SNP_FST_Default_Filtered = subset(SNP_FST_DC_FINAL, subset = WEIR_AND_COCKERHAM_FST > 0.2)
dim(SNP_FST_Default_Filtered)

### Check above output
head(SNP_FST_Default_Filtered)
tail(SNP_FST_Default_Filtered)

# Reorder columns to hopefully allow plotting with CMPlot
SNP_FST_Filtered_Reordered <- SNP_FST_Default_Filtered[, c("SNP", "CHROM", "POS", "WEIR_AND_COCKERHAM_FST")]

#Counting SNPs above threshold of 0.45
Above_Threshold = subset(SNP_FST_Filtered_Reordered, subset = WEIR_AND_COCKERHAM_FST > 0.45)
dim(Above_Threshold)

#Counting SNPs within 0.45-0.55 FST threshold
Sex_linked = subset(SNP_FST_Filtered_Reordered, subset = WEIR_AND_COCKERHAM_FST > 0.45 & WEIR_AND_COCKERHAM_FST < 0.55)
dim(Sex_linked)

# Genomewide 
CMplot(FST_Filtered_Reordered, plot.type="m", col=c("grey30","grey60"), LOG10=FALSE, ylab = "Male-Female FST", ylim = c(0.2, 1), threshold=c(0.45),
       threshold.lwd=c(1), threshold.col=c("Red"), amplify=TRUE,bin.size=1e6,
       chr.den.col=c("darkgreen", "yellow", "red"),signal.col=c("green"),signal.cex=c(0.8),axis.cex=c(0.9),
       signal.pch=c(19,19),dpi=300,file.output=FALSE,verbose=TRUE,
       width=14,height=6)

###Creating Chromosome 12 dataset
Chromosome_12 = subset(SNP_FST_DC_FINAL, subset = CHROM == 12)

# Reorder columns to hopefully allow plotting with CMPlot
Chromosome_12_Reordered <- Chromosome_12[, c("SNP", "CHROM", "POS", "WEIR_AND_COCKERHAM_FST")]

### Remove SNPs with less than 0.2 FST
Chromosome_12_Filtered = subset(Chromosome_12_Reordered, subset = WEIR_AND_COCKERHAM_FST > 0.2)
dim(Chromosome_12_Filtered)

# Chromosome 12
CMplot(Chromosome_12_Filtered, plot.type="m", col=c("grey30","grey60"), LOG10=FALSE, highlight=Female_SNPs, highlight.col = "green",
       ylab = "Male-Female FST", ylim = c(0.2, 1),
       amplify=TRUE,bin.size=1e6,
       chr.den.col=c("darkgreen", "yellow", "red"),signal.cex=c(0.8), axis.cex=c(0.9),
       signal.pch=c(19,19),dpi=300,file.output=FALSE,verbose=TRUE,
       width=14,height=6)



#######################################################################################


######################## Windowed Version ###########################################
##load FST Data
fst_data <- read.table("Kuku-MvF-FST-1kb.windowed.weir.fst", header = TRUE)

## Remove section of scaffold labels prior to numbers - Scaffold_
FST_Chrom <- fst_data %>%
  mutate(CHROM = str_replace(CHROM, "Scaffold_", ""))     

## Remove section of scaffold labels after numbers
FST_Chrom <- FST_Chrom %>%
  mutate(CHROM = str_sub(CHROM, start = 1, end = 2))

## Remove underscore from single digit scaffold numbers
FST_Chrom$CHROM <- gsub("_", "", FST_Chrom$CHROM)

### Convert CHROM column to be numeric
FST_Chrom$CHROM <- as.numeric(as.character(FST_Chrom$CHROM))

### Check that that was successful
head(FST_Chrom)
tail(FST_Chrom)

### Add position column
FST_Chrom$POS <- (FST_Chrom$BIN_START + FST_Chrom$BIN_END) / 2

###Add numbers to identify Windows
length_ <- dim(FST_Chrom)[1]
length_
FST_Chrom$SNP <- paste('W',1:length_)

### Check that worked
head(FST_Chrom)
tail(FST_Chrom)

### Remove NAs where no data is present for FST
summary(FST_Chrom$WEIGHTED_FST)
FST_FINAL <- subset(FST_Chrom, !is.na(WEIGHTED_FST))

# Reorder columns to hopefully allow plotting with CMPlot
FST_Reordered <- FST_FINAL[, c("SNP", "CHROM", "POS", "WEIGHTED_FST")]


# Check that worked
head(FST_Reordered)

### Plot using CMplot
CMplot(FST_Reordered, plot.type="m", col=c("grey30","grey60"), LOG10=FALSE, ylab = "Male-Female FST", ylim = c(0.2, 1), threshold=c(0.45),
       threshold.lwd=c(1), threshold.col=c("Red"), amplify=TRUE,signal.col=c("green"),signal.cex=c(0.8),
       signal.pch=c(19,19),dpi=300,file.output=FALSE,verbose=TRUE,
       width=14,height=6)


### Identify top windows
FST_Ranked <- FST_Reordered[order(FST_Reordered$WEIGHTED_FST, decreasing = TRUE),]
head(FST_Ranked)


####################### ANGSD 1KB Window Version ##################################
##load FST Data
fst_data <- read.table("MF-FST-1kb", header = TRUE)

# Change Column Names to Chromosome Identifier, window, number of sites, and fst
colnames(fst_data)[1:4] <- c("CHROM", "Window", "N_Sites", "FST")

## Remove section of scaffold labels prior to numbers - Scaffold_
FST_Chrom <- fst_data %>%
  mutate(CHROM = str_replace(CHROM, "Scaffold_", ""))     

## Remove section of scaffold labels after numbers
FST_Chrom <- FST_Chrom %>%
  mutate(CHROM = str_sub(CHROM, start = 1, end = 2))

## Remove underscore from single digit scaffold numbers
FST_Chrom$CHROM <- gsub("_", "", FST_Chrom$CHROM)

### Convert CHROM column to be numeric
FST_Chrom$CHROM <- as.numeric(as.character(FST_Chrom$CHROM))

### Check that that was successful
head(FST_Chrom)
tail(FST_Chrom)

###Add numbers to identify Windows
length_ <- dim(FST_Chrom)[1]
length_
FST_Chrom$SNP <- paste('W',1:length_)

### Check that worked
head(FST_Chrom)
tail(FST_Chrom)

### Remove NAs where no data is present for FST
summary(FST_Chrom$WEIGHTED_FST)
FST_FINAL <- subset(FST_Chrom, !is.na(FST))

# Reorder columns to hopefully allow plotting with CMPlot
FST_Reordered <- FST_FINAL[, c("SNP", "CHROM", "Window", "FST")]

# Check that worked
head(FST_Reordered)

### Plot using CMplot
CMplot(FST_Reordered, plot.type="m", col=c("grey30","grey60"), LOG10=FALSE, ylab = "Male-Female FST", ylim = c(0, 1), threshold=c(0.45),
       threshold.lwd=c(1), threshold.col=c("Red"), amplify=TRUE,signal.col=c("green"),signal.cex=c(0.8),
       signal.pch=c(19,19),dpi=300,file.output=FALSE,verbose=TRUE,
       width=14,height=6)

## Identify top windows
FST_Ranked <- FST_Reordered[order(FST_Reordered$WEIGHTED_FST, decreasing = TRUE),]
head(FST_Ranked)
