#!/bin/bash
set -euo pipefail

IN_DIR="/projects/health_sciences/bms/biochemistry/kenny_group/JAMIE/Jamie_reads_posttrim/bam"
RG_DIR="bams_readgroups"
DEDUP_DIR="bams_dedup"
METRICS_DIR="picard_duplicate_metrics"
LOG_DIR="logs"
TMP_DIR="picard_tmp"

mkdir -p "$RG_DIR" "$DEDUP_DIR" "$METRICS_DIR" "$LOG_DIR" "$TMP_DIR"

JAVA_MEM="28G"

export _JAVA_OPTIONS="-Xmx28G"

for bam in "$IN_DIR"/*sorted.bam; do
    sample=$(basename "$bam" sorted.bam)

    echo "Processing $sample"


    picard AddOrReplaceReadGroups \
        I="$bam" \
        O="$RG_DIR/${sample}.rg.bam" \
        RGID="$sample" \
        RGLB="${sample}_lib1" \
        RGPL="ILLUMINA" \
        RGPU="${sample}_unit1" \
        RGSM="$sample" \
        SORT_ORDER=coordinate \
        CREATE_INDEX=true \
        TMP_DIR="$TMP_DIR" \
        > "$LOG_DIR/${sample}.add_read_groups.log" 2>&1

    picard MarkDuplicates \
        I="$RG_DIR/${sample}.rg.bam" \
        O="$DEDUP_DIR/${sample}.dedup.bam" \
        M="$METRICS_DIR/${sample}.duplicate_metrics.txt" \
        REMOVE_DUPLICATES=true \
        CREATE_INDEX=true \
        VALIDATION_STRINGENCY=SILENT \
        TMP_DIR="$TMP_DIR" \
        > "$LOG_DIR/${sample}.mark_duplicates.log" 2>&1

    echo "Finished $sample"
done
