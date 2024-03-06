#!/bin/bash -e

VERSION="1.2.13"
DIRNAME="zlib-${VERSION}"
FILENAME="${DIRNAME}.tar.gz"
TMPDIR=${TMPDIR:-$(realpath "./cache")}
mkdir $(realpath "./cache") "$TMPDIR/build" -p
mkdir $(realpath "./cache") "$TMPDIR/build" -p
EXTRACT_BASE=${EXTRACT_BASE:-$(realpath "$TMPDIR/build")}
DIRPATH="${EXTRACT_BASE}/${DIRNAME}"
FILEPATH="${TMPDIR}/${FILENAME}"
URL="https://zlib.net/fossils/${FILENAME}"
PREFIX=${PREFIX:-$(realpath "./prefix")}

if [ ! -d "$DIRPATH" ]; then
  if [ ! -f "$FILEPATH" ]; then
    mkdir -p $(dirname "$FILEPATH")
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
  # emconfigure ./configure --prefix=$PREFIX
  prefix=$PREFIX CC=$(which emcc) ./configure --prefix=$PREFIX
  emmake make -j$(nproc)
  make install
)
