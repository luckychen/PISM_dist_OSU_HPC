# PISM Quick Start Guide

Get PISM running in 3 minutes!

## Step 1: Setup (First Time Only)

```bash
# Navigate to your home directory and place the pism folder there
cd ~

# Verify you have the pism folder
ls pism/
```

## Step 2: Submit Your First Job

```bash
# Go to the pism_binaries directory
cd ~/pism/pism_binaries

# Submit the sample job
sbatch run_pism_sample.slurm
```

You should see: `Submitted batch job XXXXXX`

## Step 3: Monitor Your Job

```bash
# Check if job is running
squeue -u $USER

# Watch the output log in real-time (replace JOBID with your job number)
tail -f pism_test_output_JOBID.log
```

Press `Ctrl+C` to stop watching the log.

## Step 4: View Results

```bash
# Once job completes, check the output
ls -lh runs/run_*/

# View the log files
cat pism_test_output_*.log
```

## What's Next?

- Read the full [README.md](README.md) for detailed instructions
- Explore PISM examples in `share/doc/pism/examples/`
- Modify `run_pism_sample.slurm` for your own simulations
- Check PISM documentation: https://www.pism.io/docs/

## Common Commands

```bash
# Submit a job
sbatch run_pism_sample.slurm

# Check job status
squeue -u $USER

# Cancel a job
scancel JOBID

# View available partitions
sinfo
```

## Troubleshooting

**Job won't start?**
- Check partition availability: `sinfo`
- Change partition in script if needed

**Job failed?**
- Read error log: `cat pism_test_error_*.log`
- Check you're in correct directory

**Need help?**
- See full README.md
- Contact your HPC administrator
- Visit https://www.pism.io/docs/

## Example: Run Your Own Simulation

1. Copy the sample script:
   ```bash
   cp run_pism_sample.slurm my_simulation.slurm
   ```

2. Edit the file:
   ```bash
   nano my_simulation.slurm
   ```

3. Change job name, time, and PISM parameters

4. Submit:
   ```bash
   sbatch my_simulation.slurm
   ```

Happy ice sheet modeling!
