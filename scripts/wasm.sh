#!/bin/bash -e

BASEDIR=${BASEDIR:-$(realpath .)}
BUILDDIR=${BASEDIR}/wasm-build
INSTALLPATH=${INSTALLPATH:-$(realpath ${BASEDIR}/dist)}
NVM_DIR=${NVM_DIR:-"$HOME/.nvm"}
. ~/.nvm/nvm.sh

echo BASEDIR: ${BASEDIR}
echo BUILDDIR: ${BUILDDIR}
echo INSTALLPATH: ${INSTALLPATH}

sudo chmod 777 . node_modules .pnpm-store
PATH=$PATH:$HOME/.pnpm-global/bin:/src/node_modules/.bin
GITHUB_TOKEN=${GITHUB_TOKEN:-"_DUMMY_"} corepack pnpm install

build() {
  local SUFFIX=${1:-".js"}
  if [ "${SUFFIX}" = ".js" -o "${SUFFIX}" = ".cjs" ]; then
    TYPE="cjs"
  elif [ "${SUFFIX}" = ".mjs" ]; then
    TYPE="esm"
  else
    TYPE="other"
  fi
  local BUILDDIR_TYPE="${BUILDDIR}/${TYPE}/"
  local INSTALLPATH_TYPE="${INSTALLPATH}/${TYPE}"

  emcmake cmake -GNinja \
    -S ${BASEDIR}/wasm \
    -B ${BUILDDIR_TYPE} \
    -DCMAKE_INSTALL_PREFIX="${INSTALLPATH_TYPE}" \
    -DTARGET_SUFFIX="${SUFFIX}"
  cmake --build ${BUILDDIR_TYPE} -j$(nproc)
  cmake --install ${BUILDDIR_TYPE}
}

build .cjs
build .mjs

mv ${INSTALLPATH}/cjs/* "${INSTALLPATH}/"
mv ${INSTALLPATH}/esm/*.mjs "${INSTALLPATH}/"
rm -fr "${INSTALLPATH}/cjs" "${INSTALLPATH}/esm"
