#!/bin/bash -e

# https://download.gnome.org/sources/libxml2/2.11/libxml2-2.11.4.tar.xz
VERSION="2.11.4"
DIRNAME="libxml2-${VERSION}"
FILENAME="${DIRNAME}.tar.xz"
FILEPATH="/tmp/cache/${FILENAME}"
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
  -DLIBXML2_WITH_LZMA=OFF
emmake cmake --build "$DIRNAME/build" -j$(nproc)
cmake --install "$DIRNAME/build"
rm -fr "$DIRNAME"
