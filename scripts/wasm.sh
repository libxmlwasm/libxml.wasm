#!/bin/bash -e

BASEDIR=${BASEDIR:-$(realpath .)}
BUILDDIR=${BASEDIR}/wasm-build
INSTALLPATH=${INSTALLPATH:-$(realpath ${BASEDIR}/dist)}

echo BASEDIR: ${BASEDIR}
echo BUILDDIR: ${BUILDDIR}
echo INSTALLPATH: ${INSTALLPATH}

emcmake cmake -GNinja -S ${BASEDIR}/wasm -B ${BUILDDIR}/ -DCMAKE_INSTALL_PREFIX="${INSTALLPATH}"
cmake --build ${BUILDDIR}/ -j$(nproc)
cmake --install ${BUILDDIR}/
