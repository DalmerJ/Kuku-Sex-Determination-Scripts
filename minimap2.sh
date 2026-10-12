#!/bin/bash

set -euo pipefail

REF="/projects/health_sciences/bms/biochemistry/kenny_group/Kukugenome.fa"
THREADS=16

mkdir -p bam logs

echo "========================================"
echo "Minimap2 batch alignment started"
echo "Date: $(date)"
echo "========================================"

for R1 in *_R1.trimmed.fastq.gz; do

    SAMPLE="${R1%_R1.trimmed.fastq.gz}"
    R2="${SAMPLE}_R2.trimmed.fastq.gz"

    if [[ ! -f "$R2" ]]; then
        echo "[$(date)] WARNING: Missing mate file for $SAMPLE"
        continue
    fi

    echo
    echo "[$(date)] Starting $SAMPLE"

    minimap2 \
        -t "$THREADS" \
        -ax sr \
        "$REF" \
        "$R1" \
        "$R2" \
        2> "logs/${SAMPLE}.minimap2.log" \
    | samtools sort \
        -@ "$THREADS" \
        -o "bam/${SAMPLE}.sorted.bam"

    samtools index "bam/${SAMPLE}.sorted.bam"

    echo "[$(date)] Finished $SAMPLE"

done

echo
echo "========================================"
echo "Completed all samples: $(date)"
echo "========================================"
