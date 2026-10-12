#!/bin/bash
set -euo pipefail

echo "$(date): Producing Male-Female SFS"

realSFS \
 Males-SAF.saf.idx \
 Females-SAF.saf.idx \
 -P 1 \
 > Male-Female.2D.ml

echo "$(date): Finished producing Male-Female SFS"

echo "$(date): Creating SFS Index"
realSFS fst index \
 Males-SAF.saf.idx \
 Females-SAF.saf.idx \
 -sfs Male-Female.2D.ml \
 -fstout Male-Female-Index \
 -P 1

echo "$(date): Finished Creating SFS Index"
