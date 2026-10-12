#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

INPUT_DIR="./bams_dedup"
OUTPUT_DIR="./gvcfs_jg"

REFERENCE="/projects/health_sciences/bms/biochemistry/kenny_group/Kukugenome.fa"
GATK="/projects/health_sciences/bms/biochemistry/kenny_group/JAMIE/gatk-4.6.2.0/gatk"

# Machine: 64 cores, 512 GB RAM
MAX_JOBS=24
JAVA_MEM="12g"
PAIRHMM_THREADS=3
INDEX_THREADS=4

mkdir -p "${OUTPUT_DIR}"

bams=("${INPUT_DIR}"/*.bam)

if (( ${#bams[@]} == 0 )); then
    echo "ERROR: No BAM files found in ${INPUT_DIR}" >&2
    exit 1
fi

if [[ ! -f "${REFERENCE}" ]]; then
    echo "ERROR: Reference not found: ${REFERENCE}" >&2
    exit 1
fi

if [[ ! -f "${REFERENCE}.fai" ]]; then
    echo "Creating reference FASTA index"
    samtools faidx "${REFERENCE}"
fi

REFERENCE_DICT="${REFERENCE%.*}.dict"

if [[ ! -f "${REFERENCE_DICT}" ]]; then
    echo "Creating reference sequence dictionary"
    "${GATK}" CreateSequenceDictionary \
        -R "${REFERENCE}" \
        -O "${REFERENCE_DICT}"
fi

run_haplotypecaller() {
    local bam="$1"
    local sample
    local output
    local log

    sample=$(basename "${bam}" .bam)
    output="${OUTPUT_DIR}/${sample}.gvcf.gz"
    log="${OUTPUT_DIR}/${sample}.HaplotypeCaller.log"

    echo "Starting ${sample}"

    if [[ -s "${output}" ]] && [[ -s "${output}.tbi" ]]; then
        echo "Skipping ${sample}: completed output exists"
        return 0
    fi

    if [[ ! -f "${bam}.bai" ]] &&
       [[ ! -f "${bam%.bam}.bai" ]]; then
        echo "Indexing ${sample}"
        samtools index \
            -@ "${INDEX_THREADS}" \
            "${bam}"
    fi

    "${GATK}" \
        --java-options \
        "-Xmx${JAVA_MEM} -Djava.io.tmpdir=${TMPDIR:-/tmp}" \
        HaplotypeCaller \
        -R "${REFERENCE}" \
        -I "${bam}" \
        -O "${output}" \
        -ERC GVCF \
        --native-pair-hmm-threads "${PAIRHMM_THREADS}" \
        > "${log}" 2>&1

    echo "Finished ${sample}"
}

export -f run_haplotypecaller
export OUTPUT_DIR REFERENCE GATK
export JAVA_MEM PAIRHMM_THREADS INDEX_THREADS

printf '%s\0' "${bams[@]}" |
    xargs -0 -n 1 -P "${MAX_JOBS}" \
    bash -c 'run_haplotypecaller "$1"' _

echo "All HaplotypeCaller jobs completed successfully."
