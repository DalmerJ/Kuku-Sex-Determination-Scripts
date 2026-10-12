#!/bin/bash
set -euo pipefail

# Reference genome
REF="/projects/health_sciences/bms/biochemistry/kenny_group/Kukugenome.fa"


echo "$(date): Starting gVCF conversion"

bcftools convert \
    --gvcf2vcf \
    -f "$REF" \
    Kuku.Population.gvcf.bcf \
    -Ob \
    -o Kuku_pop.bcf

echo "$(date): Conversion complete"

#Index BCFs
echo "$(date): Indexing BCF"

bcftools index Kuku_pop.bcf

echo "$(date): Indexing complete"

#Producing BCF Stats
echo "$(date): Generating statistics"

bcftools stats \
    --threads 16 \
    -F "$REF" \
    Kuku_pop.bcf \
    > vcf-stats/Kuku_pop_unfiltered.stats

echo "$(date): Statistics complete"

echo "$(date): Pipeline finished successfully"
