#!/bin/bash -e

set -uo pipefail

VERSION="2.12.6"
DIRNAME="libxml2-${VERSION}"
FILENAME="${DIRNAME}.tar.xz"
TMPDIR=${TMPDIR:-$(realpath "./cache")}
mkdir $(realpath "./cache") "$TMPDIR/build" -p
mkdir $(realpath "./cache") "$TMPDIR/build" -p
EXTRACT_BASE=${EXTRACT_BASE:-$(realpath "$TMPDIR/build")}
DIRPATH="${EXTRACT_BASE}/${DIRNAME}"
FILEPATH="${TMPDIR}/${FILENAME}"
URL="https://download.gnome.org/sources/libxml2/2.12/${FILENAME}"
PREFIX=${PREFIX:-$(realpath "./prefix")}

echo "Building $DIRNAME ..."

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

# emcmake cmake -S "$DIRPATH" -B "$DIRPATH/build" -GNinja -DCMAKE_INSTALL_PREFIX=$PREFIX \
#   -DLIBXML2_WITH_FTP=ON \
#   -DLIBXML2_WITH_XPTR_LOCS=ON \
#   -DLIBXML2_WITH_PYTHON=OFF \
#   -DLIBXML2_WITH_LZMA=OFF \
#   -DLIBXML2_WITH_ICONV=ON \
#   -DIconv_IS_BUILT_IN=OFF \
#   -DIconv_LIBRARY="$PREFIX/lib/libiconv.a" \
#   -DIconv_INCLUDE_DIR="$PREFIX/include" \
#   -DZLIB_LIBRARY="$PREFIX/lib/libz.a" \
#   -DZLIB_INCLUDE_DIR="$PREFIX/include"
# emmake cmake --build "$DIRPATH/build" -j$(nproc)
# cmake --install "$DIRPATH/build"

(
  cd "$DIRPATH"
  emconfigure ./configure \
    --host=wasm32-unknown-emscripten \
    --prefix=$PREFIX \
    --with-ftp \
    --with-history \
    --without-python
  emmake make -j$(nproc)
  make install
  cd -
)
rm -fr "$DIRPATH"
