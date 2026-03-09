#!/usr/bin/env bash
set -euo pipefail

OUT=stage1_rnnt_offline_logs
RUNS=6
QCOUNT=512
TAG="_r4.1-dev"

rm -rf "$OUT"
mkdir -p "$OUT"

for i in $(seq 1 "$RUNS"); do
  echo "========== RUN $i / $RUNS =========="

  run_out="${OUT}/run_${i}"
  rm -rf "$run_out"
  mkdir -p "$run_out"

  cm run-mlperf,inference,_find-performance,_full,${TAG} \
    --model=rnnt \
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
  grep -rh "Result is" "${run_out}"/*/mlperf_log_summary.txt 2>/dev/null || \
  grep -rh "Result is" "${run_out}"   2>/dev/null || \
  echo "  (summary not yet available at top level — check sub-dirs)"

  echo
done

echo "========== ALL RUNS COMPLETE =========="
echo "Logs written to: $OUT/"
echo
echo "Run the extract script next:"
echo "  bash extract_stage1_rnnt_offline.sh"
