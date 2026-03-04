#!/usr/bin/env bash
set -euo pipefail

OUT=bert_runs
RUNS=6
QCOUNT=1000
TAG="_r4.1-dev"

rm -rf "$OUT"
mkdir -p "$OUT"

for i in $(seq 1 $RUNS); do
  echo "========== RUN $i =========="

  run_out="$OUT/run_$i"
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
    --docker_it=no \
    --test_query_count=$QCOUNT \
    --output_dir="$run_out" \
    --quiet

  echo "Result for run $i:"
  grep "Result is" "$run_out/mlperf_log_summary.txt" || true
done

echo "Done."
sha256sum $OUT/run_*/mlperf_log_summary.txt
