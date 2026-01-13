#!/bin/bash
#SBATCH --partition=ceoas
#SBATCH --job-name=pi_mpi
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --output=pi_mpi_output_%j.log
#SBATCH --error=pi_mpi_error_%j.log

# Load spack environment with OpenMPI
cd ~/pism
source spack_setup.sh

# Disable SLURM CPU binding and let mpirun handle it
export OMP_NUM_THREADS=1
unset SLURM_CPU_BIND 
# Verify we have the right resources
echo "======== Job Information ========"
echo "Number of nodes: $SLURM_NNODES"
echo "Number of tasks: $SLURM_NTASKS"
echo "Tasks per node: $SLURM_TASKS_PER_NODE"
echo "CPUs per task: $SLURM_CPUS_PER_TASK"
echo "CPU bind method: $SLURM_CPU_BIND (socket-level binding)"
echo "MPI environment: spack-loaded OpenMPI"
echo "================================="
echo ""

# Navigate to job directory
cd ./pism_binaries/bin


# Run the MPI program with 36 processes on single node
echo "Running MPI Pi calculation with 36 processes on physical cores..."
echo ""
mpirun -np 1 --bind-to none ./pism -v 
echo ""
echo "Job completed successfully!"
