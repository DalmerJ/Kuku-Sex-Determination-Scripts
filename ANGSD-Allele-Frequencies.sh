#!/bin/bash
set -euo pipefail

ncpu=50

# Reference genome
REFERENCE="/projects/health_sciences/bms/biochemistry/kenny_group/Kukugenome.fa"


echo "$(date): Creating ANGSD Directory"

mkdir -p ANGSD

echo "$(date): Generating Allele Frequencies"

angsd \
 -out ANGSD/Kuku-Angsd \
 -bam bam.filelist\
 -ref "${REFERENCE}" \
 -GL 2 \
 -doGlf 2 \
 -doDepth 1 \
 -doCounts 1 \
 -doMajorMinor 1 \
 -doMaf 2 \
 -minMaf 0.05 \
 -uniqueOnly 1 \
 -minMapQ 30 \
 -minQ 20 \
 -skipTriallelic 1 \
 -nThreads "$ncpu" \
 -minInd 5

echo "$(date): Finished Generating Allele Frequencies" 
