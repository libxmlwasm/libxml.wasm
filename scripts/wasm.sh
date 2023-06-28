#!/bin/bash -e

BASEDIR=${BASEDIR:-$(realpath .)}

if [ "$1" = "clean" ]; then
  rm -fr ${BASEDIR}/wasm-build ${BASEDIR}/wasm-install
  if [ "$2" = "all" ]; then
    rm -fr ${BASEDIR}/prefix
  fi
else
  emcmake cmake -GNinja -S ${BASEDIR}/wasm -B ${BASEDIR}/wasm-build -DCMAKE_INSTALL_PREFIX="$(realpath ${BASEDIR}/wasm-install)"
  cmake --build ${BASEDIR}/wasm-build -j$(nproc)
  cmake --install ${BASEDIR}/wasm-build
fi
