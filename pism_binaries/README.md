# PISM Binaries Directory

This directory contains the PISM (Parallel Ice Sheet Model) executables and libraries. This is part of the PISM portable distribution for CEOAS HPC.

## Quick Start

If you're looking for installation and usage instructions, please refer to the main README.md in the parent directory:

```bash
cd ~/pism
cat README.md
```

Or view it online at: https://github.com/luckychen/PISM_dist_OSU_HPC

## What's in This Directory

- `bin/` - PISM executables (pism, pismr, pism_flowline, etc.)
- `lib64/` - PISM shared libraries
- `share/` - Documentation, examples, and configuration files
- `include/` - Header files for development
- `runs/` - Output directory for simulation results (not tracked in git)
- `verify_setup.sh` - Installation verification script
- `run_pism_sample.slurm` - Example SLURM job script

## Running PISM

### Verify Installation

```bash
cd ~/pism/pism_binaries
bash verify_setup.sh
```

### Submit Sample Job

```bash
cd ~/pism/pism_binaries
sbatch run_pism_sample.slurm
```

### Check Job Status

```bash
squeue -u $USER
```

### Interactive Testing

```bash
# Request interactive session
srun --partition=ceoas --nodes=1 --ntasks=1 --time=00:30:00 --pty bash

# Load environment
source ~/pism/active_pism.sh

# Check PISM version
pism -version

# Run quick test
pism -test G -y 200
```

## Available Tools

The `bin/` directory includes:

- `pism` - Main PISM executable
- `pism_flowline` - 1D flowline model
- `pism_nc2cdo` - Convert output for CDO climate tools
- `pism_fill_missing` - Fill missing data in NetCDF files
- `pism_check_stationarity` - Check steady-state convergence

## Examples

PISM includes examples in `share/doc/pism/examples/`:

```bash
cd ~/pism/pism_binaries/share/doc/pism/examples/
ls -la
```

Available examples:
- `antarctica/` - Antarctic Ice Sheet simulations
- `std-greenland/` - Greenland Ice Sheet examples
- `marine/` - Marine ice sheet tests (Ross Ice Shelf)

## Documentation

For comprehensive documentation, see:

- **Main README**: `~/pism/README.md` - Complete installation and usage guide
- **Project Context**: `~/pism/context.md` - Technical details and project information
- **PISM Official Docs**: https://www.pism.io/docs/
- **This Repository**: https://github.com/luckychen/PISM_dist_OSU_HPC

## Support

- **PISM Issues**: https://github.com/pism/pism/discussions
- **This Distribution**: https://github.com/luckychen/PISM_dist_OSU_HPC/issues
- **CEOAS HPC**: Contact system administrators

## Software Versions

- PISM: 2.2.2
- PETSc: 3.21.6
- NetCDF-C: 4.9.2
- NetCDF-CXX4: 4.3.1
- FFTW: 3.3.10
- GSL: 2.7.1
- OpenMPI: 5.0.5
- GCC: 13.2.0
