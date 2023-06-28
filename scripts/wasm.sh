#!/bin/bash -e

BASEDIR=${BASEDIR:-$(realpath .)}
INSTALLPATH=${INSTALLPATH:-$(realpath ${BASEDIR}/dist)}

if [ "$1" = "clean" ]; then
  rm -fr ${BASEDIR}/wasm-build ${INSTALLPATH}
  if [ "$2" = "all" ]; then
    rm -fr ${BASEDIR}/prefix
  fi
else
  emcmake cmake -GNinja -S ${BASEDIR}/wasm -B ${BASEDIR}/wasm-build -DCMAKE_INSTALL_PREFIX="${INSTALLPATH}"
  cmake --build ${BASEDIR}/wasm-build -j$(nproc)
  cmake --install ${BASEDIR}/wasm-build
fi
