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
RUN python3 -m pip install --no-cache-dir \
    numpy pyyaml cmind

# CM AUTOMATION
RUN cm pull repo mlcommons@cm4mlops

# NSIGHT SYSTEM CLI
RUN set -eux; \
    NSYS_DEB="NsightSystems-linux-cli-public-2026.1.1.204-3717666.deb"; \
    curl -fL -o /tmp/nsys.deb "https://developer.download.nvidia.com/devtools/repos/ubuntu2204/amd64/${NSYS_DEB}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/nsys.deb; \
    rm -f /tmp/nsys.deb; \
    rm -rf /var/lib/apt/lists/*; \
    nsys --version

# SET WORKDIR
WORKDIR /workspace

# Default command
CMD ["sleep", "infinity"]
