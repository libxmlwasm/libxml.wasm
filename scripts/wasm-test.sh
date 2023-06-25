#!/bin/bash -e

emcmake cmake -GNinja -S wasm-test -B wasm-test-build -DCMAKE_INSTALL_PREFIX="$(realpath ./wasm-test-install)"
cmake --build wasm-test-build -j$(nproc)
cmake --install wasm-test-build
