mkdir -p stage1_bert_offline_logs

for i in 1 2 3 4 5; do
  echo "========== RUN $i =========="

  cr run-mlperf,inference,_find-performance,_full,_r4.1-dev \
    --model=bert-99 \
    --implementation=reference \
    --framework=pytorch \
    --category=edge \
    --scenario=Offline \
    --execution_mode=test \
    --device=cuda \
    --docker \
    --test_query_count=100

  # find newest MLPerf summary log
  latest_summary=$(find ~ -name mlperf_log_summary.txt 2>/dev/null | xargs ls -t | head -n 1)
  latest_dir=$(dirname "$latest_summary")

  echo "Latest log dir: $latest_dir"

  mkdir -p stage1_bert_offline_logs/run_$i
  cp -r "$latest_dir/"* stage1_bert_offline_logs/run_$i/

  echo "Result for run $i:"
  grep "Result is" stage1_bert_offline_logs/run_$i/mlperf_log_summary.txt || true
done
