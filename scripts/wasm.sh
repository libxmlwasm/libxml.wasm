#!/bin/bash -e

BASEDIR=${BASEDIR:-$(realpath .)}
BUILDDIR=${BASEDIR}/wasm-build
INSTALLPATH=${INSTALLPATH:-$(realpath ${BASEDIR}/dist)}
NVM_DIR="$HOME/.nvm"
. ~/.nvm/nvm.sh

echo BASEDIR: ${BASEDIR}
echo BUILDDIR: ${BUILDDIR}
echo INSTALLPATH: ${INSTALLPATH}

sudo chmod 777 . node_modules .pnpm-store
PATH=$PATH:$HOME/.pnpm-global/bin:/src/node_modules/.bin
GITHUB_TOKEN=_DUMMY_ corepack pnpm install

emcmake cmake -GNinja -S ${BASEDIR}/wasm -B ${BUILDDIR}/ -DCMAKE_INSTALL_PREFIX="${INSTALLPATH}"
cmake --build ${BUILDDIR}/ -j$(nproc)
cmake --install ${BUILDDIR}/
