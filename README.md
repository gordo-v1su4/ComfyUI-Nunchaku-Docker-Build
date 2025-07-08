# ComfyUI-Nunchaku Docker Build

![Docker Build](https://github.com/gordo-v1su4/ComfyUI-Nunchaku-Docker-Build/workflows/Build%20and%20Push%20Docker%20Image/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/gordov1su4/comfyui-nunchaku)
![Docker Image Size](https://img.shields.io/docker/image-size/gordov1su4/comfyui-nunchaku)

This Docker setup includes ComfyUI with Nunchaku extensions and all necessary dependencies pre-installed and configured. The image is automatically built and pushed to Docker Hub using GitHub Actions.

## 🚀 Quick Start

### Using Docker Hub (Recommended)

```bash
docker run -d \
  --name comfyui-nunchaku \
  --gpus all \
  -p 8188:8188 \
  -v ./models:/app/ComfyUI/models \
  -v ./user:/app/ComfyUI/user \
  -v ./output:/app/ComfyUI/output \
  gordov1su4/comfyui-nunchaku:latest
```

### Using Docker Compose

```bash
docker-compose up -d
```

## 🛠️ Development Environment

- **CUDA**: 12.4 development toolkit
- **Python**: 3.12 with development packages
- **GCC**: 13 C++ compiler
- **OpenCV**: Development libraries
- **Build Tools**: CMake, Ninja
- **PyTorch**: Latest stable with CUDA 12.4 support
- **xFormers**: Latest stable version

## ✅ Fixed Issues Included

✅ **pyav updated** to v15.0.0 - Fixed API nodes error  
✅ **insightface installed** - Fixed nunchaku PuLID import failures  
✅ **facexlib & filterpy installed** - Fixed parsing module errors  
✅ **torch_complex installed** - Fixed multiple warnings  
✅ **ffmpeg-python installed** - For audio processing  
✅ **timm updated** to v1.0.16 - Fixed inspyrenet-rembg compatibility  
✅ **xformers installed** - Improved GPU performance  
✅ **speakers_info.json created** - Fixed TTS functionality  
✅ **Sox installed** - Audio processing support  

## 🔄 Automated Builds

This repository uses GitHub Actions to automatically build and push Docker images to Docker Hub:

- **On push to main**: Builds and pushes `latest` tag
- **On version tags**: Builds and pushes versioned tags (e.g., `v1.0.0`)
- **On pull requests**: Builds image for testing (no push)

## 📦 Deployment in Coolify

### Method 1: Using Docker Compose (Recommended)

1. **Upload this entire folder** to your server or git repository
2. **In Coolify dashboard:**
   - Create a new service
   - Select "Docker Compose"
   - Point to your repository or upload the folder
   - Set the compose file path to `docker-compose.yml`
3. **Configure volumes** in Coolify:
   - `models` - For AI models persistence
   - `user` - For workflows and settings
   - `output` - For generated images
4. **Set environment variables** if needed:
   - `NVIDIA_VISIBLE_DEVICES=all`
   - `NVIDIA_DRIVER_CAPABILITIES=compute,utility`
5. **Deploy** and access on port 8188

### Method 2: Manual Docker Build

1. **Build the image:**
   ```bash
   docker build -t comfyui-nunchaku .
   ```

2. **Run the container:**
   ```bash
   docker run -d \
     --name comfyui-nunchaku \
     --gpus all \
     -p 8188:8188 \
     -v ./models:/app/ComfyUI/models \
     -v ./user:/app/ComfyUI/user \
     -v ./output:/app/ComfyUI/output \
     comfyui-nunchaku
   ```

## Requirements

- **NVIDIA GPU** with CUDA support
- **Docker** with GPU support (nvidia-docker)
- **8GB+ RAM** recommended
- **10GB+ disk space** for the base image

## Accessing ComfyUI

Once deployed, access ComfyUI at:
- **Local:** `http://localhost:8188`
- **Coolify:** Your configured domain/port

## Volume Mounts

- `/app/ComfyUI/models` - Store your AI models here
- `/app/ComfyUI/user` - Workflows, settings, and user data
- `/app/ComfyUI/output` - Generated images and outputs

## Troubleshooting

### GPU Issues
- Ensure NVIDIA drivers are installed on host
- Verify `nvidia-docker` is properly configured
- Check GPU visibility with `nvidia-smi`

### Memory Issues
- Increase Docker memory limits if needed
- Monitor GPU memory usage
- Consider using model offloading for large models

### Network Issues
- Ensure port 8188 is exposed
- Check firewall settings
- Verify Coolify proxy configuration

## Custom Nodes Included

- ComfyUI-nunchaku
- ComfyUI-Easy-Use
- ComfyUI-Manager
- ComfyUI-Crystools
- ComfyUI-GGUF
- rgthree-comfy
- was-node-suite-comfyui
- comfyui-inspyrenet-rembg
- comfyui-videohelpersuite
- And many more...

## Health Check

The container includes a health check that verifies ComfyUI is responding on port 8188. Coolify will automatically restart the container if the health check fails.

## Support

For issues related to:
- **ComfyUI:** Check the official ComfyUI repository
- **Nunchaku:** Check the Nunchaku documentation
- **Docker deployment:** Review container logs
- **Coolify:** Check Coolify documentation
## Test
