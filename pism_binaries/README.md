# PISM Portable Installation Guide

This repository contains a portable PISM (Parallel Ice Sheet Model) installation for the CEOAS HPC cluster. Follow these instructions to set up and run PISM simulations with your account.

## Prerequisites

- Access to the CEOAS HPC cluster
- Basic familiarity with Linux command line
- Access to the SLURM job scheduler

## Installation Steps

### 1. Clone or Copy the Repository

```bash
# Navigate to your home directory
cd ~

# Clone the repository (or copy the pism folder if sharing via other means)
# git clone <repository-url> pism
# OR if copying from another location:
# cp -r /path/to/pism ~/pism
```

### 2. Verify the Directory Structure

After cloning/copying, your `~/pism` directory should contain:

```
pism/
├── active_pism.sh          # Environment activation script
├── spack_setup.sh          # Spack environment setup
├── pism_binaries/          # PISM installation
│   ├── bin/                # PISM executables
│   ├── lib64/              # Required libraries
│   ├── share/              # Documentation and examples
│   ├── run_pism_sample.slurm  # Sample job script
│   └── README.md           # This file
├── local_stack/            # Local dependency installations
├── petsc-install/          # PETSc library
└── fftw-3.3.10/           # FFTW library
```

### 3. Update Path References

**IMPORTANT:** The `active_pism.sh` script automatically detects its location, so no path modifications are needed. However, you must ensure the script is sourced from the correct location.

## Running PISM Simulations

### Quick Start: Submit a Sample Job

1. **Navigate to the pism_binaries directory:**
   ```bash
   cd ~/pism/pism_binaries
   ```

2. **Make the SLURM script executable (if needed):**
   ```bash
   chmod +x run_pism_sample.slurm
   ```

3. **Submit the sample job:**
   ```bash
   sbatch run_pism_sample.slurm
   ```

4. **Check job status:**
   ```bash
   squeue -u $USER
   ```

5. **View results when complete:**
   ```bash
   # Check output logs
   cat pism_test_output_*.log
   cat pism_test_error_*.log

   # View the simulation output
   ls -lh runs/run_*/
   ```

### Understanding the Sample Job

The `run_pism_sample.slurm` script runs an EISMINT II Experiment A test case, which is a standard ice sheet model benchmark. The simulation:

- Uses 4 MPI processes
- Runs for 10,000 model years
- Creates a 61×61×31 grid (Mx, My, Mz)
- Outputs results every 100 years
- Takes approximately 5-15 minutes to complete

### Customizing Your Job

Edit `run_pism_sample.slurm` to modify:

#### SLURM Parameters
```bash
#SBATCH --partition=ceoas        # Partition name (change if needed)
#SBATCH --nodes=1                # Number of nodes
#SBATCH --ntasks=4               # Total number of MPI processes
#SBATCH --time=00:30:00          # Time limit (HH:MM:SS)
```

#### PISM Parameters

Common PISM options:

- `-Mx`, `-My`, `-Mz`: Grid resolution (higher = more detail, slower)
- `-y`: Simulation duration in years
- `-ts_times`: Time series output frequency
- `-o`: Output file name
- `-sia_e`: Enhancement factor for ice deformation

Example for a longer, higher-resolution run:
```bash
mpirun -np $SLURM_NTASKS pismr \
  -Mx 121 -My 121 -Mz 51 \
  -Lz 4000 \
  -y 50000 \
  -sia_e 3.0 \
  -ts_file ts_output.nc -ts_times 0:500:50000 \
  -o final_output.nc
```

## Running Interactive Tests

To test PISM interactively (for debugging):

```bash
# Login to a compute node
srun --partition=ceoas --nodes=1 --ntasks=1 --time=00:30:00 --pty bash

# Load the environment
cd ~/pism
source spack_setup.sh
source active_pism.sh

# Test PISM
pism -version

# Run a quick test (single core)
pism -test G -y 200
```

## Available PISM Tools

The `~/pism/pism_binaries/bin/` directory contains several utilities:

- `pism` - Main PISM executable
- `pismr` - PISM with restart capabilities
- `pism_flowline` - 1D flowline model
- `pism_nc2cdo` - Convert PISM output for CDO tools
- `pism_fill_missing` - Fill missing data in input files
- `pism_check_stationarity` - Check if simulation reached steady state

## Example Simulations

PISM includes many example simulations in `~/pism/pism_binaries/share/doc/pism/examples/`:

- `antarctica/` - Antarctic ice sheet simulations
- `eismintII/` - Standard verification tests
- `marine/` - Marine ice sheet tests
- `std-greenland/` - Greenland ice sheet examples
- `ross/` - Ross Ice Shelf examples

To explore examples:
```bash
cd ~/pism/pism_binaries/share/doc/pism/examples/
ls -la
```

## Troubleshooting

### Issue: "Library not found" errors

**Solution:** Ensure you've sourced the environment scripts:
```bash
cd ~/pism
source spack_setup.sh
source active_pism.sh
```

### Issue: Job fails immediately

**Solution:** Check the error log:
```bash
cat pism_test_error_*.log
```

Common issues:
- Incorrect partition name (change `ceoas` to your available partition)
- Insufficient time allocation
- Path issues (ensure you're in the correct directory)

### Issue: "PISM: command not found"

**Solution:** The PISM environment wasn't loaded. Make sure to:
1. Source the scripts in the job script (already done in sample)
2. Verify paths in `active_pism.sh`

### Issue: Job stuck in queue

**Solution:** Check cluster status and your account limits:
```bash
squeue -u $USER
sinfo
sacctmgr show assoc user=$USER format=Account,Partition,MaxJobs,MaxSubmit
```

## Performance Guidelines

### Choosing MPI Process Count

- **Small tests (Mx, My < 100):** Use 1-4 processes
- **Medium simulations (Mx, My 100-300):** Use 4-16 processes
- **Large simulations (Mx, My > 300):** Use 16-64+ processes

### Memory Considerations

Approximate memory usage:
- Grid size: Mx × My × Mz × 8 bytes per variable
- Multiple variables stored simultaneously
- Rule of thumb: ~1-2 GB per million grid points

### Time Estimates

For EISMINT II-style tests:
- 10,000 years on 61×61×31 grid with 4 cores: ~5-15 minutes
- 50,000 years on 121×121×51 grid with 16 cores: ~1-3 hours
- Real ice sheet simulations (high resolution): hours to days

## Getting Help

1. **PISM Documentation:** https://www.pism.io/docs/
2. **PISM Help:** Run `pism --help` or `pism -help` for options
3. **Cluster Documentation:** Check your HPC center's documentation
4. **PISM User Forum:** https://github.com/pism/pism/discussions

## File Management

### Output Files

PISM creates NetCDF (.nc) files. To view:

```bash
# Use ncdump to see file structure
ncdump -h output.nc

# Use NCO tools for processing
module load nco  # if available
ncview output.nc  # visual inspection (if X11 forwarding enabled)
```

### Cleaning Up

To clean old job outputs:
```bash
cd ~/pism/pism_binaries
rm -f pism_test_*_*.log  # Remove old logs
rm -rf runs/run_*        # Remove old simulation outputs (be careful!)
```

## Citation

If you use PISM for research, please cite:

> The PISM Authors (2024). PISM, a Parallel Ice Sheet Model: https://www.pism.io

See https://www.pism.io/publications/ for more citation information.

## License

PISM is open source software under the GNU General Public License v3.0.

## Quick Reference Commands

```bash
# Submit sample job
cd ~/pism/pism_binaries && sbatch run_pism_sample.slurm

# Check job status
squeue -u $USER

# Cancel a job
scancel <job_id>

# View recent logs
ls -lt pism_test_*.log | head -2 | xargs tail -n 50

# Test PISM interactively
srun --partition=ceoas --nodes=1 --ntasks=1 --time=00:10:00 --pty bash
cd ~/pism && source spack_setup.sh && source active_pism.sh
pism -version
```

## Support

For issues specific to this installation, contact the person who shared this repository with you or your HPC system administrator.
