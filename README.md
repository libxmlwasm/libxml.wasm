# libxml.wasm

## Build

```bash
# Build also libraries
docker compose up ci
# Build only wasm (requires libraries to be built)
docker compose up wasm
```

## Usage

```ts
import init from "@libxml/wasm"
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
    <p>Good</p>
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
