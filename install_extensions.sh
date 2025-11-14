#!/bin/bash
# Install CUDA extensions after conda environment is created
# Run this after: conda activate gaussian_splatting

set -e

echo "Installing CUDA extensions for Gaussian Splatting..."

# Apply patch if not already applied
echo "Checking CUDA architecture patch..."
cd submodules/diff-gaussian-rasterization
if git apply --check ../../patches/diff-gaussian-rasterization-rtx5070ti.patch 2>/dev/null; then
    git apply ../../patches/diff-gaussian-rasterization-rtx5070ti.patch
    echo "✓ Patch applied"
else
    echo "✓ Patch already applied or not needed"
fi
cd ../..

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
