#!/bin/bash
set -euo pipefail

echo "$(date): Starting Allele Frequency Calculation"


plink2 \
  --pfile Kuku_Pop \
  --freq \
  --out Kuku_Pop

echo "$(date): Finished Allele Frequency Calculation"
