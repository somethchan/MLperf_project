#!/usr/bin/env bash
set -euo pipefail

cm run script --tags=run-mlperf,inference \
  --model=bert-99 \
  --scenario=Offline \
  --mode=performance \
  --execution_mode=valid \
  --device=cuda \
  --precision=float32 \
  --dataset_dir=/datasets \
  --model_dir=/models \
  --results_dir=/results \
  --cache_dir=/cache \
  --quiet
