#!/bin/python3
if __name__ == '__main__':
  import sys
  import os
  sys.path.insert(0, os.path.abspath('config'))
  import configure
  configure_options = [
    '--LDFLAGS=-Wl,-z,origin -Wl,-rpath,'$ORIGIN/../../local_stack/lib'',
    '--download-fblaslapack=1',
    '--download-hypre',
    '--download-metis',
    '--download-parmetis',
    '--prefix=/fs1/home/ceoas/chenchon/pism/petsc-install',
    '--with-debugging=0',
    '--with-fftw-dir=/fs1/home/ceoas/chenchon/pism/local_stack',
    '--with-hdf5-dir=/fs1/local/ceoas/spack/opt/spack/linux-rocky9-sandybridge/gcc-13.2.0/hdf5-1.14.3-p2dy6qz3shofau35b6ikibxqo6onthbm',
    '--with-mpi-dir=/fs1/local/ceoas/spack/opt/spack/linux-rocky9-sandybridge/gcc-13.2.0/openmpi-5.0.5-gpan6gdak7hjotoqee2umdghes7xfv2r',
    '--with-netcdf-dir=/fs1/home/ceoas/chenchon/pism/local_stack',
    '--with-shared-libraries=1',
    '--with-zlib-dir=/fs1/local/ceoas/spack/opt/spack/linux-rocky9-sandybridge/gcc-13.2.0/zlib-ng-2.1.6-be2z2spal7uib5osqfouapstexwk5ckg',
    'COPTFLAGS=-O3 -march=sandybridge',
    'CXXOPTFLAGS=-O3 -march=sandybridge',
    'FOPTFLAGS=-O3 -march=sandybridge',
    'PETSC_ARCH=arch-linux-c-opt',
  ]
  configure.petsc_configure(configure_options)
