# libxml_wasm

## Building

```bash
# Build also libraries
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml:latest /src/scripts/ci.sh

# Build only wasm (requires libraries to be built)
docker run --name builder -it --rm -u emscripten -v "$(pwd):/src" -w /src lxml:latest /src/scripts/wasm.sh
```
