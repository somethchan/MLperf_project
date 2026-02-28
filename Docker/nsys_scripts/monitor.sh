nsys profile \
  -o resnet50_profile \
  --trace=cuda,nvtx \
  --capture-range=nvtx \
  --capture-range-end=nvtx \
  --sample=none \
  --cpuctxsw=none \
  --force-overwrite=true \
  python3 harness.py
