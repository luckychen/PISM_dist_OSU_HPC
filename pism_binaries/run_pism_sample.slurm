#!/bin/bash
#SBATCH --partition=ceoas
#SBATCH --job-name=pism_test
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --output=pism_test_output_%j.log
#SBATCH --error=pism_test_error_%j.log

echo "========================================"
echo "PISM Sample Simulation Job"
echo "Job ID: $SLURM_JOB_ID"
echo "Started at: $(date)"
echo "========================================"
echo ""

# Load PISM environment (includes spack setup)
# Get the directory where this script is located
cd $SLURM_SUBMIT_DIR/../
source active_pism.sh

# Disable SLURM CPU binding and let mpirun handle it
export OMP_NUM_THREADS=1
unset SLURM_CPU_BIND

# Suppress KNEM warning (device not available on CEOAS HPC)
export OMPI_MCA_btl_sm_use_knem=0
export OMPI_MCA_smsc=^knem

# Display job information
echo "======== Job Resources ========"
echo "Number of nodes: $SLURM_NNODES"
echo "Number of tasks: $SLURM_NTASKS"
echo "Tasks per node: $SLURM_TASKS_PER_NODE"
echo "CPUs per task: $SLURM_CPUS_PER_TASK"
echo "================================="
echo ""

# Verify PISM is available
echo "======== PISM Environment ========"
echo "PISM executable: $(which pism)"
echo "PISM version:"
pism -version
echo "=================================="
echo ""

# Create a working directory for this job
WORK_DIR="$PISM_PACKAGE_ROOT/pism_binaries/runs/run_${SLURM_JOB_ID}"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "Working directory: $WORK_DIR"
echo ""

# Run a PISM verification test
# These are standard test cases to verify PISM installation
echo "======== Running PISM Verification Test G ========"
echo "This is a thermomechanically coupled ice sheet test"
echo "Running for 200 model years..."
echo ""

mpirun -np $SLURM_NTASKS --bind-to none --oversubscribe pism \
  -config "$PISM_PACKAGE_ROOT/pism_binaries/share/pism/pism_config.nc" \
  -test G \
  -Mx 61 -My 61 -Mz 31 \
  -y 200 \
  -o test_g_output.nc

echo ""
echo "========================================"
echo "Job completed at: $(date)"
echo "Output files created:"
ls -lh *.nc
echo "========================================"
