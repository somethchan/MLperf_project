docker run -it --gpus all \
  --cap-add=SYS_ADMIN \
  --security-opt seccomp=unconfined \
  -e CUDA_VISIBLE_DEVICES=0 \
  -v $(pwd)/mlperf_data:/datasets \
  -v $(pwd)/mlperf_models:/models \
  -v $(pwd)/mlperf_results:/results \
  -v $(pwd)/mlperf_cache:/cache \
  -v $(pwd)/mlperf_scripts:/scripts \
  -w /workspace \
  <IMG> bash
