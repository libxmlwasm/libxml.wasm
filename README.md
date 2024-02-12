# libxml.wasm

## Build

```bash
# Build also libraries
docker compose up ci
# Build only wasm (requires libraries to be built)
docker compose up wasm
```

## Docs

```bash
corepack yarn workspace @libxml/docs start
```
