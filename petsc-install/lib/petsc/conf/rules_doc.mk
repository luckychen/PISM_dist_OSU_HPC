# -*- mode: makefile-gmake -*-
#
# This is included in this file so it may be used from any source code PETSc directory
libs: /fs1/home/ceoas/chenchon/pism/petsc-install/lib/petsc/conf/files /fs1/home/ceoas/chenchon/pism/petsc-install/tests/testfiles
	+@r=`echo "${MAKEFLAGS}" | grep ' -j'`; \
        if [ "$$?" = 0 ]; then make_j=""; else make_j="-j${MAKE_NP}"; fi; \
	r=`echo "${MAKEFLAGS}" | grep ' -l'`; \
        if [ "$$?" = 0 ]; then make_l=""; else make_l="-l${MAKE_LOAD}"; fi; \
        cmd="${OMAKE_PRINTDIR} -f gmakefile $${make_j} $${make_l} ${MAKE_PAR_OUT_FLG} V=${V} libs"; \
        cd /fs1/home/ceoas/chenchon/pism/petsc-install && echo $${cmd} && exec $${cmd}
