# libxml.wasm

[Demo](https://libxmlwasm.github.io/)

## Installation

```bash
npm install libxml.wasm
```

Alternatively, you can install from [GitHub Package Registry](https://github.com/libxmlwasm/libxml.wasm/pkgs/npm/wasm)

### (Optional) Build mnually

```bash
# Build also libraries
docker compose up ci
# Build only bindings
docker compose up wasm
```

## Usage

```ts
import init from "libxml.wasm"
// or "libxml.wasm/esm", "libxml.wasm/cjs"

const libxml = await init()

const html = `
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Document</title>
</head>
<body>
  <div class="container">
    <h1 class="title">Hello world</h1>
    <p>Text</p>
  </div>
</body>
</html>
`.trim()

const doc = libxml.parseHTML(html)     // Create a document
const nodes = doc.getNode("//div/h1")  // Get a node by xpath
const h1 = nodes[0]                    // Get the first node
console.log(h1.name)                   // "h1"
console.log(h1.content)                // "Hello world"
console.log(h1.attr.class)             // "title"
```
