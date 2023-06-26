#!/bin/bash -e

if [ "$1" = "clean" ]; then
  rm -fr wasm-build wasm-install
  if [ "$2" = "all" ]; then
    rm -fr prefix
  fi
else
  emcmake cmake -GNinja -S wasm -B wasm-build -DCMAKE_INSTALL_PREFIX="$(realpath ./wasm-install)"
  cmake --build wasm-build -j$(nproc)
  cmake --install wasm-build
fi

