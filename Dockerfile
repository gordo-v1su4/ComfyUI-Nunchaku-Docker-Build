# Use Ubuntu 24.04 base image for latest packages
FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV CUDA_HOME=/usr/local/cuda
ENV PATH=${CUDA_HOME}/bin:${PATH}
ENV LD_LIBRARY_PATH=${CUDA_HOME}/lib64

# Install all system dependencies in a single layer
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2 \
    software-properties-common \
    build-essential \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    gcc-13 \
    g++-13 \
    libopencv-dev \
    libopencv-contrib-dev \
    python3-opencv \
    cmake \
    ninja-build \
    git \
    pkg-config \
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
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 60 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 60 \
    && rm -rf /var/lib/apt/lists/*

# Add NVIDIA CUDA repository and install CUDA toolkit
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get install -y cuda-toolkit \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.12 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Set work directory
WORKDIR /app

# Copy ComfyUI files
COPY ComfyUI/ /app/ComfyUI/

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

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

# Install filterpy from git
RUN pip3 install git+https://github.com/rlabbe/filterpy.git --break-system-packages

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

# Set entrypoint and default command
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["python3", "/app/ComfyUI/main.py"]
