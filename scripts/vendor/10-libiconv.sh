#!/bin/bash -e

VERSION="1.17"
DIRNAME="libiconv-${VERSION}"
FILENAME="${DIRNAME}.tar.gz"
FILEPATH="/tmp/cache/${FILENAME}"
URL="https://ftp.gnu.org/gnu/libiconv/${FILENAME}"
PREFIX=${PREFIX:-$(realpath "./prefix")}

if [ ! -d "$DIRNAME" ]; then
  if [ ! -f "$FILEPATH" ]; then
    curl -kLo "$FILEPATH" "$URL"
  else
    echo "File $FILEPATH already exists."
  fi

  tar axf "$FILEPATH"
else
  echo "Directory $DIRNAME already exists."
fi

(
  cd "$DIRNAME"
  emconfigure ./configure --prefix=$PREFIX --host=wasm32-unknown-emscripten --enable-extra-encodings
  emmake make -j$(nproc)
  make install
)
