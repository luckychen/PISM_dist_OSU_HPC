# PISM Distribution Project Context

## Project Overview

**Purpose**: Create a portable PISM (Parallel Ice Sheet Model) installation that can be distributed via GitHub, allowing any user on the CEOAS HPC cluster to run PISM with their own account without needing to rebuild from source.

**Repository**: https://github.com/luckychen/PISM_dist_OSU_HPC

**Status**: ✅ Complete and tested (as of January 12, 2026)

## Project Goals

1. ✅ Build PISM with all dependencies on CEOAS HPC cluster
2. ✅ Create portable installation that can be copied/cloned to other users
3. ✅ Provide comprehensive documentation for users
4. ✅ Create working example SLURM job scripts
5. ✅ Test the installation with real simulations
6. ✅ Distribute via GitHub for easy access

## System Environment

### HPC Platform
- **Cluster**: CEOAS HPC (Oregon State University)
- **OS**: Rocky Linux 9
- **Architecture**: Sandybridge
- **Scheduler**: SLURM
- **Partition**: ceoas (primary)
- **Compute Node Example**: hina01

### Spack Environment
- **Location**: `/local/cluster/CEOAS/spack/`
- **Setup Script**: `/local/cluster/CEOAS/spack/share/spack/setup-env.sh`

### Key Dependencies (via Spack)
- OpenMPI 5.0.5 (gcc@13.2.0)
- GCC 13.2.0
- GSL 2.7.1 (gcc@13.2.0)
- HDF5 1.14.3 (specific hash: /liawpnh)
- ZLIB-NG 2.1.6 (specific hash: /be2z2sp)
- BZIP2 (specific hash: /pntcq57)
- CMake 3.27.9 (gcc@13.2.0)

## Installation Directory Structure

```
~/pism/
├── active_pism.sh              # Main environment setup script (includes spack)
├── spack_setup.sh              # Spack-specific setup (called by active_pism.sh)
├── pism_binaries/              # Main distribution directory
│   ├── bin/                    # PISM executables
│   │   ├── pism                # Main PISM executable
│   │   ├── pism_flowline
│   │   ├── pism_nc2cdo
│   │   └── [other utilities]
│   ├── lib64/                  # PISM shared libraries
│   │   ├── libpism.so.2.2.2
│   │   └── libpism.so -> libpism.so.2.2.2
│   ├── share/                  # Documentation and examples
│   │   ├── doc/pism/examples/  # Example simulations
│   │   └── pism/pism_config.nc # PISM configuration
│   ├── include/                # Header files
│   ├── runs/                   # Job output directory (not in git)
│   ├── active_pism.sh          # Copy of environment script
│   ├── run_pism_sample.slurm   # Working example job
│   ├── verify_setup.sh         # Installation verification
│   ├── README.md               # Main documentation
│   ├── QUICKSTART.md           # Quick start guide
│   ├── GITHUB_SETUP.md         # GitHub distribution guide
│   ├── SETUP_SUMMARY.md        # Setup summary
│   └── .gitignore              # Git ignore rules
├── local_stack/                # Local dependency builds
│   ├── lib/                    # FFTW, NetCDF libraries
│   └── [other local deps]
├── petsc-install/              # PETSc 3.21.6 (97 MB)
│   ├── lib/
│   └── include/
├── petsc-src/                  # PETSc source (not in git)
├── fftw-3.3.10/                # FFTW source build (not in git)
├── netcdf-c-4.9.2/             # NetCDF C source (not in git)
└── netcdf-cxx4-4.3.1/          # NetCDF C++ source (not in git)
```

## Software Versions

### PISM Stack
- **PISM**: 2.2.2-d6b3a29ca (committed by Constantine Khrulev on 2025-03-28)
- **PETSc**: 3.21.6
- **NetCDF-C**: 4.9.2
- **NetCDF-CXX4**: 4.3.1
- **FFTW**: 3.3.10
- **GSL**: 2.7.1
- **OpenMPI**: 5.0.5
- **CMake**: 3.27.9

### Compilation Details
- **Compiler**: GCC 13.2.0
- **Optimization**: `-O3 -march=sandybridge`
- **MPI**: OpenMPI 5.0.5
- **Build Date**: January 9, 2026
- **Test Date**: January 12, 2026

## Key Files and Their Purposes

### active_pism.sh (CRITICAL)
**Purpose**: Single-source environment setup script that loads all dependencies

**What it does**:
1. Dynamically finds installation root using `${BASH_SOURCE[0]}`
2. Loads Spack environment
3. Loads OpenMPI 5.0.5 via Spack
4. Loads GSL 2.7.1 via Spack
5. Loads HDF5, ZLIB, BZIP2
6. Sets compiler variables (CC=mpicc, CXX=mpicxx, F77=mpif77)
7. Suppresses MPI/CUDA warnings for hina nodes
8. Adds PISM binaries to PATH
9. Sets LD_LIBRARY_PATH for local_stack and petsc-install
10. Sets PISM_CONFIG_NC environment variable

**Key Features**:
- Uses relative paths from script location (portable)
- Already includes spack setup (users only need to source this one file)
- No hard-coded absolute paths

### run_pism_sample.slurm
**Purpose**: Working example SLURM job that runs PISM Test G

**Job Configuration**:
- Partition: ceoas
- Nodes: 1
- Tasks: 4 (MPI processes)
- Time: 30 minutes
- Output: `pism_test_output_%j.log`
- Error: `pism_test_error_%j.log`

**Test Details**:
- Runs PISM verification Test G
- Grid: 61×61×31
- Duration: 200 model years
- Output: `test_g_output.nc` (~3.3 MB)
- Runtime: ~2 minutes

**Important MPI Flags**:
- `--bind-to none` (avoids CPU binding issues)
- `--oversubscribe` (allows process oversubscription)

### verify_setup.sh
**Purpose**: Automated verification script to check installation

**Checks**:
1. Directory structure (bin/, lib64/, share/, local_stack/, petsc-install/)
2. Required files (active_pism.sh, bin/pism)
3. Environment loading (sources active_pism.sh only)
4. PISM executable availability
5. PISM version and functionality
6. SLURM availability

## Testing History

### Successful Test (Job 2352967)
- **Date**: January 12, 2026, 15:10 PST
- **Job ID**: 2352967
- **Test**: PISM Verification Test G
- **Duration**: ~2 minutes
- **Processes**: 4 MPI tasks
- **Output**: test_g_output.nc (3.3 MB)
- **Result**: ✅ SUCCESS - All numerical errors within acceptable range

### Previous Test Attempts
- **Job 2352949**: Failed - library loading issues
- **Job 2352953**: Failed - pismr executable not found
- **Job 2352963**: Failed - missing -i input file or -test flag
- **Job 2352967**: ✅ SUCCESS - Test G completed

### Lessons Learned
1. Must use `pism` executable (not `pismr` or `pismv`)
2. PISM requires either `-i input.nc` or `-test [TEST]` flag
3. MPI requires `--bind-to none --oversubscribe` flags on CEOAS HPC
4. OpenMPI warnings about /dev/knem are normal and don't affect functionality
5. active_pism.sh must be sourced before running PISM

## Git Repository Details

### GitHub Account
- **Username**: luckychen
- **SSH Key**: Configured and working
- **Authentication**: Via SSH (git@github.com)

### Repository Information
- **URL**: https://github.com/luckychen/PISM_dist_OSU_HPC
- **Branch**: main
- **Commits**:
  - Initial: 2d3a903 (8,024 files, 1,242,867 insertions)
  - Update: 22ebfd4 (removed redundant spack_setup.sh calls)

### What's in Git
✅ **Included**:
- PISM binaries (bin/)
- Shared libraries (lib64/)
- Headers (include/)
- Documentation (share/, *.md)
- PETSc installation (petsc-install/, 97 MB)
- Local stack (local_stack/)
- Scripts (active_pism.sh, verify_setup.sh, *.slurm)

❌ **Excluded** (via .gitignore):
- Log files (*.log)
- Simulation outputs (runs/)
- Source tarballs (*.tar.gz)
- Source directories (fftw-3.3.10/, netcdf-*, petsc-src/)
- Temporary files (*.tmp, *~, .DS_Store)

### Repository Size
- Total committed: 8,024 files
- PETSc: 97 MB
- Full repository: ~150-200 MB

## User Installation Instructions

### For New Users on CEOAS HPC

```bash
# 1. Clone the repository
cd ~
git clone https://github.com/luckychen/PISM_dist_OSU_HPC.git pism

# 2. Verify installation
cd ~/pism/pism_binaries
bash verify_setup.sh

# 3. Submit test job
sbatch run_pism_sample.slurm

# 4. Check job status
squeue -u $USER

# 5. View results
cat pism_test_output_*.log
ls -lh runs/run_*/
```

### Requirements for Users
- Access to CEOAS HPC cluster
- Same Spack environment at `/local/cluster/CEOAS/spack/`
- SLURM access
- No special permissions needed

## Known Issues and Solutions

### Issue 1: Library Not Found Errors
**Symptom**: `libhdf5_hl.so.200: cannot open shared object file`
**Solution**: Source `active_pism.sh` before running PISM

### Issue 2: MPI /dev/knem Warning
**Symptom**: Warning about failed to open /dev/knem device
**Solution**: This is normal, ignore it. MPI falls back to alternative methods

### Issue 3: CPU Binding Errors
**Symptom**: "require binding processes to more cpus than are available"
**Solution**: Use `mpirun --bind-to none --oversubscribe`

### Issue 4: PISM Command Not Found
**Symptom**: PISM executable not in PATH
**Solution**:
1. Ensure active_pism.sh is sourced
2. Check PATH includes $PISM_PACKAGE_ROOT/pism_binaries/bin

### Issue 5: Wrong Executable Name
**Symptom**: "pismr: command not found"
**Solution**: Use `pism` not `pismr` or `pismv`

## Important Notes for Future Development

### DO NOT
- ❌ Hard-code absolute paths in scripts
- ❌ Rely on user-specific configurations
- ❌ Commit log files or temporary data
- ❌ Include source tarballs in git (too large)
- ❌ Use `spack_setup.sh` separately (it's in active_pism.sh)

### DO
- ✅ Use relative paths from script location
- ✅ Test with `verify_setup.sh` before distributing
- ✅ Update documentation when making changes
- ✅ Use environment variables for paths
- ✅ Keep active_pism.sh as the single entry point

## Future Work / TODOs

### Potential Improvements
1. Add more example SLURM scripts for different use cases
2. Create scripts for different partitions/resource allocations
3. Add Python post-processing examples
4. Create visualization examples
5. Add troubleshooting guide with common errors
6. Create build-from-source instructions as backup
7. Add GPU support if available on cluster
8. Create Jupyter notebook examples

### Maintenance Tasks
1. Update PISM when new versions are released
2. Test with different SLURM partitions
3. Verify compatibility with cluster updates
4. Keep documentation synchronized
5. Monitor for GitHub repository size limits

## Contact and Support

### For This Installation
- GitHub Issues: https://github.com/luckychen/PISM_dist_OSU_HPC/issues
- Maintainer: luckychen (GitHub)

### For PISM Software
- PISM Website: https://www.pism.io
- PISM Documentation: https://www.pism.io/docs/
- PISM GitHub: https://github.com/pism/pism
- PISM Discussions: https://github.com/pism/pism/discussions
- PISM Email: uaf-pism@alaska.edu

### For CEOAS HPC
- CEOAS HPC Support: Contact system administrators
- Spack Issues: Check with HPC support team

## Key Takeaways

1. **Single Source Command**: Users only need `source active_pism.sh`
2. **Portable**: Works for any user on CEOAS HPC with same Spack environment
3. **Tested**: Successfully runs PISM Test G
4. **Documented**: Comprehensive README and guides
5. **GitHub Ready**: Fully committed and pushed
6. **No Rebuilding**: Users don't need to compile anything

## Session Continuation Instructions

**For Next Session**:
When resuming work on this project:

1. Navigate to: `cd ~/pism` or `cd ~/pism/pism_binaries`
2. Check git status: `git status`
3. Review recent changes: `git log --oneline -5`
4. Test current state: `bash pism_binaries/verify_setup.sh`
5. Read this context file: `cat context.md`

**Common Tasks**:
- Update repository: `git add . && git commit -m "message" && git push`
- Test changes: Submit `run_pism_sample.slurm` to verify
- Check for issues: Review GitHub issues or user feedback
- Update docs: Edit README.md or other .md files as needed

## Project Success Metrics

✅ **All Goals Achieved**:
- [x] PISM compiled and working
- [x] Portable installation created
- [x] Documentation complete
- [x] Example job working
- [x] Successfully tested (Job 2352967)
- [x] GitHub repository created
- [x] All files committed and pushed
- [x] Redundant setup calls removed
- [x] Ready for user distribution

---

**Last Updated**: January 12, 2026
**Project Status**: COMPLETE ✅
**Repository**: https://github.com/luckychen/PISM_dist_OSU_HPC
