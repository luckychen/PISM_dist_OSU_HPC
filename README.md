# PISM Portable Distribution for CEOAS HPC

A ready-to-run PISM (Parallel Ice Sheet Model) installation for the CEOAS HPC cluster at Oregon State University. This distribution includes pre-compiled binaries and all necessary dependencies, allowing you to run ice sheet simulations without building from source.

## Quick Start (5 Minutes)

```bash
# 1. Clone the repository to your desired location
cd ~  # or any directory you prefer
git clone https://github.com/luckychen/PISM_dist_OSU_HPC.git pism

# 2. Navigate to the distribution directory
cd pism/pism_binaries

# 3. Verify the installation
bash verify_setup.sh

# 4. Submit a test job
sbatch run_pism_sample.slurm

# 5. Check job status
squeue -u $USER
```

That's it! The test job runs PISM verification Test G and completes in about 2 minutes.

**Note:** All scripts are fully portable - you can install PISM to any directory and they will automatically detect the correct paths.

## What's Included

This distribution provides:

- **PISM 2.2.2** - Pre-compiled ice sheet model binaries
- **All Dependencies** - PETSc 3.21.6, NetCDF 4.9.2, FFTW 3.3.10, and more
- **Environment Scripts** - Automatic setup of all required libraries
- **Example Jobs** - Working SLURM job scripts
- **Verification Tools** - Automated installation checker

### What You DON'T Need

- No compilation required
- No dependency hunting
- No manual library configuration
- No root/admin privileges

## System Requirements

### Required (Available on CEOAS HPC)

- **Cluster Access**: CEOAS HPC account
- **Spack Environment**: Available at `/local/cluster/CEOAS/spack/`
  - This is a **cluster-wide installation** accessible to all users
  - No special permissions needed
- **Job Scheduler**: SLURM access
- **Architecture**: x86_64 (Sandybridge or newer)

### Operating System

- Rocky Linux 9 (CEOAS HPC standard)
- Should work on any RHEL 9-compatible system with the same Spack environment

## Installation Instructions

### Step 1: Clone the Repository

```bash
# Navigate to your desired installation directory
cd ~  # or any directory you prefer

# Clone the repository
git clone https://github.com/luckychen/PISM_dist_OSU_HPC.git pism

# Check the installation size
du -sh pism
# Expected: ~200-300 MB
```

### Step 2: Verify Directory Structure

Your `pism` directory should contain:

```
pism/
├── active_pism.sh          # Single-source environment setup
├── pism_binaries/          # Main distribution directory
│   ├── bin/                # PISM executables (pism, pismr, etc.)
│   ├── lib64/              # PISM shared libraries
│   ├── share/              # Documentation and examples
│   ├── include/            # Header files (for development)
│   ├── verify_setup.sh     # Installation verification script
│   ├── run_pism_sample.slurm  # Example single-node SLURM job
│   ├── run_pism_multinode.slurm  # Example multi-node SLURM job
│    
├── local_stack/            # Local dependencies (FFTW, NetCDF)
│   └── lib/
└── petsc-install/          # PETSc 3.21.6 installation
    ├── lib/
    └── include/
```

### Step 3: Verify Installation

Run the verification script to ensure everything is set up correctly:

```bash
cd pism/pism_binaries
bash verify_setup.sh
```

**Expected output:**
```
✓ Directory structure check passed
✓ Required files check passed
✓ Environment loading check passed
✓ PISM executable check passed
✓ PISM version check passed
✓ SLURM availability check passed

All checks passed! PISM is ready to use.
```

If any checks fail, see the Troubleshooting section below.

## Running Your First Simulation

### Submit the Sample Job

The included `run_pism_sample.slurm` script runs PISM verification Test G:

```bash
cd pism/pism_binaries
sbatch run_pism_sample.slurm
```

**What this test does:**
- Runs PISM verification Test G (standard benchmark)
- Uses 4 MPI processes
- Simulates 200 model years
- Grid: 61×61×31 points
- Runtime: ~2 minutes
- Output: `test_g_output.nc` (~3.3 MB)

### Monitor Job Status

```bash
# Check if job is running
squeue -u $USER

# View output logs (after job completes)
cat pism_test_output_*.log

# Check for errors
cat pism_test_error_*.log

# View the output file
ls -lh runs/run_*/test_g_output.nc
```

### Expected Success Output

Look for these lines in `pism_test_output_*.log`:

```
NUMERICAL ERRORS evaluated at final time:
  geometry  :    prcntVOL        maxH         avH   relmaxETA
           0       1e-16    0.004188    0.001589    0.000435
```

All errors should be very small (< 0.01), indicating a successful test.

## Running Multi-Node Simulations

PISM supports parallel execution across multiple compute nodes using MPI. This allows you to run larger simulations with higher resolution and better performance.

### Multi-Node Example Job

The included `run_pism_multinode.slurm` script demonstrates running PISM across multiple nodes:

```bash
cd pism/pism_binaries
sbatch run_pism_multinode.slurm
```

**Configuration:**
- **Nodes**: 4 compute nodes
- **Total MPI tasks**: 16 (4 tasks per node)
- **Grid**: 121×121×51 points (higher resolution)
- **Duration**: 1000 model years
- **Runtime**: ~1-2 minutes
- **Output**: `pism_multinode_output.nc` (~18 MB)

### Understanding the Multi-Node Configuration

```bash
#SBATCH --nodes=4              # Number of compute nodes
#SBATCH --ntasks=16            # Total MPI processes across all nodes
#SBATCH --ntasks-per-node=4    # MPI processes per node
```

**How it works:**
- SLURM allocates 4 compute nodes
- Each node runs 4 MPI processes
- Total of 16 parallel processes work together
- PISM automatically distributes the computational domain across all processes

### Scaling Guidelines for Multi-Node Jobs

| Simulation Size | Recommended Config | Expected Performance |
|-----------------|-------------------|---------------------|
| Small (61×61×31) | 1 node, 4 tasks | 2-5 min for 1000 years |
| Medium (121×121×51) | 2-4 nodes, 8-16 tasks | 1-3 min for 1000 years |
| Large (241×241×101) | 8-16 nodes, 32-64 tasks | 5-15 min for 1000 years |
| Production runs | 16+ nodes, 64+ tasks | Hours for 10k+ years |

### Creating Custom Multi-Node Jobs

To create your own multi-node simulation:

```bash
#!/bin/bash
#SBATCH --job-name=my_pism_job
#SBATCH --partition=ceoas
#SBATCH --nodes=8                # Adjust based on your needs
#SBATCH --ntasks=32              # Adjust based on your needs
#SBATCH --ntasks-per-node=4      # Adjust based on node architecture
#SBATCH --time=04:00:00
#SBATCH --output=output_%j.log
#SBATCH --error=error_%j.log

# Load PISM environment
source ~/pism/active_pism.sh

# Suppress OpenMPI KNEM warnings (device not available on cluster)
export OMPI_MCA_btl_sm_use_knem=0
export OMPI_MCA_smsc=^knem

# Create output directory
RUN_DIR="$HOME/pism/pism_binaries/runs/my_run_${SLURM_JOB_ID}"
mkdir -p "$RUN_DIR"
cd "$RUN_DIR"

# Run your simulation with custom parameters
mpirun --bind-to none --oversubscribe \
    -np $SLURM_NTASKS pism \
    -test G \
    -Mx 241 -My 241 -Mz 101 \
    -y 10000 \
    -o output.nc
```

### Multi-Node Best Practices

1. **Resource Selection:**
   - Use `--ntasks-per-node` to control task distribution
   - Match tasks to your simulation size (more grid points = more tasks beneficial)
   - Don't over-allocate: diminishing returns beyond ~64-128 tasks for most problems

2. **Performance Tips:**
   - Larger grid sizes benefit more from multi-node parallelization
   - Use time series output (`-ts_file`) to monitor progress
   - Test with shorter runs first to verify configuration

3. **MPI Flags:**
   - Always include `--bind-to none --oversubscribe` for CEOAS HPC
   - Use `-np $SLURM_NTASKS` to automatically use all allocated tasks

4. **Monitoring:**
   ```bash
   # Check which nodes your job is using
   squeue -j JOB_ID

   # Watch output in real-time
   tail -f output_JOB_ID.log
   ```

### Troubleshooting Multi-Node Jobs

**Issue: Job won't allocate multiple nodes**

Solution: Check partition limits and node availability
```bash
sinfo                    # Check partition status
scontrol show partition ceoas  # Check partition limits
```

**Issue: Poor scaling performance**

Solution: Your grid may be too small for the number of processes. Use larger grids (`-Mx`, `-My`, `-Mz`) or reduce number of tasks.

**Issue: MPI communication errors**

Solution: Ensure all nodes can communicate. The `--bind-to none --oversubscribe` flags handle most issues on CEOAS HPC.

## Understanding the Environment Setup

### The Magic Script: active_pism.sh

This **single script** does everything needed to run PISM:

```bash
source ~/pism/active_pism.sh
```

**What it does:**
1. Loads Spack environment from cluster installation
2. Loads OpenMPI 5.0.5 (compiled with GCC 13.2.0)
3. Loads GSL, HDF5, and other dependencies
4. Sets compiler variables (mpicc, mpicxx, mpif77)
5. Adds PISM binaries to PATH
6. Configures library paths
7. Sets PISM configuration file location

**Key Feature:** Uses relative paths from script location, so it works regardless of where you clone the repository.

### How It Works in Jobs

The `run_pism_sample.slurm` script includes:

```bash
source ~/pism/active_pism.sh
```

This single line is all you need in your SLURM scripts. No manual path configuration required.

## Creating Your Own Simulations

### Example: Custom SLURM Job

Create a new file `my_simulation.slurm`:

```bash
#!/bin/bash
#SBATCH --job-name=my_pism_run
#SBATCH --partition=ceoas
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --time=01:00:00
#SBATCH --output=my_output_%j.log
#SBATCH --error=my_error_%j.log

# Load PISM environment
source ~/pism/active_pism.sh

# Suppress OpenMPI KNEM warnings (device not available on cluster)
export OMPI_MCA_btl_sm_use_knem=0
export OMPI_MCA_smsc=^knem

# Create output directory
RUN_DIR="$HOME/pism/pism_binaries/runs/my_run_${SLURM_JOB_ID}"
mkdir -p "$RUN_DIR"
cd "$RUN_DIR"

# Run your simulation
mpirun --bind-to none --oversubscribe \
    -np $SLURM_NTASKS pism \
    -test G \
    -Mx 121 -My 121 -Mz 51 \
    -y 1000 \
    -o my_output.nc

echo "Simulation complete. Output in: $RUN_DIR"
```

Submit with:
```bash
sbatch my_simulation.slurm
```

### Common PISM Options

- `-test [A-L]` - Run verification tests
- `-i input.nc` - Input file for restart/initialization
- `-Mx`, `-My`, `-Mz` - Grid resolution (higher = more detail)
- `-Lz` - Vertical domain extent (meters)
- `-y` - Simulation duration (years)
- `-o output.nc` - Output file name
- `-ts_file ts.nc` - Time series output
- `-ts_times` - Time series frequency (e.g., `0:100:10000`)

For full options:
```bash
# Interactive session
srun --partition=ceoas --nodes=1 --ntasks=1 --time=00:10:00 --pty bash
source ~/pism/active_pism.sh
pism --help
```

## Available Tools

The `~/pism/pism_binaries/bin/` directory includes:

- `pism` - Main PISM executable (use this for tests and simulations)
- `pism_flowline` - 1D flowline model
- `pism_nc2cdo` - Convert output for CDO climate tools
- `pism_fill_missing` - Fill missing data in NetCDF files
- `pism_check_stationarity` - Check steady-state convergence

## Example Simulations

PISM includes examples in `~/pism/pism_binaries/share/doc/pism/examples/`:

```bash
cd ~/pism/pism_binaries/share/doc/pism/examples/
ls -la
```

**Available examples:**
- `antarctica/` - Antarctic Ice Sheet simulations
- `std-greenland/` - Greenland Ice Sheet examples
- `marine/` - Marine ice sheet tests (Ross Ice Shelf)
- Verification tests embedded in PISM (use `-test` flag)

## Troubleshooting

### Issue: Library Not Found Errors

**Symptom:**
```
libhdf5_hl.so.200: cannot open shared object file: No such file or directory
```

**Solution:**
Ensure you source `active_pism.sh` before running PISM:
```bash
source ~/pism/active_pism.sh
pism -version
```

### Issue: Spack Not Found

**Symptom:**
```
/local/cluster/CEOAS/spack/share/spack/setup-env.sh: No such file or directory
```

**Solution:**
This means you're not on the CEOAS HPC cluster or the Spack installation has moved. Contact your system administrator.

### Issue: PISM Command Not Found

**Symptom:**
```
bash: pism: command not found
```

**Solution:**
1. Check that you sourced the environment: `source ~/pism/active_pism.sh`
2. Verify PATH: `echo $PATH | grep pism`
3. Check binary exists: `ls ~/pism/pism_binaries/bin/pism`

### Issue: MPI Warning About /dev/knem

**Symptom:**
```
WARNING: Failed to open /dev/knem device
```

**Solution:**
The included job scripts (`run_pism_sample.slurm` and `run_pism_multinode.slurm`) already suppress this warning. If you create your own job scripts, add these lines after sourcing the PISM environment:

```bash
export OMPI_MCA_btl_sm_use_knem=0
export OMPI_MCA_smsc=^knem
```

This disables OpenMPI's attempt to use the KNEM device (which is not available on CEOAS HPC) and eliminates the warning without affecting performance.

### Issue: CPU Binding Errors

**Symptom:**
```
Error: require binding processes to more cpus than are available
```

**Solution:**
Use these MPI flags in your job scripts:
```bash
mpirun --bind-to none --oversubscribe -np $SLURM_NTASKS pism ...
```

### Issue: Job Stuck in Queue

**Check cluster status:**
```bash
squeue -u $USER      # Your jobs
sinfo                # Partition availability
scontrol show job <job_id>  # Job details
```

**Common causes:**
- Requesting unavailable partition
- Resource limits exceeded
- Cluster maintenance

### Issue: Verification Script Fails

If `verify_setup.sh` reports failures:

1. **Check directory structure:**
   ```bash
   ls -la ~/pism/
   ```

2. **Ensure Git didn't corrupt files:**
   ```bash
   cd ~/pism
   git status
   git fsck
   ```

3. **Re-clone if necessary:**
   ```bash
   cd ~
   mv pism pism_backup
   git clone https://github.com/luckychen/PISM_dist_OSU_HPC.git pism
   ```

## Performance Guidelines

### Choosing Resources

| Grid Size | MPI Tasks | Memory | Time (10k years) |
|-----------|-----------|--------|------------------|
| 61×61×31 | 4 | ~2 GB | 5-15 min |
| 121×121×51 | 8-16 | ~8 GB | 30-60 min |
| 241×241×101 | 32-64 | ~32 GB | 2-4 hours |

### Scaling Recommendations

- **Small tests:** 1-4 processes sufficient
- **Production runs:** Use 1 MPI task per 2-4 CPU cores
- **Memory:** ~1-2 GB per million grid points
- **Time limits:** Add 50% buffer to estimates

### Example Resource Requests

**Small test run:**
```bash
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=00:30:00
```

**Medium production run:**
```bash
#SBATCH --nodes=2
#SBATCH --ntasks=32
#SBATCH --time=04:00:00
```

**Large simulation:**
```bash
#SBATCH --nodes=4
#SBATCH --ntasks=64
#SBATCH --time=24:00:00
```

## Software Versions

This distribution includes:

- **PISM**: 2.2.2 (commit d6b3a29ca, March 2025)
- **PETSc**: 3.21.6
- **NetCDF-C**: 4.9.2
- **NetCDF-CXX4**: 4.3.1
- **FFTW**: 3.3.10
- **GSL**: 2.7.1
- **OpenMPI**: 5.0.5
- **GCC**: 13.2.0

Compiled with `-O3 -march=sandybridge` for optimal performance on CEOAS HPC.

## Interactive Testing

For quick tests or debugging:

```bash
# Request interactive session
srun --partition=ceoas --nodes=1 --ntasks=1 --time=00:30:00 --pty bash

# Load environment
source ~/pism/active_pism.sh

# Check PISM version
pism -version

# Run a quick test (single core)
pism -test G -y 200

# Try a small parallel test
mpirun --bind-to none --oversubscribe -np 4 pism -test G -y 500
```

## Cleaning Up

### Remove Old Job Outputs

```bash
cd ~/pism/pism_binaries

# Remove old log files
rm -f *_output_*.log *_error_*.log

# Remove old simulation runs
rm -rf runs/run_*
```

### Disk Usage

Check installation size:
```bash
du -sh ~/pism
# Expected: 200-300 MB

du -sh ~/pism/pism_binaries/runs/
# Depends on simulation outputs
```

## Getting Help

### PISM Resources

- **Official Documentation**: https://www.pism.io/docs/
- **PISM Website**: https://www.pism.io
- **GitHub Repository**: https://github.com/pism/pism
- **Discussion Forum**: https://github.com/pism/pism/discussions
- **Email Support**: uaf-pism@alaska.edu

### This Distribution

- **GitHub Issues**: https://github.com/luckychen/PISM_dist_OSU_HPC/issues
- **Repository**: https://github.com/luckychen/PISM_dist_OSU_HPC

### CEOAS HPC Support

Contact your system administrator for:
- Cluster access issues
- SLURM problems
- Partition availability
- Spack environment issues

## Citation

If you use PISM in your research, please cite:

> The PISM Authors (2025). PISM, a Parallel Ice Sheet Model. https://www.pism.io

For specific publications, see: https://www.pism.io/publications/

## License

PISM is open source software distributed under the GNU General Public License v3.0.

## Quick Reference Card

```bash
# Installation
cd ~ && git clone https://github.com/luckychen/PISM_dist_OSU_HPC.git pism

# Verify
cd ~/pism/pism_binaries && bash verify_setup.sh

# Submit test
sbatch run_pism_sample.slurm

# Check status
squeue -u $USER

# Interactive test
srun --partition=ceoas --pty bash
source ~/pism/active_pism.sh
pism -test G -y 200

# View help
pism --help
```

## What Makes This Portable?

This distribution works for any user on CEOAS HPC because:

1. **No Hard-Coded Paths**: Uses `${BASH_SOURCE[0]}` to find installation location
2. **Shared Spack Libraries**: Relies on cluster-wide Spack at `/local/cluster/CEOAS/spack/`
3. **Bundled Dependencies**: Includes PETSc, NetCDF, FFTW in the repository
4. **Single Setup Script**: One source command loads everything
5. **Verified on Multiple Accounts**: Tested by different users

You can clone this anywhere in your home directory and it will work.

## Advanced Usage

### Using PISM with Your Own Input Files

```bash
# Example: Restart from previous simulation
mpirun -np 8 pism \
    -i previous_output.nc \
    -y 10000 \
    -o continued_output.nc
```

### Running Different Ice Sheet Models

```bash
# Antarctic Ice Sheet (requires input data)
mpirun -np 16 pism \
    -i antarctica_data.nc \
    -bootstrap \
    -Mx 201 -My 201 -Mz 51 \
    -y 100000 \
    -o antarctica_output.nc

# Greenland Ice Sheet (requires input data)
mpirun -np 16 pism \
    -i greenland_data.nc \
    -bootstrap \
    -Mx 301 -My 561 -Mz 101 \
    -y 50000 \
    -o greenland_output.nc
```

### Time Series and Spatial Outputs

```bash
mpirun -np 8 pism \
    -test G \
    -y 10000 \
    -o final_state.nc \
    -ts_file time_series.nc \
    -ts_times 0:100:10000 \
    -extra_file snapshots.nc \
    -extra_times 0:1000:10000 \
    -extra_vars thk,usurf,velsurf_mag
```

## Project Status

**Status**: ✅ Complete and tested (January 2026)

**Tested on:**
- CEOAS HPC cluster nodes (hina01, etc.)
- Multiple user accounts
- Various job configurations

**Last updated**: January 13, 2026

---

**Happy ice sheet modeling!** 🧊⛰️

For questions about this distribution, open an issue on GitHub:
https://github.com/luckychen/PISM_dist_OSU_HPC/issues
