sudo -E ncu \
  --profile-from-start off \
  --nvtx \
  --metrics "sm__warps_active.avg.pct_of_peak_sustained_active,sm__throughput.avg.pct_of_peak_sustained_elapsed,sm__pipe_tensor_cycles_active.avg.pct_of_peak_sustained_active,dram__throughput.avg.pct_of_peak_sustained_elapsed,smsp__warp_issue_stalled_long_scoreboard_per_warp_active.pct,launch__grid_size,launch__block_size,sm__cycles_elapsed.avg" \
  --target-processes all \
  --export /workspace/resnet_out/resnet_profile_v1 \
  --force-overwrite \
  /home/mlcuser/venv/mlcflow/bin/python3 python/main.py \
    --profile resnet50-pytorch \
    --model "$MODEL_PATH" \
    --dataset-path "$DATA_DIR" \
    --preprocessed_dir "$DATA_DIR" \
    --output /workspace/resnet_out/ncu_run_output \
    --backend pytorch \
    --scenario Offline \
    --count 5000 \
    --use_preprocessed_dataset
