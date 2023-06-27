#!/bin/bash

SOURCE=$1
DESTINATION=$2

echo Source: $SOURCE
echo Destination: $DESTINATION

for target in cache prefix wasm-build wasm-install; do
  echo Copying $SOURCE/$target to $DESTINATION
  cp -r $SOURCE/$target $DESTINATION
done

echo Copy complete
