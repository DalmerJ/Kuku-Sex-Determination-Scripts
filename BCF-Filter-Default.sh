#!/bin/bash
set -euo pipefail


echo "$(date): Starting Filtering"

bcftools view \
-v snps \
-m2 -M2 \
-i 'F_MISSING <=0.5 && MIN(FMT/DP) >= 6 && QUAL >= 20' \
-Ob \
-o Kuku_Filtered.bcf \
--threads 30 \
Kuku_pop.bcf

echo "$(date): Filtering Complete"
