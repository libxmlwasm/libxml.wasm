#!/bin/bash -e

return 0

VERSION="v0.9.5"
DIRNAME="magic_enum-${VERSION}"
FILENAME="${DIRNAME}.tar.gz"
TMPDIR=${TMPDIR:-$(realpath "./cache")}
EXTRACT_BASE=${EXTRACT_BASE:-$(realpath "$TMPDIR/build")}
DIRPATH="${EXTRACT_BASE}/${DIRNAME}"
FILEPATH="${TMPDIR}/${FILENAME}"
URL="https://github.com/Neargye/magic_enum/releases/download/${VERSION}/${FILENAME}"
PREFIX=${PREFIX:-$(realpath "./prefix")}

echo "Building $DIRNAME ..."
if [ ! -d "$DIRPATH" ]; then
  if [ ! -f "$FILEPATH" ]; then
    mkdir -p "$TMPDIR"
    curl -kLo "$FILEPATH" "$URL"
  else
    echo "File $FILEPATH already exists."
  fi
  mkdir -p "$EXTRACT_BASE/$DIRNAME"
  tar axf "$FILEPATH" -C "$EXTRACT_BASE/$DIRNAME"
else
  echo "Directory $DIRPATH already exists."
fi

(
  cd "$DIRPATH"

  emcmake cmake -S "$DIRPATH" -B "$DIRPATH/build" -GNinja
  emmake cmake --build "$DIRPATH/build" -j$(nproc)
  cmake --install "$DIRPATH/build"
)
