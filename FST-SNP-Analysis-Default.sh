#!/bin/bash
set -euo pipefail

#Calculate FST
echo "$(date):Initialising FST Calculation"

vcftools --bcf Kuku_Filtered.bcf \
--weir-fst-pop Males.txt \
--weir-fst-pop Females.txt \
--out Kuku-MvF-SNP_FST-Default

echo "$(date): Finished Calculating FST"
