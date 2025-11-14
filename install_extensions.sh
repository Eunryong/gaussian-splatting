#!/bin/bash
# Install CUDA extensions after conda environment is created
# Run this after: conda activate gaussian_splatting

set -e

echo "Installing CUDA extensions for Gaussian Splatting..."

# Apply patches if not already applied
echo "Checking CUDA architecture patches..."

cd submodules/diff-gaussian-rasterization
if git apply --check ../../patches/diff-gaussian-rasterization-rtx5070ti.patch 2>/dev/null; then
    git apply ../../patches/diff-gaussian-rasterization-rtx5070ti.patch
    echo "✓ diff-gaussian-rasterization patch applied"
else
    echo "✓ diff-gaussian-rasterization patch already applied or not needed"
fi
cd ../..

cd submodules/fused-ssim
if git apply --check ../../patches/fused-ssim-rtx5070ti.patch 2>/dev/null; then
    git apply ../../patches/fused-ssim-rtx5070ti.patch
    echo "✓ fused-ssim patch applied"
else
    echo "✓ fused-ssim patch already applied or not needed"
fi
cd ../..

# Set CUDA architecture for RTX 5070 Ti (compute capability 12.0)
# Force compilation for sm_90 (Hopper) which should be forward compatible
echo ""
echo "Setting CUDA architecture to sm_90 (forward compatibility for RTX 5070 Ti)..."
export TORCH_CUDA_ARCH_LIST="9.0"
export TCNN_CUDA_ARCHITECTURES="90"

# Install CUDA extensions
echo ""
echo "Installing diff-gaussian-rasterization..."
pip install --no-build-isolation submodules/diff-gaussian-rasterization

echo "Installing simple-knn..."
pip install --no-build-isolation submodules/simple-knn

echo "Installing fused-ssim..."
pip install --no-build-isolation submodules/fused-ssim

echo ""
echo "✓ All CUDA extensions installed successfully!"
echo ""
echo "To verify installation:"
echo "  python -c 'import diff_gaussian_rasterization; import simple_knn; print(\"All extensions loaded successfully!\")'"
