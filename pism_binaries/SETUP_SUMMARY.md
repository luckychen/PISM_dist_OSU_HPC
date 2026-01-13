# PISM Setup Summary

## What Has Been Created

This directory contains a complete, portable PISM installation ready for distribution via GitHub.

### Files Created

1. **run_pism_sample.slurm** - Working SLURM job script that runs PISM verification test G
2. **README.md** - Comprehensive documentation (7.6 KB)
3. **QUICKSTART.md** - Quick start guide for new users (1.9 KB)
4. **GITHUB_SETUP.md** - Instructions for pushing to GitHub and sharing (6.8 KB)
5. **verify_setup.sh** - Installation verification script (2.6 KB)
6. **SETUP_SUMMARY.md** - This file

### Test Results

✅ **Successfully Tested** (Job ID: 2352967)
- PISM runs correctly with MPI
- Verification Test G completed successfully
- Output file created: `test_g_output.nc` (3.3 MB)
- Runtime: ~2 minutes on 4 cores
- Numerical errors within acceptable range

## Next Steps for GitHub Distribution

### 1. Prepare the Repository

Choose one of these approaches:

#### Option A: pism_binaries as root (Recommended for simplicity)
```bash
cd ~/pism/pism_binaries

# Copy required scripts from parent
cp ../active_pism.sh .
cp ../spack_setup.sh .

# Update paths in active_pism.sh to work from current directory
# (You may need to adjust the relative paths)

# Initialize git
git init
git add .
git commit -m "Initial PISM portable installation"
```

#### Option B: Entire pism folder as root (Recommended for completeness)
```bash
cd ~/pism

# Create .gitignore
cat > .gitignore << 'EOF'
*.log
pism_binaries/runs/
*.tar.gz
fftw-3.3.10/
netcdf-c-4.9.2/
netcdf-cxx4-4.3.1/
petsc-src/
*.tmp
*~
EOF

# Initialize git
git init
git add .
git commit -m "Initial PISM portable installation"
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Create a new repository named `pism-portable` (or your preferred name)
3. DO NOT initialize with README (we already have one)

### 3. Push to GitHub

```bash
git remote add origin https://github.com/YOUR_USERNAME/pism-portable.git
git branch -M main
git push -u origin main
```

### 4. Verify on GitHub

Check that these key files are visible:
- [ ] README.md displays on main page
- [ ] QUICKSTART.md is accessible
- [ ] run_pism_sample.slurm is present
- [ ] bin/ directory with executables
- [ ] lib64/ directory with libraries

## File Size Check

Run this to check repository size:
```bash
cd ~/pism/pism_binaries
du -sh .
du -sh bin/
du -sh lib64/
du -sh share/
```

If total size > 1 GB, consider:
- Using Git LFS for large files
- Hosting binaries elsewhere and providing download script
- Providing build-from-source instructions

## For Users to Install

Once on GitHub, users can install with:

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/pism-portable.git pism
cd pism/pism_binaries
bash verify_setup.sh
sbatch run_pism_sample.slurm
```

## Sharing Instructions

Send users:
1. Repository URL
2. Link to QUICKSTART.md
3. Note about required environment (CEOAS HPC cluster)
4. Your contact information

Example message:
```
Hi,

I've created a portable PISM installation for the CEOAS HPC cluster:

Repository: https://github.com/YOUR_USERNAME/pism-portable

Quick start:
1. Clone: git clone https://github.com/YOUR_USERNAME/pism-portable.git ~/pism
2. Verify: cd ~/pism/pism_binaries && bash verify_setup.sh
3. Test: sbatch run_pism_sample.slurm

Full documentation is in README.md.

Questions? Contact me at [your email]
```

## Maintenance Notes

### To Update the Repository

```bash
cd ~/pism  # or ~/pism/pism_binaries depending on your structure
git add .
git commit -m "Description of changes"
git push
```

### Users Can Update With

```bash
cd ~/pism
git pull
```

## Testing Before Distribution

Before sharing, verify:

1. ✅ Clean environment test completed (Job 2352967 successful)
2. ✅ Documentation is complete and accurate
3. ✅ No sensitive information in files (paths should be generic)
4. ✅ Scripts use environment variables, not hard-coded paths
5. ✅ Example job runs successfully

## Important Notes

### Dependencies

This installation depends on:
- Spack environment at `/local/cluster/CEOAS/spack/`
- OpenMPI 5.0.5 via Spack
- GCC 13.2.0 via Spack
- Various libraries from Spack

Users on the same cluster (CEOAS HPC) should have access to these.

### Portability Limitations

This build is specifically for:
- CEOAS HPC cluster
- Rocky Linux 9
- Sandybridge architecture
- SLURM scheduler

Users on different systems will need to rebuild PISM.

### Known Issues and Warnings

1. OpenMPI may warn about `/dev/knem` device - this is normal and doesn't affect functionality
2. Must use `--bind-to none --oversubscribe` flags for mpirun
3. The executable is named `pism`, not `pismr` or `pismv`

## Success Criteria

Your installation is ready to share if:

- [x] `verify_setup.sh` passes all checks
- [x] Sample job completes successfully
- [x] Output NetCDF files are created
- [x] No hard-coded absolute paths in scripts
- [x] Documentation is complete
- [x] .gitignore excludes unnecessary files

## Support Resources

Include these in your README or communications:

- PISM Documentation: https://www.pism.io/docs/
- PISM GitHub: https://github.com/pism/pism
- PISM Forum: https://github.com/pism/pism/discussions
- Your contact information

## Version Information

PISM Version: 2.2.2-d6b3a29ca
PETSc Version: 3.21.6
OpenMPI Version: 5.0.5
NetCDF Version: 4.9.2
FFTW Version: 3.3.10
GSL Version: 2.7.1

Compiled: January 9, 2026
Tested: January 12, 2026
Platform: CEOAS HPC, Rocky Linux 9, Sandybridge

---

**Ready for GitHub distribution!** 🎉

Follow the steps above to push to GitHub and share with other users.
