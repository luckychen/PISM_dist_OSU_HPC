#!/bin/bash

# PISM Installation Verification Script
# Run this to check if PISM is properly set up

echo "======================================"
echo "PISM Installation Verification"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "verify_setup.sh" ]; then
    echo "ERROR: Please run this script from the pism_binaries directory"
    echo "Usage: cd ~/pism/pism_binaries && bash verify_setup.sh"
    exit 1
fi

# Check directory structure
echo "[1/6] Checking directory structure..."
MISSING_DIRS=()
for dir in bin lib64 share ../local_stack ../petsc-install; do
    if [ ! -d "$dir" ]; then
        MISSING_DIRS+=("$dir")
    fi
done

if [ ${#MISSING_DIRS[@]} -eq 0 ]; then
    echo "✓ All required directories present"
else
    echo "✗ Missing directories: ${MISSING_DIRS[*]}"
    exit 1
fi

# Check for key files
echo "[2/6] Checking required files..."
MISSING_FILES=()
for file in ../active_pism.sh bin/pism; do
    if [ ! -f "$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -eq 0 ]; then
    echo "✓ All required files present"
else
    echo "✗ Missing files: ${MISSING_FILES[*]}"
    exit 1
fi

# Load environment
echo "[3/6] Loading PISM environment..."
cd ~/pism
if ! source active_pism.sh 2>/dev/null; then
    echo "✗ Failed to load PISM environment"
    exit 1
fi
echo "✓ Environment loaded successfully"

# Check PISM executable
echo "[4/6] Checking PISM executable..."
if command -v pism &> /dev/null; then
    echo "✓ PISM found in PATH: $(which pism)"
else
    echo "✗ PISM not found in PATH"
    exit 1
fi

# Check PISM version
echo "[5/6] Checking PISM version..."
if pism -version &> /dev/null; then
    echo "✓ PISM runs successfully"
    echo "  Version info:"
    pism -version 2>&1 | head -5 | sed 's/^/    /'
else
    echo "✗ PISM failed to run"
    exit 1
fi

# Check SLURM availability
echo "[6/6] Checking SLURM availability..."
if command -v sbatch &> /dev/null; then
    echo "✓ SLURM commands available"
else
    echo "✗ SLURM not found (may not be on compute node)"
fi

echo ""
echo "======================================"
echo "Verification Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Submit sample job: sbatch run_pism_sample.slurm"
echo "2. Check status: squeue -u \$USER"
echo "3. View output: cat pism_test_output_*.log"
echo ""
echo "For more information, see README.md"
