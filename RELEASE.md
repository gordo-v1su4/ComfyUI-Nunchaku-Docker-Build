# Release Process

This document outlines the process for versioning and releasing the Docker image for this project.

## Versioning

This project uses semantic versioning (e.g., `v1.0.0`). Releases are managed using Git tags.

## Automated Release (Recommended)

The `.github/workflows/docker-build-push.yml` workflow is configured to automatically build and push the Docker image when a new tag is pushed to the `main` branch.

### Steps:

1.  **Ensure you are on the `main` branch and have pulled the latest changes.**
    ```bash
    git checkout main
    git pull origin main
    ```

2.  **Create a new Git tag.**
    For example, to create version `v1.0.0`:
    ```bash
    git tag -a v1.0.0 -m "Release v1.0.0"
    ```

3.  **Push the tag to GitHub.**
    ```bash
    git push origin v1.0.0
    ```

This will trigger the GitHub Actions workflow, which will build the Docker image and push it to Docker Hub with the following tags:
- `gordov1su4/comfyui-nunchaku:v1.0.0`
- `gordov1su4/comfyui-nunchaku:latest`

## Manual Release

If you need to build and push the image manually, follow these steps.

1.  **Build the image locally.**
    ```bash
    bash build.sh
    ```

2.  **Log in to Docker Hub.**
    ```bash
    docker login
    ```

3.  **Tag the image.**
    Replace `<version>` with the desired version number (e.g., `1.0.0`).
    ```bash
    docker tag comfyui-nunchaku:latest gordov1su4/comfyui-nunchaku:<version>
    docker tag comfyui-nunchaku:latest gordov1su4/comfyui-nunchaku:latest
    ```

4.  **Push the image to Docker Hub.**
    ```bash
    docker push gordov1su4/comfyui-nunchaku:<version>
    docker push gordov1su4/comfyui-nunchaku:latest
    ```
