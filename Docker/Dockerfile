# IMPORTS
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# SET ENVIRONMENT
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# INSTALL OS DEPENDANCIES
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv \
    git wget curl ca-certificates \
    build-essential \
    unzip rsync \
    libglib2.0-0 libgomp1 \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# INSTALL PYTHON DEPENDANCIES
RUN python3 -m pip install -U pip setuptools wheel

# INSTALL PYTORCH
RUN python3 -m pip install --no-cache-dir \
    torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121

# INSTALL CM AUTOMATION
RUN python3 -m pip install --no-cache-dir cmind
RUN cm pull repo mlcommons@cm4mlops

# INSTALL NSIGHT
RUN set -eux; \
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://developer.download.nvidia.com/devtools/repos/ubuntu2204/amd64/nvidia-devtools.gpg \
      | gpg --dearmor -o /etc/apt/keyrings/nvidia-devtools.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/nvidia-devtools.gpg] https://developer.download.nvidia.com/devtools/repos/ubuntu2204/amd64/ /" \
      > /etc/apt/sources.list.d/nvidia-devtools.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends nsight-systems; \
    rm -rf /var/lib/apt/lists/*

# SET WORKDIR
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
