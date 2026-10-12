#!/bin/bash
set -euo pipefail

echo "$(date): Scanning Annotation File"

bedtools intersect \
    -a Kuku_annotation_2026.gtf \
    -b FS-Region.bed \
    -wa \
    > FS-Region-Genes.gff3

echo "$(date): Finished Finding Annotations"
