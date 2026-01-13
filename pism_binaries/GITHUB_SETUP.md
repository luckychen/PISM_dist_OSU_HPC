# GitHub Repository Setup Guide

This guide explains how to push this PISM installation to GitHub and how other users can use it.

## For the Repository Owner (You)

### Step 1: Prepare for Git

```bash
cd ~/pism/pism_binaries

# Create .gitignore to exclude large/temporary files
cat > .gitignore << 'EOF'
# Log files
*.log

# Simulation output directories
runs/

# Temporary files
*.tmp
*~
.DS_Store

# SLURM output
slurm-*.out
EOF
```

### Step 2: Initialize Git Repository

```bash
# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial PISM portable installation

- PISM binaries and libraries
- Sample SLURM job script
- Comprehensive documentation (README, QUICKSTART)
- Verification script
- Environment setup scripts in parent directory"
```

### Step 3: Push to GitHub

```bash
# Create repository on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/pism-portable.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Important:** You should also include these files from the parent directory:
- `active_pism.sh`
- `spack_setup.sh`

Either:
1. Make `pism_binaries` the root of your repo and copy those files in, OR
2. Make the entire `pism` folder the repo root

### Recommended: Use the entire pism folder as repository

```bash
# Go to parent directory
cd ~/pism

# Initialize git there instead
git init

# Create .gitignore
cat > .gitignore << 'EOF'
# Log files
*.log

# Simulation output
pism_binaries/runs/

# Source tarballs (too large for git)
*.tar.gz

# Build directories (can be rebuilt)
fftw-3.3.10/
netcdf-c-4.9.2/
netcdf-cxx4-4.3.1/
petsc-src/

# Temporary files
*.tmp
*~
.DS_Store
EOF

# Add and commit
git add .
git commit -m "Initial PISM portable installation"

# Push to GitHub
git remote add origin https://github.com/YOUR_USERNAME/pism-portable.git
git branch -M main
git push -u origin main
```

## For Other Users (Installation Instructions)

### Option 1: Clone from GitHub (Recommended)

```bash
# On the CEOAS HPC cluster, clone the repository
cd ~
git clone https://github.com/YOUR_USERNAME/pism-portable.git pism

# Verify the installation
cd ~/pism/pism_binaries
bash verify_setup.sh

# Submit test job
sbatch run_pism_sample.slurm
```

### Option 2: Download as ZIP

```bash
# Download from GitHub web interface, then on the cluster:
cd ~
unzip pism-portable-main.zip
mv pism-portable-main pism

# Continue with verification
cd ~/pism/pism_binaries
bash verify_setup.sh
```

## Important Notes

### What to Include in Repository

✅ **Include:**
- PISM binaries (`pism_binaries/bin/`)
- Compiled libraries (`pism_binaries/lib64/`)
- Documentation and examples (`pism_binaries/share/`)
- All `.sh` scripts
- All `.slurm` scripts
- Documentation files (`.md`)
- Dependency installations (`local_stack/`, `petsc-install/`)

❌ **Exclude:**
- Log files (`*.log`)
- Output data (`runs/`)
- Source tarballs (`*.tar.gz`)
- Source directories that can be rebuilt

### File Size Considerations

GitHub has file size limits:
- Files > 100 MB will be rejected
- Repository should be < 1 GB ideally

If your compiled binaries/libraries are too large:

**Option A:** Use Git LFS (Large File Storage)
```bash
git lfs install
git lfs track "*.so*"
git lfs track "pism_binaries/bin/*"
git add .gitattributes
git commit -m "Configure Git LFS"
```

**Option B:** Host large files elsewhere
- Use institutional file sharing
- Use Zenodo or Figshare for DOI-able archives
- Include download instructions in README

**Option C:** Provide build instructions instead
- Share source code and build scripts
- Users compile on their own systems
- More portable but requires more user expertise

### Repository Structure

Recommended structure for your GitHub repo:

```
pism-portable/
├── README.md                    # Main documentation
├── QUICKSTART.md               # Quick start guide
├── GITHUB_SETUP.md            # This file
├── active_pism.sh             # Environment script
├── spack_setup.sh             # Spack setup
├── pism_binaries/
│   ├── bin/                   # PISM executables
│   ├── lib64/                 # Libraries
│   ├── share/                 # Examples and docs
│   ├── run_pism_sample.slurm  # Sample job
│   └── verify_setup.sh        # Verification script
├── local_stack/               # Local dependencies
└── petsc-install/            # PETSc library
```

### README Updates for GitHub

Add this section to your main README.md:

```markdown
## Installation from GitHub

### Quick Installation

\`\`\`bash
cd ~
git clone https://github.com/YOUR_USERNAME/pism-portable.git pism
cd ~/pism/pism_binaries
bash verify_setup.sh
\`\`\`

### Requirements

- Access to CEOAS HPC cluster (or compatible SLURM system)
- Spack environment at `/local/cluster/CEOAS/spack/`
- GCC 13.2.0 and OpenMPI 5.0.5 (loaded via Spack)

### Quick Start

See [QUICKSTART.md](QUICKSTART.md) for a 3-minute getting started guide.
```

## Sharing with Specific Users

### Share via GitHub

1. Create repository as described above
2. Send users this link:
   ```
   https://github.com/YOUR_USERNAME/pism-portable
   ```

### Share via Email

Include:
1. Repository URL
2. Link to QUICKSTART.md
3. Your contact info for questions
4. Any cluster-specific notes

Example email:

```
Subject: PISM Installation for CEOAS HPC

Hi [Name],

I've set up a portable PISM installation that you can use on the CEOAS HPC cluster.

Repository: https://github.com/YOUR_USERNAME/pism-portable

Quick start:
1. Clone: git clone https://github.com/YOUR_USERNAME/pism-portable.git ~/pism
2. Verify: cd ~/pism/pism_binaries && bash verify_setup.sh
3. Test: sbatch run_pism_sample.slurm

Full documentation is in the README.md file.

Let me know if you have questions!

Best,
[Your Name]
```

## Keeping the Repository Updated

```bash
# After making changes
cd ~/pism
git add .
git commit -m "Description of changes"
git push

# Other users can update with:
cd ~/pism
git pull
```

## License Considerations

PISM is licensed under GPL v3. Your repository should:

1. Include PISM's license:
   ```bash
   cp ~/pism/pism_binaries/share/doc/pism/LICENSE.txt ~/pism/
   ```

2. Add to README:
   ```markdown
   ## License

   PISM is distributed under the GNU General Public License v3.0.
   See LICENSE.txt for details.
   ```

## Support and Maintenance

Consider adding to README:

```markdown
## Support

- **PISM Issues:** https://github.com/pism/pism/discussions
- **This Installation:** [Your email or GitHub issues]
- **HPC Cluster:** Contact CEOAS HPC support
```

## Best Practices

1. **Test before pushing:** Run `verify_setup.sh` and test job
2. **Document changes:** Keep README updated
3. **Version tags:** Use git tags for stable releases
4. **Clean logs:** Don't commit log files
5. **Update regularly:** Pull latest PISM updates when available

Happy sharing!
