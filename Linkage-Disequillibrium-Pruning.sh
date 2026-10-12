#!/bin/bash
set -euo pipefail

echo "$(date): Starting LD Pruning"

# LD pruning
plink2 \
  --pfile Kuku_Pop \
  --indep-pairwise 200 50 0.2 \
  --bad-ld \
  --out Kuku_Pop_pruned

echo "$(date): Finished LD Pruning"
