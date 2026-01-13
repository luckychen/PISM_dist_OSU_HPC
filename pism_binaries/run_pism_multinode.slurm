#!/bin/bash
#SBATCH --job-name=pism_multinode
#SBATCH --partition=ceoas
#SBATCH --nodes=4
#SBATCH --ntasks=16
#SBATCH --ntasks-per-node=4
#SBATCH --time=01:00:00
#SBATCH --output=pism_multinode_output_%j.log
#SBATCH --error=pism_multinode_error_%j.log

# Multi-node PISM job example
# This demonstrates running PISM across multiple compute nodes
# Configuration: 4 nodes, 16 total MPI tasks, 4 tasks per node

echo "=========================================="
echo "PISM Multi-Node Job Starting"
echo "=========================================="
echo "Job ID: $SLURM_JOB_ID"
echo "Nodes: $SLURM_JOB_NUM_NODES"
echo "Tasks: $SLURM_NTASKS"
echo "Tasks per node: $SLURM_NTASKS_PER_NODE"
echo "Node list: $SLURM_JOB_NODELIST"
echo "=========================================="
echo ""

# Load PISM environment
echo "Loading PISM environment..."
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PISM_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PISM_ROOT"
source active_pism.sh
echo "PISM environment loaded successfully"
echo ""

# Suppress KNEM warning (device not available on CEOAS HPC)
export OMPI_MCA_smsc=^knem

# Create output directory
RUN_DIR="$PISM_PACKAGE_ROOT/pism_binaries/runs/multinode_run_${SLURM_JOB_ID}"
mkdir -p "$RUN_DIR"
cd "$RUN_DIR"

echo "Output directory: $RUN_DIR"
echo ""
echo "=========================================="
echo "Starting PISM Simulation"
echo "=========================================="
echo ""

# Run PISM Test G with higher resolution to utilize multiple nodes
# Grid: 121x121x51 (larger than single-node example)
# Duration: 1000 model years
mpirun --bind-to none --oversubscribe \
    -np $SLURM_NTASKS pism \
    -test G \
    -Mx 121 -My 121 -Mz 51 \
    -y 1000 \
    -o pism_multinode_output.nc

EXIT_CODE=$?

echo ""
echo "=========================================="
echo "PISM Simulation Completed"
echo "=========================================="
echo "Exit code: $EXIT_CODE"
echo "Output location: $RUN_DIR"
echo ""

if [ $EXIT_CODE -eq 0 ]; then
    echo "SUCCESS: Simulation completed successfully"
    ls -lh pism_multinode_output.nc
else
    echo "ERROR: Simulation failed with exit code $EXIT_CODE"
fi

echo ""
echo "=========================================="
echo "Job Complete"
echo "=========================================="
