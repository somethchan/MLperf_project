#!/usr/bin/env bash
set -euo pipefail

OUT=stage1_bert_offline_logs
RUNS=6
QCOUNT=1000
TAG="_r4.1-dev"

# Stop interactive shells from sticking around
export MPLCONFIGDIR=/tmp/matplotlib
export MLC_QUIET=yes
export CM_QUIET=yes

# Force any spawned bash to exit immediately
export BASH_ENV=/dev/null
export PROMPT_COMMAND="exit"

rm -rf "$OUT"
mkdir -p "$OUT"

for i in $(seq 1 "$RUNS"); do
  echo "========== RUN $i =========="
  run_out="$OUT/run_$i"
  rm -rf "$run_out"
  mkdir -p "$run_out"

  cr run-mlperf,inference,_find-performance,_full,${TAG} \
    --model=bert-99 \
    --implementation=reference \
    --framework=pytorch \
    --category=edge \
    --scenario=Offline \
    --execution_mode=test \
    --device=cuda \
    --docker \
    --quiet \
    --test_query_count="$QCOUNT" \
    --output_dir="$run_out"

  echo "Result for run $i:"
  find "$run_out" -name mlperf_log_summary.txt -print -exec grep "Result is" {} \; 2>/dev/null || true
done
