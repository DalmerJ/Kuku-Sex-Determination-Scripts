#!/usr/bin/env bash
set -euo pipefail

INPUT_DIR="/projects/health_sciences/bms/biochemistry/kenny_group/JAMIE/Jamie_reads"
TRIMMED_DIR="/projects/health_sciences/bms/biochemistry/kenny_group/JAMIE/Jamie_reads_posttrim"
THREADS=32

mkdir -p "${TRIMMED_DIR}"

find "${INPUT_DIR}" -type f -name "*_R1_001.fastq.gz" | while read -r R1; do
    SAMPLE=$(basename "${R1}" _R1_001.fastq.gz)
    R2=$(dirname "${R1}")/"${SAMPLE}_R2_001.fastq.gz"

    if [[ -f "${R2}" ]]; then
        echo ">>> Running fastp on ${SAMPLE}"
        fastp \
            -i "${R1}" \
            -I "${R2}" \
            -o "${TRIMMED_DIR}/${SAMPLE}_R1.trimmed.fastq.gz" \
            -O "${TRIMMED_DIR}/${SAMPLE}_R2.trimmed.fastq.gz" \
            --detect_adapter_for_pe \
            --cut_front --cut_tail qualified_quality_phred 20 -l 50 \
            --thread "${THREADS}" \
            --html "${TRIMMED_DIR}/${SAMPLE}_fastp.html" \
            --json "${TRIMMED_DIR}/${SAMPLE}_fastp.json"
    else
        echo ">>> Skipping ${SAMPLE}: R2 not found at ${R2}"
    fi
done

