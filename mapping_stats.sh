#!/usr/bin/env bash
set -euo pipefail

FASTA="/projects/health_sciences/bms/biochemistry/kenny_group/Kukugenome.fa"
OUTDIR="Mapping_Stats"

mkdir -p "$OUTDIR"

for file in ./bams_dedup/*.bam; do
    base=$(basename "$file" .bam)

    echo "Processing $base..."

    samtools index -@ 2 "$file"

    samtools stats "$file" > "${base}.stats"

    mosdepth \
        -n \
        --threads 2 \
        --fasta "$FASTA" \
        "$base" \
        "$file"

    mv "${base}.stats" "$OUTDIR/"
    mv "${base}"*.txt "$OUTDIR/" 2>/dev/null || true
done
