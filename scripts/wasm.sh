#!/bin/bash -e

emcmake cmake -GNinja -S wasm -B wasm-build -DCMAKE_INSTALL_PREFIX="$(realpath ./wasm-install)"
cmake --build wasm-build -j$(nproc)
cmake --install wasm-build
