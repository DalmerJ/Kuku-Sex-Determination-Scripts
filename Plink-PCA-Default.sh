#!/bin/bash
set -euo pipefail

echo "$(date): Starting PCA Calculation"

# PCA
plink2 \
  --pfile Kuku_Pop \
  --extract Kuku_Pop_pruned.prune.in \
  --read-freq Kuku_Pop.afreq \
  --pca 10 \
  --out Kuku_Pop_pca
