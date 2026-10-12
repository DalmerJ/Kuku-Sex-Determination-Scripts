#!/bin/bash
set -euo pipefail

#Calculate FST
echo "$(date):Initialising FST Calculation"

vcftools --bcf Kuku_Filtered.bcf \
--weir-fst-pop Males.txt \
--weir-fst-pop Females.txt \
--fst-window-size 1000 \
--out Kuku-MvF-FST-1kb

echo "$(date): Finished Calculating FST"
