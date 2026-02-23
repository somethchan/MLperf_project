import os
import time
import torch
import torchvision
import torch.cuda.nvtx as nvtx

# -----------------------------
# Determinism / stability knobs
# -----------------------------
torch.use_deterministic_algorithms(True)
torch.backends.cudnn.benchmark = False
torch.backends.cuda.matmul.allow_tf32 = False
torch.backends.cudnn.allow_tf32 = False  # keep consistent

# Optional: reduce noise a bit
torch.set_num_threads(1)

device = "cuda" if torch.cuda.is_available() else "cpu"
assert device == "cuda", "This script expects a CUDA GPU."

# -----------------------------
# Model: ResNet50
# -----------------------------
model = torchvision.models.resnet50(weights=None)
model.eval().to(device)

# Fixed input shape (MLPerf-style image tensor)
batch_size = int(os.environ.get("BATCH_SIZE", "1"))
inp = torch.randn(batch_size, 3, 224, 224, device=device, dtype=torch.float32)

# -----------------------------
# Run settings
# -----------------------------
warmup = int(os.environ.get("WARMUP_ITERS", "20"))
iters  = int(os.environ.get("ITERS", "50"))

# Warmup (NOT profiled if you use NVTX capture-range)
with torch.no_grad():
    for _ in range(warmup):
        _ = model(inp)
    torch.cuda.synchronize()

# Timed region (your "steady-state" inference)
times_ms = []
with torch.no_grad():
    for i in range(iters):
        nvtx.range_push("INFERENCE")
        t0 = time.perf_counter()
        _ = model(inp)
        torch.cuda.synchronize()
        t1 = time.perf_counter()
        nvtx.range_pop()
        times_ms.append((t1 - t0) * 1000.0)

# Print summary
times_ms.sort()
p50 = times_ms[len(times_ms)//2]
p90 = times_ms[int(len(times_ms)*0.90)]
p99 = times_ms[int(len(times_ms)*0.99) if len(times_ms) > 1 else 0]

print(f"ResNet50 batch={batch_size} iters={iters} warmup={warmup}")
print(f"Latency ms: p50={p50:.3f} p90={p90:.3f} p99={p99:.3f} min={times_ms[0]:.3f} max={times_ms[-1]:.3f}")
