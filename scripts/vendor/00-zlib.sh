#!/bin/bash -e

VERSION="1.2.13"
DIRNAME="zlib-${VERSION}"
FILENAME="${DIRNAME}.tar.gz"
FILEPATH="/tmp/cache/${FILENAME}"
URL="https://zlib.net/fossils/${FILENAME}"
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
  emconfigure ./configure --prefix=$PREFIX
  emmake make -j$(nproc)
  make install
)
