# libxml.wasm

## Build

```bash
# Build also libraries
docker compose up ci
# Build only wasm (requires libraries to be built)
docker compose up wasm
```

## Build (Old)

```bash
# Prepare builder image
docker build . -t lxml-builder:latest

# Build also libraries
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml-builder:latest /src/scripts/ci.sh

# Build only wasm (requires libraries to be built)
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml-builder:latest /src/scripts/wasm.sh

# Build library
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml-builder:latest /src/scripts/vendor/00-zlib.sh
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml-builder:latest /src/scripts/vendor/10-libiconv.sh
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml-builder:latest /src/scripts/vendor/20-libxml2.sh
```
