#!/bin/bash
# Setup script for RTX 5070 Ti (CUDA 12.6, Compute Capability 9.0)

set -e

echo "Setting up Gaussian Splatting for RTX 5070 Ti..."

# Apply patch to diff-gaussian-rasterization for newer GPU architectures
echo "Applying CUDA architecture patch..."
cd submodules/diff-gaussian-rasterization
if git apply --check ../../patches/diff-gaussian-rasterization-rtx5070ti.patch 2>/dev/null; then
    git apply ../../patches/diff-gaussian-rasterization-rtx5070ti.patch
    echo "✓ Patch applied successfully"
else
    echo "! Patch already applied or not needed"
fi
cd ../..

# Install dependencies
echo "Installing dependencies..."
if command -v conda &> /dev/null; then
    echo "Using conda environment..."
    conda env create -f environment.yml || conda env update -f environment.yml --prune

    echo ""
    echo "Now installing CUDA extensions..."
    echo "Activating environment and installing extensions..."

    # Activate and install CUDA extensions
    eval "$(conda shell.bash hook)"
    conda activate gaussian_splatting

    pip install --no-build-isolation submodules/diff-gaussian-rasterization
    pip install --no-build-isolation submodules/simple-knn
    pip install --no-build-isolation submodules/fused-ssim

    echo ""
    echo "✓ Environment setup complete!"
    echo "Activate environment with: conda activate gaussian_splatting"
else
    echo "Conda not found. Installing with pip..."
    pip install torch torchvision torchaudio plyfile tqdm opencv-python joblib

    echo "Installing CUDA extensions..."
    pip install --no-build-isolation submodules/diff-gaussian-rasterization
    pip install --no-build-isolation submodules/simple-knn
    pip install --no-build-isolation submodules/fused-ssim
fi

echo ""
echo "✓ Setup complete!"
echo ""
echo "To verify CUDA setup, run:"
echo "  python -c 'import torch; print(f\"CUDA available: {torch.cuda.is_available()}\"); print(f\"CUDA version: {torch.version.cuda}\")'"
echo ""
echo "To start training:"
echo "  python train.py -s <path_to_dataset>"
