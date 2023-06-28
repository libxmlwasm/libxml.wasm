#!/bin/bash -e

VERSION="1.17"
DIRNAME="libiconv-${VERSION}"
FILENAME="${DIRNAME}.tar.gz"
TMPDIR=${TMPDIR:-$(realpath "./cache")}
EXTRACT_BASE=${EXTRACT_BASE:-$(realpath "$TMPDIR/build")}
DIRPATH="${EXTRACT_BASE}/${DIRNAME}"
FILEPATH="${TMPDIR}/${FILENAME}"
URL="https://ftp.gnu.org/gnu/libiconv/${FILENAME}"
PREFIX=${PREFIX:-$(realpath "./prefix")}

if [ ! -d "$DIRPATH" ]; then
  if [ ! -f "$FILEPATH" ]; then
    mkdir -p $(dirname "$FILEPATH")
    curl -kLo "$FILEPATH" "$URL"
  else
    echo "File $FILEPATH already exists."
  fi
  mkdir -p "$EXTRACT_BASE"
  tar axf "$FILEPATH" -C "$EXTRACT_BASE"
else
  echo "Directory $DIRPATH already exists."
fi

(
  cd "$DIRPATH"
  if [ ! -f "Makefile" ]; then
    emconfigure ./configure --prefix=$PREFIX --host=wasm32-unknown-emscripten --enable-extra-encodings
  fi
  emmake make -j$(nproc)
  make install
)
