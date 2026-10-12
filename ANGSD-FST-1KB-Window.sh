#!/bin/bash
set -euo pipefail

echo "$(date): Producing Male-Female FST"

realSFS fst stats2 Male-Female-Index.fst.idx \
  -win 1000 \
  -step 1000 \
  > MF-FST-1kb

echo "$(date): Finished Producing Male-Female FST"
