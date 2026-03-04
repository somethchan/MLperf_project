#!/usr/bin/env bash
set -euo pipefail

# Force non-interactive CM/CR behavior
export CM_DOCKER_IT=0
export CM_DOCKER_INTERACTIVE=no
export CM_QUIET=yes

OUT=stage1_bert_offline_logs
RUNS=5
QCOUNT=1000
TAG="_r4.1-dev"

rm -rf "$OUT"
mkdir -p "$OUT"

for i in $(seq 1 $RUNS); do
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
    --docker_it=0 \
    --quiet \
    --test_query_count="$QCOUNT" \
    --output_dir="$run_out"

  echo "Result for run $i:"
  grep "Result is" "$run_out/mlperf_log_summary.txt" || true
done

echo "Done."
sha256sum "$OUT"/run_*/mlperf_log_summary.txt
