#!/bin/bash

# 1. Dynamically find where this script is located
export PISM_PACKAGE_ROOT=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

# 2. Load the specific MPI used for the build
source /local/cluster/CEOAS/spack/share/spack/setup-env.sh
spack load openmpi@5.0.5 %gcc@13.2.0
spack load gsl@2.7.1 %gcc@13.2.0
spack load /liawpnh
spack load cmake@3.27.9 %gcc@13.2.0

export CC=mpicc
export CXX=mpicxx
export F77=mpif77

export HDF5_DIR=$(spack location -i hdf5 %gcc@13.2.0)
export ZLIB_DIR=$(spack location -i /be2z2sp)
export BZIP2_DIR=$(spack location -i /pntcq57)
export HDF5_LIB_DIR=$(spack location -i hdf5 %gcc@13.2.0)/lib
export ZLIB_LIB_DIR=$(spack location -i /be2z2sp)/lib
export BZIP2_LIB_DIR=$(spack location -i /pntcq57)/lib
export GSL_LIB_DIR=$(spack location -i gsl@2.7.1 %gcc@13.2.0)/lib
export MPI_LIB_DIR=$(spack location -i openmpi@5.0.5 %gcc@13.2.0)/lib
export LIA_LIB_DIR=$(spack location -i /liawpnh)/lib

# 3. Suppress MPI/CUDA noise for the hina nodes
export OMPI_MCA_psec=^munge
export OMPI_MCA_accelerator=^cuda
export OMPI_MCA_rcache=^gpusm,rgpusm
export OMPI_MCA_btl=^smcuda
export OMPI_MCA_smsc=^knem

# 4. Set the Path to the PISM executable
export PATH="$PISM_PACKAGE_ROOT/pism_binaries/bin:$PATH"

export LD_LIBRARY_PATH="$PISM_PACKAGE_ROOT/local_stack/lib:$PISM_PACKAGE_ROOT/petsc-install/lib:$LIA_LIB_DIR:$GSL_LIB_DIR:$BZIP2_LIB_DIR:$HDF5_LIB_DIR:$ZLIB_LIB_DIR:$LD_LIBRARY_PATH"

# 6. Set config file path to portable location
# Uses PISM_PACKAGE_ROOT which is dynamically determined from script location
export PISM_CONFIG_NC="$PISM_PACKAGE_ROOT/pism_binaries/share/pism/pism_config.nc"

echo "------------------------------------------------"
echo " PISM Portable Stack Activated"
echo " Root: $PISM_PACKAGE_ROOT"
echo "------------------------------------------------"
