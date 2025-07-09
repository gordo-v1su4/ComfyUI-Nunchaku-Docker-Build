# Use Ubuntu 24.04 base image for latest packages
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64

# Install system dependencies and development tools
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2 \
    software-properties-common \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Add NVIDIA CUDA repository and install CUDA toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get install -y cuda-toolkit \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.12 and development packages
RUN apt-get update && apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install GCC 13 and C++ tools
RUN apt-get update && apt-get install -y \
    gcc-13 \
    g++-13 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 60 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 60 \
    && rm -rf /var/lib/apt/lists/*

# Install OpenCV development packages
RUN apt-get update && apt-get install -y \
    libopencv-dev \
    libopencv-contrib-dev \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Install CMake, Ninja, and other build tools
RUN apt-get update && apt-get install -y \
    cmake \
    ninja-build \
    git \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install additional system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    sox \
    libsox-dev \
    libsndfile1 \
    libgl1-mesa-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.12 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Set work directory
WORKDIR /app

# Copy ComfyUI files
COPY ComfyUI/ /app/ComfyUI/

# Install Python dependencies
#RUN python3 -m pip install --upgrade pip setuptools wheel --break-system-packages --force-reinstall

# Install latest stable PyTorch with CUDA 12.4 support
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124 --break-system-packages

# Install latest stable xFormers
RUN pip3 install xformers --break-system-packages

# Install core ComfyUI requirements
COPY ComfyUI/requirements.txt /app/requirements.txt
RUN pip3 install -r requirements.txt --break-system-packages

# Install additional dependencies we fixed
RUN pip3 install \
    torch_complex \
    ffmpeg-python \
    insightface \
    facexlib --no-deps --break-system-packages

# Manually install filterpy (fix for circular dependency)
RUN git clone https://github.com/rlabbe/filterpy.git /tmp/filterpy && \
    cp -r /tmp/filterpy/filterpy /usr/local/lib/python3.12/dist-packages/ && \
    rm -rf /tmp/filterpy

# Install custom node dependencies
RUN pip3 install -r /app/ComfyUI/custom_nodes/ComfyUI-nunchaku/requirements.txt --break-system-packages || true
RUN pip3 install -r /app/ComfyUI/custom_nodes/comfyui-inspyrenet-rembg/requirements.txt --break-system-packages || true
RUN pip3 install -r /app/ComfyUI/custom_nodes/stepaudiotts_mw/requirements.txt --break-system-packages || true

# Create required directories and files
RUN mkdir -p /app/ComfyUI/models/TTS/Step-Audio-speakers
RUN echo '{"speakers": {}}' > /app/ComfyUI/models/TTS/Step-Audio-speakers/speakers_info.json

# Create model directories
RUN mkdir -p /app/ComfyUI/models/checkpoints /app/ComfyUI/models/loras /app/ComfyUI/models/vae /app/ComfyUI/models/controlnet /app/ComfyUI/models/embeddings /app/ComfyUI/models/upscale_models /app/ComfyUI/models/clip_vision /app/ComfyUI/models/diffusion_models /app/ComfyUI/models/unet /app/ComfyUI/models/text_encoders /app/ComfyUI/models/xlabs /app/ComfyUI/models/pulid /app/ComfyUI/models/insightface /app/ComfyUI/models/facerestore_models /app/ComfyUI/models/animatediff_models /app/ComfyUI/models/animatediff_motion_lora /app/ComfyUI/models/clip /app/ComfyUI/models/configs /app/ComfyUI/models/diffusers /app/ComfyUI/models/florence2 /app/ComfyUI/models/gligen /app/ComfyUI/models/grounding-dino /app/ComfyUI/models/hypernetworks /app/ComfyUI/models/LLM /app/ComfyUI/models/luts /app/ComfyUI/models/nsfw_detector /app/ComfyUI/models/onnx /app/ComfyUI/models/photomaker /app/ComfyUI/models/reactor /app/ComfyUI/models/sams /app/ComfyUI/models/style_models /app/ComfyUI/models/ultralytics /app/ComfyUI/models/vae_approx /app/ComfyUI/models/vitmatte

# Set permissions
RUN chmod +x /app/ComfyUI/main.py

# Expose port
EXPOSE 8188

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8188/ || exit 1

# Start command
CMD ["python3", "/app/ComfyUI/main.py", "--listen", "0.0.0.0", "--port", "8188"]
