#!/bin/bash -e

VERSION="2.11.4"
DIRNAME="libxml2-${VERSION}"
FILENAME="${DIRNAME}.tar.xz"
TMPDIR=${TMPDIR:-$(realpath "./cache")}
FILEPATH="${TMPDIR}/${FILENAME}"
URL="https://download.gnome.org/sources/libxml2/2.11/${FILENAME}"
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

emcmake cmake -S "$DIRNAME" -B "$DIRNAME/build" -GNinja -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DLIBXML2_WITH_FTP=ON \
  -DLIBXML2_WITH_XPTR_LOCS=ON \
  -DLIBXML2_WITH_PYTHON=OFF \
  -DLIBXML2_WITH_LZMA=OFF \
  -DLIBXML2_WITH_ICONV=ON \
  -DIconv_IS_BUILT_IN=OFF \
  -DIconv_LIBRARY="$PREFIX/lib/libiconv.a" \
  -DIconv_INCLUDE_DIR="$PREFIX/include" \
  -DZLIB_LIBRARY="$PREFIX/lib/libz.a" \
  -DZLIB_INCLUDE_DIR="$PREFIX/include"
emmake cmake --build "$DIRNAME/build" -j$(nproc)
cmake --install "$DIRNAME/build"
rm -fr "$DIRNAME"
