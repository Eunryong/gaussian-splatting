# RTX 5070 Ti Setup Guide

This branch contains configurations optimized for NVIDIA RTX 5070 Ti with CUDA 12.6.

## Hardware Requirements
- NVIDIA RTX 5070 Ti (Compute Capability 9.0)
- CUDA 12.6 installed
- 16GB+ VRAM recommended

## Quick Setup

### Option 1: Automated Setup (Recommended)
```bash
# Clone with submodules
git clone --recursive -b claude/rtx5070ti-cuda-setup-01EFgBafrKajCxzZHu9Zcv8g https://github.com/Eunryong/gaussian-splatting.git
cd gaussian-splatting

# Run setup script
./setup_rtx5070ti.sh
```

### Option 2: Manual Setup

#### Step 1: Clone Repository
```bash
git clone --recursive -b claude/rtx5070ti-cuda-setup-01EFgBafrKajCxzZHu9Zcv8g https://github.com/Eunryong/gaussian-splatting.git
cd gaussian-splatting
```

#### Step 2: Apply CUDA Architecture Patch
```bash
cd submodules/diff-gaussian-rasterization
git apply ../../patches/diff-gaussian-rasterization-rtx5070ti.patch
cd ../..
```

#### Step 3: Install Dependencies

**With Conda (Recommended):**
```bash
# Create conda environment (installs PyTorch and basic dependencies)
conda env create -f environment.yml
conda activate gaussian_splatting

# Install CUDA extensions (must be done after PyTorch is installed)
./install_extensions.sh
```

**With pip:**
```bash
pip install torch torchvision torchaudio plyfile tqdm opencv-python joblib

# Apply patch first
cd submodules/diff-gaussian-rasterization
git apply ../../patches/diff-gaussian-rasterization-rtx5070ti.patch
cd ../..

# Install CUDA extensions
pip install submodules/diff-gaussian-rasterization
pip install submodules/simple-knn
pip install submodules/fused-ssim
```

## What's Changed

### 1. CUDA Configuration (`environment.yml`)
- CUDA: 11.6 → 12.1 (compatible with CUDA 12.6)
- Python: 3.7 → 3.10
- PyTorch: Updated to latest with CUDA 12.x support
- Added nvidia channel for pytorch-cuda package

### 2. GPU Architecture Support
- Added compute capabilities 8.9 and 9.0 for newer GPUs
- Supports: Volta (7.0), Turing (7.5), Ampere (8.6), Ada Lovelace (8.9), Hopper (9.0)

### 3. Submodule Updates
- `simple-knn`: Changed from GitLab to GitHub mirror (access fix)
- `diff-gaussian-rasterization`: Patch for RTX 5070 Ti support
- `fused-ssim`: Updated to latest version

## Verify Installation

```bash
# Check CUDA availability
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}')"

# Check GPU
python -c "import torch; print(torch.cuda.get_device_name(0))"
```

Expected output:
```
CUDA available: True
CUDA version: 12.1
NVIDIA GeForce RTX 5070 Ti
```

## Training

```bash
# Basic training
python train.py -s <path_to_dataset>

# With options
python train.py -s <path_to_dataset> --iterations 30000 --save_iterations 7000 30000
```

## Troubleshooting

### CUDA Extension Build Errors
If you encounter build errors with the CUDA extensions:
```bash
# Ensure patch is applied
cd submodules/diff-gaussian-rasterization
git apply --check ../../patches/diff-gaussian-rasterization-rtx5070ti.patch

# If not applied:
git apply ../../patches/diff-gaussian-rasterization-rtx5070ti.patch
```

### Out of Memory
If you run out of VRAM during training:
- Reduce resolution: Use `--resolution 1` or lower
- Reduce iterations: `--iterations 10000`
- Use smaller datasets initially

## References
- Original repository: https://github.com/graphdeco-inria/gaussian-splatting
- CUDA compatibility: https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/
