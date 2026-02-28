docker run -it --gpus all \
  --cap-add=SYS_ADMIN \
  --security-opt seccomp=unconfined \
  -v $(pwd)/mlperf_data:/datasets \
  -v $(pwd)/mlperf_models:/models \
  -v $(pwd)/mlperf_results:/results \
  -v $(pwd)/mlperf_chace:/cache \
  -v $(pwd)/mlperf_scripts:/scripts \
  -w /workspace \
  9f9674976a12 bash
