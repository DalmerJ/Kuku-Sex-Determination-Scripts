#!/bin/bash
set -euo pipefail

echo "$(date): Creating Plink2  Directory"

echo "$(date): Performing Plink Conversion of BCFs"
plink2 \
 --bcf Kuku_pop.bcf \
 --vcf-half-call m \
 --make-pgen \
 --out Plink-Files/Kuku_Pop

echo "$(date): Finished Performing Plink Conversion of BCFs"
